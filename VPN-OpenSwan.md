## client
[ref0](https://github.com/xelerance/Openswan/wiki/L2tp-ipsec-configuration-using-openswan-and-xl2tpd)
[ref1](https://wiki.archlinux.org/index.php/L2TP/IPsec_VPN_client_setup)

```
vi /etc/ipsec.conf
version 2.0
config setup
    protostack=netkey
    nat_traversal=yes
    virtual_private=%v4:192.168.0.0/16,%v4:10.0.0.0/8,%v4:172.16.0.0/12,%v4:25.0.0.0/8,%v4:!10.254.253.0/24
    oe=off
    interfaces="%defaultroute"
include /etc/ipsec.d/*.conf
```