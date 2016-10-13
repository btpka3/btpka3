```
C# 调用Java服务？
1. Apache CXF 对Contract First 这种Web Service开发模式支持不够好，如果使用Code First，有诸多不便
2. Spring WS 推荐使用Contract Fist（实际上应该是Data Contract First——即先编辑XSD文件，在根据XSD文件和类型的命名约定生成WSDL），但是经测试，如果没有牵涉到认证、加密的话，C#和Java是可以相互调用的，否则，还是有问题，尚未能找到相互调用的方法（各个WS实现对WI-Profile支持仍然不够一致哇~）
3. 退而求其次，使用自定义数据格式和认证加密方式能否实现？ 
  a) 使用JSON作为通信的数据格式，技术调查已经OK，参考下面华丽的分割线下面的部分。
  b) 认证&&安全方案：使用单向HTTPS+HTTP Basic认证，技术已调查清楚。可以实现认证和一部分安全性。而且目前在项目中使用Spring-Security框架也支持HTTP Basic认证。

TODO：是否使用HTTP Degist 认证？使用HTTP Degist认证的话，就要使Spring Security能够获得到明文密码，这就要求数据库密码字段要么明文存储、要么可逆加密存储，而不是现在的HASH摘要存储（单向加密）。该认证方式是主要针对于使用非HTTPS环境，而且实现复杂，尚未在C#中进行测试（参考1, 参考2）
参考1
http://msdn.microsoft.com/en-us/library/sxhw3bcy.aspx
参考2
http://stackoverflow.com/questions/10658202/httprequestmessage-and-digest-authentication

TODO：是否使用双向HTTPS，但是增加了复杂度。可能还需要内部小的CA系统。
TODO：使用CAS？
```

```
<<Using Data Contracts>>
 http://msdn.microsoft.com/en-us/library/ms733127.aspx
1. 确定Data Contracts，及编写XSD文件，可以在Eclipse中图形化编辑。

2. 根据XSD生成C#端、Java端的Model
2.1 C#端
      Windows开始菜单 -> Microsoft Visual Studio 2010 -> Visual Studio Tools -> Visual Studio x64 兼容工具命令提示(2010)， 之后以下命令：
      CMD \> svcutil xxx.xsd /dataContractOnly
      (TODO : 是否可以使用 CMD\> xsd /classes xxx.xsd )
      即可生成所需Model类
2.2 Java端
      运行命令 ： xjc xxx.xsd 
      该命令是JDK 1.6中自带就有的，或者使用 jaxb2-maven-plugin
      http://mojo.codehaus.org/jaxb2-maven-plugin/xjc-mojo.html

3. 序列化和反序列化
3.1 C#端
      使用 System.Runtime.Serialization.Json.DataContractJsonSerializer
3.2 Java端
      使用 Spring MVC +  Marshaller/Unmarshaller
      
      System.Net.HttpWebRequest
```