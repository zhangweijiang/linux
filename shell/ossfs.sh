#!/bin/bash
# ossfs挂载oss文件系统
# ctocode-zwj <982215226@qq.com>
# 2019-03-01 13:00
yum -y install http://www.github.com/aliyun/ossfs/releases/download/v1.80.5/ossfs_1.80.5_centos7.0_x86_64.rpm
echo hrhg-backup:LTAIht******:4UaZ***** > /etc/passwd-ossfs
chmod 640 /etc/passwd-ossfs
mkdir /ossfs
ossfs hrhg-backup /ossfs -ourl=http://oss-cn-hangzhou.aliyuncs.com