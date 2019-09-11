#!/usr/bin/env bash

##################################################################
## 计算抖音达人相关数据，含必要的数据同步                              ##                                                    #
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
echo "Start synchronize short video raw log "

# 引入通用配置和方法
source "$DIR/common/common_var.sh"
source "$DIR/common/common_func.sh"

# 检查参数
if [ $# -ne 1 ]; then
  log 'wrong parameters!'
  log 'usage: stat_douyin_user_daily.sh 20190909'
  exit 1
fi

_dt=$1
#批次号，10位时间戳
_ts=$(date +%s)

stat_daily_user_info ${_dt} ${_ts}
check
log "daily stat douyin user job done..."

