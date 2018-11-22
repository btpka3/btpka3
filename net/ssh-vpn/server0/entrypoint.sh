#!/bin/sh

mkdir /dev/net
mknod /dev/net/tun c 10 200
mkdir -p /run/nginx

/usr/sbin/sshd -D
