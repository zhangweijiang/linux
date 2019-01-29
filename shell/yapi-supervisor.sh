#!/bin/bash
# supervisor
# author ctocode-zwj
yum install python-setuptools -y
easy_install supervisor
mkdir /etc/supervisor
echo_supervisord_conf > /etc/supervisor/supervisord.conf
cat > /etc/supervisor/supervisord.conf<<"EOF"
[include]
files = conf.d/*.conf
EOF
mkdir -p /etc/supervisor/conf.d/
cat > /etc/supervisor/conf.d/YApiGhost.conf<<"EOF" 
[program: YApiGhost]
command=node vendors/server/app.js ; # 运行程序的命令
directory=/root/my-yapi ; #命令执行的目录
autorestart=true ; # 程序意外退出是否自动重启
stderr_logfile=/var/log/YApiGhost.err.log ; # 错误日志文件
stdout_logfile=/var/log/YApiGhost.out.log ; # 输出日志文件
environment=ASPNETCORE_ENVIRONMENT=Production ; # 进程环境变量
user=root ; # 进程执行的用户身份
stopsignal=INT
[supervisord]
EOF
supervisord -c /etc/supervisor/supervisord.conf
cat > /usr/lib/systemd/system/supervisord.service<<"EOF" 
[Unit]
Description=Supervisor daemon

[Service]
Type=forking
ExecStart=/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
ExecStop=/usr/bin/supervisorctl shutdown
ExecReload=/usr/bin/supervisorctl reload
KillMode=process
Restart=on-failure
RestartSec=42s

[Install]
WantedBy=multi-user.target
EOF
# 开机启动
systemctl enable supervisord