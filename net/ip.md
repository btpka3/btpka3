Q：以下IP 是公网IP ? 还是内网IP ?
- green-console 日常k8s master ip 地址： 11.164.234.212
- 个人MacOS 的办公网IP ： 30.196.226.30/18

A:  对应的网管将公网IP段当成内网IP段来使用了。
因为这些公网IP 对于绝大多数人估计一辈子都不会访问。
以下ip段属于美国的军事用途的IP段：
11.0.0.0/8
22.0.0.0/8
26.0.0.0/8
29.0.0.0/8
30.0.0.0/8

https://www.iana.org/assignments/ipv4-address-space/ipv4-address-space.xhtml
https://zh-hans.ipshu.com/ip_b_list/11
https://zh-hans.ipshu.com/ip_b_list/30
