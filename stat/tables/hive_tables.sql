--#################################原始日志###############################
--抖音视频原始日志
CREATE EXTERNAL TABLE `rlog_douyin_video`
(
    `aweme_id`          string COMMENT '视频ID',
    `user_id`           string COMMENT '用户ID',
    `sec_user_id`       string COMMENT '用户ID，页面跳转用',
    `desc`              string COMMENT '标题',
    `chat`              string COMMENT '话题',
    `cover_img`         string COMMENT '视频封面图',
    `video_create_time` string COMMENT '视频创建时间,10位时间戳',
    `digg_count`        string COMMENT '点赞数',
    `comment_count`     string COMMENT '评论数',
    `share_count`       string COMMENT '转发数',
    `duration`          string COMMENT '视频时长',
    `music_id`          string COMMENT '音乐ID',
    `room_id`           string COMMENT '直播房间ID',
    `product_id`        string COMMENT '商品ID',
    `ad_id`             string COMMENT '广告ID',
    `share_url`         string COMMENT '分享视频地址',
--    `vb_rank`           int COMMENT '今日最热视频排名',
--    `vb_rank_value`     bigint COMMENT '今日最热视频播放量',
    `create_time`       string COMMENT '爬取时间，10位时间戳，爬虫提供'
) COMMENT '抖音-视频-原始日志'
    PARTITIONED BY (
        `dt` string,
        `hh` string
        )
    ROW FORMAT DELIMITED
        FIELDS TERMINATED BY '\t'
        LINES TERMINATED BY '\n'
    STORED AS TEXTFILE
    LOCATION 'cosn://douyin-emr/video';

--抖音用户原始日志 20号开始有省份
CREATE EXTERNAL TABLE `rlog_douyin_user`
(
    `user_id`                  string COMMENT '用户ID',
    `sec_user_id`              string COMMENT '用户ID，页面跳转用',
    `unique_id`                string COMMENT '抖音号',
    `nickname`                 string COMMENT '用户名',
    `gender`                   string COMMENT '性别',
    `birthday`                 string COMMENT '生日',
    `signature`                string COMMENT '个性签名',
    `province`                 string COMMENT '省份',
    `city`                     string COMMENT '城市',
    `cover_img`                string COMMENT '背景封面',
    `total_favorited`          string COMMENT '获赞数',
    `follower_count`           string COMMENT '粉丝数',
    `following_count`          string COMMENT '关注数',
    `aweme_count`              string COMMENT '作品数',
    `dongtai_count`            string COMMENT '动态数',
    `favoriting_count`         string COMMENT '喜欢数',
    `head_img`                 string COMMENT '头像URL',
    `custom_verify`            string COMMENT '专属认证（定制认证)',
    `weibo_verify`             string COMMENT '微博认证',
    `enterprise_verify_reason` string COMMENT '官方认证',
    `is_shop`                  string COMMENT '是否有商品橱窗',
    `be_followered_uid`        string COMMENT '被关注用户ID',
    `create_time`              string COMMENT '爬取时间，10位时间戳，爬虫提供'
) COMMENT '抖音-用户-原始日志'
    PARTITIONED BY (
        `dt` string,
        `hh` string
        )
    ROW FORMAT DELIMITED
        FIELDS TERMINATED BY '\t'
        LINES TERMINATED BY '\n'
    STORED AS TEXTFILE
    LOCATION 'cosn://douyin-emr/user';


--抖音评论原始日志
CREATE EXTERNAL TABLE `rlog_douyin_comment`
(
    `cid`              string COMMENT '评论ID',
    `aweme_id`         string COMMENT '视频ID',
    `user_id`          string COMMENT '评论人ID',
    `sec_user_id`      string COMMENT '评论人ID2,页面跳转用',
    `c_nickname`       string COMMENT '评论人昵称',
    `c_img`            string COMMENT '评论人头像',
    `c_url`            string COMMENT '评论人分享地址',
    `c_time`           string COMMENT '评论创建时间',
    `c_digg_count`     string COMMENT '评论获赞数',
    `is_author_digged` string COMMENT '视频作者是否点赞',
    `c_text`           string COMMENT '评论内容',
    `reply_count`      string COMMENT '评论回复数',
    `create_time`      string COMMENT '爬取时间，10位时间戳，爬虫提供'
) COMMENT '抖音-评论-原始日志'
    PARTITIONED BY (
        `dt` string,
        `hh` string
        )
    ROW FORMAT DELIMITED
        FIELDS TERMINATED BY '\t'
        LINES TERMINATED BY '\n'
    STORED AS TEXTFILE
    LOCATION 'cosn://douyin-emr/comment';

