#!/usr/bin/env bash

##################################################################
## 统计抖音达人粉丝（来自评论关系）相关信息                            ##
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
function stat_douyin_user_video_info() {
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
      INSERT OVERWRITE TABLE short_video.stat_douyin_user_video_info PARTITION(dt='$_dt')
      SELECT user_id, count(1), sum(digg_count), sum(comment_count), sum(share_count),'$_ts'
      FROM short_video.base_douyin_video
      GROUP BY user_id
  "
  execHql "$hqlStr"
}

# 计算用户信息全量表
function stat_douyin_user_info() {
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
      INSERT OVERWRITE TABLE short_video.stat_douyin_user_info PARTITION(dt='$_dt')
      SELECT a.user_id, a.total_favorited, a.follower_count, a.following_count, a.aweme_count, a.dongtai_count, a.favoriting_count
      , case when b.video_count is null then 0 else b.video_count end as video_count
      , case when b.video_digg_count is null then 0 else b.video_digg_count end as video_digg_count
      , case when b.video_comment_count is null then 0 else b.video_comment_count end as video_comment_count
      , case when b.video_share_count is null then 0 else b.video_share_count end as video_share_count
      , '$_ts'
      FROM short_video.base_douyin_user a left join short_video.stat_douyin_user_video_info b on (a.user_id=b.user_id and b.dt='$_dt')
      WHERE b.dt='$_dt';

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

stat_douyin_user_video_info ${_dt} ${_ts}
check "stat_douyin_user_video_info ${_dt} ${_ts}"
stat_douyin_user_info ${_dt} ${_ts}
check "stat_douyin_user_info ${_dt} ${_ts}"

log "daily stat douyin user stat job done..."