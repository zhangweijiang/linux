#!/bin/bash
# lnmp之php-7.2.2的安装
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

yum -y install wget vim pcre pcre-devel openssl openssl-devel libicu-devel gcc gcc-c++ autoconf libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel ncurses ncurses-devel curl curl-devel krb5-devel libidn libidn-devel openldap openldap-devel nss_ldap jemalloc-devel cmake boost-devel bison automake libevent libevent-devel gd gd-devel libtool* libmcrypt libmcrypt-devel mcrypt mhash libxslt libxslt-devel readline readline-devel gmp gmp-devel libcurl libcurl-devel openjpeg-devel

rm -rf php-7.2.2
cp -frp /usr/lib64/libldap* /usr/lib/
if [ ! -f php-7.2.2.tar.gz ];then
  #wget https://cn2.php.net/distributions/php-7.2.2.tar.gz
  wget https://f.9635.com.cn/linux/php-7.2.2.tar.gz
fi
tar zxvf php-7.2.2.tar.gz
cd php-7.2.2
./configure --prefix=/alidata/server/php \
--with-config-file-path=/alidata/server/php/etc \
--enable-fpm \
--with-fpm-user=www \
--with-fpm-group=www \
--enable-mysqlnd \
--with-mysqli=mysqlnd \
--with-pdo-mysql=mysqlnd \
--enable-mysqlnd-compression-support \
--with-iconv-dir \
--with-freetype-dir \
--with-jpeg-dir \
--with-png-dir \
--with-zlib \
--with-libxml-dir \
--enable-xml \
--disable-rpath \
--enable-bcmath \
--enable-shmop \
--enable-sysvsem \
--enable-inline-optimization \
--with-curl \
--enable-mbregex \
--enable-mbstring \
--enable-intl \
--with-mcrypt \
--with-libmbfl \
--enable-ftp \
--with-gd \
--enable-gd-jis-conv \
--enable-gd-native-ttf \
--with-openssl \
--with-mhash \
--enable-pcntl \
--enable-sockets \
--with-xmlrpc \
--enable-zip \
--enable-soap \
--with-gettext \
--disable-fileinfo \
--enable-opcache \
--with-pear \
--enable-maintainer-zts \
--with-ldap=shared \
--without-gdbm \


CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)
if [ $CPU_NUM -gt 1 ];then
    make ZEND_EXTRA_LIBS='-liconv' -j$CPU_NUM
else
    make ZEND_EXTRA_LIBS='-liconv'
fi
make install
cd ..
cp ./php-7.2.2/php.ini-development /alidata/server/php/etc/php.ini
sed -i '$d'  /alidata/server/php/etc/php.ini
cp /alidata/server/php/etc/php-fpm.conf.default /alidata/server/php/etc/php-fpm.conf
cp /alidata/server/php/etc/php-fpm.d/www.conf.default /alidata/server/php/etc/php-fpm.d/www.conf

    cat > /usr/lib/systemd/system/php-fpm.service<<"EOF"
[Unit]
Description=The PHP FastCGI Process Manager
After=syslog.target network.target

[Service]
Type=simple
PIDFile=/alidata/server/php/var/run/php-fpm.pid
ExecStart=/alidata/server/php/sbin/php-fpm --nodaemonize --fpm-config /alidata/server/php/etc/php-fpm.conf
ExecReload=/bin/kill -USR2 $MAINPID

[Install]
WantedBy=multi-user.target
EOF
systemctl enable php-fpm.service
systemctl start php-fpm.service
sleep 5
