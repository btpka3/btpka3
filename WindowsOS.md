## 域控服务器
### 禁止使用注册表编辑器
1.  运行 gpedit.msc  
2.  “本地计算机”组策略/用户配置/系统：阻止访问注册表编辑工具：设置为“已启用”  

### 禁止使用域成员机使用USB存储
[这里]()

注意：组策略有三个：  
1.  本地组策略：运行 `gpedit.msc`  
2.  Active Directory 用户和计算机，右击域名，属性，组策略  
3.  Active Directory 用户和计算机，右击domain controllers，属性，组策略。  

添加自定义组策略模板文件
1.  在域控服务器上运行 `gpedit.msc`  
2.  “本地计算机”组策略/计算机配置/管理模板 : 右键-添加/删除模板-选中你的*.adm文件  



参考
https://github.com/btpka3/btpka3.github.com/blob/master/os/windows/DomainControllor/DisableUsbStore.EN.adm  
http://www.windowsdevcenter.com/pub/a/windows/2005/11/15/disabling-usb-storage-with-group-policy.html  
http://support.microsoft.com/default.aspx?scid=kb;en-us;555324  