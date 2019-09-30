#!/usr/bin/env bash

##################################################################
## 手动调度                                                      ##
##################################################################
## history:                                                     ##
##  2019-09-28 YuLei first release                              ##
##################################################################

#打印通用信息
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
SCRIPT_NAME="$(basename "$0")"
ARGS="$@"
echo '############################################'
echo "This shell locate at:$DIR/$SCRIPT_NAME"
echo "variable: $ARGS"
echo '############################################'
echo "start daily job info. "

# 引入通用配置和方法
source "$DIR/common/common_var.sh"
source "$DIR/common/common_func.sh"

_dt=`date +%Y%m%d`
_job_dt=`date +%Y%m%d`

if [ $# -eq 1 ]; then
  _job_dt=$1
fi
log "job_dt=$_job_dt"

log '=============start to sync and clean logs============='
/home/hadoop/yulei/shell/build_daily_log.sh $_job_dt haowu
log '=============sync and clean logs done============='


log '=============start to calc report============='
/home/hadoop/yulei/shell/dy_rpt_expert_sales_volume.sh $_job_dt
/home/hadoop/yulei/shell/dy_rpt_good_commodity.sh $_job_dt
log '=============calc profile done============='
