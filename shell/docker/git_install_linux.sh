#!/bin/bash

echo
## 安装 git
echo
echo "============================================"
echo "  install git begin  "
echo "============================================"
echo


echo
## yum安装,是否存在git
echo
echo '---------- ---------- ----------';
echo ' 1、install git '; 
echo '---------- ---------- ----------';

# isIstall=`rpm -qa git`
isIstall=`git --version`
if [ $? -ne 0 ];then
    echo " sure install ";
    sudo yum install -y git
    if [ $? -ne 0 ];then
        echo " yum install git error "
        exit 0
    fi;
else
    echo " already git "    
fi;

echo
## 查看版本
echo
echo '---------- ---------- ----------';
echo ' 2、show git version   '; 
echo '---------- ---------- ----------';

git version


echo
echo
