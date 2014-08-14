

# captcher filter

[参考](http://wiki.wireshark.org/CaptureFilters)。但是注意，本机发往本机IP的请求貌似无法捕获到。

```
host 192.168.101.222 and port 10040
(src host 192.168.101.222 and src port 10040) or (dst host 192.168.101.222 and dst port 10040)

```

# display filter

```
http
```