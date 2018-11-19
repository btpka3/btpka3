FROM alpine:3.6

RUN \
       echo "root:123456" | chpasswd \
    && apk add --no-cache openssh iptables ip6tables awall socat ulogd nginx curl openrc

COPY entrypoint.sh /entrypoint.sh
CMD "/entrypoint.sh"
