#!/usr/bin/env bash

##################################################################
## 清洗原始日志，并以ORC格式写入HIVE:                                #
#    1. 抖音                                                      #
#    2. 快手                                                      #
#                                                                #
##################################################################
## history:                                                     ##
##  2019-09-10 YuLei first release                              ##
##################################################################

#打印通用信息
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
SCRIPT_NAME="$(basename "$0")"
ARGS="$@"
echo '############################################'
echo "This shell locate at:$DIR/$SCRIPT_NAME"
echo "variable: $ARGS"
echo '############################################'
echo "Start clean short video raw log "

# 引入通用配置和方法
source "$DIR/common/common_var.sh"
source "$DIR/common/common_func.sh"

# 定义脚本方法
# 清洗抖音video日志
function clean_douyin_video_log() {
  if [ $# -ne 2 ]; then
    log "wrong parameters:$@"
    log 'usage:   clean_douyin_video_log dt hh'
    log 'example: clean_douyin_video_log 20190908 08'
    exit 1
  fi
  _dt=$1
  _hour=$2
  hqlStr="
    INSERT OVERWRITE TABLE short_video.log_douyin_video PARTITION(dt='$_dt', hh='$_hour')
       SELECT aweme_id
        , user_id
        , sec_user_id
        , desc
        , chat
        , cover_img
        , video_create_time
        , case when digg_count is null or lower(trim(digg_count))='null' or length(trim(digg_count))=0 then 0L else cast(digg_count as bigint) end as digg_count
        , case when comment_count is null or lower(trim(comment_count))='null' or length(trim(comment_count))=0 then 0L else cast(comment_count as bigint) end as comment_count
        , case when share_count is null or lower(trim(share_count))='null' or length(trim(share_count))=0 then 0L else cast(share_count as bigint) end as share_count
        , case when duration is null or lower(trim(duration))='null' or length(trim(duration))=0 then 0L else cast(duration as bigint) end as duration
        , case when music_id is null or lower(trim(music_id))='null' or length(trim(music_id))=0 then null else music_id end as music_id
        , case when room_id is null or lower(trim(room_id))='null' or length(trim(room_id))=0 then null else room_id end as room_id
        , case when product_id is null or lower(trim(product_id))='null' or length(trim(product_id))=0 then null else product_id end as product_id
        , case when ad_id is null or lower(trim(ad_id))='null' or length(trim(ad_id))=0 then null else ad_id end as ad_id
        , share_url
        , create_time
        , digg_count
        , comment_count
        , share_count
        , duration
        , music_id
        , room_id
        , product_id
        , ad_id
       FROM short_video.rlog_douyin_video
       WHERE dt='$_dt' and hh='$_hour';
  "
  execHql "$hqlStr"
}

# 清洗抖音user日志
function clean_douyin_user_log() {
  if [ $# -ne 2 ]; then
    log "wrong parameters:$@"
    log 'usage:   clean_douyin_user_log dt hh'
    log 'example: clean_douyin_user_log 20190908 08'
    exit 1
  fi
  _dt=$1
  _hour=$2
  hqlStr="
    INSERT OVERWRITE TABLE short_video.log_douyin_user PARTITION(dt='$_dt', hh='$_hour')
       SELECT user_id
        , sec_user_id
        , unique_id
        , nickname
        , case when gender is null or lower(trim(gender))='null' or length(trim(gender))=0 then null else gender end as gender
        , case when birthday is null or lower(trim(birthday))='null' or length(trim(birthday))=0 then null else birthday end as birthday
        , signature
        , case when city is null or lower(trim(city))='null' or length(trim(city))=0 then null else city end as city
        , cover_img
        , case when total_favorited is null or lower(trim(total_favorited))='null' or length(trim(total_favorited))=0 then 0L else cast(total_favorited as bigint) end as total_favorited
        , case when follower_count is null or lower(trim(follower_count))='null' or length(trim(follower_count))=0 then 0L else cast(follower_count as bigint) end as follower_count
        , case when following_count is null or lower(trim(following_count))='null' or length(trim(following_count))=0 then 0L else cast(following_count as bigint) end as following_count
        , case when aweme_count is null or lower(trim(aweme_count))='null' or length(trim(aweme_count))=0 then 0L else cast(aweme_count as bigint) end as aweme_count
        , case when dongtai_count is null or lower(trim(dongtai_count))='null' or length(trim(dongtai_count))=0 then 0L else cast(dongtai_count as bigint) end as dongtai_count
        , case when favoriting_count is null or lower(trim(favoriting_count))='null' or length(trim(favoriting_count))=0 then 0L else cast(favoriting_count as bigint) end as favoriting_count
        , head_img
        , case when custom_verify is null or lower(trim(custom_verify))='null' or length(trim(custom_verify))=0 then null else custom_verify end as custom_verify
        , case when weibo_verify is null or lower(trim(weibo_verify))='null' or length(trim(weibo_verify))=0 then null else weibo_verify end as weibo_verify
        , case when enterprise_verify_reason is null or lower(trim(enterprise_verify_reason))='null' or length(trim(enterprise_verify_reason))=0 then null else enterprise_verify_reason end as enterprise_verify_reason
        , case when is_shop is null or lower(trim(is_shop))='null' or length(trim(is_shop))=0 then null
            when lower(trim(is_shop))='true' then 1
            when lower(trim(is_shop))='false' then 0
            else is_shop end as is_shop
        , null -- be_followered_uid TODO:old log
        , be_followered_uid -- create_time TODO:old log
        , gender
        , birthday
        , city
        , total_favorited
        , follower_count
        , following_count
        , aweme_count
        , dongtai_count
        , favoriting_count
        , custom_verify
        , weibo_verify
        , enterprise_verify_reason
        , is_shop
       FROM short_video.rlog_douyin_user
       WHERE dt='$_dt' and hh='$_hour';
  "
  execHql "$hqlStr"
}

# 清洗抖音comment日志
function clean_douyin_comment_log() {
  if [ $# -ne 2 ]; then
    log "wrong parameters:$@"
    log 'usage:   clean_douyin_comment_log dt hh'
    log 'example: clean_douyin_comment_log 20190908 08'
    exit 1
  fi
  _dt=$1
  _hour=$2
  hqlStr="
    INSERT OVERWRITE TABLE short_video.log_douyin_comment PARTITION(dt='$_dt', hh='$_hour')
       SELECT cid
        , aweme_id
        , user_id
        , sec_user_id
        , c_nickname
        , c_img
        , c_url
        , c_time
        , case when c_digg_count is null or lower(trim(c_digg_count))='null' or length(trim(c_digg_count))=0 then 0L else cast(c_digg_count as bigint) end as c_digg_count
        , case when is_author_digged is null or lower(trim(is_author_digged))='null' or length(trim(is_author_digged))=0 then null
            when lower(trim(is_author_digged))='true' then 1
            when lower(trim(is_author_digged))='false' then 0
            else is_author_digged end as is_author_digged
        , c_text
        , case when reply_count is null or lower(trim(reply_count))='null' or length(trim(reply_count))=0 then 0L else cast(reply_count as bigint) end as reply_count
        , create_time
        , c_digg_count
        , is_author_digged
        , reply_count
       FROM short_video.rlog_douyin_comment
       WHERE dt='$_dt' and hh='$_hour';
  "
  execHql "$hqlStr"
}

# 检查参数
if [ $# -lt 2 ]; then
  log 'wrong parameters!'
  log "usage: $SCRIPT_NAME 20190909 08 "
  exit 1
fi

_dt=$1
_hour=$2

_TARGET_CLEAN_LOG_TYPES=('video' 'user' 'comment')

#如果参数数量大于2，则从第三个参数开始，作为需要倒入的日志类型
if [ $# -gt 2 ]; then
  _TARGET_CLEAN_LOG_TYPES=("${@:3}")
fi

for _logType in "${_TARGET_CLEAN_LOG_TYPES[@]}"; do
    log "start clean douyin.$_logType parameters:$_dt $_hour"
    case $_logType in
      video)
        clean_douyin_video_log $_dt $_hour
        ;;
      user)
        clean_douyin_user_log $_dt $_hour
        ;;
      comment)
        clean_douyin_comment_log $_dt $_hour
        ;;
      goods)
        log "goods clean script is under develop."
        ;;
      music)
        log "music clean script is under develop."
        ;;
      ad)
        log "ad clean script is under develop."
        ;;
      *)
        log "unsuported douyin table $_logType"
        exit 1
        ;;
    esac
done

log "clean log done."