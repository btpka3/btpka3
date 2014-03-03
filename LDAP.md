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

# LDAP AdsPath
* 路径语法：
如果路径上的DistinguishedName含有保留字符需要使用反斜杠进行转义、或者使用 '\xx'的形式使用十六进制值。

```txt
LDAP://HostName[:PortNumber][/DistinguishedName]
```

* 路径示例
```txt
LDAP://server01/CN=Jeff Smith,CN=users,DC=fabrikam,DC=com
```
 
# LDIF
[LDIF](http://en.wikipedia.org/wiki/LDAP_Data_Interchange_Format)（LDAP Data Interchange Format）是一种普通文本形式的数据交换格式。用以展示LDAP信息或表示更新请求。

## 内容记录格式
每条记录由一组属性构成，记录之间通过空行分隔。记录的单个属性占一个逻辑行（可通过Line-folding机制由多个物理行组成），包含 "name:value" 键值对。如果值无法使用可移植性的ASCII子集表示，则需要使用 `::`作为前缀，后跟base64编码表示。参考：RFC2425。


