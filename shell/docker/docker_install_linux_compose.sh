#!/bin/bash

## ========== 版本号可以自己修改 ==========

## 下载地址，github 和 国内
#settDCURL="https://github.com/docker/compose/releases/"
settDCURL="https://get.daocloud.io/docker/compose/releases/"

## 版本，可在 https://github.com/docker/compose/releases/ 查看
settDCV=1.26.0

echo
## 安装 docker-compose 相关
echo
echo "============================================"
echo "  install docker-compose begin  "
echo "  confog - url             : ${settDCURL}  "
echo "  confog - releases        : ${settDCV}  "
echo "============================================"
echo



echo
## 先卸载，删除二进制文件，即可
echo
echo '---------- ---------- ----------';
echo ' 1、rm old '; 
echo '---------- ---------- ----------';

sudo rm /usr/local/bin/docker-compose


echo
## 下载Docker Compose的当前稳定版本
echo
echo '---------- ---------- ----------';
echo " 2、install docker-compose      "; 
echo '---------- ---------- ----------';

sudo curl -L "${settDCURL}download/${settDCV}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
#sudo curl -L "https://get.daocloud.io/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose


echo
## 对二进制文件应用可执行权限
echo
echo '---------- ---------- ----------';
echo ' 3、change file chmod '; 
echo '---------- ---------- ----------';

chmod +x /usr/local/bin/docker-compose


echo
## 查看输出版本
echo
echo '---------- ---------- ----------';
echo ' 4、show docker-compose version '; 
echo '---------- ---------- ----------';

docker-compose version


echo
echo