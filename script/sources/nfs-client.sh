

# 安装nfs
yum -y install nfs-utils rpcbind
# 创建nfs共享目录及设置权限 
 mkdir /data/k8sdata -p
 chmod 755 /data/k8sdata -R
# 配置nfs

systemctl start rpcbind
systemctl enable rpcbind
systemctl status rpcbind
systemctl start nfs
systemctl enable nfs
systemctl status nfs
showmount -e 192.168.16.133
