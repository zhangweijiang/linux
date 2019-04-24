#!/bin/sh
# git
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
   cd $rootPath/$path/website && git clone $address ./;
elif [ $gitStatus == 2 ];then
   cd $rootPath/$path/website && git pull $address;
else
   echo 'error';
fi;

