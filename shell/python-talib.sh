wget http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz
tar -xvf ta-lib-0.4.0-src.tar.gz
cd ta-lib
# 配置
./configure --prefix=/usr
# 编译安装
make && make install
# 把/usr/lib/libta_lib.*文件复制到python安装路径下的lib文件夹里面
cp /usr/lib/libta_lib.* /root/miniconda3/lib
pip install TA-Lib -i https://pypi.douban.com/simple/
