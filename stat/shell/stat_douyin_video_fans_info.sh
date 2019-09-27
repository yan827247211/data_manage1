#!/usr/bin/env bash

##################################################################
## 统计抖音短视频观众相关信息                                       ##
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
function stat_douyin_video_fans_detail() {
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
-- 性别
INSERT OVERWRITE TABLE short_video.stat_douyin_video_fans_detail PARTITION(dt='$_dt', prop_type='gender')
select aweme_id, gender, ranking, cnt as gender_cnt, concat(round(100*cnt/sum(cnt) over (partition by aweme_id),2),'%') as perct,'$_ts'
from (
  select aweme_id, gender, cnt, row_number() over (partition by aweme_id order by cnt desc) as ranking
  from (
    SELECT a.aweme_id, b.gender, count(1) as cnt
    FROM short_video.relat_douyin_video_fans a LEFT JOIN short_video.stat_douyin_user_info b ON (a.fans_user_id=b.user_id and b.dt='$_dt' and a.dt='$_dt')
    where gender in (1,2)
    GROUP BY a.aweme_id, b.gender
  ) as b
) c;

--城市
INSERT OVERWRITE TABLE short_video.stat_douyin_video_fans_detail PARTITION(dt='$_dt', prop_type='city')
select aweme_id, city, rank, cnt, concat(round(100*cnt/sum(cnt) over (partition by aweme_id),2),'%') as perct,'$_ts'
from (
  select aweme_id, case when rank<=19 then city else '其他城市' end as city
  , case when rank<=19 then rank else 20 end as rank
  , sum(cnt) as cnt from (
    select aweme_id, ROW_NUMBER() OVER (PARTITION BY aweme_id ORDER BY cnt DESC) AS rank, city, cnt
    from(
        SELECT a.aweme_id, b.city, count(1) as cnt
        FROM short_video.relat_douyin_video_fans a LEFT JOIN short_video.stat_douyin_user_info b ON (a.fans_user_id=b.user_id and b.dt='$_dt' and a.dt='$_dt')
        where b.city is not null
        GROUP BY a.aweme_id, b.city
    ) c
  ) d
  group by aweme_id, case when rank<=19 then city else '其他城市' end
  , case when rank<=19 then rank else 20 end
) e;

--省份
INSERT OVERWRITE TABLE short_video.stat_douyin_video_fans_detail PARTITION(dt='$_dt', prop_type='province')
select aweme_id, province, rank, cnt, concat(round(100*cnt/sum(cnt) over (partition by aweme_id),2),'%') as perct,'$_ts'
from (
  select aweme_id, case when rank<=19 then province else '其他省份' end as province
  , case when rank<=19 then rank else 20 end as rank
  , sum(cnt) as cnt from (
    select aweme_id, ROW_NUMBER() OVER (PARTITION BY aweme_id ORDER BY cnt DESC) AS rank, province, cnt
    from(
        SELECT a.aweme_id, b.province, count(1) as cnt
        FROM short_video.relat_douyin_video_fans a LEFT JOIN short_video.stat_douyin_user_info b ON (a.fans_user_id=b.user_id and b.dt='$_dt' and a.dt='$_dt')
        where b.province is not null
        GROUP BY a.aweme_id, b.province
    ) c
  ) d
  group by aweme_id, case when rank<=19 then province else '其他省份' end
  , case when rank<=19 then rank else 20 end
) e;

--年龄
INSERT OVERWRITE TABLE short_video.stat_douyin_video_fans_detail PARTITION(dt='$_dt', prop_type='age')
select aweme_id, age_seg, rank, cnt, concat(round(100*cnt/sum(cnt) over (partition by aweme_id),2),'%') as perct,'$_ts'
from (
    select aweme_id, ROW_NUMBER() OVER (PARTITION BY aweme_id ORDER BY cnt DESC) AS rank, age_seg, cnt
    from(
        SELECT a.aweme_id
        , case when b.age between 0 and 5 then '0'
                when b.age between 6 and 17 then '1'
                when b.age between 18 and 24 then '2'
                when b.age between 25 and 30 then '3'
                when b.age between 31 and 35 then '4'
                when b.age between 36 and 40 then '5'
                when b.age>= 41 then '6' else '-1' end as age_seg
        , count(1) as cnt
        FROM short_video.relat_douyin_video_fans a LEFT JOIN short_video.stat_douyin_user_info b ON (a.fans_user_id=b.user_id and b.dt='$_dt' and a.dt='$_dt')
        where b.age is not null
        and b.age>5
        GROUP BY a.aweme_id, case when b.age between 0 and 5 then '0'
                when b.age between 6 and 17 then '1'
                when b.age between 18 and 24 then '2'
                when b.age between 25 and 30 then '3'
                when b.age between 31 and 35 then '4'
                when b.age between 36 and 40 then '5'
                when b.age>= 41 then '6' else '-1' end
    ) c
) e;

ADD JAR /home/hadoop/yulei/jar/hive-udf-1.0.jar;
CREATE TEMPORARY FUNCTION seg AS 'com.mobduos.bigdata.hive.udf.HanlpSegUDF';

INSERT OVERWRITE TABLE short_video.stat_douyin_video_fans_detail PARTITION(dt='$_dt', prop_type='hotword')
select aweme_id, token, rank, cnt, concat(round(100*cnt/sum(cnt) over (partition by aweme_id),2),'%') as perct,'$_ts'
from (
  select aweme_id, case when rank<=19 then token else '其他热词' end as token
  , case when rank<=19 then rank else 20 end as rank
  , sum(cnt) as cnt from (
    select aweme_id, ROW_NUMBER() OVER (PARTITION BY aweme_id ORDER BY cnt DESC) AS rank, token, cnt
    from(
        select aweme_id, token, count(1) cnt from (
          select aweme_id, token from (
            select aweme_id, seg(c_text) as tokens
            from short_video.base_douyin_comment
          ) a LATERAL VIEW explode(tokens) token_table AS token
        )b
        group by aweme_id,token
    ) c
  ) d
  group by aweme_id, case when rank<=19 then token else '其他热词' end
  , case when rank<=19 then rank else 20 end
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
      INSERT OVERWRITE TABLE short_video.stat_douyin_video_fans_info PARTITION(dt='$_dt')
      select hotword.aweme_id
      , hotword.hotword
      , age.age
      , province.province
      , city.city
      , female_rate.female_rate
      , main_age.main_age
      , main_province.main_province
      , main_city.main_city
      ,'$_ts'
      from
        --热词
        ( select aweme_id, concat_ws(',',collect_list(concat_ws(':', prop_key, prop_percent))) as hotword
          from short_video.stat_douyin_video_fans_detail
          where dt='$_dt'
          and prop_type='hotword'
          group by aweme_id) hotword
        left join (
          -- 省份
          select aweme_id, concat_ws(',',collect_list(concat_ws(':', prop_key, prop_percent))) as province
          from short_video.stat_douyin_video_fans_detail
          where dt='$_dt'
          and prop_type='province'
          group by aweme_id
        ) province on (hotword.aweme_id=province.aweme_id)
        left join (
          -- 城市
          select aweme_id, concat_ws(',',collect_list(concat_ws(':', prop_key, prop_percent))) as city
          from short_video.stat_douyin_video_fans_detail
          where dt='$_dt'
          and prop_type='city'
          group by aweme_id
        ) city on (hotword.aweme_id=city.aweme_id)
        left join (
          -- 年龄
          select aweme_id, concat_ws(',',collect_list(concat_ws(':', prop_key, prop_percent))) as age
          from short_video.stat_douyin_video_fans_detail
          where dt='$_dt'
          and prop_type='age'
          group by aweme_id
        ) age on (hotword.aweme_id=age.aweme_id)
        left join (
          -- 女性
          select aweme_id, cast(regexp_replace(prop_percent,'%','') as decimal(10,2)) as female_rate
          from short_video.stat_douyin_video_fans_detail
          where dt='$_dt'
          and prop_type='gender'
          and prop_key='2'
        ) female_rate on (hotword.aweme_id=female_rate.aweme_id)
        left join (
        --主要年龄
          select aweme_id, prop_key as main_age
          from short_video.stat_douyin_video_fans_detail
          where dt='$_dt'
          and prop_type = 'age'
          and prop_rank=1
        ) main_age on (hotword.aweme_id=main_age.aweme_id)
        left join (
        --主要省份
          select aweme_id, prop_key as main_province
          from short_video.stat_douyin_video_fans_detail
          where dt='$_dt'
          and prop_type = 'province'
          and prop_rank=1
        ) main_province on (hotword.aweme_id=main_province.aweme_id)
        left join (
        --主要城市
          select aweme_id, prop_key as main_city
          from short_video.stat_douyin_video_fans_detail
          where dt='$_dt'
          and prop_type = 'city'
          and prop_rank=1
        ) main_city on (hotword.aweme_id=main_city.aweme_id)
  "
  execHql "$hqlStr"
}

# 从评论数据中抽取计算视频-粉丝关系
function build_video_fans_relation_from_comment() {
    if [ $# -ne 2 ]; then
        log "wrong parameters:$@"
        log 'usage:   build_video_fans_relation_from_comment dt ts'
        log 'example: build_video_fans_relation_from_comment 20190920 1568165988'
        exit 1
    fi

    _dt=$1
    _ts=$2


    hqlStr="
        INSERT OVERWRITE TABLE short_video.relat_douyin_video_fans PARTITION(dt='$_dt')
        SELECT aweme_id, user_id, "$_ts"
        FROM short_video.log_douyin_comment
        where dt<='$_dt'
        GROUP BY aweme_id, user_id, "$_ts"
    "
    execHql "$hqlStr"
}


function export_video_fans_info() {
  if [ $# -ne 1 ]; then
    log "wrong parameters:$@"
    log 'usage:   export_video_fans_info dt'
    log 'example: export_video_fans_info 20190911'
    exit 1
  fi
  _dt=$1
  _ts=$2
  log "dt=$_dt, ts=$_ts"

  hqlStr="
    select concat_ws('_',aweme_id,dt)
        , aweme_id
        , hotwords
        , fans_province
        , fans_city
        , fans_age
        , female_rate
        from short_video.stat_douyin_video_fans_info
        where dt='$_dt'
  "
  exportHQL2MySQLReplace "$hqlStr" "dy_rpt_video_proportion" "$_dt" "dy_rpt_video_proportion"
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

build_video_fans_relation_from_comment ${_dt} ${_ts}
check "build_video_fans_relation_from_comment  ${_dt} ${_ts}"
stat_douyin_video_fans_detail ${_dt} ${_ts}
check "stat_douyin_video_fans_detail  ${_dt} ${_ts}"
stat_douyin_user_fans_info  ${_dt} ${_ts}
check "stat_douyin_user_fans_info  ${_dt} ${_ts}"
export_video_fans_info  ${_dt}
check "export_video_fans_info  ${_dt}"

log "daily stat douyin user stat job done..."