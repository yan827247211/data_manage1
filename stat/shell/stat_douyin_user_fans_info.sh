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
  --性别
INSERT OVERWRITE TABLE short_video.stat_douyin_user_fans_detail PARTITION(dt='$_dt', prop_type='gender')
select user_id, gender, ranking, cnt as gender_cnt, concat(round(100*cnt/sum(cnt) over (partition by user_id),2),'%') as perct,'$_ts'
from (
  select user_id, gender, cnt, row_number() over (partition by user_id order by cnt desc) as ranking
  from (
    SELECT a.user_id, b.gender, count(1) as cnt
    FROM short_video.relat_douyin_user_fans a LEFT JOIN short_video.stat_douyin_user_info b ON (a.fans_user_id=b.user_id and b.dt='$_dt' and a.dt='$_dt')
    where gender in (1,2)
    GROUP BY a.user_id, b.gender
  ) as b
) c;
-- 城市
INSERT OVERWRITE TABLE short_video.stat_douyin_user_fans_detail PARTITION(dt='$_dt', prop_type='city')
select user_id, city, rank, cnt, concat(round(100*cnt/sum(cnt) over (partition by user_id),2),'%') as perct,'$_ts'
from (
  select user_id, case when rank<=19 then city else '其他城市' end as city
  , case when rank<=19 then rank else 20 end as rank
  , sum(cnt) as cnt from (
    select user_id, ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY cnt DESC) AS rank, city, cnt
    from(
        SELECT a.user_id, b.city, count(1) as cnt
        FROM short_video.relat_douyin_user_fans a LEFT JOIN short_video.stat_douyin_user_info b ON (a.fans_user_id=b.user_id and b.dt='$_dt' and a.dt='$_dt')
        where b.city is not null
        GROUP BY a.user_id, b.city
    ) c
  ) d
  group by user_id, case when rank<=19 then city else '其他城市' end
  , case when rank<=19 then rank else 20 end
) e;
--省份
INSERT OVERWRITE TABLE short_video.stat_douyin_user_fans_detail PARTITION(dt='$_dt', prop_type='province')
select user_id, province, rank, cnt, concat(round(100*cnt/sum(cnt) over (partition by user_id),2),'%') as perct,'$_ts'
from (
  select user_id, case when rank<=19 then province else '其他省份' end as province
  , case when rank<=19 then rank else 20 end as rank
  , sum(cnt) as cnt from (
    select user_id, ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY cnt DESC) AS rank, province, cnt
    from(
        SELECT a.user_id, b.province, count(1) as cnt
        FROM short_video.relat_douyin_user_fans a LEFT JOIN short_video.stat_douyin_user_info b ON (a.fans_user_id=b.user_id and b.dt='$_dt' and a.dt='$_dt')
        where b.province is not null
        GROUP BY a.user_id, b.province
    ) c
  ) d
  group by user_id, case when rank<=19 then province else '其他省份' end
  , case when rank<=19 then rank else 20 end
) e;

