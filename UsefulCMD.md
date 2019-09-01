## Hive 相关命令
```hiveql
-- 载入本地文件到hive表
LOAD DATA LOCAL INPATH '/home/hadoop/yulei/dy083016/videoCosLog.csv' OVERWRITE INTO TABLE rlog_douyin_video PARTITION (dt='2019-08-30',hh='16');
LOAD DATA LOCAL INPATH '/home/hadoop/yulei/dy083020/videoCosLog.csv' OVERWRITE INTO TABLE rlog_douyin_video PARTITION (dt='2019-08-30',hh='20');

LOAD DATA LOCAL INPATH '/home/hadoop/yulei/dy083016/userCosLog.csv' OVERWRITE INTO TABLE rlog_douyin_user PARTITION (dt='2019-08-30',hh='16');
LOAD DATA LOCAL INPATH '/home/hadoop/yulei/dy083020/userCosLog.csv' OVERWRITE INTO TABLE rlog_douyin_user PARTITION (dt='2019-08-30',hh='20');

LOAD DATA LOCAL INPATH '/home/hadoop/yulei/dy083016/commentCosLog.csv' OVERWRITE INTO TABLE rlog_douyin_comment PARTITION (dt='2019-08-30',hh='16');
LOAD DATA LOCAL INPATH '/home/hadoop/yulei/dy083020/commentCosLog.csv' OVERWRITE INTO TABLE rlog_douyin_comment PARTITION (dt='2019-08-30',hh='20');



ADD JAR /home/hadoop/yulei/jar/hive-udf-1.0.jar;
CREATE TEMPORARY FUNCTION seg AS 'com.mobduos.bigdata.hive.udf.HanlpSegUDF';
```