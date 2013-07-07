## 域控服务器
### 强制更新组策略
配置完新的安全策略后，原则上在工作站或服务器上，每90分钟更新一次安全性设置，而在域控制器上则5分钟更新一次。除此之外，若无任何更改的情况下，这些安全设置每16小时会更新一次。若想强制更新，就需要以下命令：
```
gpupdate "/target:{computer| user}" "/force" "/wait:value" "/logoff" "/boot"
```
其中等待时间默认是600秒，0代表不等待，-1代表永远等待。

### 禁止使用注册表编辑器
1.  运行 gpedit.msc  
2.  “本地计算机”组策略/用户配置/系统：阻止访问注册表编辑工具：设置为“已启用”  

### 禁止使用域成员机使用USB存储
[这里]()

编辑组策略有三个地方可以编辑，但是作用范围不一样，下面的操作均选择第二种方式。  
1.  运行 `gpedit.msc`（本地组策略）  
2.  开始-程序-管理工具-Active Directory 用户和计算机-域名上右键-属性-组策略  
3.  开始-程序-管理工具-Active Directory 用户和计算机-域名-domain controllers上右键-属性-组策略。  

添加自定义组策略模板文件
1.  在域控服务器上运行 `gpedit.msc`  
2.  “本地计算机”组策略/计算机配置/管理模板 : 右键-添加/删除模板-选中你的*.adm文件  



参考
https://github.com/btpka3/btpka3.github.com/blob/master/os/windows/DomainControllor/DisableUsbStore.EN.adm  
http://www.windowsdevcenter.com/pub/a/windows/2005/11/15/disabling-usb-storage-with-group-policy.html  
http://support.microsoft.com/default.aspx?scid=kb;en-us;555324  
http://bbs.icpcw.com/thread-1509659-1-1.html