--抖音商品原始日志
CREATE EXTERNAL TABLE `rlog_douyin_goods`
(
    `product_id`    string COMMENT '商品ID',
    `promotion_id`  string COMMENT '商品推销id',
    `user_id`       string COMMENT '用户ID',
    `product_title` string COMMENT '商品标题',
    `product_img`   string COMMENT '商品图片',
    `market_price`  string COMMENT '商品原价',
    `price`         string COMMENT '商品现价',
    `sales`         string COMMENT '商品销量',
    `visit_count`   string COMMENT '商品访问量（查看该商品人数）',
    `detail_url`    string COMMENT '商品购买地址',
    `rank`          string COMMENT '当前排名（针对好物榜）',
    `score`         string COMMENT '当前人气值（针对好物榜）',
    `cid`           string COMMENT '商品所属榜单id（针对好物榜）',
    `create_time`   string COMMENT '爬取时间'
) COMMENT '抖音-商品-原始日志'
    PARTITIONED BY (
        `dt` string,
        `hh` string
        )
    ROW FORMAT DELIMITED
        FIELDS TERMINATED BY '\t'
        LINES TERMINATED BY '\n'
    STORED AS TEXTFILE
    LOCATION 'cosn://douyin-emr/goods';

--抖音音乐原始日志 日志格式貌似不对，需要确认
CREATE TABLE `rlog_douyin_music`
(
    `mid`         string COMMENT '音乐ID',
    `title`       string COMMENT '音乐名称',
    `img`         string COMMENT '音乐背景图片',
    `play_url`    string COMMENT '音乐URL',
    `author`      string COMMENT '作者',
    `duration`    string COMMENT '音乐时长',
    `create_time` bigint COMMENT '爬取时间，10位时间戳，爬虫提供'
) COMMENT '抖音-音乐-原始日志'
    PARTITIONED BY (
        `dt` string,
        `hh` string
        )
    ROW FORMAT DELIMITED
        FIELDS TERMINATED BY '\t'
        LINES TERMINATED BY '\n'
    STORED AS TEXTFILE;

--#########################################清洗日志表##############################
CREATE TABLE `log_douyin_video`
(
    `aweme_id`          string COMMENT '视频ID',
    `user_id`           string COMMENT '用户ID',
    `sec_user_id`       string COMMENT '用户ID，页面跳转用',
    `desc`              string COMMENT '标题',
    `chat`              string COMMENT '话题',
    `cover_img`         string COMMENT '视频封面图',
    `video_create_time` bigint COMMENT '视频创建时间,10位时间戳',
    `digg_count`        bigint COMMENT '点赞数',
    `comment_count`     bigint COMMENT '评论数',
    `share_count`       bigint COMMENT '转发数',
    `duration`          bigint COMMENT '视频时长',
    `music_id`          string COMMENT '音乐ID',
    `room_id`           string COMMENT '直播房间ID',
    `product_id`        string COMMENT '商品ID',
    `ad_id`             string COMMENT '广告ID',
    `share_url`         string COMMENT '分享视频地址',
--    `vb_rank`           int COMMENT '今日最热视频排名',
--    `vb_rank_value`     bigint COMMENT '今日最热视频播放量',
    `create_time`       bigint COMMENT '爬取时间，10位时间戳，爬虫提供',
    `r_digg_count`      string COMMENT '未清洗点赞数',
    `r_comment_count`   string COMMENT '未清洗评论数',
    `r_share_count`     string COMMENT '未清洗转发数',
    `r_duration`        string COMMENT '未清洗视频时长',
    `r_music_id`        string COMMENT '未清洗音乐ID',
    `r_room_id`         string COMMENT '未清洗直播房间ID',
    `r_product_id`      string COMMENT '未清洗商品ID',
    `r_ad_id`           string COMMENT '未清洗广告ID'
) COMMENT '抖音-视频-清洗日志'
    PARTITIONED BY (
        `dt` string,
        `hh` string
        )
    STORED AS ORC;

