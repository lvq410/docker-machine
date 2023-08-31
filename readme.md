该容器能够在外部用ssh方式登入

启动了一个容器，就像启动了一个虚拟机一样

已经内置了

`java` `curl` `net-tools` `vim`

等等常见命令环境

## 关于ssh端口

默认端口为：`22`

可以通过设置环境变量`SSH_PORT`来更改端口号

## 关于登录用认证

默认账号密码：`root:root`

可以通过设置环境变量`ROOT_PWD`来设置root账户的密码

更改公钥可以通过启动容器的时候，挂载文件卷替换`/root/.ssh/authorized_keys`