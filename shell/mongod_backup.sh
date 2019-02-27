#!/bin/sh
# author: Lorin Song
# Date: 2017-10-15
# Desc: The daily backup mongod data for week cycle
#
#########define variable##########################################
BACKUP_BASE=/data/backup/mongodbback
DELETE_DIR=${BACKUP_BASE}'/full_ba'
DAY=`date +%u`  #  %u   day of week (1..7); 1 is Monday
FILE_NAME='mongo_118_234_'${DAY}'.tar.gz'
#########define end##########################################
if [ -d $DELETE_DIR ]; then
	rm -rf $DELETE_DIR
fi
mkdir -p $DELETE_DIR
cd $BACKUP_BASE

echo `date +%Y-%m-%d` `date +%H:%M:%S` "begin mongodump....." >>$BACKUP_BASE/mongodump.log
/app/mongodb342/bin/mongodump -d liuniu -u wechat -p '###' --gzip --authenticationDatabase liuniu  -o $DELETE_DIR
echo `date +%Y-%m-%d` `date +%H:%M:%S` "end mongodump....." >>$BACKUP_BASE/mongodump.log
rm -rf ${FILE_NAME}
tar -czvf ${FILE_NAME} ${DELETE_DIR}
rm -rf ${DELETE_DIR}
echo `date +%Y-%m-%d` `date +%H:%M:%S`  "make the tar file." >>$BACKUP_BASE/mongodump.log
echo " mongodump end"
