#!/bin/sh
# author-Jang
# 20190423

path=$1
if [ ! -d /alidata/www/$path ];then
   mkdir -p /alidata/www/$path;
fi;
cd /alidata/www/$path && mkdir -p website nginx_log nginx_vhosts sh;
cd sh;

# 生成git.sh文件
cat << EOF >git.sh 
#!/bin/sh
# git
# author-Jang
# 20190423

gitStatus='\${1}'
path='\$2'
address='\$3'
rootPath=/alidata/www
if [ ! -d "\$rootPath"/"\$path" ];then
   	mkdir -p "\$rootPath"/"\$path";
fi;
if [ "\$gitStatus" == 1 ];then
   cd "\$rootPath"/website && git clone "\$address" ./;
elif [ "\$gitStatus" == 2 ];then
   cd "\$rootPath"/"\$path"/website && git pull "\$address";
else
   echo 'error';
fi;
EOF
chmod a+x git.sh;


# 生成svn.sh文件
cat << EOF >svn.sh 
#!/bin/sh
# svn
# author-Jang
# 20190423

gitStatus="\$1"
path="\$2"
address="\$3"
rootPath=/alidata/www
if [ ! -d "\$rootPath"/"\$path" ];then
   	mkdir -p "\$rootPath"/"\$path";
fi;
if [ "\$gitStatus" == 1 ];then
   cd "\$rootPath"/"\$path"/website && svn checkout "\$address" ./;
elif [ "\$gitStatus" == 2 ];then
   cd "\$rootPath"/"\$path"/website && svn update;
else
   echo 'error';
fi;
EOF
chmod a+x svn.sh;

# 生成nginx配置文件
cd ../nginx_vhosts
cat << EOF >nginx.conf.default
server {
    listen       80 default;
    server_name  {{server_name}};
    charset      utf-8;
 	index 		 index.html index.htm index.php;
	root         {{root_path}};

	location / {
        index index.html index.htm index.php;        
	    
        # ============ tp5 ==============
        if ( -f $request_filename) {
            break;
        }
        if ( !-e $request_filename) {
            rewrite ^(.*)$ /index.php/$1 last;
            break;
        }
    } 

    location ~ \.php($|/) { 
        fastcgi_pass   127.0.0.1:9000;  
        fastcgi_index  index.php;  
        fastcgi_split_path_info ^(.+\.php)(.*)$;  
        fastcgi_param   PATH_INFO $fastcgi_path_info;  
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;  
        include        fastcgi_params; 
        # 重要，负载均衡中，证书前置，后端ecs，php 无法获取 $_SERVER['HTTPS'] 参数，需要自己强制配置
        #fastcgi_param  HTTPS on; 
    }  

	location ~ .*\.(php|php5)?$
	{
		#fastcgi_pass  unix:/tmp/php-cgi.sock;
		fastcgi_pass  127.0.0.1:9000;
		fastcgi_index index.php;
		include fastcgi.conf;
	}
	location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$
	{
		expires 30d;
	}
	location ~ .*\.(js|css)?$
	{
		expires 1h;
	}
    access_log  {{access_log}};
    error_log   {{error_log}};
	
}
EOF
