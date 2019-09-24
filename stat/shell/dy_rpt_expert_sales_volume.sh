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

# 计算达人带货数据
function stat_dy_rpt_expert_sales_volume() {
  if [ $# -ne 3 ]; then
    log "wrong parameters:$@"
    log 'usage:   stat_dy_rpt_expert_sales_volume anchordt comparedt data_type'
    log 'example: stat_dy_rpt_expert_sales_volume 20190911 20190910 0'
    exit 1
  fi
  _anchordt=$1
  _comparedt=$2
  _data_type=$3
  _formated_anchordt=`date -d "$_anchordt" "+%Y-%m-%d"`
  log "_anchordt=$_anchordt, _comparedt=$_comparedt, ts=$_ts, _formated_anchordt=$_formated_anchordt"
  hqlStr="
      select concat_ws('_', x.user_id,'$_anchordt','0') as id
        , x.ranking as ranking
        , x.user_id as user_id
        , y.unique_id as unique_id
        , y.head_img as head_portrait
        , y.nickname as nickname
        , y.follower_count as fans_number
        , '' as label
        , x.at_sale_goods as at_sell_commodity_number
        , x.sales as store_sales
        , x.sales_amount as shop_sales_amount
        , onlist_cnt as continuous_list
        , 0 as date_type
        ,'$_anchordt' as dt
        , null as create_time
        , null as update_time
        , null as status
        from (
            select user_id, at_sale_goods,sales,sales_amount,onlist_cnt,ranking from (
                select a.user_id, a.at_sale_goods, a.sales, a.sales_amount
                , case when b.onlist_cnt is null then 0 else b.onlist_cnt end as onlist_cnt,
                row_number() over (order by case when b.onlist_cnt is null then 0 else b.onlist_cnt end desc, a.sales desc) as ranking
                from (
                    select user_id, count(distinct product_id) at_sale_goods, sum(user_sales) sales, cast(sum(user_sales*price/100) as decimal(10,2)) as sales_amount
                    from short_video.stat_douyin_take_goods
                    where dt='$_anchordt'
                    group by user_id
                ) as a left join short_video.base_douyin_haowu_user_onlist_count b on (a.user_id=b.user_id)
            ) c
            where ranking<=1000
        ) x left join short_video.stat_douyin_user_info y on (x.user_id=y.user_id and y.dt='$_anchordt')
  "
  exportHQL2Local "$hqlStr" "dy_rpt_expert_sales_volume"
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

stat_dy_rpt_expert_sales_volume ${_dt} ${_oneday_ago} 0
#check "stat_douyin_user_video_info ${_dt} ${_ts}"

#log "daily stat douyin user stat job done..."