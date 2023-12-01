[interface not list](https://ask.wireshark.org/questions/7523/ubuntu-machine-no-interfaces-listed)

```bash
sudo apt-get install wireshark
cp /usr/share/applications/wireshark.desktop ~/Desktop/
sudo dpkg-reconfigure wireshark-common
sudo usermod -a -G wireshark $USER
# sudo reboot
gnome-session-quit --logout --no-prompt
# 如果仍然失败，则尝试执行
sudo chmod 4711 `which dumpcap`

# macos 安装
brew install --cask wireshark
```



# 捕捉过滤器

[CaptureFilters](http://wiki.wireshark.org/CaptureFilters)、
[ChCapCaptureFilterSection](http://www.wireshark.org/docs/wsug_html_chunked/ChCapCaptureFilterSection.html)

但是注意，本机发往本机IP的请求貌似无法捕获到。

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
(src host 192.168.101.222 and src port 10040) or (dst host 192.168.101.222 and dst port 10040)
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





