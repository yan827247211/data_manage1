#!/usr/bin/env bash

##################################################################
## 统计抖音好物榜（含日榜，周榜，月榜）                            ##
##################################################################
## history:                                                     ##
##  2019-09-25 YuLei first release                              ##
##################################################################

#打印通用信息
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
SCRIPT_NAME="$(basename "$0")"
ARGS="$@"
echo '############################################'
echo "This shell locate at:$DIR/$SCRIPT_NAME"
echo "variable: $ARGS"
echo '############################################'
echo "start stat dy_rpt_good_commodity info. "

# 引入通用配置和方法
source "$DIR/common/common_var.sh"
source "$DIR/common/common_func.sh"

# 引入脚本方法

# 计算达人视频统计信息
function stat_dy_rpt_good_commodity_day() {
  if [ $# -ne 3 ]; then
    log "wrong parameters:$@"
    log 'usage:   stat_dy_rpt_good_commodity anchordt comparedt data_type'
    log 'example: stat_dy_rpt_good_commodity 20190911 20190910 0'
    exit 1
  fi
  _anchordt=$1
  _comparedt=$2
  _data_type=$3
  _formated_anchordt=`date -d "$_anchordt" "+%Y-%m-%d"`
  log "_anchordt=$_anchordt, _comparedt=$_comparedt, ts=$_ts, _formated_anchordt=$_formated_anchordt"
  hqlStr="
        select concat_ws('_', product_id,'$_anchordt',cid,'0' )
        , coalesce(stat.user_id,0) as user_id
        , ranking
        , score
        , product_id
        , product_img
        , product_title
        , cid
        , brand_name
        , coalesce(us.unique_id,'')
        , coalesce(us.head_img,'')
        , coalesce(us.nickname,'')
        , coalesce(us.follower_count,0)
        , commodity_price
        , commodity_price_interval
        , sales
        , sales_volume_interval
        , continuous_list
        , '0'
        , '$_anchordt'
        , from_unixtime($_ts) as create_time
        , from_unixtime($_ts) as update_time
        , 0 as status
        from (
        select
        user_id
        , row_number() over (order by score desc) as ranking
        , score
        , a.product_id, product_img, product_title, cid, '' as brand_name
        , cast(price/100 as decimal(10,2)) as commodity_price
        , case when price>=1 and price<5000 then 1
           when price>=5000 and price<10000 then 2
           when price>=10000 and price<20000 then 3
           when price>=20000 and price<50000 then 4
           when price>=50000 then 5
          end as commodity_price_interval
        , sales
        , case when sales<1000 then 1
           when sales>=1000 and sales<10000 then 2
           when sales>=10000 and sales<50000 then 3
           when sales>=50000 and sales<100000 then 4
           when sales>=100000 and sales<200000 then 5
           when sales>=200000 and sales<500000 then 6
           when sales>=500000 then 7
          end as sales_volume_interval,
          b.onlist_cnt as continuous_list
        from short_video.base_douyin_haowu_daily a left join short_video.stat_douyin_haowu_goods_onlist_count b on (a.product_id=b.product_id and a.dt='$_anchordt' and b.dt='$_anchordt')
        where a.dt='$_anchordt' and b.dt='$_anchordt') stat left join short_video.stat_douyin_user_info us on (stat.user_id=us.user_id and us.dt='$_anchordt')
  "

  exportHQL2MySQL "$hqlStr" "stat_dy_rpt_good_commodity_day" "$_anchordt" 'video_report.dy_rpt_good_commodity'

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

stat_dy_rpt_good_commodity_day ${_dt} ${_oneday_ago} 0
check "stat_dy_rpt_good_commodity_day ${_dt} ${_ts}"

log "stat_dy_rpt_good_commodity_day job done..."