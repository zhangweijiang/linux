#!/bin/sh
# svn
# author-Jang
# 20190423

gitStatus=$1
path=$2
address=$3
rootPath=/alidata/www
if [ ! -d $rootPath/$path ];then
   	mkdir -p $rootPath/$path;
fi;
if [ $gitStatus == 1 ];then
   cd $rootPath/$path/website && svn checkout $address;
elif [ $gitStatus == 2 ];then
   cd $rootPath/$path/website && svn update;
else
   echo 'error';
fi;

