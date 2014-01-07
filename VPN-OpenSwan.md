## client
[ref0](https://github.com/xelerance/Openswan/wiki/L2tp-ipsec-configuration-using-openswan-and-xl2tpd)
[ref1](https://wiki.archlinux.org/index.php/L2TP/IPsec_VPN_client_setup)

### openswan
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

vi /etc/ipsec.d/custom.conf
conn test-l2tp-vpn
    authby=never
    pfs=no
    auto=add
    rekey=no
    type=transport
    left=192.168.0.172          # local ip
    leftprotoport=17/1701
    leftnexthop=%defaultroute
    right=218.242.153.146       # your vpn server's public ip
    rightprotoport=17/%any
    rightsubnet=vhost:%priv,%no

vi /etc/ipsec.secrets
include /etc/ipsec.d/*.secrets

vi /etc/ipsec.d/custom.secrets
192.168.1.101 68.68.32.79 : PSK "your_pre_shared_key"

#ipsec auto --add test-l2tp-vpn

```


### xl2tipd
```

  /etc/xl2tpd/l2tp-secrets /var/run/l2tp-control

vi /etc/xl2tpd/xl2tpd.conf
TODO

vi /etc/ppp/options.l2tpd.client


mkdir -p /var/run/xl2tpd
touch /var/run/xl2tpd/l2tp-control

service ipsec start
service xl2tpd start
? for vpn in /proc/sys/net/ipv4/conf/*; do echo 0 > $vpn/accept_redirects; echo 0 > $vpn/send_redirects; done

ipsec verify
ipsec auto --up test-l2tp-vpn


```