--抖音用户原始日志
CREATE TABLE `log_douyin_user`
(
    `user_id`                    string COMMENT '用户ID',
    `sec_user_id`                string COMMENT '用户ID，页面跳转用',
    `unique_id`                  string COMMENT '抖音号',
    `nickname`                   string COMMENT '用户名',
    `gender`                     string COMMENT '性别',
    `birthday`                   string COMMENT '生日',
    `signature`                  string COMMENT '个性签名',
    `province`                   string COMMENT '省份',
    `city`                       string COMMENT '城市',
    `cover_img`                  string COMMENT '背景封面',
    `total_favorited`            bigint COMMENT '获赞数',
    `follower_count`             bigint COMMENT '粉丝数',
    `following_count`            bigint COMMENT '关注数',
    `aweme_count`                bigint COMMENT '作品数',
    `dongtai_count`              bigint COMMENT '动态数',
    `favoriting_count`           bigint COMMENT '喜欢数',
    `head_img`                   string COMMENT '头像URL',
    `custom_verify`              string COMMENT '专属认证（定制认证)',
    `weibo_verify`               string COMMENT '微博认证',
    `enterprise_verify_reason`   string COMMENT '官方认证',
    `is_shop`                    string COMMENT '是否有商品橱窗',
    `be_followered_uid`          string COMMENT '被关注用户ID',
    `create_time`                bigint COMMENT '爬取时间，10位时间戳，爬虫提供',
    `r_gender`                   string COMMENT '未清洗性别',
    `r_birthday`                 string COMMENT '未清洗生日',
    `r_province`                 string COMMENT '未清洗省份',
    `r_city`                     string COMMENT '未清洗城市',
    `r_total_favorited`          string COMMENT '未清洗获赞数',
    `r_follower_count`           string COMMENT '未清洗粉丝数',
    `r_following_count`          string COMMENT '未清洗关注数',
    `r_aweme_count`              string COMMENT '未清洗作品数',
    `r_dongtai_count`            string COMMENT '未清洗动态数',
    `r_favoriting_count`         string COMMENT '未清洗喜欢数',
    `r_custom_verify`            string COMMENT '未清洗专属认证（定制认证)',
    `r_weibo_verify`             string COMMENT '未清洗微博认证',
    `r_enterprise_verify_reason` string COMMENT '未清洗官方认证',
    `r_is_shop`                  string COMMENT '未清洗是否有商品橱窗',
    `r_be_followered_uid`        string COMMENT '未清洗被关注用户ID'
) COMMENT '抖音-用户-清洗日志'
    PARTITIONED BY (
        `dt` string,
        `hh` string
        )
    STORED AS ORC;


--抖音评论原始日志
CREATE TABLE `log_douyin_comment`
(
    `cid`                string COMMENT '评论ID',
    `aweme_id`           string COMMENT '视频ID',
    `user_id`            string COMMENT '评论人ID',
    `sec_user_id`        string COMMENT '评论人ID2,页面跳转用',
    `c_nickname`         string COMMENT '评论人昵称',
    `c_img`              string COMMENT '评论人头像',
    `c_url`              string COMMENT '评论人分享地址',
    `c_time`             bigint COMMENT '评论创建时间',
    `c_digg_count`       bigint COMMENT '评论获赞数',
    `is_author_digged`   string COMMENT '视频作者是否点赞',
    `c_text`             string COMMENT '评论内容',
    `reply_count`        bigint COMMENT '评论回复数',
    `create_time`        bigint COMMENT '爬取时间，10位时间戳，爬虫提供',
    `r_c_digg_count`     string COMMENT '未清洗评论获赞数',
    `r_is_author_digged` string COMMENT '未清洗视频作者是否点赞',
    `r_reply_count`      string COMMENT '未清洗评论回复数'
) COMMENT '抖音-评论-清洗日志'
    PARTITIONED BY (
        `dt` string,
        `hh` string
        )
    STORED AS ORC;

