

# ip route

```bash
man ip-route
ip route { add | del | change | append | replace } ROUTE

ROUTE := NODE_SPEC [ INFO_SPEC ]
NODE_SPEC := [ TYPE ] PREFIX [ tos TOS ] [ table TABLE_ID ] [ proto RTPROTO ] [ scope SCOPE ] [ metric METRIC ]
INFO_SPEC := NH OPTIONS FLAGS [ nexthop NH ] ...


```


# ip 地址
IPv4: 32位（4个字节）
IPv6: 128位（16个字节）

A、B、C、D、E




|type| max network    | IP range
|----|--------------|-----------|
|A   |    126(2^7-2)|0???????.00000000.00000000.00000000|
|B   |  16384(2^14) |
|C   |2097152(2^21) |

10.0.0.0/8
72.16.0.0--172.31.255.255
192.168.0.0--192.168.255.255

## 分类

### A 类

|prop               | desp                              |
|-------------------|-----------------------------------|
|IP range (mask)    |0???????.00000000.00000000.00000000|
|IP range           |0.0.0.0-127.255.255.255            |
|max network        |     126 (2^7-2)                   |
|max host           |16777214 (2^24-2)                  |
|private IP range   |10.0.0.0/8                         |



### B 类

|prop               | desp                              |
|-------------------|-----------------------------------|
|IP range (mask)    |10??????.????????.00000000.00000000|
|IP range           |172.16.0.0-172.31.255.255          |
|max network        |   16384 (2^14)                    |
|max host           | 65534 (2^16-2)                    |
|private IP range   |10.0.0.0/8                         |

