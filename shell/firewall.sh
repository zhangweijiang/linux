#!/bin/bash
# 十云，防火墙设置
# ctocode.com , 10yun.com
# ctocode-zwj
# 2018-08-11 11:00

#开启防火墙
systemctl start firewalld.service

#workerman-文字直播连接端口
firewall-cmd --add-port=5555/tcp --permanent
#workerman-文字直播内部通信接口
firewall-cmd --add-port=5556/tcp --permanent
#workerman-视频直播连接端口
firewall-cmd --add-port=5557/tcp --permanent
#workerman-视频直播内部通信接口
firewall-cmd --add-port=5558/tcp --permanent
#http端口-slb
firewall-cmd --add-port=4080/tcp --permanent
#htpps端口-slb
firewall-cmd --add-port=40443/tcp --permanent
#redis端口
firewall-cmd --add-port=6379/tcp --permanent
#mysql端口
firewall-cmd --add-port=3306/tcp --permanent

#重新载入配置
firewall-cmd --reload
#设置开机自启动
systemctl enable firewalld.service


#firewall基本命令
#firewall-cmd --state                           ##查看防火墙状态，是否是running
#firewall-cmd --reload                          ##重新载入配置，比如添加规则之后，需要执行此命令
#firewall-cmd --get-zones                       ##列出支持的zone
#firewall-cmd --get-services                    ##列出支持的服务，在列表中的服务是放行的
#firewall-cmd --query-service ftp               ##查看ftp服务是否支持，返回yes或者no
#firewall-cmd --add-service=ftp                 ##临时开放ftp服务
#firewall-cmd --add-service=ftp --permanent     ##永久开放ftp服务
#firewall-cmd --remove-service=ftp --permanent  ##永久移除ftp服务
#firewall-cmd --add-port=80/tcp --permanent     ##永久添加80端口 
#iptables -L -n                                 ##查看规则，这个命令是和iptables的相同的
#man firewall-cmd                               ##查看帮助

#注意开启防火墙之后需要调大net.netfilter.nf_conntrack_max的值（默认65536）,不然请求量多时会导致新连接被drop掉
#CentOS服务器，负载正常，但请求大量超时，服务器／应用访问日志看不到相关请求记录。
#在dmesg或/var/log/messages看到大量以下记录：
#kernel: nf_conntrack: table full, dropping packet.
#解决办法
#vim /etc/sysctl.conf
#防火墙跟踪表的大小。注意：如果防火墙没开则会提示error: "net.netfilter.nf_conntrack_max" is an unknown key，忽略即可
#net.netfilter.nf_conntrack_max = 2621440
#sysctl -p
