## 域控服务器

编辑组策略有三个地方可以编辑，但是作用范围不一样：
1.  运行 `gpedit.msc`（本地组策略，只对本地计算机起作用。FIXME：有可能在同步时被AD目录中的设置覆盖？）
2.  开始-程序-管理工具-Active Directory 用户和计算机-域名上右键-属性-组策略（对域下所有账户均起作用）
3.  开始-程序-管理工具-Active Directory 用户和计算机-域名-domain controllers上右键-属性-组策略。（只对域控制器起作用）
由于我们打算对域下所有的计算机均设置，所以选择第二种方式。

### 强制更新组策略
配置完新的安全策略后，原则上在工作站或服务器上，每90分钟更新一次安全性设置，而在域控制器上则5分钟更新一次。除此之外，若无任何更改的情况下，这些安全设置每16小时会更新一次。若想强制更新，就需要以下命令：
```
gpupdate "/target:{computer| user}" "/force" "/wait:value" "/logoff" "/boot"
```
其中等待时间默认是600秒，0代表不等待，-1代表永远等待。
FIXME：该命令只能对当前电脑有效？（因此：需要每个电脑都执行一下该命令，如果不想重启的话）
FIXME：在域控制器端是无法强制客户机强制刷新的？


### 禁止使用域成员机使用USB存储
1.  从[这里](http://support.microsoft.com/default.aspx?scid=kb;en-us;555324) 复制一份禁用USB存储的adm文件，假设文件名是：Custom-USB.adm。（可选）将文件保存在域控服务器的 C:\WINDOWS\inf 目录下。PS：[这里](https://github.com/btpka3/btpka3.github.com/blob/master/os/windows/DomainControllor/DisableUsbStore.ZH.adm)提供了一份中文的adm文件，且以下步骤使用的是此中文版的adm文件。

2.  在域控服务器上：开始-程序-管理工具-Active Directory 用户和计算机-域名（比如：xxx.com）上右键-属性-组策略-新建-自定义名称（比如：禁用USB存储）
3.  编辑新建的组策略-计算机配置-管理模板：
    1.  管理模板上右键-添加/删除模板-添加-选中第一步保存的adm文件-关闭。
    2.  管理模板上右键-察看-筛选-取消选中“只显示能完全管理的组策略”-确定。
    3.  在新出现的 “自定义策略设置”-“首先设备”下每个设备均更改为“已启用”

### 禁止使用注册表编辑器
因为组策略最终都体现在注册表中，操作步骤同上，但第三步变更为：
用户配置-系统-阻止访问注册表编辑工具-设置为“已启用”

### 修改组策略更新时间
位置：计算机配置-管理模板-系统-组策略-计算机组策略刷新间隔

参考
https://github.com/btpka3/btpka3.github.com/blob/master/os/windows/DomainControllor/DisableUsbStore.EN.adm
http://www.windowsdevcenter.com/pub/a/windows/2005/11/15/disabling-usb-storage-with-group-policy.html
http://support.microsoft.com/default.aspx?scid=kb;en-us;555324
http://bbs.icpcw.com/thread-1509659-1-1.html