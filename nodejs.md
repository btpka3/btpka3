http://www.ituring.com.cn/article/946
http://segmentfault.com/a/1190000000372040
https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-an-ubuntu-14-04-server


《[NODE.JS为什么会成为企业中的首选技术](http://ourjs.com/detail/532f0650c911679a2800000a)》
《[PayPal为什么从Java迁移到Node.js，性能提高一倍，文件代码减少44%](http://ourjs.com/detail/52a914f0127c763203000008)》


[who use nodejs?](https://github.com/joyent/node/wiki/Projects,-Applications,-and-Companies-Using-Node)



http://momentjs.com/
https://ghost.org/
https://cnodejs.org/

https://pages.github.com/
https://stackedit.io/
http://nodeschool.io/
https://npm.taobao.org/

# 安装

## Ubuntu
```
sudo add-apt-repository ppa:chris-lea/node.js
sudo apt-get update
apt-cache policy nodejs
sudo apt-get install nodejs
sudo apt-get install npm
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



