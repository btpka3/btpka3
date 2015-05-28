## SwitchySharp + GoAgent

注意：关于安全性，请参考 《[GoAgent的安全风险](http://www.williamlong.info/archives/3882.html)》，是否使用了 GoAgent 的根证书，请使用不同浏览器访问 [https://goagent-cert-test.bamsoftware.com/](https://goagent-cert-test.bamsoftware.com/) 进行检测。

一般情况下，请使用 Firefox 访问大部分网站，只用 Chrome 浏览器访问被屏蔽的网站。

### GoAgent

```
sudo yum install pyOpenSSL  
sudo apt-get install python-openssl
```

1. 下载 [GoAgent](https://github.com/goagent/goagent)，并解压
1. 运行 `sudo ${GO_AGENT_HOME}/local/proxy.sh start`，GoAgent 自带 一部分GAE的账户，可以先使用着
1. 到 [GAE](https://appengine.google.com) 注册一个app，并记住ID
1. 运行 `${GO_AGENT_HOME}/server/uploader.py`, 并根据提示输入 app ID，输入Email（谷歌账户）、密码，把 服务端代码 上传到 GAE。
1. 修改 `${GO_AGENT_HOME}/local/proxy.ini`， 将自己注册的 app id 添加到 `[gae]` 下的 appid 中。
1. 重启 proxy.sh : `sudo ./proxy.sh restart`
    
1. linux下运行的，可以查看日志 `/var/log/goagent.log` 确认为何连接不上。

    1. 如果是 IP 地址连接超时，请参考 [Goagent 最新可用IP](http://www.ruooo.com/VPS/704.html)
    1. 如果是 appid 不行，可以参考 使用以下值：

        ```
        [gae]
        appid=hardseedexample|hardseedexample2|hardseedexample3|hardseedexample4|hardseedexample5|hardseedexample6|hardseedexample7|hardseedexample8|hardseedexample9|hardseedexample10|hardseedexample11|hardseedexample12|hardseedexample13|hardseedexample14|hardseedexample15|hardseedexample16|hardseedexample17|hardseedexample18|hardseedexample19|hardseedexample20|hardseedexample21|hardseedexample22|hardseedexample23|hardseedexample24|hardseedexample25|nucaodiss|nucaodiss1|nucaodiss2|nucaodiss3|nucaodiss4|nucaodiss5|nucaodiss6|nucaodiss7|nucaodiss8|nucaodiss9|nucaodiss10|lovesphinx1|lovesphinx2|lovesphinx3|lovesphinx4|lovesphinx5|lovesphinx6|lovesphinx7|lovesphinx8|lovesphinx9|lovesphinx10|goagent-dup001|goagent-dup002|goagent-dup003|gonggongid01|gongongid02|gonggongid03gonggongid04|gonggongid05|gonggongid06|gonggongid07|gonggongid08|gonggongid09|gonggongid10
        ```

### SwitchyOmega

1. 下载 SwitchyOmega，并安装到 chrome 浏览器中。
1.  打开 SwitchyOmega， Import  -> Restore from file -> `${GO_AGENT_HOME}/local/SwitchyOptions.bak`
1.  在 chrome 的 settings -> HTTP/SSL -> Manage certificates -> Authorities -> Import -> `${GO_AGENT_HOME}/local/CA.crt`
1.  打开 SwitchyOmega，切换至 "Auto Switch" 模式



## FreeGate
在程序开发过程中，在搜索E文资料的时候，发现有好多好的文章总是被GFW给屏蔽掉了。
这里就以Chrome浏览器或360极速浏览器为例（基于Chrome）总结一下如何通过 Proxy Switchy! 插件和 FreeGate 进行突破。

步骤：

1. 下载并运行 [http://www.freegate8.info/ FreeGate]
    1. 在 `通道` 标签页: 先点击 `恢复默认设置`，如果以前从未更改过设置的话，可以跳过此步骤。
    1. 在 `通道` 标签页: 将模式设定为 `经典模式`（浏览器不需要设置代理），因为我们接下来通过 Switchy! Options 为浏览器设置。
1.  在Chrome浏览器中，安装 [Proxy Switchy! 插件](https://chrome.google.com/webstore/detail/proxy-switchy/caehdcpeofiiigpdhbabniblemipncjj/related)
1. 单击浏览器右上角 Proxy Switchy! 的图标，选择`Options`
    1. 在`Proxy Profiles`标签页中新建一个Profile：
    1. 名称自定义，假设为`GFW`
    1. 选择`Manual Configuration`
    1. 选择`Use the same proxy server for all protocols`
    1. 设置`HTTP Proxy`为`127.0.0.1`
    1. 设置`Port`为`8580`（与FreeGate`服务器`标签页中`当前端口`保持一致）
    1. 点击`Save`按钮进行保存
1. 在`Switch Rules`标签页中新建需要的规则：
    1. `Role Name`可以自定义，这里保持默认
    1. `URL Pattern`中输入被屏蔽的URL，比如`*.wordpress.com`
    1. `Pattern Type`根据你输入的URL的格式进行选定，但大多均为`Wildcard`
    1. `Proxy Profile`中应当选择为前面建立的Profile的名字，这里是`GFW`
    1. 点击`Save`按钮进行保存
1. 单击浏览器右上角 Proxy Switchy! 的图标，将模式切换为`Auto Switch Mode`即可。

附：被屏蔽URL总结

```
*.sourceforge.net
*.blogspot.com
*.wordpress.com
```
