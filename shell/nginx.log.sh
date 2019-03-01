#!/bin/bash
# nginx日志按日分割
# ctocode-zwj <982215226@qq.com>
# 2019-03-01 11:00

#设置日志文件存放目录
logs_path=/alidata/www/zhyt_hrhg2_www_log/
#设置pid文件
pid_path="/alidata/server/nginx-1.12.2/logs/nginx.pid"

#重命名日志文件
if [ ! -d ${logs_path}log/` date +%Y%m ` ]; then
	mkdir -p ${logs_path}log/` date +%Y%m `
fi
mv ${logs_path}www.log ${logs_path}log/` date +%Y%m `/www_$(date -d "yesterday" +"%Y%m%d").log
mv ${logs_path}www_error.log ${logs_path}log/` date +%Y%m `/www_error_$(date -d "yesterday" +"%Y%m%d").log
#向nginx主进程发信号重新打开日志
kill -USR1 `cat ${pid_path}`