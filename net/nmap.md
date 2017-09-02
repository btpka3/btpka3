

# 端口扫描

```bash
# 通过能否连接来扫描端口
nmap -sT wazitang.cn
    # Open          - 端口处于开放状态
    # Closed        - 端口处于关闭状态
    # Filtered      - 过滤的。 由于报文无法到达指定的端口，nmap不能够决定端口的开放状态，
    #                 这主要是由于网络或者主机安装了一些防火墙所导致的
    # Unfiltered    - 未被过滤的。当nmap不能确定端口是否开放的时候所打上的状态
    #                  unfiltered的端口能被nmap访问，但是nmap根据返回的报文无法确定端口的开放状态
    # Open|filtered
    # Closed|filtered
# -sU 扫描 UDP端口
# -Pn 绕过ping 检查，因为有些防火墙会禁止 ping
nmap -Pn -sU 192.168.0.12
```
