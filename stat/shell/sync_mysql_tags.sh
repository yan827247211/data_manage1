#!/usr/bin/env bash

##################################################################
## 从 MySQL同步标签相关信息                                        ##
##################################################################
## history:                                                     ##
##  2019-09-21 YuLei first release                              ##
##################################################################

#打印通用信息
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
SCRIPT_NAME="$(basename "$0")"
ARGS="$@"
echo '############################################'
echo "This shell locate at:$DIR/$SCRIPT_NAME"
echo "variable: $ARGS"
echo '############################################'
echo "start stat douyin comment daily info. "

# 引入通用配置和方法
source "$DIR/common/common_var.sh"
source "$DIR/common/common_func.sh"

_run_dt=`date "+%Y%m%d"`
_tmp_export_path_prefix=$DIR/data/$SCRIPT_NAME/$_run_dt

# 引入脚本方法
function sync_mysql_label() {
    label_sql="
        SELECT id, label_name, status, create_time, update_time
        FROM video_public.label
        WHERE status=0
    "
    _tmp_local_path="$_tmp_export_path_prefix/video_public_label"
    # 目录不存在则创建目录
    if [ ! -d "$_tmp_export_path_prefix" ]; then
        mkdir -p "$_tmp_export_path_prefix"
    fi
    log "export path:$_tmp_local_path"
    exportSQL2Local "$label_sql" "$_tmp_local_path"
    check 'load label from mysql to local'

# 导出文件存在则执行导入，否则报错
    if [ -f "$_tmp_local_path" ]; then
      _load_sql="LOAD DATA LOCAL INPATH '$_tmp_local_path' OVERWRITE into table short_video.biz_label;"
      execHql "$_load_sql"
      check 'load label data to hive'
    else
      log "load label data failed, $_tmp_local_path is not exist."
    fi
}

function sync_mysql_user_label() {
    user_label_sql="
        SELECT id, user_id, label_id, status, create_time, update_time
        FROM video_public.user_label
        WHERE status=0
    "
    _tmp_local_path="$_tmp_export_path_prefix/video_public_user_label"
    # 目录不存在则创建目录
    if [ ! -d "$_tmp_export_path_prefix" ]; then
        mkdir -p "$_tmp_export_path_prefix"
    fi
    log "export path:$_tmp_local_path"
    exportSQL2Local "$user_label_sql" "$_tmp_local_path"
    check 'load user_label from mysql to local'

# 导出文件存在则执行导入，否则报错
    if [ -f "$_tmp_local_path" ]; then
      _load_sql="LOAD DATA LOCAL INPATH '$_tmp_local_path' OVERWRITE into table short_video.biz_user_label;"
      execHql "$_load_sql"
      check 'load user_label data to hive'
    else
      log "load label data failed, $_tmp_local_path is not exist."
    fi
}



sync_mysql_label

sync_mysql_user_label