#!/bin/bash
# 脚本功能 : 一键安装Mysql
# 脚本参数 :  无
# 参数示例 :  mysql自动安装
# AUTHOR :  运维部

Rely_Install()
{
	yum remove mysql -y
	yum install -y cmake bison bison-devel libaio-devel gcc gcc-c++ git  ncurses-devel perl libedit-devel
}

Mysql_Define()
{
    Mysql_Version=mysql-5.7.20
    Mysql_Path=/alidata/server/${Mysql_Version}
    Mysql_Log=/alidata/server/${Mysql_Version}/logs
    Mysql_Data=${Mysql_Path}/data
    Mysql_Config=/etc
    
}

Mysql_Download()
{
	wget   -N https://dev.mysql.com/get/archives/mysql-5.7/mysql-5.7.20.tar.gz
	wget https://sourceforge.mirrorservice.org/b/bo/boost/boost/1.59.0/boost_1_59_0.tar.gz
}

Mysql_Config() 
{
cat > ${Mysql_Config}/my.cnf<<EOF
[client]
default_character_set = utf8mb4
socket=${Mysql_Data}/mysql.sock

[mysqld]
port=3306
socket=${Mysql_Data}/mysql.sock
basedir = ${Mysql_Path}
datadir = ${Mysql_Path}/data
pid_file = ${Mysql_Path}/mysql-pid.pid
character_set_server = utf8mb4
default_storage_engine = InnoDB
explicit_defaults_for_timestamp
federated

#Innodb
innodb_flush_method = O_DIRECT
innodb_log_files_in_group = 5
innodb_lock_wait_timeout = 50
innodb_log_file_size = 1024M
innodb_flush_log_at_trx_commit = 1
innodb_file_per_table = 1
innodb_thread_concurrency = 8
innodb_buffer_pool_size = 2G
innodb_read_io_threads = 24
innodb_write_io_threads = 24
log_bin_trust_function_creators=1

innodb_locks_unsafe_for_binlog = 1
innodb_autoinc_lock_mode = 2
sql_mode=NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION
group_concat_max_len = 18446744073709551615

# MyISAM #
key_buffer_size = 1344M
myisam_recover_options = FORCE,BACKUP
lower_case_table_names=1
event_scheduler=1

# SAFETY #
max_allowed_packet = 1024M
max_connect_errors = 1000000
skip_name_resolve = 1

# Binary Logging #
server_id = 200
log_bin = mysql-bin
binlog_format = ROW
sync_binlog = 1

# CACHES AND LIMITS #
tmp_table_size = 32M
max_heap_table_size = 32M
max_connections = 1000
thread_cache_size = 50
open_files_limit = 65535
table_definition_cache = 4096
table_open_cache = 5000

# LOGGING #
log_error = ${Mysql_Log}/mysql-error.log
log_queries_not_using_indexes = 0
slow_query_log = 1
long_query_time = 1
slow_query_log_file = ${Mysql_Log}/mysql-slow.log

# REPLICATION #
relay_log = relay-bin
slave_net_timeout = 60
symbolic-links = 0

[mysql]
no-auto-rehash
default_character_set = utf8mb4

[xtrabackup]
default-character-set = utf8mb4
EOF
}

MySQL_Install()
{
     echo "[+] Installing ${Mysql_Version}..."
     mkdir -p ${Mysql_Path}
     mkdir -p $Mysql_Data
     mkdir -p ${Mysql_Log}
     
     groupadd mysql > /dev/null 2>1
     useradd -s /sbin/nologin -g mysql mysql > /dev/null 2>1
     chown -R mysql:mysql ${Mysql_Data}
     chown -R mysql:mysql ${Mysql_Log}
     
     tar xvf ${Mysql_Version}.tar.gz
     cd ${Mysql_Version}
     mv ../boost_1_59_0.tar.gz ./ 
     mkdir -p configure
     cd configure
cmake .. -DBUILD_CONFIG=mysql_release \
-DINSTALL_LAYOUT=STANDALONE \
-DCMAKE_BUILD_TYPE=RelWithDebInfo \
-DENABLE_DTRACE=OFF \
-DWITH_EMBEDDED_SERVER=OFF \
-DWITH_INNODB_MEMCACHED=ON \
-DWITH_SSL=bundled \
-DWITH_ZLIB=system \
-DWITH_PAM=ON \
-DCMAKE_INSTALL_PREFIX=${Mysql_Path} \
-DINSTALL_PLUGINDIR="${Mysql_Path}/lib/plugin" \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DWITH_EDITLINE=bundled \
-DFEATURE_SET=community \
-DCOMPILATION_COMMENT="MySQL Server (GPL)" \
-DWITH_DEBUG=OFF \
-DWITH_BOOST=..
     make && make install
     Mysql_Config
     ${Mysql_Path}/bin/mysqld  --initialize --user=mysql
     /bin/cp -f support-files/mysql.server /etc/init.d/mysqld
     chmod 744 /etc/init.d/mysqld
     ln -sf ${Mysql_Path}/bin/mysql /usr/bin/
     ln -sf ${Mysql_Path}/bin/mysqldump /usr/bin/
     /etc/init.d/mysqld start
     cat ${Mysql_Log}/mysql-error.log |grep 'A temporary password'|awk '{print $10,$11}' >> ../../account.log

	
}

Rely_Install
Mysql_Define
Mysql_Download
MySQL_Install
