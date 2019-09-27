#!/usr/bin/env bash

##################################################################
## 计算抖音视频相关数据，含必要的数据同步                              ##
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
echo "Start stat douyin video daily info. "

# 引入通用配置和方法
source "$DIR/common/common_var.sh"
source "$DIR/common/common_func.sh"

# 引入脚本方法

# 计算用户信息全量表
function calc_base_douyin_video_info() {
  if [ $# -ne 2 ]; then
    log "wrong parameters:$@"
    log 'usage:   calc_base_douyin_video_info dt ts'
    log 'example: calc_base_douyin_video_info 20190911 1568165988'
    exit 1
  fi
  _dt=$1
  _ts=$2
  log "dt=$_dt, ts=$_ts"
  hqlStr="
  set mapreduce.reduce.shuffle.input.buffer.percent=0.7;
  set mapreduce.reduce.shuffle.memory.limit.percent=0.1;
  set mapreduce.reduce.shuffle.merge.percent=0.5;
  set hive.optimize.skewjoin=true;
  INSERT OVERWRITE TABLE short_video.base_douyin_video
  SELECT aweme_id, user_id, sec_user_id, desc, chat, cover_img, video_create_time, digg_count
        , comment_count, share_count, duration, music_id, room_id, product_id, ad_id, share_url
        -- , vb_rank, vb_rank_value
        , create_time, '$_ts'
  FROM (
      SELECT aweme_id, user_id, sec_user_id, desc, chat, cover_img, video_create_time, digg_count
            , comment_count, share_count, duration, music_id, room_id, product_id, ad_id, share_url
            -- , vb_rank, vb_rank_value
            , create_time, stat_time
            , ROW_NUMBER() OVER (PARTITION BY aweme_id ORDER BY create_time DESC) AS rn
      FROM (
                SELECT aweme_id, user_id, sec_user_id, desc, chat, cover_img, video_create_time, digg_count
                    , comment_count, share_count, duration, music_id, room_id, product_id, ad_id, share_url
                    -- , vb_rank, vb_rank_value
                    , create_time, stat_time
                FROM short_video.base_douyin_video_daily
                WHERE dt='$_dt'

                UNION ALL

                SELECT aweme_id, user_id, sec_user_id, desc, chat, cover_img, video_create_time, digg_count
                    , comment_count, share_count, duration, music_id, room_id, product_id, ad_id, share_url
                    -- , vb_rank, vb_rank_value
                    , create_time, stat_time
                FROM short_video.base_douyin_video
      ) a
  ) b
  WHERE b.rn=1;
  "
  execHql "$hqlStr"
}

# 增量计算抖音用户信息
function calc_base_douyin_video_daily() {
  if [ $# -ne 2 ]; then
    log "wrong parameters:$@"
    log 'usage:   calc_base_douyin_video_daily dt ts'
    log 'example: calc_base_douyin_video_daily 20190911 1568165988'
    exit 1
  fi
  _dt=$1
  _ts=$(date +%s)
  log "dt=$_dt, ts=$_ts"
  hqlStr="
  set mapreduce.reduce.shuffle.input.buffer.percent=0.7;
  set mapreduce.reduce.shuffle.memory.limit.percent=0.1;
  set mapreduce.reduce.shuffle.merge.percent=0.5;
  set hive.optimize.skewjoin=true;
  INSERT OVERWRITE TABLE short_video.base_douyin_video_daily PARTITION(dt='$_dt')
  SELECT aweme_id, user_id, sec_user_id, desc, chat, cover_img, video_create_time, digg_count
            , comment_count, share_count, duration, music_id, room_id, product_id, ad_id, share_url
            -- , vb_rank, vb_rank_value
            , create_time, '$_ts'
  FROM (
        SELECT aweme_id, user_id, sec_user_id, desc, chat, cover_img, video_create_time, digg_count
            , comment_count, share_count, duration, music_id, room_id, product_id, ad_id, share_url
            -- , vb_rank, vb_rank_value
            , create_time
            , ROW_NUMBER() OVER (PARTITION BY aweme_id ORDER BY create_time DESC) AS rn
        FROM short_video.log_douyin_video
        WHERE dt='$_dt'
  ) a
    WHERE a.rn=1;
  "
  execHql "$hqlStr"
}

# 检查参数
if [ $# -ne 1 ]; then
  log 'wrong parameters!'
  log 'usage: stat_douyin_video_daily.sh 20190909'
  exit 1
fi

_dt=$1
#批次号，10位时间戳
_ts=$(date +%s)

calc_base_douyin_video_daily ${_dt} ${_ts}
check "calc_base_douyin_video_daily ${_dt} ${_ts}"
calc_base_douyin_video_info ${_dt} ${_ts}
check "calc_base_douyin_video_info ${_dt} ${_ts}"

log "daily stat douyin video job done..."

