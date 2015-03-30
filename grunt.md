## nodejs

```
sudo mkdir /usr/local/nodejs
sudo tar zxvf node-v0.12.1-linux-x64.tar.gz -C /usr/local/nodejs

sudo vi /etc/profile.d/xxx.sh    # 追加以下配置
export NODEJS_HOME=/usr/local/nodejs/node-v0.12.1-linux-x64
export PATH=$NODEJS_HOME/bin:$PATH

cd /usr/local/nodejs/node-v0.12.1-linux-x64
sudo chmod 777 bin
sudo chmod 777 lib/node_modules
```

## init


```
npm install -g grunt-cli
npm install -g grunt-init

npm init
npm install grunt --save-dev
npm install grunt-contrib-jshint --save-dev
npm install grunt-contrib-nodeunit --save-dev
npm install grunt-contrib-uglify --save-dev
npm install grunt-contrib-watch --save-dev
npm install grunt-contrib-requirejs --save-dev
npm install bootstrap --save
```

 


	