--抖音商品清洗日志日志
CREATE TABLE `log_douyin_goods`
(
    `product_id`    string COMMENT '商品ID',
    `promotion_id`  string COMMENT '商品推销id',
    `user_id`       string COMMENT '用户ID',
    `product_title` string COMMENT '商品标题',
    `product_img`   string COMMENT '商品图片',
    `market_price`  bigint COMMENT '商品原价',
    `price`         bigint COMMENT '商品现价',
    `sales`         bigint COMMENT '商品销量',
    `visit_count`   bigint COMMENT '商品访问量（查看该商品人数）',
    `detail_url`    string COMMENT '商品购买地址',
    `rank`          int COMMENT '当前排名（针对好物榜）',
    `score`         int COMMENT '当前人气值（针对好物榜）',
    `cid`           string COMMENT '商品所属榜单id（针对好物榜）',
    `create_time`   bigint COMMENT '爬取时间'
) COMMENT '抖音-评论-清洗日志'
    PARTITIONED BY (
        `dt` string,
        `hh` string
        )
    STORED AS ORC;

--抖音用户每日最新数据，只保留当日最新的数据
CREATE TABLE `base_douyin_user_daily`
(
    `user_id`                  string COMMENT '用户ID',
    `sec_user_id`              string COMMENT '用户ID，页面跳转用',
    `unique_id`                string COMMENT '抖音号',
    `nickname`                 string COMMENT '用户名',
    `gender`                   string COMMENT '性别',
    `birthday`                 string COMMENT '生日',
    `signature`                string COMMENT '个性签名',
    `province`                 string COMMENT '省份',
    `city`                     string COMMENT '城市',
    `cover_img`                string COMMENT '背景封面',
    `total_favorited`          bigint COMMENT '获赞数',
    `follower_count`           bigint COMMENT '粉丝数',
    `following_count`          bigint COMMENT '关注数',
    `aweme_count`              bigint COMMENT '作品数',
    `dongtai_count`            bigint COMMENT '动态数',
    `favoriting_count`         bigint COMMENT '喜欢数',
    `head_img`                 string COMMENT '头像URL',
    `custom_verify`            string COMMENT '专属认证（定制认证)',
    `weibo_verify`             string COMMENT '微博认证',
    `enterprise_verify_reason` string COMMENT '官方认证',
    `is_shop`                  string COMMENT '是否有商品橱窗',
    `be_followered_uid`        string COMMENT '被关注用户ID',
    `create_time`              bigint COMMENT '爬取时间，10位时间戳，爬虫提供',
    `stat_time`                bigint COMMENT '数据计算时间，10位时间戳'
) COMMENT '抖音-用户-每日增量用户数据，保存当天最新的日志信息'
    PARTITIONED BY (
        `dt` string
        )
    STORED AS ORC;

--抖音用户全量信息表，用户关联统计信息
CREATE TABLE `base_douyin_user`
(
    `user_id`                  string COMMENT '用户ID',
    `sec_user_id`              string COMMENT '用户ID，页面跳转用',
    `unique_id`                string COMMENT '抖音号',
    `nickname`                 string COMMENT '用户名',
    `gender`                   string COMMENT '性别',
    `birthday`                 string COMMENT '生日',
    `signature`                string COMMENT '个性签名',
    `province`                 string COMMENT '省份',
    `city`                     string COMMENT '城市',
    `cover_img`                string COMMENT '背景封面',
    `total_favorited`          bigint COMMENT '获赞数',
    `follower_count`           bigint COMMENT '粉丝数',
    `following_count`          bigint COMMENT '关注数',
    `aweme_count`              bigint COMMENT '作品数',
    `dongtai_count`            bigint COMMENT '动态数',
    `favoriting_count`         bigint COMMENT '喜欢数',
    `head_img`                 string COMMENT '头像URL',
    `custom_verify`            string COMMENT '专属认证（定制认证)',
    `weibo_verify`             string COMMENT '微博认证',
    `enterprise_verify_reason` string COMMENT '官方认证',
    `is_shop`                  string COMMENT '是否有商品橱窗',
    `be_followered_uid`        string COMMENT '被关注用户ID',
    `create_time`              bigint COMMENT '爬取时间，10位时间戳，爬虫提供',
    `stat_time`                bigint COMMENT '数据计算时间，10位时间戳'
) COMMENT '抖音-用户-全量用户数据'
    STORED AS ORC;


