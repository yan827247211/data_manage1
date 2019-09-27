#!/usr/bin/env bash

##################################################################
## 建立抖音评论相关的基础信息                                       ##
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
echo "start stat douyin comment daily info. "

# 引入通用配置和方法
source "$DIR/common/common_var.sh"
source "$DIR/common/common_func.sh"

# 引入脚本方法

# 计算用户信息全量表
function calc_base_douyin_comment_info() {
  if [ $# -ne 2 ]; then
    log "wrong parameters:$@"
    log 'usage:   calc_base_douyin_comment_info dt ts'
    log 'example: calc_base_douyin_comment_info 20190911 1568165988'
    exit 1
  fi
  _dt=$1
  _ts=$2
  log "dt=$_dt, ts=$_ts"
  hqlStr="
  INSERT OVERWRITE TABLE short_video.base_douyin_comment
  SELECT cid, aweme_id, user_id, sec_user_id, c_nickname, c_img, c_url
            , c_time, c_digg_count, is_author_digged, c_text, reply_count, create_time
            , '$_ts'
  FROM (
      SELECT cid, aweme_id, user_id, sec_user_id, c_nickname, c_img, c_url
            , c_time, c_digg_count, is_author_digged, c_text, reply_count, create_time
            , ROW_NUMBER() OVER (PARTITION BY cid ORDER BY create_time DESC) AS rn
      FROM (
            SELECT cid, aweme_id, user_id, sec_user_id, c_nickname, c_img, c_url
                , c_time, c_digg_count, is_author_digged, c_text, reply_count, create_time
            FROM short_video.base_douyin_comment_daily
            WHERE dt='$_dt'

            UNION ALL

            SELECT cid, aweme_id, user_id, sec_user_id, c_nickname, c_img, c_url
                , c_time, c_digg_count, is_author_digged, c_text, reply_count, create_time
            FROM short_video.base_douyin_comment
      ) a
  ) b
  WHERE b.rn=1;
  "
  execHql "$hqlStr"
}

# 增量计算抖音用户信息
function calc_base_douyin_comment_daily() {
  if [ $# -ne 2 ]; then
    log "wrong parameters:$@"
    log 'usage:   calc_base_douyin_comment_daily dt ts'
    log 'example: calc_base_douyin_comment_daily 20190911 1568165988'
    exit 1
  fi
  _dt=$1
  _ts=$(date +%s)
  log "dt=$_dt, ts=$_ts"
  hqlStr="
  INSERT OVERWRITE TABLE short_video.base_douyin_comment_daily PARTITION(dt='$_dt')
  SELECT cid, aweme_id, user_id, sec_user_id, c_nickname, c_img, c_url
            , c_time, c_digg_count, is_author_digged, c_text, reply_count, create_time
            , '$_ts'
  FROM (
        SELECT cid, aweme_id, user_id, sec_user_id, c_nickname, c_img, c_url
            , c_time, c_digg_count, is_author_digged, c_text, reply_count, create_time
            , ROW_NUMBER() OVER (PARTITION BY cid ORDER BY create_time DESC) AS rn
        FROM short_video.log_douyin_comment
        WHERE dt='$_dt'
  ) a
  WHERE a.rn=1;
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

calc_base_douyin_comment_daily ${_dt} ${_ts}
check "calc_base_douyin_comment_daily ${_dt} ${_ts}"
calc_base_douyin_comment_info ${_dt} ${_ts}
check "calc_base_douyin_comment_info ${_dt} ${_ts}"
log "daily stat douyin comment job done..."