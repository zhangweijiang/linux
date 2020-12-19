#!/bin/bash
# lnmp之nginx1.12.2的安装
# author ctocode-zwj <982215226@qq.com>

# 判断用户或用户组是否存在，不存在则创建
user=www
group=www
#create group if not exists
egrep "^$group" /etc/group >& /dev/null
if [ $? -ne 0 ]
then
    groupadd $group
fi

#create user if not exists
egrep "^$user" /etc/passwd >& /dev/null
if [ $? -ne 0 ]
then
    useradd -g $group -s /sbin/nolgin $user
fi

yum -y install pcre pcre-devel openssl openssl-devel

rm -rf nginx-1.12.2
if [ ! -f nginx-1.12.2.tar.gz ];then
  #wget http://nginx.org/download/nginx-1.12.2.tar.gz
  wget https://f.9635.com.cn/linux/nginx-1.12.2.tar.gz
fi
tar zxvf nginx-1.12.2.tar.gz
cd nginx-1.12.2
chmod a+x configure
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

if [ ! -d "/alidata/www" ]; then
  mkdir -p /alidata/www
fi

chmod -R 775 /alidata/www
chown -R www:www /alidata/www
cd ..
cp -fR ./nginx-1.12.2/config-nginx/* /alidata/server/nginx/conf/
cp -fR ./nginx-1.12.2/conf/nginx.conf /alidata/server/nginx/conf/
sed -i 's/worker_processes  2/worker_processes  '"$CPU_NUM"'/' /alidata/server/nginx/conf/nginx.conf
chmod 755 /alidata/server/nginx/sbin/nginx
#/alidata/server/nginx/sbin/nginx
mv /alidata/server/nginx/conf/nginx /etc/init.d/
chmod +x /etc/init.d/nginx

# 设置开机启动
cat > /usr/lib/systemd/system/nginx.service<<"EOF"
[Unit]
Description=nginx service
After=network.target

[Service]
Type=forking
ExecStart=/etc/rc.d/init.d/nginx start
ExecReload=/etc/rc.d/init.d/nginx reload
ExecStop=/etc/rc.d/init.d/nginx stop
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF
systemctl enable nginx.service
systemctl start nginx.service

