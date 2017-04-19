



# 安装

```bash
yum install epel-release

yum install openvpn easy-rsa -y

cp /usr/share/doc/openvpn-2.4.1/sample/sample-config-files/server.conf /etc/openvpn

vi /etc/openvpn/server.conf


firewall-cmd --permanent --direct --get-all-passthroughs

firewall-cmd --permanent   \
   --direct                \
   --passthrough ipv4      \
   -t nat                  \
   -A POSTROUTING          \
   -o eth0                 \
   -j MASQUERADE           \
   -s 10.8.0.0/24
firewall-cmd --complete-reload

systemctl restart network.service

systemctl start openvpn@server.service

telnet localhost 1194       # Connection refused
netstat -uapn | grep openvpn
nmap -sU localhost -p 1194  # 显示一下信息，则代表启动起来了
# PORT     STATE         SERVICE
# 1194/udp open|filtered openvpn

```

# 参考

* [openVpn](https://openvpn.net/)
* 《[How To Setup and Configure an OpenVPN Server on CentOS 7](https://www.digitalocean.com/community/tutorials/how-to-setup-and-configure-an-openvpn-server-on-centos-7)》

* [Docker 上的 IPsec VPN 服务器](https://github.com/hwdsl2/docker-ipsec-vpn-server/blob/master/README-zh.md)