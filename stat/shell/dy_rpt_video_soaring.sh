#!/usr/bin/env bash

##################################################################
## 统计抖音视频飙升（含日榜，周榜，月榜）                            ##
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
echo "start stat dy_rpt_expert_composite info. "

# 引入通用配置和方法
source "$DIR/common/common_var.sh"
source "$DIR/common/common_func.sh"

# 引入脚本方法

# 计算达人视频统计信息
function stat_dy_rpt_video_soaring() {
  if [ $# -ne 3 ]; then
    log "wrong parameters:$@"
    log 'usage:   stat_dy_rpt_video_soaring anchordt comparedt data_type'
    log 'example: stat_dy_rpt_video_soaring 20190911 20190910 0'
    exit 1
  fi
  _anchordt=$1
  _comparedt=$2
  _data_type=$3
  _formated_anchordt=`date -d "$_anchordt" "+%Y-%m-%d"`
  log "_anchordt=$_anchordt, _comparedt=$_comparedt, ts=$_ts, _formated_anchordt=$_formated_anchordt"
  hqlStr="
      select concat_ws('_', video_id,'$_anchordt', '0') as id
        ,s.user_id, video_id, share_url, ranking, score
        ,like_number, like_number-lastday_like_number as like_increment, coalesce((like_number-lastday_like_number)/lastday_like_number,0) as like_speed_increase
        ,comment_number, comment_number-lastday_comment_number as comment_increment, coalesce((comment_number-lastday_comment_number)/lastday_comment_number) as comment_speed_increase
        , video_cover, video_title, null as video_label, fans_stat.hotwords as video_hot_word
        , unique_id, u.head_img head_portrait, nickname
        , case when like_number<100000 then 1
         when like_number>=100000 and like_number<500000 then 2
         when like_number>=500000 and like_number<1000000 then 3
         when like_number>=1000000 and like_number<2000000 then 4
         when like_number>=2000000 then 5
         else 999 end as like_number_interregional
        , case when comment_number<1000 then 1
         when comment_number>=1000 and comment_number<5000 then 2
         when comment_number>=5000 and comment_number<10000 then 3
         when comment_number>=10000 and comment_number<20000 then 4
         when comment_number>=20000 and comment_number<50000 then 5
         when comment_number>=50000 then 6
         else 999 end as comment_number_interregional
        , case when forward_number<1000 then 1
         when forward_number>=1000 and forward_number<5000 then 2
         when forward_number>=5000 and forward_number<10000 then 3
         when forward_number>=10000 and forward_number<20000 then 4
         when forward_number>=20000 and forward_number<50000 then 5
         when forward_number>=50000 then 6
         else 999 end as forward_number_interregional
        , case when video_duration<15000 then 1
         when video_duration>=15000 and video_duration<30000 then 2
         when video_duration>=30000 and video_duration<60000 then 3
         when video_duration>=60000 and video_duration<300000 then 4
         when video_duration>=300000 then 5
         else 999 end as video_duration_interregional
        , main_province as province
        , main_city as city
        , female_rate as proportion
        , main_age as age_range
        , fans_age as age_proportion
        , 0 as date_type
        , commodity_id as commodity_id
        ,'$_anchordt' as dt
        , from_unixtime($_ts) as create_time
        , from_unixtime($_ts) as update_time
        , 0 as status
        from (
             select today.aweme_id as video_id, today.user_id as user_id, today.share_url, today.duration as video_duration, today.cover_img as video_cover, today.desc as video_title, today.product_id as commodity_id
             , today.digg_count like_number, coalesce(lastday.digg_count, today.digg_count) lastday_like_number
             , today.comment_count comment_number, coalesce(lastday.comment_count, today.comment_count) lastday_comment_number
             , today.share_count forward_number, coalesce(lastday.share_count, today.share_count) lastday_forward_number
             , (today.digg_count-coalesce(lastday.digg_count, today.digg_count))+(today.comment_count-coalesce(lastday.comment_count, today.comment_count))*2+(today.share_count-coalesce(lastday.share_count, today.share_count))*3 as score
             , row_number() over (order by (today.digg_count-coalesce(lastday.digg_count, today.digg_count))+(today.comment_count-coalesce(lastday.comment_count, today.comment_count))*2+(today.share_count-coalesce(lastday.share_count, today.share_count))*3 desc) as ranking
            from short_video.stat_douyin_video_info today left join short_video.stat_douyin_video_info lastday on (today.aweme_id=lastday.aweme_id and lastday.dt='$_comparedt' and today.dt='$_anchordt')
        ) s left join short_video.stat_douyin_user_info u on (s.user_id=u.user_id and u.dt='$_anchordt' and s.ranking<=3000)
        left join short_video.stat_douyin_video_fans_info fans_stat on (s.video_id=fans_stat.aweme_id and fans_stat.dt='$_anchordt' and s.ranking<=3000)
        where ranking<=1000
  "
  exportHQL2MySQL "$hqlStr" "stat_dy_rpt_video_soaring" "$_anchordt" "video_report.dy_rpt_video_soaring"
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

stat_dy_rpt_video_soaring ${_dt} ${_oneday_ago} 0
check "stat_dy_rpt_video_soaring ${_dt} ${_ts}"

#log "daily stat douyin user stat job done..."