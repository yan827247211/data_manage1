-- MySQL dump 10.13  Distrib 8.0.16, for macos10.14 (x86_64)
--
-- Host: sh-cdb-eb41ykaw.sql.tencentcdb.com    Database: video_report
-- ------------------------------------------------------
-- Server version	5.6.28-cdb2016-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT = @@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS = @@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION = @@COLLATION_CONNECTION */;
SET NAMES utf8;
/*!40103 SET @OLD_TIME_ZONE = @@TIME_ZONE */;
/*!40103 SET TIME_ZONE = '+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS = @@UNIQUE_CHECKS, UNIQUE_CHECKS = 0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS = 0 */;
/*!40101 SET @OLD_SQL_MODE = @@SQL_MODE, SQL_MODE = 'NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES = @@SQL_NOTES, SQL_NOTES = 0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN = 0;

--
-- GTID state at the beginning of the backup
--

SET @@GLOBAL.GTID_PURGED = /*!80000 '+'*/ '184fa05c-e231-11e8-a07b-6c92bf5b8f3e:1-16391815,
1d78b01d-aa04-11e9-b780-18ded7a37962:1-63049,
25b4f59a-e231-11e8-a07c-6c92bf5b8b32:1-256';

--
-- Table structure for table `dy_rpt_ad_video_composite`
--

