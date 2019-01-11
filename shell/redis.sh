#!/bin/bash
# linux安装redis-4.0.0
# ctocode-zwj <982215226@qq.com>
# 2019-01-10 21:00

# 进入根目录
cd /root/
# 下载安装包
wget http://download.redis.io/releases/redis-4.0.0.tar.gz
# 解压安装包
tar xzf redis-4.0.0.tar.gz
# 删除压缩包
rm -rf redis-4.0.0.tar.gz
# 进入安装目录
cd redis-4.0.0/src
# 编译安装（PREFIX指定设置安装目录）
make && make PREFIX=/alidata/server/redis-4.0.0 install
# redis-benchmark(redis性能测试工具),redis-check-aot(检查aot日志的工具)，redis-check-rdb(检查rdb日志的工具)
# 复制redis.conf到/alidata/server/redis-4.0.0目录下
cp /root/redis-4.0.0/redis.conf /alidata/server/redis-4.0.0
# 将redis的启动脚本放到/etc/init.d(类似windows的注册表，在系统启动时候执行)，给与可执行权限chmod a+x redis，并修改EXEC路径为/alidata/server/redis/bin/redis-server，CLIEXEC路径为/alidata/server/redis/bin/redis-cli，CONF路径为"/alidata/server/redis/redis.conf"
# 删除安装包
rm -rf /root/redis-4.0.0
# 进入/alidata/server/redis-4.0.0目录
cd /alidata/server/redis-4.0.0
# 启动Redis服务
# /alidata/server/redis-4.0.0/bin/redis-server /alidata/server/redis-4.0.0/redis.conf
# 启动redis客户端
# redis-cli
# 关闭redis客户端
# redis-cli shutdown
# 备注需要修改redis.conf的几个配置节点
# vim /alidata/server/redis-4.0.0/redis.conf
# daemonize no 改为   yes   #以守护进程方式运行  
echo "daemonize yes" >> /alidata/server/redis-4.0.0/redis.conf
# 如要允许外网连接redis把bind 127.0.0.1 前面的#注释掉。然后把protectionmode 改为no，否则远程客户端链接不上。
# 去掉requirepass foobared的#,把foobared换成你想设置的密码
# 建立软连接
ln -s /alidata/server/redis-4.0.0 /alidata/server/redis
cat > /etc/init.d/redis<<"EOF"
#!/bin/sh
# chkconfig: 2345 56 26
# description: Redis Service

### BEGIN INIT INFO
# Provides:          Redis
# Required-Start:    $all
# Required-Stop:     $all
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts Redis
# Description:       starts the BT-Web
### END INIT INFO

# Simple Redis init.d script conceived to work on Linux systems
# as it does use of the /proc filesystem.

CONF="/alidata/server/redis/redis.conf"
REDISPORT=$(cat $CONF |grep port|grep -v '#'|awk '{print $2}')
REDISPASS=$(cat $CONF |grep requirepass|grep -v '#'|awk '{print $2}')
if [ "$REDISPASS" != "" ];then
	REDISPASS=" -a $REDISPASS"
fi
if [ -f /www/server/redis/start.pl ];then
	STARPORT=$(cat /alidata/server/redis/start.pl)
else
	STARPORT=6379
fi
EXEC=/alidata/server/redis/bin/redis-server
CLIEXEC="/alidata/server/redis/bin/redis-cli -p $STARPORT$REDISPASS"
PIDFILE=/var/run/redis_6379.pid

redis_start(){
	if [ -f $PIDFILE ]
	then
			echo "$PIDFILE exists, process is already running or crashed"
	else
			echo "Starting Redis server..."
			nohup $EXEC $CONF >> /alidata/server/redis/logs.pl 2>&1 &
			echo ${REDISPORT} > /alidata/server/redis/start.pl
	fi
}
redis_stop(){
	if [ ! -f $PIDFILE ]
	then
			echo "$PIDFILE does not exist, process is not running"
	else
			PID=$(cat $PIDFILE)
			echo "Stopping ..."
			$CLIEXEC shutdown
			while [ -x /proc/${PID} ]
			do
				echo "Waiting for Redis to shutdown ..."
				sleep 1
			done
			echo "Redis stopped"
	fi
}


case "$1" in
    start)
		redis_start
        ;;
    stop)
        redis_stop
        ;;
	restart|reload)
		redis_stop
		sleep 0.3
		redis_start
		;;
    *)
        echo "Please use start or stop as first argument"
        ;;
esac
EOF
# 设置redis可执行权限
chmod a+x /etc/init.d/redis
# 设置开机启动项
chkconfig --add redis
# 通过service命令启动redis
service redis start
# 检查开机启动项
# chkconfig --list redis

