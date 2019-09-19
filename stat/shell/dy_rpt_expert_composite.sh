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
function stat_dy_rpt_expert_composite() {
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
      select concat_ws('_',a.user_id,'$_anchordt','$_data_type') as id
        , a.user_id as uid
        , b.unique_id as unique_id
        , 1 as ranking
        , 100 as score
        , a.today_aweme_count as video_number
        , a.today_follower_count as fans_number
        , a.today_follower_count - a.lastday_follower_count  as fans_increment
        , coalesce(round((a.today_follower_count - a.lastday_follower_count) / a.lastday_follower_count,2),0) as fans_speed_increase
        , a.today_total_favorited as like_number
        , a.today_total_favorited - a.lastday_total_favorited as like_increment
        , coalesce(round((a.today_total_favorited - a.lastday_total_favorited) / a.lastday_total_favorited,2),0) as like_speed_increase
        , a.today_video_comment_count as comment_number
        , a.today_video_comment_count - a.lastday_video_comment_count as comment_increment
        , coalesce(round((a.today_video_comment_count - a.lastday_video_comment_count) / a.lastday_video_comment_count,2),0) as comment_speed_increase
        , a.today_video_share_count as forward_number
        , a.today_video_share_count - a.lastday_video_share_count as forward_increment
        , coalesce(round((a.today_video_share_count - a.lastday_video_share_count) / a.lastday_video_share_count,2),0) as forward_speed_increase
        , average_digg as video_average_like_number
        , average_comment as video_average_comment_number
        , average_share as video_average_share_number
        , b.head_img as head_portrait
        , 'b.nickname' as nickname
        , case when b.custom_verify is not null then 1
           when b.enterprise_verify_reason is not null then 2
           else 0
          end as account_authentication
        , 'industry' industry
        , 'label' label
        , b.gender as expert_sex
        , case when b.birthday is null then -1
            else floor(datediff(to_date('$_formated_anchordt'), to_date(b.birthday)) / 365.25)
          end as expert_age
        , 'province' as province
        , coalesce(b.city,'') as city
        , a.fans_age_seg as fans_mainly_age
        , a.fans_province as fans_maily_province
        , a.fans_city as fans_mainly_city
        , case when a.average_digg<100000 then 1
           when a.average_digg>=100000 and a.average_digg<500000 then 2
           when a.average_digg>=500000 and a.average_digg<1000000 then 3
           when a.average_digg>=1000000 and a.average_digg<2000000 then 4
           when a.average_digg>=2000000 then 5
          end as video_average_like_number_interregional
        , case when a.average_comment<1000 then 1
           when a.average_comment>=1000 and a.average_comment<5000 then 2
           when a.average_comment>=5000 and a.average_comment<10000 then 3
           when a.average_comment>=10000 and a.average_comment<20000 then 4
           when a.average_comment>=20000 and a.average_comment<50000 then 5
           when a.average_comment>=50000 then 6
          end as video_average_comment_number_interregional
        , case when a.average_share<1000 then 1
           when a.average_share>=1000 and a.average_share<5000 then 2
           when a.average_share>=5000 and a.average_share<10000 then 3
           when a.average_share>=10000 and a.average_share<20000 then 4
           when a.average_share>=20000 and a.average_share<50000 then 5
           when a.average_share>=50000 then 6
          end as video_average_share_number_interregional
        , case when a.today_aweme_count<50 then 1
           when a.today_aweme_count>=50 and a.today_aweme_count<100 then 2
           when a.today_aweme_count>=100 and a.today_aweme_count<200 then 3
           when a.today_aweme_count>=200 and a.today_aweme_count<500 then 4
           when a.today_aweme_count>=500 then 5
          end as video_number_interregional
        , case when a.today_total_favorited<100000 then 1
           when a.today_total_favorited>=100000 and a.today_total_favorited<500000 then 2
           when a.today_total_favorited>=500000 and a.today_total_favorited<1000000 then 3
           when a.today_total_favorited>=1000000 and a.today_total_favorited<2000000 then 4
           when a.today_total_favorited>=2000000 then 5
          end as like_number_interregional
        , case when a.today_follower_count<1000000 then 0
           when a.today_follower_count>=1000000 and a.today_follower_count<5000000 then 1
           when a.today_follower_count>=5000000 and a.today_follower_count<10000000 then 2
           when a.today_follower_count>=10000000 and a.today_follower_count<20000000 then 3
           when a.today_follower_count>=20000000 then 4
          end as fans_number_interregional
        , a.female_rate_seg as female_fan_ratio
        , '$_data_type' as data_type
        , '$_anchordt'
        , '' as create_time
        , '' as update_time
        , 1 as status from (
          select
          user_id
          , today_follower_count
          , case when lastday_follower_count is not null then lastday_follower_count else today_follower_count end as lastday_follower_count
          , today_aweme_count
          , case when lastday_aweme_count is not null then lastday_aweme_count else today_aweme_count end as lastday_aweme_count
          , today_total_favorited
          , case when lastday_total_favorited is not null then lastday_total_favorited else today_total_favorited end as lastday_total_favorited
          , today_video_comment_count
          , case when lastday_video_comment_count is not null then lastday_video_comment_count else today_video_comment_count end as lastday_video_comment_count
          , today_video_share_count
          , case when lastday_video_share_count is not null then lastday_video_share_count else today_video_share_count end as lastday_video_share_count
          , coalesce(round(today_total_favorited/today_aweme_count, 2),0) average_digg
          , coalesce(round(today_video_comment_count/today_aweme_count, 2),0) average_comment
          , coalesce(round(today_video_share_count/today_aweme_count, 2),0) average_share
          , coalesce(fans_age_seg,999) as fans_age_seg
          , coalesce(fans_province,'unknown') as fans_province
          , coalesce(fans_city, 'unknown') as fans_city
          , coalesce(female_rate_seg,999) as female_rate_seg
          from (
            select today.user_id
            , today.aweme_count today_aweme_count, lastday.aweme_count lastday_aweme_count
            , today.follower_count today_follower_count, lastday.follower_count lastday_follower_count
            , today.total_favorited today_total_favorited, lastday.total_favorited lastday_total_favorited
            , today.video_comment_count today_video_comment_count, lastday.video_comment_count lastday_video_comment_count
            , today.video_share_count today_video_share_count, lastday.video_share_count lastday_video_share_count
            , fans_stat.fans_age_seg
            , fans_stat.fans_province
            , fans_stat.fans_city
            , fans_stat.female_rate_seg
            from short_video.stat_douyin_user_info today left join short_video.stat_douyin_user_info lastday on (today.user_id=lastday.user_id and today.dt='$_anchordt' and lastday.dt='$_comparedt')
            left join short_video.stat_douyin_user_fans_info fans_stat on (today.user_id=fans_stat.user_id and today.dt='$_anchordt' and fans_stat.dt='$_anchordt')
            where today.dt='$_anchordt'
          ) zz
        ) a left join short_video.base_douyin_user b on (a.user_id=b.user_id)
  "
  exportSQL2Local "$hqlStr" "dy_rpt_expert_composite"
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