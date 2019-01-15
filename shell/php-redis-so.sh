#!/bin/bash
# linux下安装redis扩展
# ctocode-zwj <982215226@qq.com>
# 2019-01-14 00:00
cd /root
# 下载安装包
wget https://pecl.php.net/get/redis-4.0.0.tgz
#解压安装包
tar -zxf redis-4.0.0.tgz
# 删除安装包
rm -rf redis-4.0.0.tgz
# 进入安装目录
cd redis-4.0.0
# 用phpize生成configure配置文件
/alidata/server/php-7.2.2/bin/phpize
# 配置
./configure --with-php-config=/alidata/server/php-7.2.2/bin/php-config
# 编译安装
make && make install
rm -rf /root/redis-4.0.0
# 往php.ini添加redis扩展
echo "extension=redis.so">>/alidata/server/php/etc/php.ini
# 重新启动redis
service php-fpm restart
