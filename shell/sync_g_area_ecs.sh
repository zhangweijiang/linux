#!/bin/bash
# sync跨服务器数据同步
# author ctocode-zwj <982215226@qq.com>
 
function ctocodeLinuxSync()
{
    echo "|----------------------------------------------------------"
    echo "|========== sync  ---- $1  --- start  =========="
    echo "|----------------------------------------------------------"
    echo ""
	echo "== 1.1、if dir "
	echo "== 1.2、delete remote ECS nginx vhosts        "
	echo "== 1.3、delete remote ECS program        "
	echo  ""
	ssh -t root@"$1" " 
	[[ -d /alidata/www/phplog ]]                        || mkdir /alidata/www/phplog;
	[[ -d /alidata/www/ctocode_website ]]               || mkdir /alidata/www/ctocode_website;
	[[ -d /alidata/www/ctocode_website_log ]]           || mkdir /alidata/www/ctocode_website_log;
	[[ -d /alidata/www/ctocode_website_log_cms ]]       || mkdir /alidata/www/ctocode_website_log_cms;
	[[ -d /alidata/www/ctocode_website_log_shop ]]      || mkdir /alidata/www/ctocode_website_log_shop;
	[[ -d /alidata/www/ctocode_website_nginx_vhosts ]]  || mkdir /alidata/www/ctocode_website_nginx_vhosts;
	rm -r /alidata/www/ctocode_website_nginx_vhosts/*;
	rm -r /alidata/www/ctocode_website/*;
	"
	echo ""
	
	echo "== 2.1、copy local nginx vhosts to remote ECS "
	echo ""
	scp -r /alidata/www/ctocode_website_nginx_vhosts/* root@"$1":/alidata/www/ctocode_website_nginx_vhosts/
	echo ""
	echo "== 2.2、copy local program to remote ECS "
	scp -rq /alidata/www/ctocode_website/* root@"$1":/alidata/www/ctocode_website/
	echo ""

	echo "== 3.1、restart remote ECS nginx "
	echo "== 3.2、setting dir/file right "

	ssh -t root@"$1" "
	chmod -R 777 /alidata/www/ctocode_website/data;
	chmod -R 777 /alidata/www/ctocode_website/ctocode-php-frame/function;

	chmod -R 777 /alidata/www/ctocode_website/domain_cms/data;
	chmod -R 777 /alidata/www/ctocode_website/domain_shop/data;
	/etc/init.d/nginx restart;
	"

	echo ""
    echo "|----------------------------------------------------------"
    echo "|========== sync  ---- $1  --- success  =========="
    echo "|----------------------------------------------------------"
    echo ""
}

echo "|----------------------------------------"
echo "|"
echo "|========== ctocode-linux-sync =========="
echo "|"
echo "|----------------------------------------"

# 本机内网ip
localIp="*.*.*.*"

# 远程内网ip数组密码
remoteIpPwd="****"

# 远程内网ip数组
remoteIpArr[0]=*.*.*.*
remoteIpArr[1]=*.*.*.*
 
#for 循环遍历 -- 同步
for remoteIp in ${remoteIpArr[@]};
do
	# expect 免密登录
	/bin/expect <<-EOF

		set timeout 30
		spawn scp -r /root/.ssh/id_rsa.pub root@$remoteIp:/root/${localIp}_id_rsa.pub

		# 监听询问,这句意思是交互获取是否返回password：
		# send就是将密码zjk123发送过去
		expect {
			"*yes/no" { send "yes\r";exp_continue }
			"password:" { send "$remoteIpPwd\r" }
		}
		# 将本机公钥追加到远程主机的authorized文件中
		spawn ssh -t root@$remoteIp echo > /root/.ssh/authorized_keys 
		spawn ssh -t root@$remoteIp cat /root/${localIp}_id_rsa.pub >> /root/.ssh/authorized_keys 

		expect {
			"*yes/no" { send "yes\r";exp_continue }
			"*password:" { send "$remoteIpPwd\r" }
		}
		 
		# interact代表执行完留在远程控制台，不加这句执行完后返回本地控制台 
		# interact
		# expect eof
	EOF

	# -- 数据同步
	ctocodeLinuxSync $remoteIp $localIp
done

echo "|----------------------------------------"
echo "|"
echo "|========== ctocode-linux-sync =========="
echo "|"
echo "|----------------------------------------"
