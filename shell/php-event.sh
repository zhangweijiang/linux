#!/bin/bash
# linux下安装php的event扩展
# ctocode-zwj <982215226@qq.com>
# 2018-08-17 16:00
cd /root
# 下载安装包
wget http://pecl.php.net/get/event-2.4.1.tgz
# 解压安装包
tar -zxvf event-2.4.1.tgz
# 删除安装包
rm -rf event-2.4.1.tgz
# 进入event-2.4.1目录
cd event-2.4.1/
# 用phpize生成configure配置文件
phpize
# 配置
./configure
# 编译安装
make && make install
# 删除安装文件
rm -rf /root/event-2.4.1
# 往php.ini添加event扩展
echo "extension=event.so">>/alidata/server/php/etc/php.ini
# 重新启动php-fpm
service php-fpm reload
