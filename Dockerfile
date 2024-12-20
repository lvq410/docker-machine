FROM adoptopenjdk/openjdk8:jdk8u382-b05-alpine

#使用国内的源安装各种工具
RUN echo -e 'https://mirrors.aliyun.com/alpine/v3.11/main/\nhttps://mirrors.aliyun.com/alpine/v3.11/community/' > /etc/apk/repositories
RUN apk update

#busybox-extras包含命令有如：awk、cat、chmod、cp、grep、kill、ls、mkdir、mv、ps、sed、tar、top、wget 等
RUN apk add --no-cache busybox-extras

#alpine默认grep为BusyBox的grep，是较精简的版本，将其替换为GNU版本的grep
#GNU版本的grep需要安装glibc兼容库 原始地址：https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.34-r0/glibc-2.34-r0.apk
COPY glibc-2.34-r0.apk glibc-2.34-r0.apk
RUN apk del glibc && \
  apk add glibc-2.34-r0.apk && \
  rm glibc-2.34-r0.apk && \
  apk add --no-cache grep

RUN apk add bash less curl vim rsync git make

#net-tools包含命令有如：ifconfig、netstat、route 等
RUN apk add net-tools

#nss支持ssl/tls连接、数字证书管理等
RUN apk add nss

#alpine默认没有字体，装一个dejavu字体
RUN apk add ttf-dejavu

RUN apk add openssh

#清理安装包缓存
RUN rm -rf /var/cache/apk/*

#为SSH生成主机密钥对，用于加密和验证SSH连接
RUN ssh-keygen -A
# 设置ssh配置
COPY sshd_config /etc/ssh/sshd_config

# 设置root账户的公钥 及其文件权限
COPY authorized_keys /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys

# 设置环境变量文件
COPY .profile /root/.profile

# 替换默认的java.security文件，重新启用TLSv1
ADD java.security /opt/java/openjdk/jre/lib/security/java.security

#设置启动脚本
COPY start.sh /root/start.sh
RUN chmod +x /root/start.sh

# 设置项目启动时脚本
ENTRYPOINT ["sh","-c","/root/start.sh"]