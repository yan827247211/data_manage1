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
    log "$1 error, exit"
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

#执行MySQL命令，并将结果导出到本地路径
function exportSQL2Local() {
  if [ $# -ne 2 ]; then
    log "USAGE: exportSQL2Local sql localpath"
    exit;
  fi

  sqlStr=$1
  localPath=$2
  ${MYSQL_BIN} -h${MYSQL_HOST} -P${MYSQL_PORT} -u${MYSQL_USER} -p${MYSQL_PWD} ${MYSQL_DBNAME} -N -e "${sqlStr}" > ${localPath}
}

#导出hive命令的执行结果到本地路径
function exportSQL2Local() {
  if [ $# -ne 2 ]; then
    log "USAGE: exportSQL2Local hiveql localpath"
    exit;
  fi

  _hql=$1
  _localpath=$2
  _job_dt=`date '+%Y-%m-%d'`
  _job_time=`date '+%H_%M_%S'`
  # for safty
  _insert_local_hql="INSERT OVERWRITE DIRECTORY '/home/hadoop/yulei/shell/data/$_localpath/$_job_dt/$_job_time/'
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY '\t'
    $_hql
    "
   execHql "$_insert_local_hql"

}





