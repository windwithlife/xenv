
#/bin/bash
#CentOS 8 问题解决
rename '.repo' '.repo.bak' /etc/yum.repos.d/*.repo 
wget https://mirrors.aliyun.com/repo/Centos-vault-8.5.2111.repo -O /etc/yum.repos.d/Centos-vault-8.5.2111.repo
wget https://mirrors.aliyun.com/repo/epel-archive-8.repo -O /etc/yum.repos.d/epel-archive-8.repo

yum clean all && yum makecache

#阿里云CentOS 8问题解决 因为云服务在阿里云内部，所以要替换一下源目标
rename '.repo' '.repo.bak' /etc/yum.repos.d/*.repo 
wget https://mirrors.aliyun.com/repo/Centos-vault-8.5.2111.repo -O /etc/yum.repos.d/Centos-vault-8.5.2111.repo
wget https://mirrors.aliyun.com/repo/epel-archive-8.repo -O /etc/yum.repos.d/epel-archive-8.repo

sed -i 's/mirrors.cloud.aliyuncs.com/url_tmp/g'  /etc/yum.repos.d/Centos-vault-8.5.2111.repo &&  sed -i 's/mirrors.aliyun.com/mirrors.cloud.aliyuncs.com/g' /etc/yum.repos.d/Centos-vault-8.5.2111.repo && sed -i 's/url_tmp/mirrors.aliyun.com/g' /etc/yum.repos.d/Centos-vault-8.5.2111.repo
sed -i 's/mirrors.aliyun.com/mirrors.cloud.aliyuncs.com/g' /etc/yum.repos.d/epel-archive-8.repo
yum clean all && yum makecache

##############################升级内核##################################
#Centos8 升级内核
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
yum install https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm

yum --disablerepo="*" --enablerepo="elrepo-kernel" list available
hostnamectl 
yum clean all && yum -y install --enablerepo=elrepo-kernel kernel-ml kernel-ml-devel  
#查看默认加载的内核
grubby --default-kernel

# 重启生效

reboot

 yum -y install kernel-ml-tools kernel-ml-headers

########################CentOS 7升级内核#############
 rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
 yum install -y https://www.elrepo.org/elrepo-release-7.el7.elrepo.noarch.rpm

 yum list available --disablerepo=* --enablerepo=elrepo-kernel

 yum install -y --enablerepo=elrepo-kernel kernel-ml kernel-ml-devel 

#查看内核列表
cat /boot/grub2/grub.cfg | grep menuentry

 grub2-set-default 0 #当前内核序号
 grub2-mkconfig -o /boot/grub2/grub.cfg　　#重新创建内核配置

 reboot

 uname -r



#####################安装wireguard VPN 支持 CentOS7############################
yum install epel-release https://www.elrepo.org/elrepo-release-7.el7.elrepo.noarch.rpm
yum install yum-plugin-elrepo
yum install kmod-wireguard wireguard-tools


vim /etc/sysctl.conf
net.ipv4.ip_forward = 1
sysctl -p
sysctl  net.ipv4.ip_forward

#关闭重定向，防止恶意用户可以使用IP重定向来修改远程主机中的路由表
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
#####################CentOS 8 安装 Wireguard ###################
yum install https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm -y 
yum install yum-plugin-elrepo
yum install kmod-wireguard wireguard-tools


vim /etc/sysctl.conf
net.ipv4.ip_forward = 1
sysctl -p
sysctl  net.ipv4.ip_forward

#关闭重定向，防止恶意用户可以使用IP重定向来修改远程主机中的路由表
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0

############################解决内网不通-> flannel不通->负载无法访问#######
kubectl get node master-node -o yaml
kubectl annotate nodes master-node flannel.alpha.coreos.com/public-ip-overwrite=<master_pub_ip>
kubectl annotate nodes work-node flannel.alpha.coreos.com/public-ip-overwrite=<work_pub_ip>

###########################解决内网不通->集群操作无法访问work node ###################

iptables -t nat -A OUTPUT -d node1-内网ip  -j DNAT --to-destination node1-公网ip

iptables -t nat -A OUTPUT -d node2-内网ip  -j DNAT --to-destination node2-公网ip

#####################NFS
yum  install  nfs-utils rpcbind  -y 
mkdir /data
chmod -Rf 777 /data/
vim /etc/exports
/data *(rw,no_root_squash,no_all_squash,insecure)
#生效配置
exportfs -r
systemctl restart rpcbind nfs



