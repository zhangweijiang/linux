#!/bin/bash

## ========== 软件源信息仓库 ==========
# 阿里仓库(默认)
setRepo="https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo"
# 中央仓库
# setRepo="https://download.docker.com/linux/centos/docker-ce.repo"

echo
## 安装 docker-ce 相关
echo
echo "============================================"
echo "  install docker-ce begin  "
echo "  confog - repo            : ${setRepo}  "
echo "============================================"
echo


echo
## 先删除安装过的，将以前下载好的 docker 卸载干净
echo
echo '---------- ---------- ----------';
echo ' 1、remove old '; 
echo '---------- ---------- ----------';

sudo yum -y remove \
	docker \
    docker-client \
    docker-client-latest \
    docker-common \
    docker-latest \
    docker-latest-logrotate \
    docker-logrotate \
    docker-engine \
    docker-selinux  \
    docker-engine-selinux \
    container-selinux \
    docker-ce \
    docker-ce-cli ;

rm -rf /etc/systemd/system/docker.service.d;
rm -rf /var/lib/docker;
rm -rf /var/run/docker;


echo
## 安装必要的一些系统工具、软件包
echo
echo '---------- ---------- ----------';
echo ' 2、install tool '; 
echo '---------- ---------- ----------';

yum install -y yum-utils device-mapper-persistent-data lvm2;

## 安装最新版 containerd.io
yum install -y https://mirrors.aliyun.com/docker-ce/linux/centos/8/x86_64/stable/Packages/containerd.io-1.3.7-3.1.el8.x86_64.rpm

echo
## 添加软件源信息
echo
echo '---------- ---------- ----------';
echo ' 3、add repo '; 
echo '---------- ---------- ----------';

sudo yum-config-manager --add-repo "${setRepo}"


echo
## 安装最新稳定版 Docker-CE，自动安装其他依赖, yum dnf   --nobest
echo
echo '---------- ---------- ----------';
echo ' 4、install docker-ce '; 
echo '---------- ---------- ----------';

sudo dnf -y install docker-ce

# sudo dnf -y install docker-ce --nobest
# sudo dnf -y install docker-ce docker-ce-cli containerd.io
# sudo yum -y update


echo
## 设置docker开机自启，并且启动服务
echo
echo '---------- ---------- ----------';
echo ' 5、enable and start '; 
echo '---------- ---------- ----------';

sudo systemctl enable --now docker
sudo systemctl start docker


echo
## 安装完成后，测试查看版本
echo
echo '---------- ---------- ----------'
echo ' 6、show current docker-ce version '
echo '---------- ---------- ----------'
docker -v


echo
echo