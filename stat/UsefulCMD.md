## Hive 相关命令
```hiveql
-- 载入本地文件到hive表
LOAD DATA LOCAL INPATH '/home/hadoop/yulei/dy083016/videoCosLog.csv' OVERWRITE INTO TABLE rlog_douyin_video PARTITION (dt='2019-08-30',hh='16');
LOAD DATA LOCAL INPATH '/home/hadoop/yulei/dy083020/videoCosLog.csv' OVERWRITE INTO TABLE rlog_douyin_video PARTITION (dt='2019-08-30',hh='20');

LOAD DATA LOCAL INPATH '/home/hadoop/yulei/dy083016/userCosLog.csv' OVERWRITE INTO TABLE rlog_douyin_user PARTITION (dt='2019-08-30',hh='16');
LOAD DATA LOCAL INPATH '/home/hadoop/yulei/dy083020/userCosLog.csv' OVERWRITE INTO TABLE rlog_douyin_user PARTITION (dt='2019-08-30',hh='20');

LOAD DATA LOCAL INPATH '/home/hadoop/yulei/dy083016/commentCosLog.csv' OVERWRITE INTO TABLE rlog_douyin_comment PARTITION (dt='2019-08-30',hh='16');
LOAD DATA LOCAL INPATH '/home/hadoop/yulei/dy083020/commentCosLog.csv' OVERWRITE INTO TABLE rlog_douyin_comment PARTITION (dt='2019-08-30',hh='20');


set mapred.child.java.opts = -Xmx1024m;
ADD JAR /home/hadoop/yulei/jar/hive-udf-1.0.jar;
CREATE TEMPORARY FUNCTION seg AS 'com.mobduos.bigdata.hive.udf.HanlpSegUDF';

```

```hiveql
ADD JAR /home/hadoop/yulei/jar/hive-udf-1.0.jar;
CREATE TEMPORARY FUNCTION seg AS 'com.mobduos.bigdata.hive.udf.HanlpSegUDF';
select aweme_id, token, count(1) from (
select aweme_id, token from (
select aweme_id, c_text, seg(c_text) as tokens 
from rlog_douyin_comment
where dt='2019-08-30' and hh='20') a LATERAL VIEW explode(tokens) token_table AS token
) b 
group by aweme_id, token;

set mapred.child.java.opts = -Xmx1024m;
ADD JAR /home/hadoop/yulei/jar/hive-udf-1.0.jar;
CREATE TEMPORARY FUNCTION seg AS 'com.mobduos.bigdata.hive.udf.HanlpSegUDF';
select aweme_id, token, cnt, rn from (
select aweme_id, token, cnt, row_number() over (partition by aweme_id order by cnt desc) as rn from (
select aweme_id, token, count(1) cnt from (
select aweme_id, token from (
select aweme_id, c_text, seg(c_text) as tokens 
from rlog_douyin_comment
where 1=1) a LATERAL VIEW explode(tokens) token_table AS token
) b 
group by aweme_id, token) c)d
where rn<=10;
``` 

```hiveql
-- 视频赞 转 评论
select aweme_id, digg_count, comment_count, share_count,create_time,rn from(
select aweme_id, digg_count, comment_count, share_count, from_unixtime(create_time) as create_time
, row_number() over (partition by aweme_id order by create_time desc) as rn
from rlog_douyin_video
where dt='20190904') a
limit 100;
```


```hiveql
--粉丝信息
select a.user_id, a.age, null as province,  b.city, c.female_rate, '$_ts' from (
    select user_id, concat(cast(age0*100/total as decimal(10,2)), '%, '
    	, cast(age1*100/total as decimal(10,2)), '%, '
    	, cast(age2*100/total as decimal(10,2)), '%, '
    	, cast(age3*100/total as decimal(10,2)), '%, '
    	, cast(age4*100/total as decimal(10,2)), '%, '
    	, cast(age5*100/total as decimal(10,2)), '%, '
    	, cast(age6*100/total as decimal(10,2)), '%') as age
    from (
        select user_id, sum(case when cast(prop_key as int) between 6 and 17 then prop_count else 0 end)
        , sum(case when prop_key='-1' then prop_count else 0 end) as age0
        , sum(case when cast(prop_key as int) between 6 and 17 then prop_count else 0 end) as age1
        , sum(case when cast(prop_key as int) between 18 and 24 then prop_count else 0 end) as age2
        , sum(case when cast(prop_key as int) between 25 and 30 then prop_count else 0 end) as age3
        , sum(case when cast(prop_key as int) between 31 and 35 then prop_count else 0 end) as age4
        , sum(case when cast(prop_key as int) between 36 and 41 then prop_count else 0 end) as age5
        , sum(case when cast(prop_key as int)>41 then prop_count else 0 end) as age6
        , sum(prop_count) as total
        from short_video.stat_douyin_user_fans_detail
        where dt='$_dt' and prop_type='age'
    	group by user_id
    ) aa
) a left join (
	select user_id, concat_ws(',',collect_set(concat_ws(':', city, par))) as city from (
		select user_id, city, concat(cast(cnt*100/sum(cnt) over (partition by user_id) as decimal(10,2)),'%') as par from ( 
			select user_id
				, case when prop_rank>20 then '其他' when prop_key='-1' then '未知' else prop_key end as city
				, sum(prop_count) cnt
			from short_video.stat_douyin_user_fans_detail
			where dt='$_dt' and prop_type='city'
			group by user_id, case when prop_rank>20 then '其他' when prop_key='-1' then '未知' else prop_key end) bb) bbb
	group by user_id) b on (a.user_id=b.user_id)
    left join (
        select user_id, cast(female*100/total as decimal(10,2)) as female_rate
        from (
	        select user_id, sum(case when prop_key='2' then prop_count else 0 end) as female, sum(prop_count) as total
	        from short_video.stat_douyin_user_fans_detail
	        where dt='$_dt' and prop_type='gender'
	        group by user_id
	    ) cc
    ) c on (a.user_id=c.user_id)
```