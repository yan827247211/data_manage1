#!/usr/bin/env bash

# 用来存储统计脚本的公共变量

## 腾讯云COS相关配置
COSN_DOUYIN_BUCKET_PATH_PREFIX='cosn://douyin-emr'
COSN_KUAISHOU_BUCKET_PATH_PREFIX=

HIVE_BIN='/usr/local/service/hive/bin/hive'
HADOOP_BIN='/usr/local/service/hadoop/bin/hadoop'

# MySQL相关数据
MYSQL_BIN='/bin/mysql'
MYSQL_REPORT_HOST=10.0.0.14
MYSQL_REPORT_PORT=3306
MYSQL_REPORT_USER=video_user
MYSQL_REPORT_PWD=7zhwaG6nUTJscCpH
MYSQL_REPORT_DB=video_report
