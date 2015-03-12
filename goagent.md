## SwitchySharp + GoAgent

注意：关于安全性，请参考 《[GoAgent的安全风险](http://www.williamlong.info/archives/3882.html)》，是否使用了 GoAgent 的根证书，请使用不同浏览器访问 [https://goagent-cert-test.bamsoftware.com/](https://goagent-cert-test.bamsoftware.com/) 进行检测。

一般情况下，请使用 Firefox 访问大部分网站，只用 Chrome 浏览器访问被屏蔽的网站。

### GoAgent

1. 下载 [GoAgent](https://github.com/goagent/goagent)，并解压
1. 运行 `sudo ${GO_AGENT_HOME}/local/proxy.sh start`，GoAgent 自带 一部分GAE的账户，可以先使用着
1. 到 [GAE](https://appengine.google.com) 注册一个app，并记住ID
1. 运行 `${GO_AGENT_HOME}/server/uploader.py`, 并根据提示输入 app ID，输入Email（谷歌账户）、密码，把 服务端代码 上传到 GAE。
1. 修改 `${GO_AGENT_HOME}/local/proxy.ini`， 将自己注册的 app id 添加到 `[gae]` 下的 appid 中。
1. 重启 proxy.sh （提示：ps,grep,kill）


### SwitchyOmega.crx

1. 下载 SwitchyOmega，并安装到 chrome 浏览器中。
1.  打开 SwitchyOmega， Import  -> Restore from file -> `${GO_AGENT_HOME}/local/SwitchyOptions.bak`
1.  在 chrome 的 settings -> HTTP/SSL -> Manage certificates -> Authorities -> Import -> `${GO_AGENT_HOME}/local/CA.crt`
1.  打开 SwitchyOmega，切换至 "Auto Switch" 模式



## FreeGate
在程序开发过程中，在搜索E文资料的时候，发现有好多好的文章总是被GFW给屏蔽掉了。
这里就以Chrome浏览器或360极速浏览器为例（基于Chrome）总结一下如何通过 Proxy Switchy! 插件和 FreeGate 进行突破。

步骤：

# 下载并运行 [http://www.freegate8.info/ FreeGate]
## 在<code>通道</code>标签页: 先点击<code>恢复默认设置</code>，如果以前从未更改过设置的话，可以跳过此步骤。
## 在<code>通道</code>标签页: 将模式设定为<code>经典模式（浏览器不需要设置代理），因为我们接下来通过 Switchy! Options 为浏览器设置</code>。
# 在Chrome浏览器中，安装 [https://chrome.google.com/webstore/detail/proxy-switchy/caehdcpeofiiigpdhbabniblemipncjj/related Proxy Switchy! 插件]
## 单击浏览器右上角 Proxy Switchy! 的图标，选择<code>Options</code>
## 在<code>Proxy Profiles</code>标签页中新建一个Profile：
### 名称自定义，假设为<code>GFW</code>
### 选择<code>Manual Configuration</code>
### 选择<code>Use the same proxy server for all protocols</code>
### 设置<code>HTTP Proxy</code>为<code>127.0.0.1</code>
### 设置<code>Port</code>为<code>8580</code>（与FreeGate<code>服务器</code>标签页中<code>当前端口</code>保持一致）
### 点击<code>Save</code>按钮进行保存
## 在<code>Switch Rules</code>标签页中新建需要的规则：
### <code>Role Name</code>可以自定义，这里保持默认
### <code>URL Pattern</code>中输入被屏蔽的URL，比如<code>*.wordpress.com</code>
### <code>Pattern Type</code>根据你输入的URL的格式进行选定，但大多均为<code>Wildcard</code>
### <code>Proxy Profile</code>中应当选择为前面建立的Profile的名字，这里是<code>GFW</code>
### 点击<code>Save</code>按钮进行保存
# 单击浏览器右上角 Proxy Switchy! 的图标，将模式切换为<code>Auto Switch Mode</code>即可。

附：被屏蔽URL总结
<source>
 *.sourceforge.net
 *.blogspot.com
 *.wordpress.com
</source>

# http://jingyan.baidu.com/article/6766299717faec54d41b8477.html