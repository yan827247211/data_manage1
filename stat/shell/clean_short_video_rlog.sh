#!/usr/bin/env bash

##################################################################
## 清洗原始日志，并以ORC格式写入HIVE:                                #
#    1. 抖音                                                      #
#    2. 快手                                                      #
#                                                                #
##################################################################
## history:                                                     ##
##  2019-09-10 YuLei first release                              ##
##################################################################

#打印通用信息
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
SCRIPT_NAME="$(basename "$0")"
ARGS="$@"
echo '############################################'
echo "This shell locate at:$DIR/$SCRIPT_NAME"
echo "variable: $ARGS"
echo '############################################'
echo "Start clean short video raw log "

# 引入通用配置和方法
source "$DIR/common/common_var.sh"
source "$DIR/common/common_func.sh"

# 检查参数
if [ $# -lt 2 ]; then
  log 'wrong parameters!'
  log "usage: $SCRIPT_NAME 20190909 08 "
  exit 1
fi

_dt=$1
_hour=$2

_TARGET_CLEAN_LOG_TYPES=('video' 'user' 'comment')

#如果参数数量大于2，则从第三个参数开始，作为需要倒入的日志类型
if [ $# -gt 2 ]; then
  _TARGET_CLEAN_LOG_TYPES=("${@:3}")
fi

for _logType in "${_TARGET_CLEAN_LOG_TYPES[@]}"; do
    log "start clean douyin.$_logType parameters:$_dt $_hour"
    case $_logType in
      video)
        clean_douyin_video_log $_dt $_hour
        ;;
      user)
        clean_douyin_user_log $_dt $_hour
        ;;
      comment)
        clean_douyin_comment_log $_dt $_hour
        ;;
      goods)
        log "goods clean script is under develop."
        ;;
      music)
        log "music clean script is under develop."
        ;;
      ad)
        log "ad clean script is under develop."
        ;;
      *)
        log "unsuported douyin table $_logType"
        exit 1
        ;;
    esac
done

log "clean log done."