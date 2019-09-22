#!/usr/bin/env bash

##################################################################
## 统计抖音视频综合榜（含日榜，周榜，月榜）                            ##
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
function stat_dy_rpt_video_composite() {
  if [ $# -ne 3 ]; then
    log "wrong parameters:$@"
    log 'usage:   stat_dy_rpt_video_composite anchordt comparedt data_type'
    log 'example: stat_dy_rpt_video_composite 20190911 20190910 0'
    exit 1
  fi
  _anchordt=$1
  _comparedt=$2
  _data_type=$3
  _formated_anchordt=`date -d "$_anchordt" "+%Y-%m-%d"`
  log "_anchordt=$_anchordt, _comparedt=$_comparedt, ts=$_ts, _formated_anchordt=$_formated_anchordt"
  hqlStr="
      select concat_ws('_', video_id,'20190922', '0') as id
        ,user_id, video_id, share_url, ranking, score, fans_number
        ,like_number, like_number-lastday_like_number as like_increment, coalesce((like_number-lastday_like_number)/lastday_like_number,0) as like_speed_increase
        ,comment_number, comment_number-lastday_comment_number as comment_increment, coalesce((comment_number-lastday_comment_number)/lastday_comment_number) as comment_speed_increase
        ,forward_number, forward_number-lastday_forward_number, coalesce((forward_number-lastday_forward_number)/lastday_forward_number) as forward_speed_increase
        ,video_duration, video_cover, video_title, video_label, video_hot_word
        , unique_id, head_portrait, nickname
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
        , 'province' as province
        , 'city' as city
        , 999 as proportion
        , 999 as age_range
        ,'age_proportion' as age_proportion
        , 0 as date_type
        , commodity_id as commodity_id
        ,'20190922' as dt
        from (
            select s.user_id
            , s.aweme_id as video_id
            , v.share_url as share_url
            , s.rank as ranking
            , cast(s.rank_score as decimal(10,2)) as score
            , coalesce(u.follower_count,0) as fans_number
            , s.today_digg_count as like_number
            , coalesce(case when s.lastday_digg_count is not null then s.lastday_digg_count else s.today_digg_count end,0) as lastday_like_number
            , s.today_comment_count as comment_number
            , coalesce(case when s.lastday_comment_count is not null then s.lastday_comment_count else s.today_comment_count end, 2) as lastday_comment_number
            , s.today_share_count as forward_number
            , coalesce(case when s.lastday_share_count is not null then s.lastday_share_count else s.today_share_count end,0) as lastday_forward_number
            , v.duration as video_duration
            , v.cover_img as video_cover
            , v.desc as video_title
            , 'label' as video_label
            , coalesce(s.hotwords,'') as video_hot_word
            , u.unique_id as unique_id
            , u.head_img as head_portrait
            , u.nickname as nickname
            , coalesce(s.fans_province,'未知') as fans_province
            , coalesce(s.fans_city,'未知') as fans_city
            , coalesce(s.fans_age_seg,'未知')  as fans_age_seg
            , coalesce(s.female_rate_seg,999) as female_rate_seg
            , v.product_id as commodity_id
            from (
                select today.aweme_id, today.user_id, today.rank_score,today.rank
                , today.digg_count today_digg_count, lastday.digg_count lastday_digg_count
                , today.comment_count today_comment_count, lastday.comment_count lastday_comment_count
                , today.share_count today_share_count, lastday.share_count lastday_share_count
                , fans_stat.fans_age_seg
                , fans_stat.fans_province
                , fans_stat.fans_city
                , fans_stat.female_rate_seg
                , hotwords.hotwords
                from (select aweme_id, user_id, digg_count, comment_count, share_count, rank_score, rank from (
                  select aweme_id, user_id, digg_count, comment_count, share_count
                  , digg_count+comment_count*2+share_count*3 as rank_score
                  , row_number() over (order by digg_count+comment_count*2+share_count*3 desc) as rank
                  from short_video.stat_douyin_video_info
                  where dt='20190922') a
                where a.rank<=3000) today left join short_video.stat_douyin_video_info lastday on (today.aweme_id=lastday.aweme_id and lastday.dt='20190920')
                left join short_video.stat_douyin_video_fans_info fans_stat on (today.aweme_id=fans_stat.aweme_id and fans_stat.dt='20190922')
                left join short_video.stat_douyin_video_hotwords hotwords on (today.aweme_id=hotwords.aweme_id and hotwords.dt='20190922')
            ) s left join short_video.base_douyin_video v on (s.aweme_id=v.aweme_id)
            left join short_video.base_douyin_user u on (s.user_id=u.user_id)
        ) rpt
  "
  exportHQL2Local "$hqlStr" "dy_rpt_video_composite"
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

stat_dy_rpt_video_composite ${_dt} ${_oneday_ago} 0
#check "stat_douyin_user_video_info ${_dt} ${_ts}"

#log "daily stat douyin user stat job done..."