#!/usr/bin/env bash

##################################################################
## 计算抖音商品相关数据，含必要的数据同步                             ##
##################################################################
## history:                                                     ##
##  2019-09-21 YuLei first release                              ##
##################################################################

#打印通用信息
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
SCRIPT_NAME="$(basename "$0")"
ARGS="$@"
echo '############################################'
echo "This shell locate at:$DIR/$SCRIPT_NAME"
echo "variable: $ARGS"
echo '############################################'
echo "Start stat douyin goods daily info. "

# 引入通用配置和方法
source "$DIR/common/common_var.sh"
source "$DIR/common/common_func.sh"

# 引入脚本方法

# 计算用户信息全量表
function calc_base_douyin_goods_info() {
  if [ $# -ne 2 ]; then
    log "wrong parameters:$@"
    log 'usage:   calc_base_douyin_goods_info dt ts'
    log 'example: calc_base_douyin_goods_info 20190911 1568165988'
    exit 1
  fi
  _dt=$1
  _ts=$2
  log "dt=$_dt, ts=$_ts"
  hqlStr="
  INSERT OVERWRITE TABLE short_video.base_douyin_goods
  SELECT product_id, promotion_id, user_id, product_title, product_img, market_price
         , price, sales, visit_count, detail_url, rank, score, cid, create_time, '$_ts'
  FROM (
      SELECT product_id, promotion_id, user_id, product_title, product_img, market_price
             , price, sales, visit_count, detail_url, rank, score, cid, create_time
             , ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY create_time DESC) AS rn
      FROM (
                SELECT product_id, promotion_id, user_id, product_title, product_img, market_price
                    , price, sales, visit_count, detail_url, rank, score, cid, create_time
                FROM short_video.base_douyin_goods_daily
                WHERE dt='$_dt'

                UNION ALL

                SELECT product_id, promotion_id, user_id, product_title, product_img, market_price
                    , price, sales, visit_count, detail_url, rank, score, cid, create_time
                FROM short_video.base_douyin_goods
      ) a
  ) b
  WHERE b.rn=1;
  "
  execHql "$hqlStr"
}

function stat_base_douyin_goods() {
  if [ $# -ne 2 ]; then
    log "wrong parameters:$@"
    log 'usage:   stat_base_douyin_goods dt ts'
    log 'example: stat_base_douyin_goods 20190911 1568165988'
    exit 1
  fi
  _dt=$1
  _ts=$2
  log "dt=$_dt, ts=$_ts"
  hqlStr="
  INSERT OVERWRITE TABLE short_video.stat_douyin_goods PARTITION(dt='$_dt')
  SELECT product_id, promotion_id, user_id, product_title, product_img, market_price
         , price, sales, visit_count, detail_url, rank, score, cid, create_time, '$_ts'
  FROM short_video.base_douyin_goods
  "
  execHql "$hqlStr"
}

# 增量计算抖音用户信息
function calc_base_douyin_goods_daily() {
  if [ $# -ne 2 ]; then
    log "wrong parameters:$@"
    log 'usage:   calc_base_douyin_goods_daily dt ts'
    log 'example: calc_base_douyin_goods_daily 20190911 1568165988'
    exit 1
  fi
  _dt=$1
  _ts=$(date +%s)
  log "dt=$_dt, ts=$_ts"
  hqlStr="
  INSERT OVERWRITE TABLE short_video.base_douyin_goods_daily PARTITION(dt='$_dt')
  SELECT product_id, promotion_id, user_id, product_title, product_img, market_price
        , price, sales, visit_count, detail_url, rank, score, cid, create_time
        , '$_ts'
  FROM (
        SELECT product_id, promotion_id, user_id, product_title, product_img, market_price
            , price, sales, visit_count, detail_url, rank, score, cid, create_time
            , ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY create_time DESC) AS rn
        FROM short_video.log_douyin_goods
        WHERE dt='$_dt'
  ) a
    WHERE a.rn=1;
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

calc_base_douyin_goods_daily ${_dt} ${_ts}
check "calc_base_douyin_goods_daily ${_dt} ${_ts}"
calc_base_douyin_goods_info ${_dt} ${_ts}
check "calc_base_douyin_goods_info ${_dt} ${_ts}"
stat_base_douyin_goods ${_dt} ${_ts}
check "stat_base_douyin_goods ${_dt} ${_ts}"

log "daily stat douyin goods job done..."

