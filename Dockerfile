FROM adoptopenjdk/openjdk8:jdk8u382-b05-alpine

#使用国内的源安装各种工具
RUN echo -e 'https://mirrors.aliyun.com/alpine/v3.9/main/\nhttps://mirrors.aliyun.com/alpine/v3.9/community/' > /etc/apk/repositories && \
    apk update && \
    apk add --no-cache bash curl busybox-extras net-tools nss vim ttf-dejavu openssh && \
    ssh-keygen -A && \
    rm -rf /var/cache/apk/* && \
    echo "root:root" | chpasswd

# 设置ssh配置
COPY sshd_config /etc/ssh/sshd_config

# 设置root账户的公钥
COPY authorized_keys /root/.ssh/authorized_keys

# 设置环境变量文件
COPY .profile /root/.profile

EXPOSE 22

# 启动sshd服务，并使用root用户登录
CMD ["/usr/sbin/sshd", "-D", "-e"]