--抖音视频每日最新数据
CREATE TABLE `base_douyin_video_daily`
(
    `aweme_id`          string COMMENT '视频ID',
    `user_id`           string COMMENT '用户ID',
    `sec_user_id`       string COMMENT '用户ID，页面跳转用',
    `desc`              string COMMENT '标题',
    `chat`              string COMMENT '话题',
    `cover_img`         string COMMENT '视频封面图',
    `video_create_time` bigint COMMENT '视频创建时间,10位时间戳',
    `digg_count`        bigint COMMENT '点赞数',
    `comment_count`     bigint COMMENT '评论数',
    `share_count`       bigint COMMENT '转发数',
    `duration`          bigint COMMENT '视频时长',
    `music_id`          string COMMENT '音乐ID',
    `room_id`           string COMMENT '直播房间ID',
    `product_id`        string COMMENT '商品ID',
    `ad_id`             string COMMENT '广告ID',
    `share_url`         string COMMENT '分享视频地址',
--    `vb_rank`           int COMMENT '今日最热视频排名',
--    `vb_rank_value`     bigint COMMENT '今日最热视频播放量',
    `create_time`       bigint COMMENT '爬取时间，10位时间戳，爬虫提供',
    `stat_time`         bigint COMMENT '统计时间，10位时间戳，由计算脚本写入'
) COMMENT '抖音-视频-每日最新信息'
    PARTITIONED BY (
        `dt` string
        )
    STORED AS ORC;

--抖音视频全量信息
CREATE TABLE `base_douyin_video`
(
    `aweme_id`          string COMMENT '视频ID',
    `user_id`           string COMMENT '用户ID',
    `sec_user_id`       string COMMENT '用户ID，页面跳转用',
    `desc`              string COMMENT '标题',
    `chat`              string COMMENT '话题',
    `cover_img`         string COMMENT '视频封面图',
    `video_create_time` bigint COMMENT '视频创建时间,10位时间戳',
    `digg_count`        bigint COMMENT '点赞数',
    `comment_count`     bigint COMMENT '评论数',
    `share_count`       bigint COMMENT '转发数',
    `duration`          bigint COMMENT '视频时长',
    `music_id`          string COMMENT '音乐ID',
    `room_id`           string COMMENT '直播房间ID',
    `product_id`        string COMMENT '商品ID',
    `ad_id`             string COMMENT '广告ID',
    `share_url`         string COMMENT '分享视频地址',
--    `vb_rank`           int COMMENT '今日最热视频排名',
--    `vb_rank_value`     bigint COMMENT '今日最热视频播放量',
    `create_time`       bigint COMMENT '爬取时间，10位时间戳，爬虫提供',
    `stat_time`         bigint COMMENT '统计时间，10位时间戳，由计算脚本写入'
) COMMENT '抖音-视频-全量信息'
    STORED AS ORC;

--抖音每日增量评论
CREATE TABLE `base_douyin_comment_daily`
(
    `cid`              string COMMENT '评论ID',
    `aweme_id`         string COMMENT '视频ID',
    `user_id`          string COMMENT '评论人ID',
    `sec_user_id`      string COMMENT '评论人ID2,页面跳转用',
    `c_nickname`       string COMMENT '评论人昵称',
    `c_img`            string COMMENT '评论人头像',
    `c_url`            string COMMENT '评论人分享地址',
    `c_time`           bigint COMMENT '评论创建时间',
    `c_digg_count`     bigint COMMENT '评论获赞数',
    `is_author_digged` string COMMENT '视频作者是否点赞',
    `c_text`           string COMMENT '评论内容',
    `reply_count`      bigint COMMENT '评论回复数',
    `create_time`      bigint COMMENT '爬取时间，10位时间戳，爬虫提供',
    `stat_time`        bigint COMMENT '跑批批次，10位时间戳，跑批脚本提供'
) COMMENT '抖音-评论-爬虫每日增量信息'
    PARTITIONED BY (
        `dt` string
        )
    STORED AS ORC;

