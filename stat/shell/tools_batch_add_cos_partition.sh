#!/usr/bin/env bash

##################################################################
## 工具脚本，批量添加cos脚本                                        ##
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

for pDt in '20190904' '20190905' '20190906' '20190909' '20190910' '20190912' '20190913' '20190914' '20190915' '20190918' '20190919' '20190920' '20190922'
do
    for pHh in {0..23}
    do
        if [ ${pHh} -le 9 ];then
          pHh="0${pHh}"
        fi
        addHQL="${addHQL}alter table short_video.rlog_douyin_user add if not exists partition(dt='${pDt}',hh='${pHh}') location '$COSN_DOUYIN_BUCKET_PATH_PREFIX/user/$pDt/$pHh';"
    done
done
echo $addHQL