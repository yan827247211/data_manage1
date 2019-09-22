#!/usr/bin/env bash

##################################################################
## 统计抖音短视频相关信息                                           ##
##################################################################
## history:                                                     ##
##  2019-09-22 YuLei first release                              ##
##################################################################

#打印通用信息
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
SCRIPT_NAME="$(basename "$0")"
ARGS="$@"
echo '############################################'
echo "This shell locate at:$DIR/$SCRIPT_NAME"
echo "variable: $ARGS"
echo '############################################'
echo "start stat douyin video daily stat info. "

# 引入通用配置和方法
source "$DIR/common/common_var.sh"
source "$DIR/common/common_func.sh"

# 引入脚本方法

# 计算视频统计信息
function stat_douyin_video_info() {
  if [ $# -ne 2 ]; then
    log "wrong parameters:$@"
    log 'usage:   stat_douyin_video_info dt ts'
    log 'example: stat_douyin_video_info 20190911 1568165988'
    exit 1
  fi
  _dt=$1
  _ts=$2
  log "dt=$_dt, ts=$_ts"
  hqlStr="
      INSERT OVERWRITE TABLE short_video.stat_douyin_video_info PARTITION(dt='$_dt')
      SELECT aweme_id, user_id, digg_count, comment_count, share_count,'$_ts'
      FROM short_video.base_douyin_video
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

stat_douyin_video_info ${_dt} ${_ts}
check "stat_douyin_video_info ${_dt} ${_ts}"

log "daily stat douyin user stat job done..."