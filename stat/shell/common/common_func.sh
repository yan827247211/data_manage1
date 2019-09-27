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
  echo "sql:$1"
  echo "local_path:$2"
  ${MYSQL_BIN} -h"${MYSQL_REPORT_HOST}" -P"${MYSQL_REPORT_PORT}" -u"${MYSQL_REPORT_USER}" -p"${MYSQL_REPORT_PWD}" "${MYSQL_REPORT_DB}" -N -e "${sqlStr}" >"${localPath}"
}

# 执行Mysql语句
function execSql() {
  if [ $# -ne 1 ]; then
    log "USAGE: execSql sql "
    exit
  fi

  sqlStr=$1
  echo "$sqlStr"
  ${MYSQL_BIN} -h"${MYSQL_REPORT_HOST}" -P"${MYSQL_REPORT_PORT}" -u"${MYSQL_REPORT_USER}" -p"${MYSQL_REPORT_PWD}" "${MYSQL_REPORT_DB}" -N -e "${sqlStr}"
}

# 执行Hive语句
function execHql() {
  if [ $# -ne 1 ]; then
    log "USAGE: execSql hql "
    exit
  fi
  hqlStr="set mapred.child.java.opts=-Xmx2048m;
          set mapreduce.map.memory.mb=2048;
          set mapreduce.reduce.memory.mb=2048;
        "$1
  echo "execHql:$hqlStr"
  ${HIVE_BIN} -e "$hqlStr"
}

#导出hive命令的执行结果到本地路径
function exportHQL2Local() {
  if [ $# -ne 2 ]; then
    log "USAGE: exportHQL2Local hiveql localpath"
    exit;
  fi

  _hql=$1
  _localpath=$2
  _job_dt=`date '+%Y-%m-%d'`
  _job_time=`date '+%H_%M_%S'`
  _ab_path="/home/hadoop/yulei/shell/data/$_localpath/$_job_dt/$_job_time/"
  # for safty
  _insert_local_hql="INSERT OVERWRITE DIRECTORY '$_ab_path'
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY '\t'
    $_hql
    "
   execHql "$_insert_local_hql"

}

#导出hive命令的执行结果到MySQL
function exportHQL2MySQL() {
  if [ $# -ne 4 ]; then
    log "USAGE: exportHQL2Local hiveql localpath date_dt table"
    exit;
  fi

  _hql=$1
  _localpath=$2
  _date_dt=$3
  _table=$4
  _job_dt=`date '+%Y-%m-%d'`
  _job_time=`date '+%H_%M_%S'`
  _ab_path="/home/hadoop/yulei/shell/data/$_localpath/$_job_dt/$_job_time/"
  # for safty
  _insert_local_hql="INSERT OVERWRITE DIRECTORY '$_ab_path'
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY '\t'
    $_hql
    "
   execHql "$_insert_local_hql"
   # 目录不存在则创建目录
   if [ ! -d "$_ab_path" ]; then
       mkdir -p "$_ab_path"
   fi
   ${HADOOP_BIN} fs -text $_ab_path* > ${_ab_path}result.txt

   execSql "delete from $_table where date='$_date_dt';
   LOAD DATA local INFILE '${_ab_path}result.txt' INTO TABLE $_table
   FIELDS TERMINATED BY '\t';
"

   echo "$_ab_path"

}

#导出hive命令的执行结果到MySQL
function exportHQL2MySQLReplace() {
  if [ $# -ne 4 ]; then
    log "USAGE: exportHQL2Local hiveql localpath date_dt table"
    exit;
  fi

  _hql=$1
  _localpath=$2
  _date_dt=$3
  _table=$4
  _job_dt=`date '+%Y-%m-%d'`
  _job_time=`date '+%H_%M_%S'`
  _ab_path="/home/hadoop/yulei/shell/data/$_localpath/$_job_dt/$_job_time/"
  # for safty
  _insert_local_hql="INSERT OVERWRITE DIRECTORY '$_ab_path'
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY '\t'
    $_hql
    "
   execHql "$_insert_local_hql"
   # 目录不存在则创建目录
   if [ ! -d "$_ab_path" ]; then
       mkdir -p "$_ab_path"
   fi
   ${HADOOP_BIN} fs -text $_ab_path* > ${_ab_path}result.txt

   execSql "
   LOAD DATA local INFILE '${_ab_path}result.txt' REPLACE INTO TABLE $_table
   FIELDS TERMINATED BY '\t';
   "

   echo "$_ab_path"

}


