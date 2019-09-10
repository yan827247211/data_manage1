#!/usr/bin/env bash

# 用来存放公共方法

# 打印日志，带上当前时间 yyyy-MM-dd hh:mm:ss
function log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S'): $1"
}

# 检查上一个命令是否执行成功，若失败，直接答应日志并退出脚本
# TODO：加上失败回调
function check() {
  if [ $? -ne 0 ]; then
    log "error, exit"
    exit
  fi
}

# 执行Mysql语句，并将结果到处到本地文件
function exportSQL2Local() {
  if [ $# -ne 2 ]; then
    log "USAGE: exportSQL2Local sql localpath"
    exit
  fi

  sqlStr=$1
  localPath=$2
  ${MYSQL_BIN} -h"${MYSQL_REPORT_HOST}" -P"${MYSQL_REPORT_PORT}" -u"${MYSQL_REPORT_USER}" -p"${MYSQL_REPORT_PWD}" "${MYSQL_REPORT_DB}" -N -e "${sqlStr}" >"${localPath}"
}

# 执行Mysql语句
function execSql() {
  if [ $# -ne 1 ]; then
    log "USAGE: execSql sql "
    exit
  fi

  sqlStr=$1
  ${MYSQL_BIN} -h"${MYSQL_W_HOST}" -P"${MYSQL_PORT}" -u"${MYSQL_W_USER}" -p"${MYSQL_W_PWD}" "${MYSQL_W_DBNAME}" -N -e "${sqlStr}"
}

# 执行Hive语句
function execHql() {
  if [ $# -ne 1 ]; then
    log "USAGE: execSql hql "
    exit
  fi
  hqlStr=$1
  echo "execHql:$hqlStr"
  ${HIVE_BIN} -e "$hqlStr"
}

# 增加抖音分区
function add_douyin_partition() {
  if [ $# -lt 2 ]; then
    log 'wrong parameters!'
    log 'usage:   add_douyin_partition dt hh [log_type...]'
    log 'example: add_douyin_partition 20190908 08'
    log 'example: add_douyin_partition 20190908 08 video user'
    exit 1
  fi

  _ALL_DOUYIN_LOG_TYPES=('video' 'user')
  _TARGET_LOG_TYPES=("${_ALL_DOUYIN_LOG_TYPES[@]}")

#如果参数数量大于2，则从第三个参数开始，作为需要倒入的日志类型
  if [ $# -gt 2 ]; then
    _TARGET_LOG_TYPES=("${@:3}")
  fi

  _dt=$1
  _hour=$2
  _logType=''
  _table=''
  _hql=''

  for _logType in "${_TARGET_LOG_TYPES[@]}"; do
    log "start synchronize douyin.$_logType"
    case $_logType in
      video)
        _table='short_video.rlog_douyin_video'
        ;;
      user)
        _table='short_video.rlog_douyin_user'
        ;;
      comment)
        _table='short_video.rlog_douyin_comment'
        ;;
      goods)
        _table='goods'
        ;;
      music)
        _table='music'
        ;;
      ad)
        _table='ad'
        ;;
      *)
        log "unsuported douyin table $_logType"
        exit 1
        ;;
    esac
    _hql="${_hql}alter table ${_table} add if not exists partition(dt='${_dt}',hh='${_hour}') location '$COSN_DOUYIN_BUCKET_PATH_PREFIX/$_logType/$_dt/$_hour';"
  done

  execHql "$_hql"
#  echo "${_hql}"
}

function clean_video_log() {
  if [ $# -ne 2 ]; then
    log "wrong parameters:$@"
    log 'usage:   clean_video_log dt hh'
    log 'example: add_douyin_partition 20190908 08'
    exit 1
  fi
  _dt=$1
  _hour=$2
  hqlStr="
    INSERT OVERWRITE TABLE log_douyin_video PARTITION(dt='$_dt', hh='$_hour')
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
       FROM rlog_douyin_video
       WHERE dt='$_dt' and hh='$_hour'
  "
}