--年龄
INSERT OVERWRITE TABLE short_video.stat_douyin_user_fans_detail PARTITION(dt='$_dt', prop_type='age')
select user_id, age_seg, rank, cnt, concat(round(100*cnt/sum(cnt) over (partition by user_id),2),'%') as perct,'$_ts'
from (
    select user_id, ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY cnt DESC) AS rank, age_seg, cnt
    from(
        SELECT a.user_id
        , case when b.age between 0 and 5 then '0'
                when b.age between 6 and 17 then '1'
                when b.age between 18 and 24 then '2'
                when b.age between 25 and 30 then '3'
                when b.age between 31 and 35 then '4'
                when b.age between 36 and 40 then '5'
                when b.age>= 41 then '6' else '-1' end as age_seg
        , count(1) as cnt
        FROM short_video.relat_douyin_user_fans a LEFT JOIN short_video.stat_douyin_user_info b ON (a.fans_user_id=b.user_id and b.dt='$_dt' and a.dt='$_dt')
        where b.age is not null
        and b.age>5
        GROUP BY a.user_id, case when b.age between 0 and 5 then '0'
                when b.age between 6 and 17 then '1'
                when b.age between 18 and 24 then '2'
                when b.age between 25 and 30 then '3'
                when b.age between 31 and 35 then '4'
                when b.age between 36 and 40 then '5'
                when b.age>= 41 then '6' else '-1' end
    ) c
) e;
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
      select u.user_id
      , age.age
      , province.province
      , city.city
      , female_rate.female_rate
      , main_age.main_age
      , main_province.main_province
      , main_city.main_city
      ,'$_ts'
      from (select user_id
       from stat_douyin_user_fans_detail
       where dt='$_dt' group by user_id) u
        left join (
          -- 省份
          select user_id, concat_ws(',',collect_list(concat_ws(':', prop_key, prop_percent))) as province
          from short_video.stat_douyin_user_fans_detail
          where dt='$_dt'
          and prop_type='province'
          group by user_id
        ) province on (u.user_id=province.user_id)
        left join (
          -- 城市
          select user_id, concat_ws(',',collect_list(concat_ws(':', prop_key, prop_percent))) as city
          from short_video.stat_douyin_user_fans_detail
          where dt='$_dt'
          and prop_type='city'
          group by user_id
        ) city on (u.user_id=city.user_id)
        left join (
          -- 年龄
          select user_id, concat_ws(',',collect_list(concat_ws(':', prop_key, prop_percent))) as age
          from short_video.stat_douyin_user_fans_detail
          where dt='$_dt'
          and prop_type='age'
          group by user_id
        ) age on (u.user_id=age.user_id)
        left join (
          -- 女性
          select user_id, cast(regexp_replace(prop_percent,'%','') as decimal(10,2)) as female_rate
          from short_video.stat_douyin_user_fans_detail
          where dt='$_dt'
          and prop_type='gender'
          and prop_key='2'
        ) female_rate on (u.user_id=female_rate.user_id)
        left join (
        --主要年龄
          select user_id, prop_key as main_age
          from short_video.stat_douyin_user_fans_detail
          where dt='$_dt'
          and prop_type = 'age'
          and prop_rank=1
        ) main_age on (u.user_id=main_age.user_id)
        left join (
        --主要省份
          select user_id, prop_key as main_province
          from short_video.stat_douyin_user_fans_detail
          where dt='$_dt'
          and prop_type = 'province'
          and prop_rank=1
        ) main_province on (u.user_id=main_province.user_id)
        left join (
        --主要城市
          select user_id, prop_key as main_city
          from short_video.stat_douyin_user_fans_detail
          where dt='$_dt'
          and prop_type = 'city'
          and prop_rank=1
        ) main_city on (u.user_id=main_city.user_id)
  "
  execHql "$hqlStr"
}

# 从评论数据中抽取计算用户-粉丝关系
function build_user_fans_relation() {
    if [ $# -ne 2 ]; then
        log "wrong parameters:$@"
        log 'usage:   build_user_fans_relation dt ts'
        log 'example: build_user_fans_relation 20190920 1568165988'
        exit 1
    fi

    _dt=$1
    _ts=$2


    hqlStr="
        INSERT OVERWRITE TABLE short_video.relat_douyin_user_fans PARTITION(dt='$_dt')
        select user_id, be_followered_uid,'$_ts'
        from short_video.log_douyin_user
        where dt<='$_dt'
        and be_followered_uid is not null
        group by user_id, be_followered_uid,'$_ts'
    "
    execHql "$hqlStr"
}

function export_user_fans_info() {
  if [ $# -ne 1 ]; then
    log "wrong parameters:$@"
    log 'usage:   export_user_fans_info dt'
    log 'example: export_user_fans_info 20190911'
    exit 1
  fi
  _dt=$1
  _ts=$2
  log "dt=$_dt, ts=$_ts"

  hqlStr="
    select concat_ws('_',a.user_id,a.dt)
        , a.user_id
        , b.unique_id
        , a.fans_province
        , a.fans_city
        , a.fans_age
        , a.female_rate
        from short_video.stat_douyin_user_fans_info a left join short_video.stat_douyin_user_info b on (a.user_id=b.user_id and a.dt='$_dt' and b.dt='$_dt')
        where a.dt='$_dt' and b.dt='$_dt'
  "
  exportHQL2MySQLReplace "$hqlStr" "dy_rpt_expert_proportion" "$_dt" "dy_rpt_expert_proportion"
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


build_user_fans_relation ${_dt} ${_ts}
check "build_user_fans_relation  ${_dt} ${_ts}"
stat_douyin_user_fans_details ${_dt} ${_ts}
check "stat_douyin_user_fans_details  ${_dt} ${_ts}"
stat_douyin_user_fans_info  ${_dt} ${_ts}
check "stat_douyin_user_fans_info  ${_dt} ${_ts}"
export_user_fans_info ${_dt}
check "export_user_fans_info  ${_dt}"
log "daily stat douyin user stat job done..."