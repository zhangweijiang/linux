#!/bin/bash
# lnmp之nginx1.12.2的安装
# author ctocode-zwj <982215226@qq.com>
rm -rf nginx-1.12.2
if [ ! -f nginx-1.12.2.tar.gz ];then
  wget http://nginx.org/download/nginx-1.12.2.tar.gz
fi
tar zxvf nginx-1.12.2.tar.gz
cd nginx-1.12.2
./configure --user=www \
--group=www \
--prefix=/alidata/server/nginx \
--with-http_stub_status_module \
--without-http-cache \
--with-http_ssl_module \
--with-http_gzip_static_module
CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install
chmod 775 /alidata/server/nginx/logs
chown -R www:www /alidata/server/nginx/logs
chmod -R 775 /alidata/www
chown -R www:www /alidata/www
cd ..
cp -fR ./nginx/config-nginx/* /alidata/server/nginx/conf/
sed -i 's/worker_processes  2/worker_processes  '"$CPU_NUM"'/' /alidata/server/nginx/conf/nginx.conf
chmod 755 /alidata/server/nginx/sbin/nginx
#/alidata/server/nginx/sbin/nginx
mv /alidata/server/nginx/conf/nginx /etc/init.d/
chmod +x /etc/init.d/nginx
/etc/init.d/nginx start
