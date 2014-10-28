

# 捕捉过滤器

[CaptureFilters](http://wiki.wireshark.org/CaptureFilters)、
[ChCapCaptureFilterSection](http://www.wireshark.org/docs/wsug_html_chunked/ChCapCaptureFilterSection.html)

语法

```
syntax:
    [not] primitive [and|or [not] primitive ...]
primitive = 
    [src|dst] host <host>
    ether [src|dst] host <ehost>
    gateway host <host>
    [src|dst] net <net> [{mask <mask>}|{len <len>}] 
    [tcp|udp] [src|dst] port <port>
    less|greater <length>
    ip|ether proto <protocol>
    ether|ip broadcast|multicast
    <expr> relop <expr>
```

示例    

```
host 192.168.115.12 and port 9091
```

# 显示过滤器

[DisplayFilters](http://wiki.wireshark.org/DisplayFilters)、
[ChWorkBuildDisplayFilterSection](http://www.wireshark.org/docs/wsug_html_chunked/ChWorkBuildDisplayFilterSection.html)


操作符

```
operators : eq, ne, gt, lt, ge, le
```

示例

```
http
```




