#!/usr/bin/env bash

##################################################################
## 清洗日志完整流程                                                 #
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
function add_douyin_partition_day() {
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
    if ${HDFS_BIN} dfs -test -e $COSN_DOUYIN_BUCKET_PATH_PREFIX/$_logType/$_dt/$_hour
    then
       $DIR/sync_cos_short_video_rlog.sh $_dt $_hour $_logType
       $DIR/clean_short_video_rlog.sh $_dt $_hour $_logType
    else
       log "cos not exists: $COSN_DOUYIN_BUCKET_PATH_PREFIX/$_logType/$_dt/$_hour"
    fi
  done
}

function build_stat_tables() {
  if [ $# -lt 2 ]; then
    log 'wrong parameters!'
    log 'usage:   build_stat_tables dt [log_type...]'
    log 'example: build_stat_tables 20190908'
    log 'example: build_stat_tables 20190908 video user'
    exit 1
  fi

  _ALL_DOUYIN_LOG_TYPES=('video' 'user' 'goods')
  _TARGET_LOG_TYPES=("${_ALL_DOUYIN_LOG_TYPES[@]}")

#如果参数数量大于1，则从第三个参数开始，作为需要倒入的日志类型
  if [ $# -gt 1 ]; then
    _TARGET_LOG_TYPES=("${@:2}")
  fi

  _dt=$1

  for _logType in "${_TARGET_LOG_TYPES[@]}"; do
      case $_logType in
        video)
          $DIR/build_base_douyin_video_daily.sh $_dt
          $DIR/stat_douyin_video_info.sh $_dt
          ;;
        user)
          $DIR/build_base_douyin_user_daily.sh $_dt
          $DIR/stat_douyin_user_info.sh $_dt
          ;;
        comment)
          $DIR/build_base_douyin_comment.sh $_dt
          ;;
        goods)
          $DIR/build_base_douyin_goods_daily.sh $_dt
          $DIR/stat_douyin_take_goods.sh $_dt
          ;;
        haowu)
          $DIR/build_base_douyin_haowu_daily.sh $_dt
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
  done
}

# 检查参数
if [ $# -lt 1 ]; then
  log 'wrong parameters!'
  log 'usage: sync_cos_short_video_rlog.sh 20190909 '
  exit 1
fi

_jobDt="$1"
_otherArgs="${@:2}"
echo "$_jobDt"
echo "$_otherArgs"

for pHh in {0..23}
  do
    if [ ${pHh} -le 9 ];then
      pHh="0${pHh}"
    fi
    add_douyin_partition_day $_jobDt $pHh $_otherArgs
  done
check

build_stat_tables $_jobDt $_otherArgs

log 'finish sync douyin log.'



