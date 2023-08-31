#设置root账户
echo "root:"${ROOT_PWD:-"root"} | chpasswd

exec /usr/sbin/sshd -D -e -p ${SSH_PORT:-22}