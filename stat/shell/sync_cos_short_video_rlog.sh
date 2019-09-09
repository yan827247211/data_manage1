#!/usr/bin/env bash

##################################################################
## 同步短视频项目相关的原始日志到HIVE:                                #
#    1. 抖音                                                      #
#    2. 快手                                                      #
#  to hive                                                       #
##################################################################
## history:                                                     ##
##  2019-09-09 YuLei first release                              ##
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
if [ $# -lt 2 ]; then
  log 'wrong parameters!'
  log 'usage: sync_cos_short_video_rlog.sh 20190909 08 '
  exit 1
fi

add_douyin_partition "$@"

check

log 'finish sync douyin log.'



