#!/usr/bin/env bash

##################################################################
## 计算抖音达人相关数据，含必要的数据同步                              ##
##################################################################
## history:                                                     ##
##  2019-09-11 YuLei first release                              ##
##################################################################

#打印通用信息
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
SCRIPT_NAME="$(basename "$0")"
ARGS="$@"
echo '############################################'
echo "This shell locate at:$DIR/$SCRIPT_NAME"
echo "variable: $ARGS"
echo '############################################'
echo "Start synchronize short video raw log "

# 引入通用配置和方法
source "$DIR/common/common_var.sh"
source "$DIR/common/common_func.sh"

# 引入脚本方法

# 计算用户信息全量表
function calc_base_douyin_user_info() {
  if [ $# -ne 2 ]; then
    log "wrong parameters:$@"
    log 'usage:   calc_daily_user_info dt ts'
    log 'example: calc_daily_user_info 20190911 1568165988'
    exit 1
  fi
  _dt=$1
  _ts=$2
  log "dt=$_dt, ts=$_ts"
  hqlStr="
  INSERT OVERWRITE TABLE short_video.base_douyin_user
  SELECT user_id, sec_user_id, unique_id, nickname, gender, birthday, signature, province, city, cover_img, total_favorited
    , follower_count, following_count, aweme_count, dongtai_count, favoriting_count, head_img, custom_verify
    , weibo_verify, enterprise_verify_reason, is_shop, be_followered_uid, create_time, '$_ts'
  FROM (
      SELECT user_id, sec_user_id, unique_id, nickname, gender, birthday, signature, province, city, cover_img, total_favorited
            , follower_count, following_count, aweme_count, dongtai_count, favoriting_count, head_img, custom_verify
            , weibo_verify, enterprise_verify_reason, is_shop, be_followered_uid, create_time
            , ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY create_time DESC) AS rn
      FROM (
                SELECT user_id, sec_user_id, unique_id, nickname, gender, birthday, signature, province, city, cover_img, total_favorited
                    , follower_count, following_count, aweme_count, dongtai_count, favoriting_count, head_img, custom_verify
                    , weibo_verify, enterprise_verify_reason, is_shop, be_followered_uid, create_time
                FROM short_video.base_douyin_user_daily
                WHERE dt='$_dt'

                UNION ALL

                SELECT user_id, sec_user_id, unique_id, nickname, gender, birthday, signature, province, city, cover_img, total_favorited
                    , follower_count, following_count, aweme_count, dongtai_count, favoriting_count, head_img, custom_verify
                    , weibo_verify, enterprise_verify_reason, is_shop, be_followered_uid, create_time
                FROM short_video.base_douyin_user
      ) a
  ) b
  WHERE b.rn=1;
  "
  execHql "$hqlStr"
}

# 增量计算抖音用户信息
function calc_base_douyin_user_daily() {
  if [ $# -ne 2 ]; then
    log "wrong parameters:$@"
    log 'usage:   calc_daily_user_info dt ts'
    log 'example: calc_daily_user_info 20190911 1568165988'
    exit 1
  fi
  _dt=$1
  _ts=$(date +%s)
  log "dt=$_dt, ts=$_ts"
  hqlStr="
  INSERT OVERWRITE TABLE short_video.base_douyin_user_daily PARTITION(dt='$_dt')
  SELECT user_id, sec_user_id, unique_id, nickname, gender, birthday, signature, province, city, cover_img, total_favorited
        , follower_count, following_count, aweme_count, dongtai_count, favoriting_count, head_img, custom_verify
        , weibo_verify, enterprise_verify_reason, is_shop, be_followered_uid, create_time, '$_ts'
  FROM (
        SELECT user_id, sec_user_id, unique_id, nickname, gender, birthday, signature
            , case when province is not null then regexp_replace(province, '[省|市]$','')
                when province is null and city is not null then regexp_replace(city, '[省|市]$','')
                else null end as province
            , case when city is not null then regexp_replace(city, '[省|市]$','') else null end as city
            , cover_img, total_favorited
            , follower_count, following_count, aweme_count, dongtai_count, favoriting_count, head_img, custom_verify
            , weibo_verify, enterprise_verify_reason, is_shop, be_followered_uid, create_time
            , ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY create_time DESC) AS rn
        FROM short_video.log_douyin_user
        WHERE dt='$_dt'
  ) a
    WHERE a.rn=1;
  "
  execHql "$hqlStr"
}

# 检查参数
if [ $# -ne 1 ]; then
  log 'wrong parameters!'
  log 'usage: stat_douyin_user_daily.sh 20190909'
  exit 1
fi

_dt=$1
#批次号，10位时间戳
_ts=$(date +%s)

calc_base_douyin_user_daily ${_dt} ${_ts}
check "calc_base_douyin_user_daily ${_dt} ${_ts}"
calc_base_douyin_user_info ${_dt} ${_ts}
check "calc_base_douyin_user_info ${_dt} ${_ts}"

log "daily stat douyin user job done..."

