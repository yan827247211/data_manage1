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

--抖音用户原始日志
CREATE EXTERNAL TABLE `rlog_douyin_user`
(
    `user_id`                  string COMMENT '用户ID',
    `sec_user_id`              string COMMENT '用户ID，页面跳转用',
    `unique_id`                string COMMENT '抖音号',
    `nickname`                 string COMMENT '用户名',
    `gender`                   string COMMENT '性别',
    `birthday`                 string COMMENT '生日',
    `signature`                string COMMENT '个性签名',
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
    `c_time`           bigint COMMENT '评论创建时间',
    `c_digg_count`     bigint COMMENT '评论获赞数',
    `is_author_digged` string COMMENT '视频作者是否点赞',
    `c_text`           string COMMENT '评论内容',
    `reply_count`      bigint COMMENT '评论回复数',
    `create_time`      bigint COMMENT '爬取时间，10位时间戳，爬虫提供'
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
    `r_is_shop`                  string COMMENT '未清洗是否有商品橱窗'
) COMMENT '抖音-用户-清洗日志'
    PARTITIONED BY (
        `dt` string,
        `hh` string
        )
    STORED AS ORC;


--抖音评论原始日志
CREATE TABLE `log_douyin_comment`
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
    `create_time`      bigint COMMENT '爬取时间，10位时间戳，爬虫提供'
) COMMENT '抖音-评论-清洗日志'
    PARTITIONED BY (
        `dt` string,
        `hh` string
        )
    STORED AS ORC;