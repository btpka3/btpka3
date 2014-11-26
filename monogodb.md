http://www.csdn.net/article/2012-11-15/2811920-mongodb-quan-gong-lue

# 安装
参考[这里](http://docs.mongodb.org/manual/tutorial/install-mongodb-on-ubuntu/)

```
# 安装公钥
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10

# 
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list

sudo apt-get update

sudo apt-get install -y mongodb-org

sudo apt-get install -y mongodb-org=2.6.1 mongodb-org-server=2.6.1 mongodb-org-shell=2.6.1 mongodb-org-mongos=2.6.1 mongodb-org-tools=2.6.1


```