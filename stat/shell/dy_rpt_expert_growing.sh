#!/usr/bin/env bash

##################################################################
## 统计抖音达人成长榜（含日榜，周榜，月榜）                            ##
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
function stat_dy_rpt_expert_growing() {
  if [ $# -ne 3 ]; then
    log "wrong parameters:$@"
    log 'usage:   stat_dy_rpt_expert_growing anchordt comparedt data_type'
    log 'example: stat_dy_rpt_expert_growing 20190911 20190910 0'
    exit 1
  fi
  _anchordt=$1
  _comparedt=$2
  _data_type=$3
  _formated_anchordt=`date -d "$_anchordt" "+%Y-%m-%d"`
  log "_anchordt=$_anchordt, _comparedt=$_comparedt, ts=$_ts, _formated_anchordt=$_formated_anchordt"
  hqlStr="
select * from (
  select concat_ws('_',a.user_id,'$_anchordt','0') as id
  , a.user_id as uid
  , a.unique_id as unique_id
  , row_number() over (order by ((a.today_follower_count - a.lastday_follower_count) + (a.today_total_favorited - a.lastday_total_favorited)/10000) desc) as ranking
  , ((a.today_follower_count - a.lastday_follower_count) + (a.today_total_favorited - a.lastday_total_favorited)/10000) as score
  , a.today_total_favorited as like_number
  , a.today_total_favorited - a.lastday_total_favorited as like_increment
  , coalesce(round((a.today_total_favorited - a.lastday_total_favorited) / a.lastday_total_favorited,2),0) as like_speed_increase
  , a.today_follower_count as fans_number
  , a.today_follower_count - a.lastday_follower_count  as fans_increment
  , coalesce(round((a.today_follower_count - a.lastday_follower_count) / a.lastday_follower_count,2),0) as fans_speed_increase
  , a.head_img as head_portrait
  , a.nickname
  , a.account_authentication
  , c.industry
  , b.label
  , a.gender as expert_sex
  , a.age as expert_age
  , a.province
  , coalesce(a.city,'未知城市') as city
  , d.main_age as fans_mainly_age
  , d.main_province as fans_maily_province
  , d.main_city as fans_mainly_city
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
  , case when d.female_rate is null or d.female_rate<10 then 0
  	when d.female_rate>=10 and d.female_rate<20 then 1
  	when d.female_rate>=20 and d.female_rate<30 then 2
  	when d.female_rate>=30 and d.female_rate<40 then 3
  	when d.female_rate>=40 and d.female_rate<50 then 4
  	when d.female_rate>=50 and d.female_rate<60 then 5
  	when d.female_rate>=60 and d.female_rate<70 then 6
  	when d.female_rate>=70 and d.female_rate<80 then 7
  	when d.female_rate>=80 and d.female_rate<90 then 8
  	when d.female_rate>=90 then 9
    end as female_fan_ratio
  , '0' as data_type
  , '$_anchordt'
  from (
    select today.user_id, today.sec_user_id, today.unique_id, today.nickname, today.head_img, today.gender, today.age  , today.province, today.city
    , today.account_authentication
    , today.total_favorited as today_total_favorited
    , coalesce(lastday.total_favorited,today.total_favorited) as lastday_total_favorited
    , today.follower_count as today_follower_count
    , coalesce(lastday.follower_count,today.follower_count) as lastday_follower_count
    , today.aweme_count as today_aweme_count
    , today.video_comment_count as today_video_comment_count
    , coalesce(lastday.video_comment_count,today.video_comment_count) as lastday_video_comment_count
    , today.video_share_count as today_video_share_count
    , coalesce(lastday.video_share_count,today.video_share_count) as lastday_video_share_count
    , coalesce(round(today.total_favorited/today.aweme_count, 2),0) average_digg
    , coalesce(round(today.video_comment_count/today.aweme_count, 2),0) average_comment
    , coalesce(round(today.video_share_count/today.aweme_count, 2),0) average_share
    from (
      select user_id, sec_user_id, unique_id, nickname, head_img, gender, age, province, city
      , account_authentication
      , total_favorited, follower_count, aweme_count, video_comment_count, video_share_count
      from (
        select user_id, sec_user_id, unique_id, nickname, head_img, gender, age, province, city
        , case when custom_verify is not null then 1
           when enterprise_verify_reason is not null then 2
           else 0
          end as account_authentication
        , total_favorited, follower_count, aweme_count, video_comment_count, video_share_count
        from short_video.stat_douyin_user_info
        where dt='$_anchordt'
      ) z
    ) today left join short_video.stat_douyin_user_info lastday on (today.user_id=lastday.user_id and lastday.dt='$_comparedt')
  ) a left join short_video.dim_user_label b on (a.user_id=b.user_id)
  left join short_video.dim_user_industry c on (a.user_id=c.user_id)
  left join short_video.stat_douyin_user_fans_info d on (a.user_id=d.user_id and d.dt='$_anchordt')
) rpt where ranking<=500
  "
  exportHQL2MySQL "$hqlStr" "dy_rpt_expert_growing" "$_anchordt" 'video_report.dy_rpt_expert_growing'
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

stat_dy_rpt_expert_growing ${_dt} ${_oneday_ago} 0
#check "stat_douyin_user_video_info ${_dt} ${_ts}"

#log "daily stat douyin user stat job done..."