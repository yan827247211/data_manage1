# 数据管理项目
## hive-udf
此模块为分词的hive udf，输入string字段即可产出分词结果
hanlp.properties可以配置自定义路径，resources文件夹下有词库，可以添加，不过要重新打包上传。
打包方法
```bash
mvn clean package -Pprod -Dmaven.test.skip=true
```
其中`-Pprod`表示用生产环境配置，配置文件路径具体可看maven的pom文件

### udf使用方法
```hiveql
set mapred.child.java.opts = -Xmx1024m;
ADD JAR /home/hadoop/yulei/jar/hive-udf-1.0.jar;
CREATE TEMPORARY FUNCTION seg AS 'com.mobduos.bigdata.hive.udf.HanlpSegUDF';
select aweme_id, c_text, seg(c_text) as tokens 
from rlog_douyin_comment
```
## stat
此模块为数据脚本, 调度入口为`manual_schedule.sh`
### 建表语句
/stat/tables/hive_tables.sql
### 表前缀解释
rlog 为原始日志，用的hive外部表，映射到cos上的具体路径
log 为落地到hdfs的日志
base 表是清洗过的全量信息
stat 表为按天统计的数据，理论上出报表从stat前缀表出