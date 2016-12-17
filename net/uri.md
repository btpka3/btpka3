* Uniform Resource Locators (URL)
    * [RFC 1738](https://tools.ietf.org/html/rfc1738)
* ~~Relative Uniform Resource Locators~~
    * ~~[RFC 1808](https://tools.ietf.org/html/rfc1808)~~

* HTTP State Management Mechanism
    * ~~[RFC 2109](https://tools.ietf.org/html/rfc2109)~~
    * ~~[RFC 2965](https://tools.ietf.org/html/rfc2965)~~
    * [RFC 6265](https://tools.ietf.org/html/rfc6265)
    
* Augmented BNF for Syntax Specifications: ABNF
    * ~~[RFC 2234](https://tools.ietf.org/html/rfc2234)~~
    * ~~[RFC 4324](https://tools.ietf.org/html/rfc4324)~~
    * [RFC 5234](https://tools.ietf.org/html/rfc5234)
    * [RFC 7405](https://tools.ietf.org/html/rfc7405)

* The 'mailto' URI Scheme
    * ~~[RFC 2368](https://tools.ietf.org/html/rfc2368)~~
    * [RFC 6068](https://tools.ietf.org/html/rfc6068)

* **Uniform Resource Identifiers (URI): Generic Syntax** 
    * ~~[RFC 2396](https://tools.ietf.org/html/rfc2396)~~
    * [RFC 3986](https://tools.ietf.org/html/rfc3986)

* Hypertext Transfer Protocol -- HTTP/1.1
    * [RFC 2616](https://tools.ietf.org/html/rfc2616)
    * ~~[RFC 2068](https://tools.ietf.org/html/rfc2068)~~
* Upgrading to TLS Within HTTP/1.1
    * [RFC 2817](https://tools.ietf.org/html/rfc2817)
* HTTP Over TLS
    * [RFC 2818](https://tools.ietf.org/html/rfc2818)

* The telnet URI Scheme
    * [RFC 4828](https://tools.ietf.org/html/rfc4828)
* The gopher URI Scheme
    * [RFC 4266](https://tools.ietf.org/html/rfc4266)
* Defining Well-Known Uniform Resource Identifiers (URIs)
    * [RFC 5785](https://tools.ietf.org/html/rfc5785)


* Use of the Content-Disposition Header Field in the Hypertext Transfer Protocol (HTTP)
    * [RFC 6068](https://tools.ietf.org/html/rfc6068)
* Representing IPv6 Zone Identifiers in Address Literals and Uniform Resource Identifiers
    * [RFC 6874](https://tools.ietf.org/html/rfc6874)

* Hypertext Transfer Protocol (HTTP/1.1): Message Syntax and Routing
    * [RFC 7230](https://tools.ietf.org/html/rfc7230)
* Hypertext Transfer Protocol (HTTP/1.1): Semantics and Content
    * [RFC 7231](https://tools.ietf.org/html/rfc7231)
* Hypertext Transfer Protocol (HTTP/1.1): Conditional Requests
    * [RFC 7232](https://tools.ietf.org/html/rfc7232)
* Hypertext Transfer Protocol (HTTP/1.1): Range Requests
    * [RFC 7233](https://tools.ietf.org/html/rfc7233)
* Hypertext Transfer Protocol (HTTP/1.1): Caching
    * [RFC 7234](https://tools.ietf.org/html/rfc7234)
* Hypertext Transfer Protocol (HTTP/1.1): Authentication
    * [RFC 7235](https://tools.ietf.org/html/rfc7235)

* The OAuth 2.0 Authorization Framework: Bearer Token Usage
    * [RFC 6750](https://tools.ietf.org/html/rfc6750)



http://www.rfcreader.com/#rfc6750



# application/x-www-form-urlencoded
application/x-www-form-urlencoded 定义位于 [HTML 4.01](https://www.w3.org/TR/html401/interact/forms.html#h-17.13.4.1)

    * key-value 对（键值对） 通过 `&` 相连
    * key 与 value 通过 `=` 相连
    * key,value都需要先将空格替换为 `+`，再使用 URL encoding 进行编码

```
Name: Gareth Wylie
Age: 24
Formula: a + b == 13%!
```
被编码为：

```
Name=Gareth+Wylie&Age=24&Formula=a+%2B+b+%3D%3D+13%25%21
```

只有该 ContentType中才将空格变为加号，URL上的仍需变为 `%20`

