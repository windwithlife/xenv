#!/bin/bash


side=$1
masterIP=$1
nodeIP=$2
nodeID=$3
registry=registry.zyq0.com:5000

if [ ! -n "$nodeIP" ]
then
nodeIP=127.0.0.1
echo "you have no a host ip to create node \n"

else
echo "you have a host ip to create master \n"
registry=$masterIP
fi

#master节点:
hostnamectl set-hostname k8s-node$nodeID
echo "finished to set hostname \n"

echo $masterIP k8s-master >> /etc/hosts
echo $nodeIP k8s-node$nodeID >> /etc/hosts


#关闭防火墙和selinux
systemctl stop firewalld && systemctl disable firewalld
sed -i 's/^SELINUX=enforcing$/SELINUX=disabled/' /etc/selinux/config && setenforce 0

#关闭swap
swapoff -a
#yes | cp /etc/fstab /etc/fstab_bak
#cat /etc/fstab_bak |grep -v swap > /etc/fstab



#安装chrony：
yum install -y chrony
#注释默认服务器
sed -i 's/^server/#&/' /etc/chrony.conf
#指定内网 master节点为上游NTP服务器
echo server k8s-master iburst >> /etc/chrony.conf
#重启服务并设为开机启动：
systemctl enable chronyd && systemctl restart chronyd
#开启网络时间同步功能
timedatectl set-ntp true

tee /etc/sysctl.d/k8s.conf <<-'EOF'
vm.swappiness = 0
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1

EOF
#vm.swappiness=0

# 使配置生效
modprobe br_netfilter
sysctl -p /etc/sysctl.d/k8s.conf


#配置docker yum源
#yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
curl -o /etc/yum.repos.d/docker-ce.repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum clean all
yum makecache fast 
yum repolist
#安装指定版本，这里安装18.06
yum list docker-ce --showduplicates | sort -r
yum install -y docker-ce-18.06.1.ce-3.el7
systemctl start docker && systemctl enable docker

#设置docker阿里加速器
#设置docker阿里加速器
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://89cgb0wn.mirror.aliyuncs.com"],
  "insecure-registries": ["registry-host:5000"] 
}
EOF
sed -i "s/registry-host/$registry/g" /etc/docker/daemon.json

systemctl daemon-reload
systemctl restart docker
echo "finished to setup docker accelerator\n"


#创建k8s的基于阿里的yum源
touch /etc/yum.repos.d/kubernetes.repo
echo [kubernetes] >> /etc/yum.repos.d/kubernetes.repo
echo name=Kubernetes >> /etc/yum.repos.d/kubernetes.repo
echo baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/ >> /etc/yum.repos.d/kubernetes.repo
echo enabled=1 >> /etc/yum.repos.d/kubernetes.repo
echo gpgcheck=1 >> /etc/yum.repos.d/kubernetes.repo
echo repo_gpgcheck=1 >> /etc/yum.repos.d/kubernetes.repo
echo gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg >> /etc/yum.repos.d/kubernetes.repo


#在所有节点上安装指定版本kubeadm
yum install -y kubelet-1.13.1 kubeadm-1.13.1 kubectl-1.13.1

systemctl enable kubelet.service
#kubeadm reset --force
kubeadm join $masterIP:6443 --token t2anpo.v46i0kcpihh7qxge --discovery-token-ca-cert-hash sha256:8ef5316779e45dcc6ce835d3be7129741fe60c523d7afd2d2056c53b3dc4468a
#kubeadm init --image-repository registry.aliyuncs.com/google_containers --kubernetes-version v1.13.1 --pod-network-cidr=10.244.0.0/16
#启动kubelet服务
#systemctl start kubelet

#创建启动配置到当前用户下。
#mkdir -p $HOME/.kube
#cp -rf /etc/kubernetes/admin.conf $HOME/.kube/config
#chown $(id -u):$(id -g) $HOME/.kube/config

#安装虚拟网络组件到K8s
#kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml



