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
-- 视频标签

```