--抖音评论全量评论信息
CREATE TABLE `base_douyin_comment`
(
    `cid`              string COMMENT '评论ID',
    `aweme_id`         string COMMENT '视频ID',
    `user_id`          string COMMENT '评论人ID',
    `sec_user_id`      string COMMENT '评论人ID2,页面跳转用',
    `c_nickname`       string COMMENT '评论人昵称',
    `c_img`            string COMMENT '评论人头像',
    `c_url`            string COMMENT '评论人分享地址',
    `c_time`           bigint COMMENT '评论创建时间',
    `c_digg_count`     bigint COMMENT '评论获赞数',
    `is_author_digged` string COMMENT '视频作者是否点赞',
    `c_text`           string COMMENT '评论内容',
    `reply_count`      bigint COMMENT '评论回复数',
    `create_time`      bigint COMMENT '爬取时间，10位时间戳，爬虫提供',
    `stat_time`        bigint COMMENT '跑批批次，10位时间戳，跑批脚本提供'
) COMMENT '抖音-评论-全量评论信息，数据量大，慎用！'
    STORED AS ORC;

--抖音商品每日增量表
CREATE TABLE `base_douyin_goods_daily`
(
    `product_id`    string COMMENT '商品ID',
    `promotion_id`  string COMMENT '商品推销id',
    `user_id`       string COMMENT '用户ID',
    `product_title` string COMMENT '商品标题',
    `product_img`   string COMMENT '商品图片',
    `market_price`  bigint COMMENT '商品原价',
    `price`         bigint COMMENT '商品现价',
    `sales`         bigint COMMENT '商品销量',
    `visit_count`   bigint COMMENT '商品访问量（查看该商品人数）',
    `detail_url`    string COMMENT '商品购买地址',
    `rank`          int COMMENT '当前排名（针对好物榜）',
    `score`         int COMMENT '当前人气值（针对好物榜）',
    `cid`           string COMMENT '商品所属榜单id（针对好物榜）',
    `create_time`   bigint COMMENT '爬取时间,10位时间戳,爬虫提供',
    `stat_time`     bigint COMMENT '跑批批次，10位时间戳，跑批脚本提供'
) COMMENT '抖音-商品-爬虫每日增量信息'
    PARTITIONED BY (
        `dt` string
        )
    STORED AS ORC;

--抖音商品每日全量表
CREATE TABLE `base_douyin_goods`
(
    `product_id`    string COMMENT '商品ID',
    `promotion_id`  string COMMENT '商品推销id',
    `user_id`       string COMMENT '用户ID',
    `product_title` string COMMENT '商品标题',
    `product_img`   string COMMENT '商品图片',
    `market_price`  bigint COMMENT '商品原价',
    `price`         bigint COMMENT '商品现价',
    `sales`         bigint COMMENT '商品销量',
    `visit_count`   bigint COMMENT '商品访问量（查看该商品人数）',
    `detail_url`    string COMMENT '商品购买地址',
    `rank`          int COMMENT '当前排名（针对好物榜）',
    `score`         int COMMENT '当前人气值（针对好物榜）',
    `cid`           string COMMENT '商品所属榜单id（针对好物榜）',
    `create_time`   bigint COMMENT '爬取时间,10位时间戳,爬虫提供',
    `stat_time`     bigint COMMENT '跑批批次，10位时间戳，跑批脚本提供'
) COMMENT '抖音-商品-爬虫每日全量信息'
    STORED AS ORC;

--抖音视频评论粉丝
CREATE TABLE `relat_douyin_video_fans`
(
    `aweme_id`     string COMMENT '视频ID',
    `fans_user_id` string COMMENT '粉丝用户ID',
    `stat_time`    bigint COMMENT '跑批批次，10位时间戳，跑批脚本提供'
) COMMENT '抖音-视频评论粉丝，从评论信息中抽取'
    STORED AS ORC;

--抖音达人粉丝
CREATE TABLE `relat_douyin_user_fans`
(
    `user_id`      string COMMENT '用户ID',
    `fans_user_id` string COMMENT '粉丝用户ID',
    `stat_time`    bigint COMMENT '跑批批次，10位时间戳，跑批脚本提供'
) COMMENT '抖音-达人粉丝，从评论信息中抽取'
    STORED AS ORC;

