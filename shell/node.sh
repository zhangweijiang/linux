#!/bin/bash
# nodejs的安装
# author ctocode-zwj

# node官网 https://nodejs.org
# node中文网 http://nodejs.cn

# 判读是否创建/alidata/server文件夹，没有则创建文件夹，可自行选择安装位置
[[ -d /alidata/server ]] ||  mkdir -p /alidata/server
# 切换到/alidata/server目录
cd /alidata/server
# 下载v10.14.2安装包
wget https://nodejs.org/dist/v10.14.2/node-v10.14.2-linux-x64.tar.xz
# 解压安装包
tar xvf node-v10.14.2-linux-x64.tar.xz
# 删除安装包
rm -rf node-v10.14.2-linux-x64.tar.xz
# 改短名
mv node-v10.14.2-linux-x64 node-v10.14.2
# 建立软连接，相当于windows的快捷方式
ln -s /alidata/server/node-v10.14.2/bin/node /usr/local/bin/node
ln -s /alidata/server/node-v10.14.2/bin/npm /usr/local/bin/npm
#安装cnpm镜像
npm install -g cnpm --registry=https://registry.npm.taobao.org
# 查看版本
node -v
# 查看环境变量
# echo $PATH
# 设置环境变量
# vim /etc/profile 往export PATH=后面追加路径，修改完执行source /etc/profile让变量生效


