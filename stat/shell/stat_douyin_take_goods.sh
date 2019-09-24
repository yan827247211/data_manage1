#!/usr/bin/env bash

##################################################################
## 统计抖音带货相关视频                                            ##
##################################################################
## history:                                                     ##
##  2019-09-22 YuLei first release                              ##
##################################################################

#打印通用信息
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
SCRIPT_NAME="$(basename "$0")"
ARGS="$@"
echo '############################################'
echo "This shell locate at:$DIR/$SCRIPT_NAME"
echo "variable: $ARGS"
echo '############################################'
echo "start stat douyin take goods daily stat info. "

# 引入通用配置和方法
source "$DIR/common/common_var.sh"
source "$DIR/common/common_func.sh"

# 引入脚本方法

# 计算视频统计信息
function stat_douyin_take_goods() {
  if [ $# -ne 2 ]; then
    log "wrong parameters:$@"
    log 'usage:   stat_douyin_take_goods dt ts'
    log 'example: stat_douyin_take_goods 20190911 1568165988'
    exit 1
  fi
  _dt=$1
  _ts=$2
  log "dt=$_dt, ts=$_ts"
  hqlStr="
      INSERT OVERWRITE TABLE short_video.stat_douyin_take_goods PARTITION(dt='$_dt')
      SELECT a.user_id, a.product_id
        , goods.promotion_id, goods.product_title, goods.product_img, goods.market_price, goods.price, goods.sales
        , cast(round(goods.sales*a.perc) as bigint) as user_sales
        , goods.visit_count, goods.detail_url, goods.rank, goods.score, goods.cid, goods.create_time,'$_ts'
        FROM (
          SELECT stat_percent.user_id, stat_percent.product_id, stat_percent.digg/sum(stat_percent.digg) over (partition  by stat_percent.product_id) as perc
          FROM (
            select user_id, product_id, sum(digg_count) as digg
            FROM short_video.base_douyin_video
            WHERE product_id is not null
            GROUP BY user_id, product_id
          ) stat_percent
        ) a JOIN short_video.base_douyin_goods goods ON (a.product_id=goods.product_id)
  "
  execHql "$hqlStr"
}

# 检查参数
if [ $# -ne 1 ]; then
  log 'wrong parameters!'
  log "usage: $SCRIPT_NAME 20190909"
  exit 1
fi

_dt=$1
#批次号，10位时间戳
_ts=$(date +%s)

stat_douyin_take_goods ${_dt} ${_ts}
check "stat_douyin_take_goods ${_dt} ${_ts}"

log "daily stat douyin take goods stat job done..."