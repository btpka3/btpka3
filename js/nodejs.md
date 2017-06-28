
# 参考
* [从Java到Node.js](http://www.ituring.com.cn/article/946)
* [Ghost 基于Node.js的开源博客系统](http://segmentfault.com/a/1190000000372040)
* [How To Install Node.js on an Ubuntu 14.04 server](https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-an-ubuntu-14-04-server)
* [NODE.JS为什么会成为企业中的首选技术](http://ourjs.com/detail/532f0650c911679a2800000a)
* [PayPal为什么从Java迁移到Node.js，性能提高一倍，文件代码减少44%](http://ourjs.com/detail/52a914f0127c763203000008)
* [who use nodejs?](https://github.com/joyent/node/wiki/Projects,-Applications,-and-Companies-Using-Node)
* [stackedit](https://stackedit.io/)
* [cnodejs](https://cnodejs.org/)
* [nodeschool](http://nodeschool.io/)
* [npm@taobao](https://npm.taobao.org/)


# 安装

## NVM 安装

[nvm](https://github.com/creationix/nvm) 可以方便的切换多个版本的 nodejs

```
# 为所有人
mkdir -p /usr/local/nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | NVM_DIR=/usr/local/nvm bash

# 只为自己
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash
# 然后关闭、并重新打开命令行窗口
nvm --version


# 更新 nvm 版本
(
  cd "$NVM_DIR"
  git fetch origin
  git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" origin`
) && . "$NVM_DIR/nvm.sh"


# 检查安装了哪些版本
nvm ls

# 检查有哪些版本可以使用
nvm ls-remote

# 安装最新 LTS 版本 nodejs
nvm install --lts
# 使用当前版本作为默认版本
nvm alias default node

# 删除 nvm
rm -rf ~/.nvm
rm -rf ~/.npm
rm -rf ~/.bower

```

## 二进制安装

打开 nodejs 官网的[下载页](https://nodejs.org/download/), 下载二进制安装包


```
sudo mkdir /usr/local/nodejs
sudo tar zxvf node-v0.12.1-linux-x64.tar.gz -C /usr/local/nodejs

sudo vi /etc/profile.d/xxx.sh    # 追加以下配置
export NODEJS_HOME=/usr/local/nodejs/node-v0.12.1-linux-x64
export PATH=$NODEJS_HOME/bin:$PATH

chown -R `whoami`:`whoami` /usr/local/nodejs/node-v0.12.1-linux-x64
```





## Ubuntu

参考[这里](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager)

```
curl -sL https://deb.nodesource.com/setup | sudo bash -
#sudo add-apt-repository ppa:chris-lea/node.js
#sudo apt-get update
apt-cache policy nodejs
sudo apt-get install nodejs
sudo apt-get install build-essential
```


# Http Hello world

新建 hi.js，内容如下

```
var http = require('http');
http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end('Hello World\n');
}).listen(1337, '127.0.0.1');
console.log('Server running at http://127.0.0.1:1337/');
```

然后运行：

```
node hi.js
```

最后浏览器访问 http://127.0.0.1:1337/



## Centos

使用Linux二进制包。

<del>使用 [nvm](https://github.com/joyent/node/wiki/installing-node.js-via-package-manager#enterprise-linux-and-fedora)</del>

```
su -
curl -sL https://deb.nodesource.com/setup | sudo bash -
su -
nvm install v0.10.34
```


# npm

```
npm ls      # 显示当前的依赖树

npm install -g available-versions
releases angular    # 查看 angular 发布的所有版本
```

## 私有 registry

```bash

# 安装 sonartype nexus 3, 并在 管理/Security/Realms 中激活 npm Bearer Token Realm
# 以下命令会 在 `~/.npmrc` 中 配置 "registry = http://localhost:8081/repository/npm-all/"
npm config set registry http://localhost:8081/repository/npm-all/

# 检查
npm --loglevel info install grunt

# 登录
# 以下命令会 在 `~/.npmrc` 中 配置 
# "//localhost:8081/repository/my-npm/:_authToken=56c295ca-560a-3de0-b974-d92fb5b37976"
npm login --registry=http://localhost:8081/repository/my-npm/

# 发布
npm publish --registry http://localhost:8081/repository/npm-internal/

# 或者 先修改 packakage.json 追加以下配置后，再 `npm publish`
"publishConfig" : {
  "registry" : "http://localhost:8081/repository/npm-internal/"
},
```

## 使用国内淘宝的镜像

* 通过 config 命令

    ```
    npm config set registry https://registry.npm.taobao.org
    npm info underscore
    npm config list
    ```

* 通过命令行参数

    ```
    npm --registry https://registry.npm.taobao.org info underscore
    ```

* 通过修改 `~/.npmrc` 加入以下内容

    ```
    registry = https://registry.npm.taobao.org
    ```

# 常用工具

```
npm install -g npm-check-updates
```


# run script

* package.json

    ```json
    {
      "scripts": {
        "webpack": "node $NODE_DEBUG_OPTION ./node_modules/.bin/webpack"
      }
    }
    ```
* bash

    ```bash
    npm run webpack -- --env.prod
    ```
