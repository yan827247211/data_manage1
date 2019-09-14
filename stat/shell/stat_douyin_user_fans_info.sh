#!/usr/bin/env bash

##################################################################
## 统计抖音达人、达人粉丝相关信息                                    ##
##################################################################
## history:                                                     ##
##  2019-09-12 YuLei first release                              ##
##################################################################

#打印通用信息
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
SCRIPT_NAME="$(basename "$0")"
ARGS="$@"
echo '############################################'
echo "This shell locate at:$DIR/$SCRIPT_NAME"
echo "variable: $ARGS"
echo '############################################'
echo "start stat douyin user daily stat info. "

# 引入通用配置和方法
source "$DIR/common/common_var.sh"
source "$DIR/common/common_func.sh"

# 引入脚本方法

# 计算达人视频统计信息
function stat_douyin_user_fans_details() {
  if [ $# -ne 2 ]; then
    log "wrong parameters:$@"
    log 'usage:   stat_douyin_user_video_info dt ts'
    log 'example: stat_douyin_user_video_info 20190911 1568165988'
    exit 1
  fi
  _dt=$1
  _ts=$2
  log "dt=$_dt, ts=$_ts"
  hqlStr="
      INSERT OVERWRITE TABLE short_video.stat_douyin_user_fans_detail PARTITION(dt='$_dt', prop_type='gender')
      select user_id, ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY cnt desc) AS rank, gender, cnt, '$_ts'
      from(
          SELECT a.user_id, coalesce(gender,'-1') as gender, count(1) as cnt
          FROM short_video.relat_douyin_user_fans a LEFT JOIN short_video.base_douyin_user b ON (a.fans_user_id=b.user_id)
          GROUP BY a.user_id, coalesce(gender,'-1')
      ) c;

      INSERT OVERWRITE TABLE short_video.stat_douyin_user_fans_detail PARTITION(dt='$_dt', prop_type='city')
      select user_id, ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY cnt DESC) AS rank, city, cnt, '$_ts'
      from(
          SELECT a.user_id, coalesce(city,'-1') as city, count(1) as cnt
          FROM short_video.relat_douyin_user_fans a LEFT JOIN short_video.base_douyin_user b ON (a.fans_user_id=b.user_id)
          GROUP BY a.user_id, coalesce(city,'-1')
      ) c;

      INSERT OVERWRITE TABLE short_video.stat_douyin_user_fans_detail PARTITION(dt='$_dt', prop_type='age')
      SELECT user_id, ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY cnt DESC) AS rank, age, cnt, '$_ts'
      from(
        SELECT a.user_id
        , CASE WHEN birthday is null THEN -1 ELSE floor(DATEDIFF(TO_DATE(FROM_UNIXTIME(UNIX_TIMESTAMP())), TO_DATE(birthday)) / 365.25) END AS age
        , count(1) AS cnt
        FROM short_video.relat_douyin_user_fans a LEFT JOIN short_video.base_douyin_user b ON (a.fans_user_id=b.user_id)
        GROUP BY a.user_id, CASE WHEN birthday IS NULL then -1 ELSE FLOOR(DATEDIFF(TO_DATE(FROM_UNIXTIME(UNIX_TIMESTAMP())), TO_DATE(birthday)) / 365.25) END
      ) c;
  "
  execHql "$hqlStr"
}

# 计算用户信息全量表
function stat_douyin_user_fans_info() {
  if [ $# -ne 2 ]; then
    log "wrong parameters:$@"
    log 'usage:   stat_douyin_user_info dt ts'
    log 'example: stat_douyin_user_info 20190911 1568165988'
    exit 1
  fi
  _dt=$1
  _ts=$2
  log "dt=$_dt, ts=$_ts"
  hqlStr="
      INSERT OVERWRITE TABLE short_video.stat_douyin_user_fans_info PARTITION(dt='$_dt')
      -- 主要年龄Top1
      select a.user_id, a.age_seg, null as province,  b.city, coalesce(c.female_rate_seg,0), '$_ts' from (
          select user_id, age_seg from (
            select user_id, age_seg, age_cnt, row_number() over (partition by user_id order by age_cnt desc) as rn
            from (
              select user_id,
              case when cast(prop_key as int) between 0 and 5 then '0'
                when cast(prop_key as int) between 6 and 17 then '1'
                when cast(prop_key as int) between 18 and 24 then '2'
                when cast(prop_key as int) between 25 and 30 then '3'
                when cast(prop_key as int) between 31 and 35 then '4'
                when cast(prop_key as int) between 36 and 41 then '5'
                when cast(prop_key as int)>41 then '6' else '-1' end as age_seg,
              sum(prop_count) as age_cnt
              from short_video.stat_douyin_user_fans_detail
              where dt='$_dt' and prop_type='age'
              group by user_id,
              case when cast(prop_key as int) between 0 and 5 then '0'
                when cast(prop_key as int) between 6 and 17 then '1'
                when cast(prop_key as int) between 18 and 24 then '2'
                when cast(prop_key as int) between 25 and 30 then '3'
                when cast(prop_key as int) between 31 and 35 then '4'
                when cast(prop_key as int) between 36 and 41 then '5'
                when cast(prop_key as int)>41 then '6' else '-1' end
            ) a1) a2
            where rn=1
          ) a
      left join (
      -- 粉丝主要城市Top1
          select user_id, prop_key as city
          from short_video.stat_douyin_user_fans_detail
          where dt='$_dt' and prop_type='city' and prop_rank=1
      ) b on (a.user_id=b.user_id)
      left join (
          select user_id
          , case when female_rate<10 then 0
            when female_rate>=10 and female_rate<20 then 1
            when female_rate>=20 and female_rate<30 then 2
            when female_rate>=30 and female_rate<40 then 3
            when female_rate>=40 and female_rate<50 then 4
            when female_rate>=50 and female_rate<60 then 5
            when female_rate>=60 and female_rate<70 then 6
            when female_rate>=70 and female_rate<80 then 7
            when female_rate>=80 and female_rate<90 then 8
            when female_rate>=90 then 9 end as female_rate_seg from (
              select user_id, cast(female*100/total as decimal(10,2)) as female_rate
                from (
                    select user_id, sum(case when prop_key='2' then prop_count else 0 end) as female, sum(prop_count) as total
                    from short_video.stat_douyin_user_fans_detail
                    where dt='$_dt' and prop_type='gender'
                    group by user_id
                ) c1
              )c2
      ) c on (a.user_id=c.user_id)
  "
  execHql "$hqlStr"
}

# 检查参数
if [ $# -ne 1 ]; then
  log 'wrong parameters!'
  log "usage: $SCRIPT_NAME 20190909"
  exit 1
fi

_dt=$1
#批次号，10位时间戳
_ts=$(date +%s)

stat_douyin_user_fans_details ${_dt} ${_ts}
check "stat_douyin_user_fans_details  ${_dt} ${_ts}"
stat_douyin_user_fans_info  ${_dt} ${_ts}
check "stat_douyin_user_fans_info  ${_dt} ${_ts}"

log "daily stat douyin user stat job done..."