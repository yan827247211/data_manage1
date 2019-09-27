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

# 计算用户信息全量

# 增量计算抖音用户信息
function calc_base_douyin_haowu_daily() {
  if [ $# -ne 2 ]; then
    log "wrong parameters:$@"
    log 'usage:   calc_base_douyin_haowu_daily dt ts'
    log 'example: calc_base_douyin_haowu_daily 20190911 1568165988'
    exit 1
  fi
  _dt=$1
  _ts=$(date +%s)
  log "dt=$_dt, ts=$_ts"
  hqlStr="
  INSERT OVERWRITE TABLE short_video.base_douyin_haowu_daily PARTITION(dt='$_dt')
    SELECT product_id
      , case when promotion_id is null or lower(trim(promotion_id))='null' or length(trim(promotion_id))=0 then null else promotion_id end as promotion_id
      , case when user_id is null or lower(trim(user_id))='null' or length(trim(user_id))=0 then null else user_id end as user_id
      , case when product_title is null or lower(trim(product_title))='null' or length(trim(product_title))=0 then null else product_title end as product_title
      , case when product_img is null or lower(trim(product_img))='null' or length(trim(product_img))=0 then null else product_img end as product_img
      , case when market_price is null or lower(trim(market_price))='null' or length(trim(market_price))=0 then 0 else cast(market_price as bigint) end as market_price
      , case when price is null or lower(trim(price))='null' or length(trim(price))=0 then 0 else cast(price as bigint) end as price
      , case when sales is null or lower(trim(sales))='null' or length(trim(sales))=0 then 0 else cast(sales as bigint) end as sales
      , case when visit_count is null or lower(trim(visit_count))='null' or length(trim(visit_count))=0 then 0 else cast(visit_count as bigint) end as visit_count
      , case when detail_url is null or lower(trim(detail_url))='null' or length(trim(detail_url))=0 then null else detail_url end as detail_url
      , case when rank is null or lower(trim(rank))='null' or length(trim(rank))=0 then 0 else cast(rank as int) end as rank
      , case when score is null or lower(trim(score))='null' or length(trim(score))=0 then 0 else cast(score as bigint) end as score
      , case when cid is null or lower(trim(cid))='null' or length(trim(cid))=0 then null else cid end as cid
      , create_time
      , '$_ts'
    FROM (
      SELECT product_id
      , promotion_id
      , user_id
      , product_title
      , product_img
      , market_price
      , price
      , sales
      , visit_count
      , detail_url
      , rank
      , score
      , cid
      , create_time
      , ROW_NUMBER() OVER (PARTITION BY rank, cid ORDER BY create_time DESC) as rn
      FROM short_video.rlog_douyin_haowu
      WHERE dt='$_dt'
     ) a
    WHERE rn=1
  "
  execHql "$hqlStr"
}

function stat_haowu_goods_onlist_count() {
if [ $# -ne 2 ]; then
    log "wrong parameters:$@"
    log 'usage:   stat_haowu_goods_onlist_count dt ts'
    log 'example: stat_haowu_goods_onlist_count 20190911 1568165988'
    exit 1
  fi
  _dt=$1
  _ts=$(date +%s)
  log "dt=$_dt, ts=$_ts"
  hqlStr="
  INSERT OVERWRITE TABLE short_video.stat_douyin_haowu_goods_onlist_count PARTITION(dt='$_dt')
    SELECT product_id, count(dt) as onListCnt,'$_ts'
    FROM (
     select product_id, dt
     from short_video.base_douyin_haowu_daily
     group by product_id,dt
    ) a
    group by product_id

  "
  execHql "$hqlStr"
}

function stat_haowu_user_onlist_count() {
if [ $# -ne 2 ]; then
    log "wrong parameters:$@"
    log 'usage:   stat_haowu_user_onlist_count dt ts'
    log 'example: stat_haowu_user_onlist_count 20190911 1568165988'
    exit 1
  fi
  _dt=$1
  _ts=$(date +%s)
  log "dt=$_dt, ts=$_ts"
  hqlStr="
  INSERT OVERWRITE TABLE short_video.stat_douyin_haowu_user_onlist_count PARTITION(dt='$_dt')
    SELECT user_id, count(dt) as onListCnt,'$_ts'
    FROM (
     select user_id, dt
     from short_video.base_douyin_haowu_daily
     group by user_id,dt
    ) a
    group by user_id

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

calc_base_douyin_haowu_daily ${_dt} ${_ts}
check "calc_base_douyin_haowu_daily ${_dt} ${_ts}"
stat_haowu_goods_onlist_count ${_dt} ${_ts}
check "stat_haowu_goods_onlist_count ${_dt} ${_ts}"
stat_haowu_user_onlist_count ${_dt} ${_ts}
check "stat_haowu_user_onlist_count ${_dt} ${_ts}"

log "daily stat douyin haowu job done..."

