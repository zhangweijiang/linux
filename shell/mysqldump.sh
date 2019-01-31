#!/bin/bash
# mysql备份
# ctocode-zwj <982215226@qq.com>
# 2019-01-31 17:00 
 
#DUMP=/usr/bin/mysqldump    #mysqldump备份程序执行路径  
 
OUT_DIR=/backup/mysql   #备份文件存放路径  
 
LINUX_USER=root            #系统用户名 
 
DB_NAME=shxx_hrhg           #要备份的数据库名字 
 
DB_USER=shxx_hrhg              #数据库用户名 
  
DB_PASS=HwddFfDMaJEYctAy             #密码 
 
DAYS=7         #DAYS=7代表删除7天前的备份，即只保留最近7天的备份 

#ftp-config

ftp_host="*.*.*.*"  #服务器ip

ftp_user="hrhg_test"       #ftp账号

ftp_pass="*******"      #ftp密码

  
cd $OUT_DIR                #进入备份存放目录 
 
DATE=`date +%Y_%m_%d`      #获取当前系统时间

HourMin=`date +%H%M`       #获取当前系统时间时分
 
OUT_SQL="$DB_NAME-$DATE.sql"        #备份数据库的文件名 
 
TAR_SQL="$DB_NAME-$DATE.sql.tar.gz" #最终保存的数据库备份文件名 
 
#$DUMP -u$DB_USER -p$DB_PASS $DB_NAME --default-character-set=utf8 --opt -Q -R --skip-lock-tables> $OUT_SQL #备份 

#上面那条是别人备份用的语句，我平常用的是下面的，/usr/local/mysql/bin/mysqldump为mysql安装目录，必须写对路径
mysqldump -u$DB_USER -p$DB_PASS -R --single-transaction --add-drop-database --databases $DB_NAME  >  $OUT_SQL
 
tar -zcvf $TAR_SQL  $OUT_SQL  #压缩为.tar.gz格式 
 
rm $OUT_SQL   #删除最原始为压缩的备份文件 
 
#chown  $LINUX_USER:$LINUX_USER $OUT_DIR/$TAR_SQL  #更改备份数据库文件的所有者 
chown  $LINUX_USER:$LINUX_USER $TAR_SQL  #更改备份数据库文件的所有者 
 
find $OUT_DIR -name "mydb_dump*" -type f -mtime +$DAYS -exec rm {} \;  #删除7天前的备份文件(注意：{} \;中间有空格) 
 
deldate=` date -d -7day +%Y_%m_%d `   #删除ftp服务器空间7天前的备份  


#fpt 登录 ，如果要单独测试下面的ftp脚本是否正常，需要去掉<<! 字符。同时如果端口号不是21要指定新端口2121：ftp -v -n 192.168.1.1 2121
ftp -v -n $ftp_host<<! 

user $ftp_user $ftp_pass
 
binary  #设置二进制传输 
 
cd mysql_data  #进入ftp目录 
  
prompt 
 
mput $DB_NAME-$DATE.sql.tar.gz
 
mdelete $DB_NAME-$deldate.sql.tar.gz   #删除ftp空间7天前的备份 
 
close 
 
bye !
