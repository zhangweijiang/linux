#!/bin/bash
# linux下安装mongo扩展
# ctocode-zwj <982215226@qq.com>
# 2019-01-14 00:00
#cd /root
# 下载安装包
wget http://pecl.php.net/get/mongo-1.5.1.tgz
#解压安装包
tar  zxvf mongo-1.5.1.tgz
cd mongo-1.5.1
/alidata/server/php/bin/phpize
./configure --with-php-config=/alidata/server/php/bin/php-config
make && make install

# 以上安装如果失败用以下pecl安装
# /alidata/server/php/bin/pecl install mongodb
