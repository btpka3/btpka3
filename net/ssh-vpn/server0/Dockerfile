FROM alpine:3.6

RUN \
       echo "root:123456" | chpasswd \
    && apk add --no-cache openssh iptables ip6tables awall socat ulogd nginx curl openrc \
    && ssh-keygen -A \
    && ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa \
    && cat /root/.ssh/id_rsa.pub > /root/.ssh/authorized_keys \
    && chmod 644 /root/.ssh/authorized_keys

COPY sshd_config    /etc/ssh/sshd_config
COPY entrypoint.sh  /entrypoint.sh
COPY ulogd.conf     /etc/ulogd.conf

CMD "/entrypoint.sh"
