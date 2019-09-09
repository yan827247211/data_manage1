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
  ${MYSQL_BIN} -h${MYSQL_REPORT_HOST} -P${MYSQL_REPORT_PORT} -u${MYSQL_REPORT_USER} -p${MYSQL_REPORT_PWD} ${MYSQL_REPORT_DB} -N -e "${sqlStr}" >${localPath}
}

# 执行Mysql语句
function execSql() {
  if [ $# -ne 1 ]; then
    log "USAGE: execSql sql "
    exit
  fi

  sqlStr=$1
  ${MYSQL_BIN} -h${MYSQL_W_HOST} -P${MYSQL_PORT} -u${MYSQL_W_USER} -p${MYSQL_W_PWD} ${MYSQL_W_DBNAME} -N -e "${sqlStr}"
}

# 执行Hive语句
function execHql() {
  if [ $# -ne 1 ]; then
    log "USAGE: execSql hql "
    exit
  fi
  hqlStr=$1
  echo "${HIVE_BIN} -e "
  echo "$hqlStr"
}

# 增加抖音分区
function add_douyin_partition() {
  if [ $# != 2 ]; then
    log 'wrong parameters!'
    log 'usage:   add_douyin_partition dt hh'
    log 'example: add_douyin_partition 20190908 08'
    exit 1
  fi

  _ALL_DOUYIN_LOG_TYPES=('video' 'user')

  _dt=$1
  _hour=$2
  _logType=$3
  _table=''
  _hql=''

  for _logType in "${_ALL_DOUYIN_LOG_TYPES[@]}"; do
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
    _hql="${_hql}alter table ${_table} add if not exists partition(dt='${pDt}',hh='${pHour}') location '$COSN_DOUYIN_BUCKET_PATH_PREFIX/$_logType/$pDt/$pHour/';"
  done

  execHql "$_hql"
#  echo "${_hql}"
}
