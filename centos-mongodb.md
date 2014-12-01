
# 安装
see [here](http://docs.mongodb.org/manual/tutorial/install-mongodb-on-red-hat-centos-or-fedora-linux/)

## ubuntu
see [here](http://docs.mongodb.org/manual/tutorial/install-mongodb-on-ubuntu/)

```sh
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
sudo apt-get update
sudo apt-get install -y mongodb-org   # 安装最新版

sudo apt-get install -y \
    mongodb-org=2.6.1 \
    mongodb-org-server=2.6.1 \
    mongodb-org-shell=2.6.1 \
    mongodb-org-mongos=2.6.1 \
    mongodb-org-tools=2.6.1          # 安装特定版本


# 之后更新时总会自动更新mongodb的版本，可以使用以下命令固定版本号
echo "mongodb-org hold"        | sudo dpkg --set-selections
echo "mongodb-org-server hold" | sudo dpkg --set-selections
echo "mongodb-org-shell hold"  | sudo dpkg --set-selections
echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
echo "mongodb-org-tools hold"  | sudo dpkg --set-selections

```

# 启停

```sh
sudo service mongod start
sudo service mongod stop
```

## 连接到数据库

```
mongo
```