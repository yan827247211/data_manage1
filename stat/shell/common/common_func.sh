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
