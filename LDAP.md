# Distinguished Names
[DN](http://msdn.microsoft.com/en-us/library/aa366101(v=vs.85).aspx)是一序列由逗号连接起来的RDN（relative distinguished name）组成。
RDN是 attribute=value 形式的属性值，通常是UTF-8字符串。

* 常见属性名
属性名 | 属性值
-------|---------------------------------------
DC     | domainComponent : 域组件
CN     | commonName : 普通名称
OU     | organizationalUnitName :（组织）单位名称
O      | organizationName : 组织名称
STREET | streetAddress : 街道地址
L      | localityName : 地区
ST     | stateOrProvinceName : 州名/省名
C      | countryName : 国家
UID    | userid : 用户ID

* 示例：
```txt
CN=Karen Berge,CN=admin,DC=corp,DC=Fabrikam,DC=COM
```

* 保留字符  
如果确实需要在DN中使用保留字符，则需要使用反斜杠进行转义。

保留字符 | 描述                       | 十六进制值
--------|---------------------------|---------
        | 字符串开头的空格、'#'       | 
        | 字符串结尾的空格            | 
,       | 逗号                       | 0x2C
+       | 加号                       | 0x2B
"       | 双引号                     | 0x22
\       | 反斜杠                     | 0x5C
<       | 小于号                     | 0x3C
>       | 大于号                     | 0x3E
;       | 分号                       | 0x3B
LF      | 换行符                     | 0x0A
CR      | 回车符                     | 0x0D
=       | 等于号                     | 0x3D
/       | 斜杠                       | 0x2F

 