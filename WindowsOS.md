## 域控服务器
### 禁止使用域成员机使用USB存储
参考[这里](http://support.microsoft.com/default.aspx?scid=kb;en-us;555324)

注意：组策略有三个：
1.  本地组策略：运行 `gpedit.msc`
2.  Active Directory 用户和计算机，右击域名，属性，组策略
3.  Active Directory 用户和计算机，右击domain controllers，属性，组策略。

https://github.com/btpka3/btpka3.github.com/blob/master/os/windows/DomainControllor/DisableUsbStore.EN.adm
