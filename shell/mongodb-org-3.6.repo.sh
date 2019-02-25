#!/bin/bash
# linux安装mongodb-3.6
# ctocode-zwj <982215226@qq.com>
# 2019-02-25 13:00
cat > /etc/yum.repos.d/mongodb-org-3.6.repo<<"EOF"
[mongodb]
name=MongoDB Repository
baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64/
gpgcheck=0
enabled=1
EOF
yum -y install mongodb-org
service mongod start