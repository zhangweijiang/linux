#!/bin/bash

## 配置docker镜像加速器

mkdir -p /etc/docker

tee /etc/docker/daemon.json <<-'EOF'
{

"registry-mirrors": ["https://u5rqg49f.mirror.aliyuncs.com"]

}
EOF

## 重新加载Docker配置
systemctl daemon-reload;

## 重启Docker服务
systemctl restart docker