--达人信息统计表
CREATE TABLE `stat_douyin_user_info`
(
    `user_id`             string COMMENT '用户ID',
    `total_favorited`     bigint COMMENT '获赞数',
    `follower_count`      bigint COMMENT '粉丝数',
    `following_count`     bigint COMMENT '关注数',
    `aweme_count`         bigint COMMENT '作品数',
    `dongtai_count`       bigint COMMENT '动态数',
    `favoriting_count`    bigint COMMENT '喜欢数',
    `video_count`         bigint COMMENT '视频数量，统计自视频接口',
    `video_digg_count`    bigint COMMENT '达人视频获赞数，统计自视频接口',
    `video_comment_count` bigint COMMENT '达人视频评论数，统计自视频接口',
    `video_share_count`   bigint COMMENT '达人视频分享数， 统计自视频接口',
    `stat_time`           bigint COMMENT '跑批批次，10位时间戳，跑批脚本提供'
) COMMENT '抖音-达人统计信息'
    PARTITIONED BY (
        `dt` string
        )
    STORED AS ORC;

--达人视频信息统计表
CREATE TABLE `stat_douyin_user_video_info`
(
    `user_id`             string COMMENT '用户ID',
    `video_count`         string COMMENT '视频数量',
    `video_digg_count`    bigint COMMENT '达人视频评论数',
    `video_comment_count` bigint COMMENT '达人视频评论数',
    `video_share_count`   bigint COMMENT '达人视频分享数',
    `stat_time`           bigint COMMENT '跑批批次，10位时间戳，跑批脚本提供'
) COMMENT '抖音-达人视频信息统计信息'
    PARTITIONED BY (
        `dt` string
        )
    STORED AS ORC;

--达人粉丝统计信息表
CREATE TABLE `stat_douyin_user_fans_info`
(
    `user_id`         string COMMENT '用户ID',
    `fans_age_seg`    int COMMENT '粉丝主要年龄区间，1：6-17、2：18-24、3：25-30、4：31-35、5：36-40、6：41+',
    `fans_province`   string COMMENT '粉丝主要省份信息',
    `fans_city`       string COMMENT '粉丝主要城市信息',
    `female_rate_seg` int COMMENT '女粉丝占比区间,0：10%以下、1：10%-20%、2：20%-30%、3：30%-40%，4：40%-50%，5：50%-60%，6：60%-70%，7：70%-80%，8：80%-90%，9：90%以上',
    `stat_time`       bigint COMMENT '跑批批次，10位时间戳，跑批脚本提供'
) COMMENT '抖音-达人统计信息'
    PARTITIONED BY (
        `dt` string
        )
    STORED AS ORC;

--达人粉丝统计信息表
CREATE TABLE `stat_douyin_user_fans_detail`
(
    `user_id`    string COMMENT '用户ID',
    `prop_rank`  int COMMENT '属性分布排名',
    `prop_key`   string COMMENT '属性key',
    `prop_count` bigint COMMENT '属性key数量',
    `stat_time`  bigint COMMENT '跑批批次，10位时间戳，跑批脚本提供'
) COMMENT '抖音-用户粉丝属性明细'
    PARTITIONED BY (
        `dt` string,
        `prop_type` string COMMENT '属性类型，age:年龄，gender:性别 city:城市，province:省份'
        )
    STORED AS ORC;


-----业务同步表
--标签表
CREATE TABLE `biz_label`
(
    `id`          string COMMENT '标签id',
    `label_name`  string COMMENT '标签名称',
    `status`      int COMMENT '数据状态',
    `create_time` string COMMENT '数据创建时间',
    `update_time` string COMMENT '数据更新时间'
) COMMENT '标签表，来源：video_public.label'
    ROW FORMAT DELIMITED
        FIELDS TERMINATED BY '\t'
        LINES TERMINATED BY '\n'
    STORED AS TEXTFILE;
--达人标签表
CREATE TABLE `biz_user_label`
(
    `id`          string COMMENT '关系id',
    `user_id`     string COMMENT '用户ID',
    `label_id`    string COMMENT '标签ID',
    `status`      int COMMENT '数据状态',
    `create_time` string COMMENT '数据创建时间',
    `update_time` string COMMENT '数据更新时间'
) COMMENT '标签表，来源：video_public.user_label'
    ROW FORMAT DELIMITED
        FIELDS TERMINATED BY '\t'
        LINES TERMINATED BY '\n'
    STORED AS TEXTFILE;