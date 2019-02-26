#!/bin/bash
# gitlab 环境部署
# author ctocode-zwj

cat > /etc/yum.repos.d/gitlab-ce.repo<<"EOF"
[gitlab-ce]
name=Gitlab CE Repository
baseurl=https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el$releasever/
gpgcheck=0
enabled=1
EOF
yum -y makecache
yum -y install gitlab-ce-11.5.4
#systemctl stop gitlab-runsvdir.service 停止gitlab后台服务进程
# gitlab-ctl staus

# gitlab汉化
# 安装git(已安装可忽略)
yum install -y git
#下载对应版本的汉化包
git clone https://gitlab.com/xhang/gitlab.git -b v11.5.4-zh