DROP TABLE IF EXISTS `dy_rpt_ad_video_composite`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
SET character_set_client = utf8mb4;
CREATE TABLE `dy_rpt_ad_video_composite`
(
    `id`              varchar(255) NOT NULL COMMENT '广告视频id_日期',
    `uid`             bigint(20)          DEFAULT NULL COMMENT '抖音用户id',
    `ad_video_id`     bigint(20) unsigned DEFAULT NULL COMMENT '广告视频ID',
    `ad_video_cover`  varchar(255)        DEFAULT NULL COMMENT '广告视频封面',
    `ad_video_title`  varchar(255)        DEFAULT NULL COMMENT '广告视频标题',
    `ad_side_name`    varchar(255)        DEFAULT NULL COMMENT '广告方名称',
    `ad_video_time`   bigint(20) unsigned DEFAULT NULL COMMENT '广告时长',
    `head_portrait`   varchar(255)        DEFAULT NULL COMMENT '头像',
    `nickname`        varchar(255)        DEFAULT NULL COMMENT '昵称',
    `unique_id`       varchar(255)        DEFAULT NULL COMMENT '抖音号',
    `fans_number`     bigint(20) unsigned DEFAULT NULL COMMENT '粉丝数',
    `like_number`     bigint(20) unsigned DEFAULT NULL COMMENT '点赞数',
    `comments_number` bigint(20) unsigned DEFAULT NULL COMMENT '评论数',
    `forward_number`  bigint(20) unsigned DEFAULT NULL COMMENT '转发数',
    `release_time`    datetime            DEFAULT NULL COMMENT '发布时间',
    `create_time`     datetime            DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据创建时间',
    `update_time`     datetime            DEFAULT CURRENT_TIMESTAMP COMMENT '数据修改时间',
    `status`          int(11) unsigned    DEFAULT '0' COMMENT '数据状态',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='广告视频';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dy_rpt_audio`
--

DROP TABLE IF EXISTS `dy_rpt_audio`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
SET character_set_client = utf8mb4;
CREATE TABLE `dy_rpt_audio`
(
    `id`                        varchar(255)        NOT NULL COMMENT '音频id_日期',
    `uid`                       bigint(20)          NOT NULL COMMENT '抖音用户id',
    `audio_id`                  bigint(20) unsigned NOT NULL COMMENT '音频ID',
    `ranking`                   int(11)                      DEFAULT NULL COMMENT '音频名次',
    `score`                     decimal(10, 2)               DEFAULT NULL COMMENT '热度指数',
    `audio_cover`               varchar(255)                 DEFAULT NULL COMMENT '音频封面',
    `audio_name`                varchar(255)                 DEFAULT NULL COMMENT '音频名称',
    `audio_time`                bigint(20) unsigned          DEFAULT NULL COMMENT '音频时长',
    `audio_url`                 varchar(255)                 DEFAULT NULL COMMENT '音频链接',
    `use_number`                bigint(20) unsigned          DEFAULT NULL COMMENT '使用人数',
    `use_number_increment`      bigint(20) unsigned          DEFAULT NULL COMMENT '使用人数增量',
    `use_number_speed_increase` decimal(10, 2)               DEFAULT NULL COMMENT '使用人数增速',
    `release_time`              datetime                     DEFAULT NULL COMMENT '发布时间',
    `unique_id`                 varchar(255)                 DEFAULT NULL COMMENT '抖音号',
    `head_portrait`             varchar(255)                 DEFAULT NULL COMMENT '头像',
    `nickname`                  varchar(255)                 DEFAULT NULL COMMENT '昵称',
    `audio_type`                varchar(255)                 DEFAULT NULL COMMENT '音频类型',
    `create_time`               datetime                     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据创建时间',
    `update_time`               datetime                     DEFAULT CURRENT_TIMESTAMP COMMENT '数据修改日期',
    `status`                    int(255) unsigned   NOT NULL DEFAULT '0' COMMENT '数据状态',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='抖音音频榜';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dy_rpt_expert_composite`
--

DROP TABLE IF EXISTS `dy_rpt_expert_composite`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
SET character_set_client = utf8mb4;
CREATE TABLE `dy_rpt_expert_composite`
(
    `id`                                         varchar(255)            NOT NULL COMMENT 'uid_日期_榜单类型',
    `uid`                                        bigint(20)              NOT NULL COMMENT '抖音用户id',
    `unique_id`                                  varchar(255)            NOT NULL COMMENT '抖音号',
    `ranking`                                    int(11) unsigned        NOT NULL COMMENT '达人综合榜名次（按达人指数降序赋值）',
    `score`                                      decimal(10, 2) unsigned NOT NULL COMMENT '达人指数',
    `video_number`                               bigint(20) unsigned     NOT NULL COMMENT '视频数',
    `fans_number`                                bigint(20) unsigned     NOT NULL COMMENT '粉丝数',
    `fans_increment`                             bigint(20)              NOT NULL COMMENT '粉丝增量',
    `fans_speed_increase`                        decimal(10, 2)          NOT NULL COMMENT '粉丝增速',
    `like_number`                                bigint(20) unsigned     NOT NULL COMMENT '点赞总量',
    `like_increment`                             bigint(20)              NOT NULL COMMENT '点赞增量',
    `like_speed_increase`                        decimal(10, 2)          NOT NULL COMMENT '点赞增速',
    `comment_number`                             bigint(20) unsigned     NOT NULL COMMENT '评论总量',
    `comment_increment`                          bigint(20)              NOT NULL COMMENT '评论增量',
    `comment_speed_increase`                     decimal(10, 2)          NOT NULL COMMENT '评论增速',
    `forward_number`                             bigint(20) unsigned     NOT NULL COMMENT '转发总量',
    `forward_increment`                          bigint(20)              NOT NULL COMMENT '转发增量',
    `forward_speed_increase`                     decimal(10, 2)          NOT NULL COMMENT '转发增速',
    `video_average_like_number`                  bigint(20) unsigned     NOT NULL COMMENT '视频均赞数',
    `video_average_comment_number`               bigint(20) unsigned     NOT NULL COMMENT '视频均评数',
    `video_average_share_number`                 bigint(20) unsigned     NOT NULL COMMENT '视频均转数',
    `head_portrait`                              varchar(255)            NOT NULL COMMENT '头像',
    `nickname`                                   varchar(255)            NOT NULL COMMENT '昵称',
    `account_authentication`                     int(11) unsigned        NOT NULL COMMENT '账号认证(0：未认证，1：MCN机构认证，2：企业蓝V认证)',
    `industry`                                   varchar(255)            NOT NULL COMMENT '行业',
    `label`                                      varchar(255)            NOT NULL COMMENT '标签(可以有多个标签,不同的标签由","隔开)',
    `expert_sex`                                 int(11) unsigned        NOT NULL COMMENT '达人性别(0:未知,1:男,2:女)',
    `expert_age`                                 int(11) unsigned        NOT NULL COMMENT '达人年龄',
    `province`                                   varchar(255)                     DEFAULT NULL COMMENT '达人所在省份',
    `city`                                       varchar(255)                     DEFAULT NULL COMMENT '达人所在城市',
    `fans_mainly_age`                            int(11) unsigned        NOT NULL COMMENT '粉丝主要年龄（1：6-17、2：18-24、3：25-30、4：31-35、5：36-40、6：41+）',
    `fans_mainly_province`                       varchar(255)            NOT NULL COMMENT '粉丝主要省份',
    `fans_mainly_city`                           varchar(255)            NOT NULL COMMENT '粉丝主要城市',
    `video_average_like_number_interregional`    int(11) unsigned        NOT NULL COMMENT '视频均赞数区间（1：10以下、2：10-50、3：50-100、4：100-200、5：200以上） 单位：万',
    `video_average_comment_number_interregional` int(11) unsigned        NOT NULL COMMENT '视频均评数区间（1：0.1以下、2：0.1-0.5、3：0.5-1.0、4：1.0-2.0、5：2.0-5.0、6：5.0以上） 单位：万',
    `video_average_share_number_interregional`   int(11) unsigned        NOT NULL COMMENT '视频均转数区间（1：0.1以下、2：0.1-0.5、3：0.5-1.0、4：1.0-2.0、5：2.0-5.0、6：5.0以上） 单位：万',
    `video_number_interregional`                 int(11) unsigned        NOT NULL COMMENT '视频数区间(1：50以下、2：50-100、3：100-200、4：200-500、5：500以上)',
    `like_number_interregional`                  int(11) unsigned        NOT NULL COMMENT '点赞数区间（1：10以下、2：10-50、3：50-100、4：100-200、5：200以上） 单位：万',
    `fans_number_interregional`                  int(11) unsigned        NOT NULL COMMENT '粉丝数区间（1：100-500、2：500-1000、3：1000-2000、4：2000以上）  单位：万',
    `female_fan_ratio`                           int(11) unsigned        NOT NULL COMMENT '女性粉丝占比（0：10%以下、1：10%-20%、2：20%-30%、3：30%-40%，4：40%-50%，5：50%-60%，6：60%-70%，7：70%-80%，8：80%-90%，9：90%以上）',
    `date_type`                                  int(11) unsigned        NOT NULL COMMENT '日期类型（0：当天数据统计，1：七天数据统计，2，三十天数据统计）',
    `date`                                       varchar(255)            NOT NULL COMMENT '数据日期',
    `create_time`                                datetime                         DEFAULT CURRENT_TIMESTAMP COMMENT '数据创建时间',
    `update_time`                                datetime                NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据修改时间',
    `status`                                     int(11) unsigned        NOT NULL COMMENT '数据状态',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='达人综合榜';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dy_rpt_expert_growing`
--

DROP TABLE IF EXISTS `dy_rpt_expert_growing`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
SET character_set_client = utf8mb4;
CREATE TABLE `dy_rpt_expert_growing`
(
    `id`                                         varchar(255)            NOT NULL COMMENT 'uid_日期_榜单类型',
    `uid`                                        bigint(20)              NOT NULL COMMENT '抖音用户ID',
    `unique_id`                                  varchar(255)            NOT NULL COMMENT '抖音号',
    `ranking`                                    int(11) unsigned        NOT NULL COMMENT '达人成长榜名次（按成长指数降序赋值）',
    `score`                                      decimal(10, 2) unsigned NOT NULL COMMENT '成长指数',
    `like_number`                                bigint(20) unsigned     NOT NULL COMMENT '点赞数',
    `like_increment`                             bigint(20) unsigned     NOT NULL COMMENT '点赞增量',
    `like_speed_increase`                        decimal(10, 2)          NOT NULL COMMENT '点赞增速',
    `fans_number`                                bigint(20) unsigned     NOT NULL COMMENT '粉丝数',
    `fans_increment`                             bigint(20) unsigned     NOT NULL COMMENT '粉丝增量',
    `fans_speed_increase`                        decimal(10, 2)          NOT NULL COMMENT '粉丝增速',
    `head_portrait`                              varchar(255)            NOT NULL COMMENT '头像',
    `nickname`                                   varchar(255)            NOT NULL COMMENT '昵称',
    `account_authentication`                     int(11) unsigned        NOT NULL COMMENT '账号认证(0：未认证，1：MCN机构认证，2：企业蓝V认证)',
    `industry`                                   varchar(255)            NOT NULL COMMENT '行业',
    `label`                                      varchar(255)            NOT NULL COMMENT '标签(可以有多个标签,不同的标签由","隔开)',
    `expert_sex`                                 int(11) unsigned        NOT NULL COMMENT '达人性别(0:未知,1:男,2:女)',
    `expert_age`                                 int(11) unsigned        NOT NULL COMMENT '达人年龄',
    `expert_province`                            varchar(255)            NOT NULL COMMENT '达人所在省份',
    `expert_city`                                varchar(255)            NOT NULL COMMENT '达人所在城市',
    `fans_mainly_age`                            int(11) unsigned        NOT NULL COMMENT '粉丝主要年龄（1：6-17、2：18-24、3：25-30、4：31-35、5：36-40、6：41+）',
    `fans_mainly_province`                       varchar(255)            NOT NULL COMMENT '粉丝主要省份',
    `fans_mainly_city`                           varchar(255)            NOT NULL COMMENT '粉丝主要城市',
    `video_average_like_number_interregional`    int(11) unsigned        NOT NULL COMMENT '视频均赞数区间（1：10以下、2：10-50、3：50-100、4：100-200、5：200以上） 单位：万',
    `video_average_comment_number_interregional` int(11) unsigned        NOT NULL COMMENT '视频均评数区间（1：0.1以下、2：0.1-0.5、3：0.5-1.0、4：1.0-2.0、5：2.0-5.0、6：5.0以上） 单位：万',
    `video_average_share_number_interregional`   int(11) unsigned        NOT NULL COMMENT '视频均转数区间（1：0.1以下、2：0.1-0.5、3：0.5-1.0、4：1.0-2.0、5：2.0-5.0、6：5.0以上） 单位：万',
    `video_number_interregional`                 int(11) unsigned        NOT NULL COMMENT '视频数区间(1：50以下、2：50-100、3：100-200、4：200-500、5：500以上)',
    `like_number_interregional`                  int(11) unsigned        NOT NULL COMMENT '点赞数区间（1：10以下、2：10-50、3：50-100、4：100-200、5：200以上） 单位：万',
    `fans_number_interregional`                  int(11) unsigned        NOT NULL COMMENT '粉丝数区间（1：100-500、2：500-1000、3：1000-2000、4：2000以上）  单位：万',
    `female_fans_ratio`                          int(11) unsigned        NOT NULL COMMENT '女性粉丝占比（0：10%以下、1：10%-20%、2：20%-30%、3：30%-40%，4：40%-50%，5：50%-60%，6：60%-70%，7：70%-80%，8：80%-90%，9：90%以上）',
    `date_type`                                  int(11) unsigned        NOT NULL COMMENT '日期类型（0：当天数据统计，1：七天数据统计，2，三十天数据统计）',
    `date`                                       varchar(255)            NOT NULL COMMENT '数据日期',
    `create_time`                                datetime                NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '数据创建时间',
    `update_time`                                datetime                         DEFAULT CURRENT_TIMESTAMP COMMENT '数据修改时间',
    `status`                                     int(11) unsigned        NOT NULL COMMENT '数据状态',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='达人成长榜';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dy_rpt_expert_live_broadcast`
--

DROP TABLE IF EXISTS `dy_rpt_expert_live_broadcast`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
SET character_set_client = utf8mb4;
CREATE TABLE `dy_rpt_expert_live_broadcast`
(
    `id`                                         varchar(255)            NOT NULL COMMENT '直播id_日期',
    `uid`                                        bigint(20)              NOT NULL COMMENT '抖音用户id',
    `unique_id`                                  varchar(20)             NOT NULL COMMENT '抖音号',
    `ranking`                                    int(11) unsigned        NOT NULL COMMENT '达人直播榜名次（按直播指数降序赋值）',
    `score`                                      decimal(10, 2) unsigned NOT NULL COMMENT '直播指数',
    `fans_number`                                bigint(20) unsigned     NOT NULL COMMENT '粉丝数',
    `barrage_number`                             bigint(20) unsigned     NOT NULL COMMENT '弹幕数',
    `soundbyte`                                  bigint(20) unsigned     NOT NULL COMMENT '音浪',
    `head_portrait`                              varchar(255)            NOT NULL COMMENT '头像',
    `nickname`                                   varchar(255)            NOT NULL COMMENT '昵称',
    `account_authentication`                     int(11) unsigned        NOT NULL COMMENT '账号认证(0：未认证，1：MCN机构认证，2：企业蓝V认证)',
    `industry`                                   varchar(255)            NOT NULL COMMENT '行业',
    `label`                                      varchar(255)            NOT NULL COMMENT '标签(可以有多个标签,不同的标签由","隔开)',
    `expert_sex`                                 int(11) unsigned        NOT NULL COMMENT '达人性别(0:未知,1:男,2:女)',
    `expert_age`                                 int(11) unsigned        NOT NULL COMMENT '达人年龄',
    `expert_province`                            varchar(255)            NOT NULL COMMENT '达人所在省份',
    `expert_city`                                varchar(255)            NOT NULL COMMENT '达人所在城市',
    `fans_mainly_age`                            int(11) unsigned        NOT NULL COMMENT '粉丝主要年龄（1：6-17、2：18-24、3：25-30、4：31-35、5：36-40、6：41+）',
    `fans_mainly_province`                       varchar(255)            NOT NULL COMMENT '粉丝主要省份',
    `fans_mainly_city`                           varchar(255)            NOT NULL COMMENT '粉丝主要城市',
    `video_average_like_number_interregional`    int(11) unsigned        NOT NULL COMMENT '视频均赞数区间（1：10以下、2：10-50、3：50-100、4：100-200、5：200以上） 单位：万',
    `video_average_comment_number_interregional` int(11) unsigned        NOT NULL COMMENT '视频均评数区间（1：0.1以下、2：0.1-0.5、3：0.5-1.0、4：1.0-2.0、5：2.0-5.0、6：5.0以上） 单位：万',
    `video_average_share_number_interregional`   int(11) unsigned        NOT NULL COMMENT '视频均转数区间（1：0.1以下、2：0.1-0.5、3：0.5-1.0、4：1.0-2.0、5：2.0-5.0、6：5.0以上） 单位：万',
    `video_number_interregional`                 int(11) unsigned        NOT NULL COMMENT '视频数区间(1：50以下、2：50-100、3：100-200、4：200-500、5：500以上)',
    `like_number_interregional`                  int(11) unsigned        NOT NULL COMMENT '点赞数区间（1：10以下、2：10-50、3：50-100、4：100-200、5：200以上） 单位：万',
    `fans_number_interregional`                  int(11) unsigned        NOT NULL COMMENT '粉丝数区间（1：100-500、2：500-1000、3：1000-2000、4：2000以上）  单位：万',
    `female_fan_ratio`                           int(11) unsigned        NOT NULL COMMENT '女性粉丝占比（0：10%以下、1：10%-20%、2：20%-30%、3：30%-40%，4：40%-50%，5：50%-60%，6：60%-70%，7：70%-80%，8：80%-90%，9：90%以上）',
    `date_type`                                  int(11) unsigned        NOT NULL COMMENT '日期类型（0：当天数据统计，1：七天数据统计，2，三十天数据统计）',
    `date`                                       varchar(255)            NOT NULL COMMENT '数据日期',
    `create_time`                                datetime                NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '数据创建时间',
    `update_time`                                datetime                         DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据修改时间',
    `status`                                     int(11) unsigned        NOT NULL COMMENT '数据状态',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='达人直播榜';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dy_rpt_expert_proportion`
--

DROP TABLE IF EXISTS `dy_rpt_expert_proportion`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
SET character_set_client = utf8mb4;
CREATE TABLE `dy_rpt_expert_proportion`
(
    `id`                  varchar(255) NOT NULL COMMENT 'uid_日期',
    `uid`                 bigint(20)   NOT NULL COMMENT '抖音用户id',
    `province_proportion` varchar(255) NOT NULL COMMENT '省份占比( 省份:比例,省份:比例 )',
    `city_proportion`     varchar(255) NOT NULL COMMENT '城市占比( 城市:比例,城市:比例 )',
    `age_proportion`      varchar(255)          DEFAULT NULL COMMENT '各年龄段所占比例(不同年龄段所占比例由 , 分隔开)\r\n 各年龄段（6-17、18-24、25-30、31-35、36-40、41+）',
    `female_fans_ratio`   decimal(10, 2)        DEFAULT NULL COMMENT '女性粉丝所占比例',
    `status`              int(11)               DEFAULT '0' COMMENT '数据状态',
    `create_time`         datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '数据创建时间',
    `update_time`         datetime              DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据修改时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='达人占比表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dy_rpt_expert_sales_volume`
--

DROP TABLE IF EXISTS `dy_rpt_expert_sales_volume`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
SET character_set_client = utf8mb4;
CREATE TABLE `dy_rpt_expert_sales_volume`
(
    `id`                       varchar(255)            NOT NULL COMMENT 'uid_日期_类型',
    `ranking`                  int(11) unsigned        NOT NULL COMMENT '销量名次',
    `uid`                      bigint(20)              NOT NULL COMMENT '抖音用户id',
    `unique_id`                varchar(255)            NOT NULL COMMENT '抖音号',
    `head_portrait`            varchar(255)            NOT NULL COMMENT '头像',
    `nickname`                 varchar(255)            NOT NULL COMMENT '昵称',
    `fans_number`              bigint(20) unsigned     NOT NULL COMMENT '粉丝数',
    `label`                    varchar(255)            NOT NULL COMMENT '标签(可以有多个标签,不同的标签由","隔开)',
    `at_sell_commodity_number` int(11) unsigned        NOT NULL COMMENT '在售商品数',
    `store_sales`              bigint(20) unsigned     NOT NULL COMMENT '店铺销量',
    `shop_sales_amount`        decimal(20, 5) unsigned NOT NULL COMMENT '店铺销售额',
    `continuous_list`          int(11) unsigned        NOT NULL COMMENT '累计上榜天数',
    `date_type`                int(11) unsigned        NOT NULL COMMENT '日期类型（0：当天数据统计，1：七天数据统计，2，三十天数据统计）',
    `date`                     varchar(255)            NOT NULL COMMENT '数据日期',
    `create_time`              datetime                NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '数据创建时间',
    `update_time`              datetime                         DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据修改时间',
    `status`                   int(11) unsigned        NOT NULL COMMENT '数据状态',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='达人销量榜';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dy_rpt_good_commodity`
--

DROP TABLE IF EXISTS `dy_rpt_good_commodity`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
SET character_set_client = utf8mb4;
CREATE TABLE `dy_rpt_good_commodity`
(
    `good_commodity_id`        varchar(255)            NOT NULL COMMENT '商品id_日期_榜单类型',
    `uid`                      bigint(20)                       DEFAULT NULL COMMENT '抖音用户id',
    `ranking`                  int(11) unsigned        NOT NULL COMMENT '好物榜名次（按好物指数降序赋值）',
    `score`                    decimal(10, 2) unsigned NOT NULL COMMENT '好物指数',
    `commodity_id`             bigint(20) unsigned     NOT NULL COMMENT '商品ID',
    `commodity_cover`          varchar(255)            NOT NULL COMMENT '商品封面',
    `commodity_name`           varchar(255)            NOT NULL COMMENT '商品名称',
    `commodity_type`           varchar(255)                     DEFAULT NULL COMMENT '商品类型',
    `brand_name`               varchar(255)            NOT NULL COMMENT '品牌名称',
    `unique_id`                varchar(255)                     DEFAULT NULL COMMENT '抖音号',
    `head_portrait`            varchar(255)            NOT NULL COMMENT '头像',
    `nickname`                 varchar(255)            NOT NULL COMMENT '昵称',
    `fans_number`              bigint(20) unsigned     NOT NULL COMMENT '粉丝数',
    `commodity_price`          decimal(10, 2) unsigned NOT NULL COMMENT '价格',
    `commodity_price_interval` int(11) unsigned        NOT NULL COMMENT '商品价格区间（1-50、50-100、100-200、200-500、500以上）',
    `sales_volume`             bigint(20) unsigned     NOT NULL COMMENT '销量',
    `sales_volume_interval`    int(11) unsigned        NOT NULL COMMENT '商品销量区间（1：0.1以下、2：0.1-1.0、3：1.0-5.0、4：5.0-10.0、5：10.0-20.0、6：20.0-50.0、7：50.0以上）单位：万',
    `continuous_list`          int(11) unsigned        NOT NULL COMMENT '连续上榜天数',
    `date_type`                int(11) unsigned        NOT NULL COMMENT '日期类型（0：当天数据统计，1：七天数据统计，2，三十天数据统计）',
    `date`                     varchar(255)            NOT NULL COMMENT '数据日期',
    `create_time`              datetime                NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '数据创建时间',
    `update_time`              datetime                         DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据修改时间',
    `status`                   int(11) unsigned        NOT NULL COMMENT '数据状态',
    PRIMARY KEY (`good_commodity_id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='好物榜';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dy_rpt_video_composite`
--

DROP TABLE IF EXISTS `dy_rpt_video_composite`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
SET character_set_client = utf8mb4;
CREATE TABLE `dy_rpt_video_composite`
(
    `id`                           varchar(255)            NOT NULL COMMENT '视频id_日期_榜单类型',
    `uid`                          bigint(20)              NOT NULL COMMENT '抖音用户id',
    `video_id`                     bigint(20) unsigned     NOT NULL COMMENT '视频id',
    `share_url`                    varchar(255)            NOT NULL COMMENT '视频链接',
    `ranking`                      int(11) unsigned        NOT NULL COMMENT '视频综合榜名次',
    `score`                        decimal(10, 2) unsigned NOT NULL COMMENT '视频指数',
    `fans_number`                  bigint(20)              NOT NULL COMMENT '粉丝数',
    `like_number`                  bigint(20) unsigned     NOT NULL COMMENT '点赞数',
    `like_increment`               bigint(20)              NOT NULL COMMENT '点赞增量',
    `like_speed_increase`          decimal(10, 2)          NOT NULL COMMENT '点赞增速',
    `comment_number`               bigint(20) unsigned     NOT NULL COMMENT '评论数',
    `comment_increment`            bigint(20)              NOT NULL COMMENT '评论增量',
    `comment_speed_increase`       decimal(10, 2)          NOT NULL COMMENT '评论增速',
    `forward_number`               bigint(20) unsigned     NOT NULL COMMENT '转发数',
    `forward_increment`            bigint(20)              NOT NULL COMMENT '转发增量',
    `forward_speed_increase`       decimal(10, 2)          NOT NULL COMMENT '转发增速',
    `video_duration`               bigint(20) unsigned     NOT NULL COMMENT '视频时长',
    `video_cover`                  varchar(255)            NOT NULL COMMENT '视频封面',
    `video_title`                  varchar(255)            NOT NULL COMMENT '视频标题',
    `video_label`                  varchar(255)            NOT NULL COMMENT '视频标签(可以有多个标签,不同的标签由","隔开)',
    `video_hot_word`               varchar(255)            NOT NULL COMMENT '视频热词(可以有多个热词,不同的热词由","隔开)',
    `unique_id`                    varchar(255)            NOT NULL COMMENT '抖音号',
    `head_portrait`                varchar(255)            NOT NULL COMMENT '头像',
    `nickname`                     varchar(255)            NOT NULL COMMENT '昵称',
    `like_number_interregional`    int(11) unsigned        NOT NULL COMMENT '点赞数区间（1：10以下、2：10-50、3：50-100、4：100-200、5：200以上） 单位：万',
    `comment_number_interregional` int(11) unsigned        NOT NULL COMMENT '评论数区间（1：0.1以下、2：0.1-0.5、3：0.5-1.0、4：1.0-2.0、5：2.0-5.0、6：5.0以上） 单位：万',
    `forward_number_interregional` int(11) unsigned        NOT NULL COMMENT '转发数区间（1：0.1以下、2：0.1-0.5、3：0.5-1.0、4：1.0-2.0、5：2.0-5.0、6：5.0以上） 单位：万',
    `video_duration_interregional` int(11) unsigned        NOT NULL COMMENT '视频时长区间（1：15秒以下、2：15秒-30秒、3：30秒-60秒、4：60秒-5分钟、5：5分钟以上）',
    `province`                     varchar(255)                     DEFAULT NULL COMMENT '省份',
    `city`                         varchar(255)                     DEFAULT NULL COMMENT '城市',
    `proportion`                   int(11)                 NOT NULL COMMENT '女性观众比例（0：10%以下、1：10%-20%、2：20%-30%、3：30%-40%，4：40%-50%，5：50%-60%，6：60%-70%，7：70%-80%，8：80%-90%，9：90%以上）',
    `age_range`                    int(11) unsigned        NOT NULL COMMENT '观众主要年龄（1：6-17、2：18-24、3：25-30、4：31-35、5：36-40、6：41+）',
    `age_proportion`               varchar(255)            NOT NULL COMMENT '观众个年龄段所占比例(不同年龄段所占比例由 , 分隔开)\r\n 各年龄段（6-17、18-24、25-30、31-35、36-40、41+）',
    `date_type`                    int(11)                 NOT NULL COMMENT '日期类型（0：当天数据统计，1：七天数据统计，2，三十天数据统计）',
    `commodity_id`                 bigint(20) unsigned              DEFAULT NULL COMMENT '商品id(值为null时表示该视频没有关联商品)',
    `date`                         varchar(255)            NOT NULL COMMENT '数据日期',
    `create_time`                  datetime                NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '数据创建时间',
    `update_time`                  datetime                NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据修改日期',
    `status`                       int(11) unsigned        NOT NULL DEFAULT '1' COMMENT '数据状态',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='视频综合榜';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dy_rpt_video_monitor`
--

DROP TABLE IF EXISTS `dy_rpt_video_monitor`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
SET character_set_client = utf8mb4;
CREATE TABLE `dy_rpt_video_monitor`
(
    `id`                      varchar(255)        NOT NULL COMMENT '视频id_日期',
    `video_id`                bigint(20)          NOT NULL COMMENT '视频id',
    `total_like_increment`    bigint(20) unsigned NOT NULL COMMENT '总点赞数',
    `like_increment`          bigint(20) unsigned NOT NULL COMMENT '点赞增量',
    `total_comment_increment` bigint(20) unsigned NOT NULL COMMENT '总评论数',
    `comment_increment`       bigint(20) unsigned NOT NULL COMMENT '评论增量',
    `total_forward_increment` bigint(20) unsigned NOT NULL COMMENT '总转发数',
    `forward_increment`       bigint(20) unsigned NOT NULL COMMENT '转发增量',
    `time_point`              datetime            NOT NULL COMMENT '时间点',
    `status`                  int(11) unsigned    NOT NULL COMMENT '状态',
    `create_time`             datetime            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`             datetime                     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='抖音视频监控表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dy_rpt_video_proportion`
--

DROP TABLE IF EXISTS `dy_rpt_video_proportion`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
SET character_set_client = utf8mb4;
CREATE TABLE `dy_rpt_video_proportion`
(
    `id`                        varchar(255) NOT NULL COMMENT '视频id_日期',
    `video_id`                  bigint(20)   NOT NULL COMMENT '视频ID',
    `video_hot_word_proportion` varchar(255) NOT NULL COMMENT '视频热词占比( 热词:比例,热词:比例 )',
    `province_proportion`       varchar(255) NOT NULL COMMENT '省份占比( 省份:比例,省份:比例 )',
    `city_proportion`           varchar(255) NOT NULL COMMENT '城市占比( 城市:比例,城市:比例 )',
    `age_proportion`            varchar(255)          DEFAULT NULL COMMENT '各年龄段所占比例(不同年龄段所占比例由 , 分隔开)\r\n 各年龄段（6-17、18-24、25-30、31-35、36-40、41+）',
    `female_fans_ratio`         decimal(10, 2)        DEFAULT NULL COMMENT '女性观众所占比例',
    `status`                    int(11)      NOT NULL COMMENT '数据状态',
    `create_time`               datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '数据创建时间',
    `update_time`               datetime              DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据修改时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='视频占比表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dy_rpt_video_soaring`
--

DROP TABLE IF EXISTS `dy_rpt_video_soaring`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
SET character_set_client = utf8mb4;
CREATE TABLE `dy_rpt_video_soaring`
(
    `id`                           varchar(255)            NOT NULL COMMENT '视频id_日期_榜单类型',
    `uid`                          bigint(20)              NOT NULL COMMENT '抖音用户id',
    `video_id`                     bigint(20) unsigned     NOT NULL COMMENT '视频id',
    `share_url`                    varchar(255)            NOT NULL COMMENT '视频链接',
    `ranking`                      int(11) unsigned        NOT NULL COMMENT '视频飙升榜名次',
    `score`                        decimal(10, 2) unsigned NOT NULL COMMENT '飙升指数',
    `like_number`                  bigint(20) unsigned     NOT NULL COMMENT '点赞数',
    `like_increment`               bigint(20) unsigned     NOT NULL COMMENT '点赞增量',
    `like_speed_increase`          decimal(10, 2)          NOT NULL COMMENT '点赞增速',
    `comment_number`               bigint(20) unsigned     NOT NULL COMMENT '评论数',
    `comment_increment`            bigint(20) unsigned     NOT NULL COMMENT '评论增量',
    `comment_speed_increase`       decimal(10, 2)          NOT NULL COMMENT '评论增速',
    `video_cover`                  varchar(255)            NOT NULL COMMENT '视频封面',
    `video_title`                  varchar(255)            NOT NULL COMMENT '视频标题',
    `video_label`                  varchar(255)            NOT NULL COMMENT '视频标签(可以有多个标签,不同的标签由","隔开)',
    `video_hot_word`               varchar(255)            NOT NULL COMMENT '视频热词(可以有多个热词,不同的热词由","隔开)',
    `unique_id`                    varchar(255)            NOT NULL COMMENT '抖音号',
    `head_portrait`                varchar(255)            NOT NULL COMMENT '头像',
    `nickname`                     varchar(255)            NOT NULL COMMENT '昵称',
    `like_number_interregional`    int(11) unsigned        NOT NULL COMMENT '点赞数区间（1：10以下、2：10-50、3：50-100、4：100-200、5：200以上） 单位：万',
    `comment_number_interregional` int(11) unsigned        NOT NULL COMMENT '评论数区间（1：0.1以下、2：0.1-0.5、3：0.5-1.0、4：1.0-2.0、5：2.0-5.0、6：5.0以上） 单位：万',
    `forward_number_interregional` int(11) unsigned        NOT NULL COMMENT '转发数区间（1：0.1以下、2：0.1-0.5、3：0.5-1.0、4：1.0-2.0、5：2.0-5.0、6：5.0以上） 单位：万',
    `video_duration_interregional` int(11) unsigned        NOT NULL COMMENT '视频时长区间（1：15秒以下、2：15秒-30秒、3：30秒-60秒、4：60秒-5分钟、5：5分钟以上）',
    `province`                     varchar(255)            NOT NULL COMMENT '省份',
    `city`                         varchar(255)            NOT NULL COMMENT '城市',
    `proportion`                   int(11)                 NOT NULL COMMENT '女性观众比例（0：10%以下、1：10%-20%、2：20%-30%、3：30%-40%，4：40%-50%，5：50%-60%，6：60%-70%，7：70%-80%，8：80%-90%，9：90%以上）',
    `age_range`                    int(11) unsigned        NOT NULL COMMENT '观众年龄范围（1：6-17、2：18-24、3：25-30、4：31-35、5：36-40、6：41+）',
    `age_proportion`               varchar(255)            NOT NULL COMMENT '观众个年龄段所占比例(不同年龄段所占比例由 , 分隔开)\r\n 各年龄段（6-17、18-24、25-30、31-35、36-40、41+）',
    `date_type`                    int(11)                 NOT NULL COMMENT '日期类型（0：当天数据统计，1：七天数据统计，2，三十天数据统计）',
    `commodity_id`                 bigint(20) unsigned              DEFAULT NULL COMMENT '商品id(值为null时表示该视频没有关联商品)',
    `date`                         varchar(255)            NOT NULL COMMENT '数据日期',
    `create_time`                  datetime                         DEFAULT CURRENT_TIMESTAMP COMMENT '数据创建时间',
    `update_time`                  datetime                NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据修改日期',
    `status`                       int(11) unsigned        NOT NULL DEFAULT '1' COMMENT '数据状态',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='视频飙升榜';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ks_rpt_advertising_video_composite`
--

DROP TABLE IF EXISTS `ks_rpt_advertising_video_composite`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
SET character_set_client = utf8mb4;
CREATE TABLE `ks_rpt_advertising_video_composite`
(
    `id`                      varchar(255)        NOT NULL COMMENT '视频id_日期_榜单类型（日榜/周榜/月榜）',
    `advertising_video_cover` varchar(255)        NOT NULL COMMENT '广告视频封面',
    `advertising_video_title` varchar(255)        NOT NULL COMMENT '广告视频标题',
    `advertisers_name`        varchar(255)        NOT NULL COMMENT '广告商名称',
    `adcertising_duration`    int(11) unsigned    NOT NULL COMMENT '广告时长',
    `user_id`                 bigint(20) unsigned NOT NULL COMMENT '用户id',
    `kwai_id`                 varchar(255)                 DEFAULT NULL COMMENT '快手号id',
    `name`                    varchar(255)        NOT NULL COMMENT '作者昵称',
    `profile_picture`         varchar(255)        NOT NULL COMMENT '作者头像',
    `fan_number`              bigint(20) unsigned NOT NULL COMMENT '粉丝数',
    `like_number`             bigint(20) unsigned NOT NULL COMMENT '点赞数',
    `comment_number`          bigint(20) unsigned NOT NULL COMMENT '评论数',
    `play_number`             bigint(20) unsigned NOT NULL COMMENT '播放数',
    `release_time`            datetime            NOT NULL COMMENT '发布时间',
    `status`                  tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态',
    `create_time`             datetime            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
    `update_time`             datetime                     DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='广告视频榜';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ks_rpt_expert_composite`
--

DROP TABLE IF EXISTS `ks_rpt_expert_composite`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
SET character_set_client = utf8mb4;
CREATE TABLE `ks_rpt_expert_composite`
(
    `id`                                 varchar(255)            NOT NULL COMMENT 'UID_日期_榜单类型（日榜/周榜/月榜）',
    `user_id`                            bigint(20)              NOT NULL COMMENT '用户id',
    `kwai_id`                            varchar(255)                     DEFAULT NULL COMMENT '快手号id',
    `ranking`                            int(11) unsigned        NOT NULL COMMENT '达人综合榜名次',
    `score`                              decimal(10, 2) unsigned NOT NULL COMMENT '达人指数',
    `profile_picture`                    varchar(255)            NOT NULL COMMENT '头像',
    `name`                               varchar(255)            NOT NULL COMMENT '昵称',
    `industry`                           varchar(255)            NOT NULL COMMENT '行业',
    `label`                              varchar(255)            NOT NULL COMMENT '标签',
    `like_number_interval`               int(11) unsigned        NOT NULL COMMENT '点赞数区间（0：100-500、1：500-1000、2：1000-2000、3：2000以上）',
    `comment_number_interval`            int(11) unsigned        NOT NULL COMMENT '评论数区间（0：5-10、1：10-50、2：50-100、3：100-200、4：200以上）',
    `video_number`                       int(11) unsigned        NOT NULL COMMENT '视频数',
    `fan_number`                         bigint(20) unsigned     NOT NULL COMMENT '粉丝数',
    `fan_number_interval`                int(11) unsigned        NOT NULL COMMENT '粉丝数区间（0：100-500、1：500-1000、2：1000-2000、3：2000以上）',
    `fan_increment`                      int(11)                 NOT NULL COMMENT '粉丝增量',
    `fan_speed_increase`                 decimal(10, 2)          NOT NULL COMMENT '粉丝增速',
    `like_number`                        bigint(20)              NOT NULL COMMENT '点赞数',
    `like_increment`                     int(11)                 NOT NULL COMMENT '点赞增量',
    `like_speed_increase`                decimal(10, 2)          NOT NULL COMMENT '点赞增速',
    `comment_number`                     bigint(20) unsigned     NOT NULL COMMENT '评论数',
    `comment_increment`                  int(11) unsigned        NOT NULL COMMENT '评论增量',
    `comment_speed_increase`             decimal(10, 2) unsigned NOT NULL COMMENT '评论增速',
    `play_number`                        bigint(20) unsigned     NOT NULL COMMENT '播放数',
    `play_increment`                     int(11) unsigned        NOT NULL COMMENT '播放增量',
    `play_speed_increase`                decimal(10, 2) unsigned NOT NULL COMMENT '播放增速',
    `video_average_like_number`          bigint(20) unsigned     NOT NULL COMMENT '视频均赞数',
    `video_average_comments_number`      bigint(20) unsigned     NOT NULL COMMENT '视频均评数',
    `video_average_play_number`          bigint(20) unsigned     NOT NULL COMMENT '视频均播数',
    `video_average_play_number_interval` int(11) unsigned        NOT NULL COMMENT '视频均播数区间（0：10以下、1：10-50、2：50-100、3：100-200、4：200-500、5：500以上）',
    `expert_sex`                         int(11)                          DEFAULT NULL COMMENT '达人性别（0：男，1：女）',
    `expert_age`                         int(11) unsigned                 DEFAULT NULL COMMENT '达人年龄',
    `expert_province`                    varchar(255)                     DEFAULT NULL COMMENT '达人所在省份',
    `expert_city`                        varchar(255)                     DEFAULT NULL COMMENT '达人所在城市',
    `account_verification`               varchar(255)            NOT NULL COMMENT '账号认证（0：未认证，1：MCN机构认证，2：企业蓝V认证）',
    `female_fan_ratio`                   int(11) unsigned        NOT NULL COMMENT '女性粉丝比例区间',
    `fan_age_range`                      int(11) unsigned        NOT NULL COMMENT '粉丝年龄区间（0:0~17,1:18~24,2:25~30,3:31~35,4:36~40,5:41+）',
    `fan_province`                       varchar(255)            NOT NULL COMMENT '粉丝所在最多省份',
    `fan_city`                           varchar(255)            NOT NULL COMMENT '粉丝所在最多城市',
    `data_update_time`                   int(11) unsigned        NOT NULL COMMENT '数据更新时间（秒）',
    `date_type`                          int(11) unsigned        NOT NULL COMMENT '日期类型（0:当天数据统计,1:七天数据统计,2:30天数据统计）',
    `date`                               varchar(255)            NOT NULL COMMENT '日期',
    `status`                             tinyint(3) unsigned     NOT NULL DEFAULT '0' COMMENT '状态',
    `create_time`                        datetime                NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
    `update_time`                        datetime                         DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='达人综合榜，达人成长榜';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ks_rpt_expert_growing`
--

DROP TABLE IF EXISTS `ks_rpt_expert_growing`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
SET character_set_client = utf8mb4;
CREATE TABLE `ks_rpt_expert_growing`
(
    `id`                                 varchar(255)            NOT NULL COMMENT 'UID_日期_榜单类型（日榜/周榜/月榜）',
    `user_id`                            bigint(20) unsigned     NOT NULL COMMENT '用户id',
    `kwai_id`                            varchar(255)                     DEFAULT NULL COMMENT '快手号id',
    `ranking`                            int(11) unsigned        NOT NULL COMMENT '名次',
    `score`                              decimal(10, 2) unsigned NOT NULL COMMENT '成长指数',
    `profile_picture`                    varchar(255)            NOT NULL COMMENT '头像',
    `name`                               varchar(255)            NOT NULL COMMENT '昵称',
    `industry`                           varchar(255)            NOT NULL COMMENT '行业',
    `label`                              varchar(255)            NOT NULL COMMENT '标签',
    `video_number`                       int(11) unsigned        NOT NULL COMMENT '视频数',
    `like_number_interval`               int(11) unsigned        NOT NULL COMMENT '点赞数区间（0：100-500、1：500-1000、2：1000-2000、3：2000以上）',
    `comment_number_interval`            int(11) unsigned        NOT NULL COMMENT '评论数区间（0：5-10、1：10-50、2：50-100、3：100-200、4：200以上）',
    `fan_number`                         bigint(20) unsigned     NOT NULL COMMENT '粉丝数',
    `fan_number_interval`                int(11) unsigned        NOT NULL COMMENT '粉丝数区间（0：100-500、1：500-1000、2：1000-2000、3：2000以上）',
    `fan_increment`                      int(11)                 NOT NULL COMMENT '粉丝增量',
    `fan_speed_increase`                 decimal(10, 2) unsigned NOT NULL COMMENT '粉丝增速',
    `like_number`                        bigint(20) unsigned     NOT NULL COMMENT '点赞数',
    `like_increment`                     int(11)                 NOT NULL COMMENT '点赞增量',
    `like_speed_increase`                decimal(10, 2) unsigned NOT NULL COMMENT '点赞增速',
    `video_average_play_number_interval` int(11) unsigned        NOT NULL COMMENT '视频均播数区间（0：10以下、1：10-50、2：50-100、3：100-200、4：200-500、5：500以上）',
    `expert_sex`                         varchar(255)                     DEFAULT NULL COMMENT '达人性别',
    `expert_age`                         int(11) unsigned                 DEFAULT NULL COMMENT '达人年龄',
    `expert_province`                    varchar(255)                     DEFAULT NULL COMMENT '达人所在省份',
    `expert_city`                        varchar(255)                     DEFAULT NULL COMMENT '达人所在城市',
    `account_verification`               varchar(255)                     DEFAULT NULL COMMENT '账号认证',
    `female_fan_ratio`                   int(11) unsigned        NOT NULL COMMENT '女性粉丝比例区间（0:10%以下,1:10%~20%,2:20%~30%,3:30~40%,4:40%~50%,5:50%~60%,6:60%~70%,7:70%~80%,8:80%~90%,9:90%+）',
    `fan_age_range`                      int(11) unsigned        NOT NULL COMMENT '粉丝年龄区间（0:0~17,1:18~24,2:25~30,3:31~35,4:36~40,5:41+）',
    `fan_province`                       varchar(255)            NOT NULL COMMENT '粉丝所在最多省份',
    `fan_city`                           varchar(255)            NOT NULL COMMENT '粉丝所在最多城市',
    `date_type`                          int(11) unsigned        NOT NULL COMMENT '日期类型（0:当天数据统计,1:七天数据统计,2:30天数据统计）',
    `date`                               varchar(255)            NOT NULL COMMENT '日期',
    `status`                             tinyint(3) unsigned     NOT NULL DEFAULT '0' COMMENT '状态',
    `create_time`                        datetime                NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
    `update_time`                        datetime                         DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='达人成长榜';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ks_rpt_expert_live_broadcast`
--

DROP TABLE IF EXISTS `ks_rpt_expert_live_broadcast`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
SET character_set_client = utf8mb4;
CREATE TABLE `ks_rpt_expert_live_broadcast`
(
    `id`                                 varchar(255)            NOT NULL COMMENT 'UID_日期_榜单类型（日榜/周榜/月榜）',
    `user_id`                            bigint(20)              NOT NULL COMMENT '用户id',
    `kwai_id`                            varchar(255)                     DEFAULT NULL COMMENT '快手号id',
    `ranking`                            int(11) unsigned        NOT NULL COMMENT '名次',
    `score`                              decimal(10, 2) unsigned NOT NULL COMMENT '直播指数',
    `profile_picture`                    varchar(255)            NOT NULL COMMENT '头像',
    `name`                               varchar(255)            NOT NULL COMMENT '昵称',
    `industry`                           varchar(255)            NOT NULL COMMENT '行业',
    `label`                              varchar(255)            NOT NULL COMMENT '标签',
    `like_number_interval`               int(11) unsigned        NOT NULL COMMENT '点赞数区间（0：100-500、1：500-1000、2：1000-2000、3：2000以上）',
    `comment_number_interval`            int(11) unsigned        NOT NULL COMMENT '评论数区间（0：5-10、1：10-50、2：50-100、3：100-200、4：200以上）',
    `video_number`                       int(11) unsigned        NOT NULL COMMENT '视频数',
    `fan_number`                         bigint(20) unsigned     NOT NULL COMMENT '粉丝数',
    `fan_number_interval`                int(11) unsigned        NOT NULL COMMENT '粉丝数区间（0：100-500、1：500-1000、2：1000-2000、3：2000以上）',
    `barrage_number`                     bigint(20) unsigned     NOT NULL COMMENT '弹幕数',
    `fast_currency`                      bigint(20) unsigned     NOT NULL COMMENT '快币',
    `video_average_play_number_interval` int(11) unsigned        NOT NULL COMMENT '视频均播数区间（0：10以下、1：10-50、2：50-100、3：100-200、4：200-500、5：500以上）',
    `expert_sex`                         int(11) unsigned                 DEFAULT NULL COMMENT '达人性别（0：男，1：女）',
    `expert_age`                         int(11) unsigned                 DEFAULT NULL COMMENT '达人年龄',
    `expert_province`                    varchar(255)                     DEFAULT NULL COMMENT '达人所在省份',
    `expert_city`                        varchar(255)                     DEFAULT NULL COMMENT '达人所在城市',
    `account_verification`               varchar(255)                     DEFAULT NULL COMMENT '账号认证',
    `female_fan_ratio`                   int(11) unsigned        NOT NULL COMMENT '女性粉丝比例区间',
    `fan_age_range`                      int(11) unsigned        NOT NULL COMMENT '粉丝年龄区间（0:0~17,1:18~24,2:25~30,3:31~35,4:36~40,5:41+）',
    `fan_province`                       varchar(255)            NOT NULL COMMENT '粉丝所在最多省份',
    `fan_city`                           varchar(255)            NOT NULL COMMENT '粉丝所在最多城市',
    `date_type`                          int(11) unsigned        NOT NULL COMMENT '日期类型（0:当天数据统计,1:七天数据统计,2:30天数据统计）',
    `date`                               varchar(255)            NOT NULL COMMENT '日期',
    `status`                             tinyint(3) unsigned     NOT NULL DEFAULT '0' COMMENT '状态',
    `create_time`                        datetime                NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
    `update_time`                        datetime                         DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='达人直播榜';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ks_rpt_expert_proportion`
--

DROP TABLE IF EXISTS `ks_rpt_expert_proportion`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
SET character_set_client = utf8mb4;
CREATE TABLE `ks_rpt_expert_proportion`
(
    `id`                  varchar(255)            NOT NULL COMMENT 'UID_日期_榜单类型（日榜/周榜/月榜）',
    `user_id`             bigint(20)              NOT NULL COMMENT '用户id',
    `province_proportion` varchar(255)            NOT NULL COMMENT '省份占比( 省份:比例,省份:比例 )',
    `city_proportion`     varchar(255)            NOT NULL COMMENT '城市占比( 城市:比例,城市:比例 )',
    `age_proportion`      varchar(255)            NOT NULL COMMENT '年龄段占比',
    `female_fans_ratio`   decimal(10, 2) unsigned NOT NULL COMMENT '女性粉丝所占比例',
    `status`              tinyint(3) unsigned     NOT NULL DEFAULT '0' COMMENT '数据状态',
    `create_time```       datetime                NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据创建时间',
    `update_time`         datetime                         DEFAULT CURRENT_TIMESTAMP COMMENT '数据修改时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='达人占比表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ks_rpt_good_commodity`
--

DROP TABLE IF EXISTS `ks_rpt_good_commodity`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
SET character_set_client = utf8mb4;
CREATE TABLE `ks_rpt_good_commodity`
(
    `id`                                         varchar(255)            NOT NULL COMMENT '商品id_日期_榜单类型（日榜/周榜/月榜）',
    `ranking`                                    int(11) unsigned        NOT NULL COMMENT '名次',
    `score`                                      decimal(10, 2) unsigned NOT NULL COMMENT '好物指数',
    `commodity_id`                               varchar(255)            NOT NULL COMMENT '商品id',
    `commodity_cover`                            varchar(255)            NOT NULL COMMENT '商品封面',
    `commodity_name`                             varchar(255)            NOT NULL COMMENT '商品名称',
    `brand_name`                                 varchar(255)                     DEFAULT NULL COMMENT '品牌名称',
    `commodity_type`                             varchar(255)            NOT NULL COMMENT '商品类型',
    `live_broadcast_peak_value_number_of_people` bigint(20) unsigned     NOT NULL COMMENT '直播峰值人数',
    `relevance_live_broadcast_number`            bigint(20) unsigned     NOT NULL COMMENT '关联直播数',
    `whole_network_sales_volume`                 int(11) unsigned        NOT NULL COMMENT '全网销量',
    `whole_network_sales_volume_increment`       int(11)                 NOT NULL COMMENT '全网销量增量',
    `whole_network_sales_volume_speed_increase`  int(11) unsigned        NOT NULL COMMENT '全网销量增速',
    `selling_price`                              decimal(10, 2) unsigned NOT NULL COMMENT '售价',
    `sales_volume`                               int(11) unsigned        NOT NULL COMMENT '销量区间（0：0.1以下、1：0.1-1.0、2：1.0-5.0、3：5.0-10.0、4：10.0-20.0、5：20.0-50.0、6：50.0以上 ）',
    `commodity_source`                           varchar(255)            NOT NULL COMMENT '商品来源',
    `date_type`                                  int(11) unsigned        NOT NULL COMMENT '日期类型（0:当天数据统计,1:七天数据统计,2:30天数据统计）',
    `date`                                       varchar(255)            NOT NULL COMMENT '日期',
    `status`                                     tinyint(3) unsigned     NOT NULL DEFAULT '0' COMMENT '状态',
    `create_time`                                datetime                NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`                                datetime                         DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='好物榜';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ks_rpt_live_broadcast_expert_sales_volume`
--

DROP TABLE IF EXISTS `ks_rpt_live_broadcast_expert_sales_volume`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
SET character_set_client = utf8mb4;
CREATE TABLE `ks_rpt_live_broadcast_expert_sales_volume`
(
    `id`                                 varchar(255)        NOT NULL COMMENT 'UID_日期_榜单类型（日榜/周榜/月榜）',
    `ranking`                            int(11) unsigned    NOT NULL COMMENT '名次',
    `user_id`                            bigint(20) unsigned NOT NULL COMMENT '用户id',
    `kwai_id`                            varchar(255)                 DEFAULT NULL COMMENT '快手号id',
    `profile_picture`                    varchar(255)        NOT NULL COMMENT '头像',
    `name`                               varchar(255)        NOT NULL COMMENT '昵称',
    `label`                              varchar(255)        NOT NULL COMMENT '标签',
    `fan_number`                         bigint(20) unsigned NOT NULL COMMENT '粉丝数',
    `live_broadcast_bring_goods_number`  int(11) unsigned    NOT NULL COMMENT '直播带货数',
    `live_broadcast_commodity_number`    int(11) unsigned    NOT NULL COMMENT '直播商品数',
    `live_broadcast_sales_volume`        bigint(20) unsigned NOT NULL COMMENT '直播销售额',
    `off_site_audience_peak_value`       int(11) unsigned    NOT NULL COMMENT '场外观众峰值',
    `bring_goods_live_broadcast_session` int(11) unsigned    NOT NULL COMMENT '带货直播场次',
    `status`                             tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态',
    `create_time`                        datetime            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`                        datetime                     DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='直播达人销量榜';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ks_rpt_music_audio`
--

DROP TABLE IF EXISTS `ks_rpt_music_audio`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
SET character_set_client = utf8mb4;
CREATE TABLE `ks_rpt_music_audio`
(
    `id`                             varchar(255)        NOT NULL COMMENT '音频id_日期_榜单类型（日榜/周榜/月榜）',
    `music_id`                       varchar(255)        NOT NULL COMMENT '音乐id',
    `ranking`                        int(11) unsigned    NOT NULL COMMENT '名次',
    `score`                          decimal(10, 2)               DEFAULT NULL COMMENT '热度指数',
    `audio_cover`                    varchar(255)        NOT NULL COMMENT '音频封面',
    `audio_name`                     varchar(255)        NOT NULL COMMENT '音频名称',
    `audio_duration`                 int(11) unsigned    NOT NULL COMMENT '音频时长',
    `song_sheet_type`                varchar(255)        NOT NULL COMMENT '所属歌单',
    `user_total_usage`               bigint(20)          NOT NULL COMMENT '总使用人数',
    `user_use_number_increment`      int(11)             NOT NULL COMMENT '使用人数增量',
    `user_use_number_speed_increase` decimal(10, 2)      NOT NULL COMMENT '使用人数增速',
    `release_time`                   datetime            NOT NULL COMMENT '发布时间',
    `user_id`                        bigint(20)          NOT NULL COMMENT '用户id',
    `kwai_id`                        varchar(255)                 DEFAULT NULL COMMENT '快手号id',
    `profile_picture`                varchar(255)        NOT NULL COMMENT '作者头像',
    `name`                           varchar(255)        NOT NULL COMMENT '作者昵称',
    `status`                         tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态（0：未删除，1：已删除）',
    `create_time`                    datetime            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`                    datetime                     DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='音频表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ks_rpt_video_composite`
--

DROP TABLE IF EXISTS `ks_rpt_video_composite`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
SET character_set_client = utf8mb4;
CREATE TABLE `ks_rpt_video_composite`
(
    `id`                            varchar(255)            NOT NULL COMMENT '视频id_日期_榜单类型（日榜/周榜/月榜）',
    `ranking`                       int(11) unsigned        NOT NULL COMMENT '综合榜名次',
    `video_id`                      bigint(20) unsigned     NOT NULL COMMENT '视频id',
    `score`                         decimal(10, 2) unsigned NOT NULL COMMENT '视频指数',
    `video_label`                   varchar(255)            NOT NULL COMMENT '视频标签',
    `video_cover`                   varchar(255)            NOT NULL COMMENT '视频封面图',
    `video_title`                   varchar(255)            NOT NULL COMMENT '视频标题',
    `video_hot_word`                varchar(255)            NOT NULL COMMENT '视频热词',
    `video_url`                     varchar(255)            NOT NULL COMMENT '视频链接',
    `video_topic`                   varchar(255)                     DEFAULT NULL COMMENT '视频话题（如果爬虫获取不到标签那么就由大数据统计）',
    `user_id`                       bigint(20)              NOT NULL COMMENT '用户id',
    `kwai_id`                       varchar(255)                     DEFAULT NULL COMMENT '快手号id',
    `profile_picture`               varchar(255)            NOT NULL COMMENT '头像',
    `name`                          varchar(255)            NOT NULL COMMENT '昵称',
    `like_number`                   bigint(20) unsigned     NOT NULL COMMENT '点赞数',
    `like_number_interval`          int(11) unsigned        NOT NULL COMMENT '点赞数区间（0：10以下、1：10-50、2：50-100、3：100-200、4：200以上）',
    `like_number_increment`         int(11)                 NOT NULL COMMENT '点赞增量',
    `like_number_speed_increase`    decimal(10, 2) unsigned NOT NULL COMMENT '点赞增速',
    `comment_number`                bigint(20) unsigned     NOT NULL COMMENT '评论数',
    `comment_number_interval`       int(11) unsigned        NOT NULL COMMENT '评论数区间（0：0.1以下、1：0.1-0.5、2：0.5-1.0、3：1.0-2.0、4：2.0-5.0、5：5.0以上）',
    `comment_number_increment`      int(11) unsigned        NOT NULL COMMENT '评论增量',
    `comment_number_speed_increase` decimal(10, 2) unsigned NOT NULL COMMENT '评论增速',
    `play_number_increment`         int(11) unsigned        NOT NULL COMMENT '播放增量',
    `play_number_speed_increase`    decimal(10, 2) unsigned NOT NULL COMMENT '播放增速',
    `play_number`                   bigint(20) unsigned     NOT NULL COMMENT '播放数',
    `play_number_interval`          int(11) unsigned        NOT NULL COMMENT '播放数区间（0：10以下、1：10-50、2：50-100、3：100-200、4：200-500、5：500以上）',
    `duration`                      int(11) unsigned        NOT NULL COMMENT '视频时长',
    `female_fan_ratio`              int(11) unsigned        NOT NULL COMMENT '女性观众比例区间（0:10%以下,1:10%~20%,2:20%~30%,3:30~40%,4:40%~50%,5:50%~60%,6:60%~70%,7:70%~80%,8:80%~90%,9:90%+）',
    `age_range`                     int(11) unsigned        NOT NULL COMMENT '主要观众年龄区间（0:0~17,1:18~24,2:25~30,3:31~35,4:36~40,5:41+）',
    `province`                      varchar(255)            NOT NULL COMMENT '观众所在最多的省份',
    `city`                          varchar(255)            NOT NULL COMMENT '观众所在最多的城市',
    `commodity_id`                  varchar(255)                     DEFAULT NULL COMMENT '关联商品id',
    `date_type`                     int(11) unsigned        NOT NULL COMMENT '日期类型（0:当天数据统计,1:七天数据统计,2:30天数据统计）',
    `date`                          varchar(255)            NOT NULL COMMENT '日期',
    `status`                        tinyint(3) unsigned     NOT NULL DEFAULT '0' COMMENT '状态',
    `create_time`                   datetime                NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`                   datetime                         DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='视频综合榜';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ks_rpt_video_monitor_detail`
--

DROP TABLE IF EXISTS `ks_rpt_video_monitor_detail`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
SET character_set_client = utf8mb4;
CREATE TABLE `ks_rpt_video_monitor_detail`
(
    `id`                 varchar(255)        NOT NULL COMMENT '视频id_日期',
    `video_id`           bigint(20) unsigned NOT NULL COMMENT '视频id',
    `user_id`            bigint(20) unsigned NOT NULL COMMENT '用户id',
    `kwai_id`            varchar(255)                 DEFAULT NULL COMMENT '快手号id',
    `monitor_start_time` datetime            NOT NULL COMMENT '监控开始时间',
    `monitor_end_time`   datetime            NOT NULL COMMENT '监控结束时间',
    `like_increment`     int(11)             NOT NULL COMMENT '点赞增量',
    `comment_increment`  int(11) unsigned    NOT NULL COMMENT '评论增量',
    `play_increment`     int(11) unsigned    NOT NULL COMMENT '播放增量',
    `time_interval`      int(11) unsigned    NOT NULL COMMENT '时间间隔（默认都是十分钟）',
    `status`             tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态(0：未删除，1：已删除)',
    `create_time`        datetime            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
    `update_time`        datetime                     DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='视频监控详情';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ks_rpt_video_proportion`
--

DROP TABLE IF EXISTS `ks_rpt_video_proportion`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
SET character_set_client = utf8mb4;
CREATE TABLE `ks_rpt_video_proportion`
(
    `id`                        varchar(255)        NOT NULL COMMENT '视频id_日期_榜单类型（日榜/周榜/月榜）',
    `video_id`                  bigint(20) unsigned NOT NULL COMMENT '视频ID',
    `video_hot_word_proportion` varchar(255)        NOT NULL COMMENT '视频热词占比( 热词:比例,热词:比例 )',
    `province_proportion`       varchar(255)        NOT NULL COMMENT '省份占比( 省份:比例,省份:比例 )',
    `city_proportion`           varchar(255)        NOT NULL COMMENT '城市占比( 城市:比例,城市:比例 )',
    `age_proportion`            varchar(255)        NOT NULL COMMENT '各年龄段所占比例',
    `female_fans_ratio`         decimal(10, 2)      NOT NULL COMMENT '女性观众所占比例',
    `status`                    tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '数据状态',
    `create_time```             datetime            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '数据创建时间',
    `update_time`               datetime                     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据修改时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='视频占比表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ks_rpt_video_soaring`
--

DROP TABLE IF EXISTS `ks_rpt_video_soaring`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
SET character_set_client = utf8mb4;
CREATE TABLE `ks_rpt_video_soaring`
(
    `id`                            varchar(255)            NOT NULL COMMENT '视频id_日期_榜单类型（日榜/周榜/月榜）',
    `ranking`                       int(11) unsigned        NOT NULL COMMENT '名次',
    `score`                         decimal(10, 2) unsigned NOT NULL COMMENT '飙升指数',
    `video_id`                      bigint(20)              NOT NULL COMMENT '视频id',
    `video_label`                   varchar(255)            NOT NULL COMMENT '视频标签',
    `video_cover`                   varchar(255)            NOT NULL COMMENT '视频封面图',
    `video_title`                   varchar(255)            NOT NULL COMMENT '视频标题',
    `video_hot_word`                varchar(255)            NOT NULL COMMENT '视频热词',
    `video_url`                     varchar(255)            NOT NULL COMMENT '视频链接',
    `user_id`                       bigint(20) unsigned     NOT NULL COMMENT '用户id',
    `kwai_id`                       varchar(255)                     DEFAULT NULL COMMENT '快手号id',
    `profile_picture`               varchar(255)            NOT NULL COMMENT '头像',
    `name`                          varchar(255)            NOT NULL COMMENT '昵称',
    `like_number`                   bigint(20) unsigned     NOT NULL COMMENT '点赞数',
    `like_number_interval`          int(11) unsigned        NOT NULL COMMENT '点赞数区间（0：10以下、1：10-50、2：50-100、3：100-200、4：200以上）',
    `like_number_increment`         int(11)                 NOT NULL COMMENT '点赞增量',
    `like_number_speed_increase`    decimal(10, 2) unsigned NOT NULL COMMENT '点赞增速',
    `comment_number`                bigint(20) unsigned     NOT NULL COMMENT '评论数',
    `comment_number_interval`       int(11) unsigned        NOT NULL COMMENT '评论数区间（0：0.1以下、1：0.1-0.5、2：0.5-1.0、3：1.0-2.0、4：2.0-5.0、5：5.0以上）',
    `comment_number_increment`      int(11) unsigned        NOT NULL COMMENT '评论增量',
    `comment_number_speed_increase` decimal(10, 2) unsigned NOT NULL COMMENT '评论增速',
    `play_number_interval`          int(11) unsigned        NOT NULL COMMENT '播放数区间（0：10以下、1：10-50、2：50-100、3：100-200、4：200-500、5：500以上）',
    `duration`                      int(11) unsigned        NOT NULL COMMENT '视频时长',
    `female_fan_ratio`              int(11) unsigned        NOT NULL COMMENT '女性观众比例区间（0:10%以下,1:10%~20%,2:20%~30%,3:30~40%,4:40%~50%,5:50%~60%,6:60%~70%,7:70%~80%,8:80%~90%,9:90%+）',
    `age_range`                     int(11) unsigned        NOT NULL COMMENT '主要观众年龄区间（0:0~17,1:18~24,2:25~30,3:31~35,4:36~40,5:41+）',
    `province`                      varchar(255)            NOT NULL COMMENT '观众所在最多的省份',
    `city`                          varchar(255)            NOT NULL COMMENT '观众所在最多的城市',
    `commodity_id`                  bigint(20) unsigned     NOT NULL COMMENT '关联商品id',
    `date_type`                     int(11) unsigned        NOT NULL COMMENT '日期类型（0:当天数据统计,1:七天数据统计,2:30天数据统计）',
    `date`                          varchar(255)            NOT NULL COMMENT '日期',
    `status`                        tinyint(3) unsigned     NOT NULL DEFAULT '0' COMMENT '状态',
    `create_time`                   datetime                NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`                   datetime                         DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='视频飙升榜';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ks_rpt_video_trend`
--

DROP TABLE IF EXISTS `ks_rpt_video_trend`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
SET character_set_client = utf8mb4;
CREATE TABLE `ks_rpt_video_trend`
(
    `id`                   varchar(255)        NOT NULL COMMENT '视频id_日期_榜单类型（日榜/周榜/月榜）',
    `video_id`             bigint(20) unsigned NOT NULL COMMENT '视频id',
    `total_like_number`    bigint(20) unsigned NOT NULL COMMENT '总点赞量',
    `like_increment`       bigint(20)          NOT NULL COMMENT '点赞增量',
    `total_comment_number` bigint(20) unsigned NOT NULL COMMENT '总评论数',
    `comment_increment`    bigint(20) unsigned NOT NULL COMMENT '评论增量',
    `total_play_number`    bigint(20) unsigned NOT NULL COMMENT '总播放数',
    `play_increment`       bigint(20) unsigned NOT NULL COMMENT '播放增量',
    `status`               tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态',
    `create_time`          datetime            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`          datetime                     DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='视频趋势表';
/*!40101 SET character_set_client = @saved_cs_client */;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE = @OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE = @OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS = @OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT = @OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS = @OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION = @OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES = @OLD_SQL_NOTES */;

-- Dump completed on 2019-09-12 20:56:10
