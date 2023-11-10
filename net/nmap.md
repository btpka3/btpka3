

# 端口扫描

```bash
brew install nmap

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


# SSL server cipher suite

[ssl-enum-ciphers.nse](https://svn.nmap.org/nmap/scripts/ssl-enum-ciphers.nse)

```bash
mkdir /tmp/aaa
cd /tmp/aaa
curl -fsSL https://svn.nmap.org/nmap/scripts/ssl-enum-ciphers.nse -o ssl-enum-ciphers.nse
nmap --script ssl-enum-ciphers -p 443 sts.cn-hangzhou.aliyuncs.com
```

output
```plain
Starting Nmap 7.94 ( https://nmap.org ) at 2023-11-02 00:06 CST
Nmap scan report for sts.cn-hangzhou.aliyuncs.com (101.37.132.1)
Host is up (0.0040s latency).
Other addresses for sts.cn-hangzhou.aliyuncs.com (not scanned): 47.111.202.72

PORT    STATE SERVICE
443/tcp open  https
| ssl-enum-ciphers:
|   TLSv1.0:
|     ciphers:
|       TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA (ecdh_x25519) - A
|       TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA (ecdh_x25519) - A
|       TLS_RSA_WITH_AES_256_CBC_SHA (rsa 2048) - A
|       TLS_RSA_WITH_AES_128_CBC_SHA (rsa 2048) - A
|     compressors:
|       NULL
|     cipher preference: server
|   TLSv1.1:
|     ciphers:
|       TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA (ecdh_x25519) - A
|       TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA (ecdh_x25519) - A
|       TLS_RSA_WITH_AES_256_CBC_SHA (rsa 2048) - A
|       TLS_RSA_WITH_AES_128_CBC_SHA (rsa 2048) - A
|     compressors:
|       NULL
|     cipher preference: server
|   TLSv1.2:
|     ciphers:
|       TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA (ecdh_x25519) - A
|       TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA (ecdh_x25519) - A
|       TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (ecdh_x25519) - A
|       TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384 (ecdh_x25519) - A
|       TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (ecdh_x25519) - A
|       TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256 (ecdh_x25519) - A
|       TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256 (ecdh_x25519) - A
|       TLS_RSA_WITH_AES_256_CBC_SHA (rsa 2048) - A
|       TLS_RSA_WITH_AES_128_CBC_SHA (rsa 2048) - A
|     compressors:
|       NULL
|     cipher preference: server
|   TLSv1.3:
|     ciphers:
|       TLS_AKE_WITH_AES_256_GCM_SHA384 (ecdh_x25519) - A
|       TLS_AKE_WITH_AES_128_GCM_SHA256 (ecdh_x25519) - A
|       TLS_AKE_WITH_CHACHA20_POLY1305_SHA256 (ecdh_x25519) - A
|       TLS_AKE_WITH_SM4_CCM_SM3 (ecdh_x25519) - A
|       TLS_AKE_WITH_SM4_GCM_SM3 (ecdh_x25519) - A
|     cipher preference: server
|_  least strength: A

Nmap done: 1 IP address (1 host up) scanned in 1.31 seconds
```


