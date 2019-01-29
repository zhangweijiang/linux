#!/bin/bash
# Yapi开源接口管理平台部署
# author ctocode-zwj <982215226@qq.com>

curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -
yum -y install nodejs
cat > /etc/yum.repos.d/mongodb-org-3.6.repo<<"EOF"
[mongodb]
name=MongoDB Repository
baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64/
gpgcheck=0
enabled=1
EOF
yum -y install mongodb-org
service mongod start
npm install -g yapi-cli --registry https://registry.npm.taobao.org
yapi server