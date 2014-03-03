# Distinguished Names
[DN](http://msdn.microsoft.com/en-us/library/aa366101(v=vs.85).aspx)是一序列由逗号连接起来的RDN（relative distinguished name）组成。
RDN是 attribute=value 形式的属性值，通常是UTF-8字符串。

* 常见属性名

attribute | Alias                   | shema        | objectClass         | notes
----------|-------------------------|--------------|---------------------|-----------------
c         | countryName             | core.schema | country              | ISO 3166:两位国家编码 
cn        | commonName              | core.schema | person etc.          |
dc        | domainComponent         | core.schema | dcObject             | 域名的任意部分
mail      | rfc822Mailbox           | core.schema | inetOrgPerson        |
o         | organizationName        | core.schema | organization         | 组织名称
ou        | organizationalUnitName  | core.schema | organizationUnit     | 单位名称
street    | streetAddress           | core.schema | organizationalPerson |街道地址
l         | localityName            | core.schema | locality etc.        | 地区
st        | stateOrProvinceName     | core.schema | organizationalPerson | 州名/省名
uid       | userid                  | core.schema | account etc.         | 用户名等

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


# LDAP vs. Database
LDAP相对于数据库有何优缺点？应当[何时](http://www.zytrax.com/books/ldap/ch2/index.html#database)考虑使用LDAP？以下仅作参考：
* 更新操作会影响性能。因此，需要更多的快速读取（建立索引），更少的更新的时候（读:写 > 1000:1）可以考虑使用LDAP。
* LDAP 复制会为每个更新产生多个事务。所以使用LDAP时，应当保证读:写 >= 1000:1
* 如果总数据量很大（比如：>10,0000条），即使很小数量的索引的更新都可能会很严重。因此，使用LDAP时，应保证读:写 >= 10000:1
* 如果总数据量相对较小（比如：<1000条），且没有使用LDAP复制，则可以适当的使用有事务的LDAP。（每5~10个读操作之后又一个写操作）

# Data Informaction Tree
```txt
Root # aka "base","suffix"
 |--Entry#1    #ObjectClass=name(attr=value,attr=value)
 |--Entry#2
     |--Entry#3
     |--Entry#3
```
* 每个Entry只有一个父Entry，可以有零个活多个子Entry
* 每个Entry有一个或多个objectClass，每个objectClass都有名字
* 每个objectClass都有一组attribute组成（key=value）
* 不同的objectClass可能有不同的[可选、必选attribute](http://www.zytrax.com/books/ldap/ape/index.html#objectclasses)
* objectClass可以继承

# referral 
LDAP在设计时就支持代理部分内容的维护。LDAP没有固定如何如何处理referral。LDAP服务器通常会不会像DNS服务器那样自动查询referral节点上的内容，而是给客户端一个referral，让客户端去直连。但LDAP服务器的实现也可能提供chaining机制自动完成代理。

# schema
[schema](http://directory.apache.org/apacheds/basic-ug/2.3-introducing-schema.html)是一个打包单元。定义一下内容：
* attributeType
* objectClass 
* syntax
* matchingRule 
