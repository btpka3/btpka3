FROM o-docker.alibaba-inc.com/docker.io/alpine:3.21.3

RUN \
    apk add --no-cache \
        acl \
        alpine-conf \
        openrc \
        bash \
        curl \
        dmidecode \
        file \
        findutils \
        iputils-ping \
        inetutils-telnet \
        iproute2-ss \
        jq \
        lsof \
        openssh-client-default \
        procps-ng \
        ncurses \
        pstree \
        shadow \
        tcpdump \
        tree \
        ugrep \
        sudo \
        unzip \
        dante-server \
        openssh \
        vim && \
    # rm -f /etc/init.d/hwdrivers \
    #   /etc/init.d/hwclock \
    #   /etc/init.d/hwdrivers \
    #   /etc/init.d/modules \
    #   /etc/init.d/modules-load \
    #   /etc/init.d/modloop && \
    # ⭕️ 避免报错: can't open /dev/tty1: No such file or directory
    sed -i 's/^\(tty\d\:\:\)/#\1/g' /etc/inittab && \
    # sed -i \
    #   -e 's/#rc_sys=".*"/rc_sys="docker"/g' \
    #   -e 's/#rc_env_allow=".*"/rc_env_allow="\*"/g' \
    #   -e 's/#rc_crashed_stop=.*/rc_crashed_stop=NO/g' \
    #   -e 's/#rc_crashed_start=.*/rc_crashed_start=YES/g' \
    #   -e 's/#rc_provide=".*"/rc_provide="loopback net"/g' \
    #   /etc/rc.conf && \
    #sed -i 's/cgroup_add_service /# cgroup_add_service /g' /lib/rc/sh/openrc-run.sh && \
    #sed -i 's/VSERVER/DOCKER/Ig' /lib/rc/sh/init.sh && \
    touch /root/.vimrc && \
    mkdir -p /run/openrc/ && \
    touch /run/openrc/softlevel && \
    mkdir -p /root/.ssh && \
    chmod 0700 /root/.ssh && \
    rc-update add sshd default &&\
    rc-update add sockd default

COPY ./rootfs /

# alpine docker 镜像的默认 CMD ["sh"]

CMD ["/sbin/init"]

# 检查: `rc-service sshd checkconfig;  echo $?`
#CMD ["/etc/init.d/sshd", "start"]

# 启动 dante 代理服务, 配置文件 /etc/sockd.conf,
# 可以通过 `/usr/sbin/sockd -V ; echo $?` 检查配置文件
#CMD ["/etc/init.d/sockd", "start"]

#ENTRYPOINT ["/sbin/init"]
#ENTRYPOINT ["sh", "-c", "rc-status; rc-service sshd start"]
