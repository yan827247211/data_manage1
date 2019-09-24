#!/usr/bin/env bash

##################################################################
## 统计抖音达人综合榜（含日榜，周榜，月榜）                            ##
##################################################################
## history:                                                     ##
##  2019-09-15 YuLei first release                              ##
##################################################################

#打印通用信息
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
SCRIPT_NAME="$(basename "$0")"
ARGS="$@"
echo '############################################'
echo "This shell locate at:$DIR/$SCRIPT_NAME"
echo "variable: $ARGS"
echo '############################################'
echo "start stat dy_rpt_expert_composite info. "

# 引入通用配置和方法
source "$DIR/common/common_var.sh"
source "$DIR/common/common_func.sh"

# 引入脚本方法

# 计算达人视频统计信息
function stat_dy_rpt_expert_sales_volume() {
  if [ $# -ne 3 ]; then
    log "wrong parameters:$@"
    log 'usage:   stat_douyin_user_video_info anchordt comparedt data_type'
    log 'example: stat_douyin_user_video_info 20190911 20190910 0'
    exit 1
  fi
  _anchordt=$1
  _comparedt=$2
  _data_type=$3
  _formated_anchordt=`date -d "$_anchordt" "+%Y-%m-%d"`
  log "_anchordt=$_anchordt, _comparedt=$_comparedt, ts=$_ts, _formated_anchordt=$_formated_anchordt"
  hqlStr="
      select concat_ws('_', x.user_id,'$_anchordt','0') as id
        , x.rn as ranking
        , x.user_id as user_id
        , y.unique_id as unique_id
        , y.head_img as head_portrait
        , y.nickname as nickname
        , y.follower_count as fans_number
        , 'label' as label
        , x.product_count as at_sell_commodity_number
        , x.user_sales as store_sales
        , x.user_sales_money as shop_sales_amount
        , 0 as continuous_list
        , 0 as date_type
        ,'$_anchordt' as dt
        from (
        select user_id, product_count, cast(user_sales as bigint) as user_sales, cast(user_sales_money as bigint) as user_sales_money,rn from (
        select user_id, product_count, user_sales, user_sales_money, row_number() over (order by user_sales desc) as rn from (
        select rpt.user_id, count(distinct product_id) as product_count, round(sum(total_sales*user_par),0) as user_sales, sum(total_sales*user_par*price) as user_sales_money from (
        select u.product_id, u.user_id, u.par as user_par, g.price as price, g.sales as total_sales
        from (
        select user_id, product_id, digg/sum(digg) over (partition by product_id) as par
        from (
         select user_id, product_id, sum(digg_count) as digg
         from base_douyin_video
         where product_id is not null
         group by user_id, product_id
        ) a) u join base_douyin_goods g on (u.product_id=g.product_id)
        ) rpt
        group by rpt.user_id) wrapper)final
        where rn<=1000)x join base_douyin_user y on (x.user_id=y.user_id)
  "
  exportHQL2Local "$hqlStr" "dy_rpt_expert_composite"
#    echo "$hqlStr"
}


# 检查参数
if [ $# -ne 1 ]; then
  log 'wrong parameters!'
  log "usage: $SCRIPT_NAME 20190909"
  exit 1
fi

_dt=$1
_oneday_ago=`date -d "$_dt 1 day ago" "+%Y%m%d"`
#得到是当周的周几 (0为星期日，1为星期一,...6为星期六)
_whichday=$(date -d $_dt +%w)
#用(statday-whichday)+1，就是某周的第一天，这里是星期一
if [ $_whichday -eq 0 ]; then
  _monday=`date -d "$_dt -6 days" +%Y%m%d`
else
  _monday=`date -d "$_dt -$[${_whichday} - 1] days" +%Y%m%d`
fi
#批次号，10位时间戳
_ts=$(date +%s)
_monthday=`date -d "$_dt" "+%Y%m01"`
echo "dt=$_dt, oneday_ago=$_oneday_ago, monday=$_monday, monthday=$_monthday"

stat_dy_rpt_expert_composite ${_dt} ${_oneday_ago} 0
#check "stat_douyin_user_video_info ${_dt} ${_ts}"

#log "daily stat douyin user stat job done..."