
## 下载

```bash
# 下载指定的文件
wget -O outputFileName.zip http://www.baidu.com/xxx

# 下载指定的文件(不显示进度条)
wget -q -O outputFileName.zip http://www.baidu.com/xxx

# 下载指定的Zip文件,不显示进度条,并解压
wget -qO- -O /tmp/tmp.zip https://github.com/vozlt/nginx-module-vts/archive/v0.1.15.zip \
    && unzip /tmp/tmp.zip \
    && rm /tmp/tmp.zip

# 下载指定的 *.tar.gz 文件,不显示进度条,并解压
TAG=v0.1.15
wget -q -O- https://github.com/vozlt/nginx-module-vts/archive/${TAG}.tar.gz | tar -zx

```
