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

# 定义脚本方法
# 增加抖音分区
function add_douyin_partition() {
  if [ $# -lt 2 ]; then
    log 'wrong parameters!'
    log 'usage:   add_douyin_partition dt hh [log_type...]'
    log 'example: add_douyin_partition 20190908 08'
    log 'example: add_douyin_partition 20190908 08 video user'
    exit 1
  fi

  _ALL_DOUYIN_LOG_TYPES=('video' 'user' 'goods')
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
        _table='short_video.rlog_douyin_goods'
        ;;
      haowu)
        _table='short_video.rlog_douyin_haowu'
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

# 检查参数
if [ $# -lt 2 ]; then
  log 'wrong parameters!'
  log 'usage: sync_cos_short_video_rlog.sh 20190909 08 '
  exit 1
fi

add_douyin_partition "$@"

check
log 'finish sync douyin log.'



