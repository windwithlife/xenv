#!/bin/bash


side=$1
hostIP=$1
registry=registry.zyq0.com

if [ ! -n "$hostIP" ]
then
hostIP=127.0.0.1
echo "you have no a host ip to create master \n"

else
echo "you have a host ip to create master \n"
registry=$hostIP
fi

echo $hostIP k8s-master >> /etc/hosts

#master节点:
hostnamectl set-hostname k8s-master
echo "finished to set hostname \n"

#echo $hostIP k8s-master >> /etc/hosts

#关闭防火墙和selinux
systemctl stop firewalld && systemctl disable firewalld
sed -i 's/^SELINUX=enforcing$/SELINUX=disabled/' /etc/selinux/config && setenforce 0

#关闭swap
swapoff -a
#yes | cp /etc/fstab /etc/fstab_bak
#cat /etc/fstab_bak |grep -v swap > /etc/fstab

#安装chrony：
yum install -y chrony
#注释默认ntp服务器
sed -i 's/^server/#&/' /etc/chrony.conf
#指定上游公共 ntp 服务器，并允许其他节点同步时间
echo server 0.asia.pool.ntp.org iburst >> /etc/chrony.conf
echo server 1.asia.pool.ntp.org iburst >> /etc/chrony.conf
echo server 2.asia.pool.ntp.org iburst >> /etc/chrony.conf
echo allow all >> /etc/chrony.conf
#重启chronyd服务并设为开机启动：
systemctl enable chronyd && systemctl restart chronyd
#开启网络时间同步功能
timedatectl set-ntp true

#安装chrony：
#yum install -y chrony
#注释默认服务器
#sed -i 's/^server/#&/' /etc/chrony.conf
#指定内网 master节点为上游NTP服务器
#echo server k8s-master iburst >> /etc/chrony.conf
#重启服务并设为开机启动：
#systemctl enable chronyd && systemctl restart chronyd

tee /etc/sysctl.d/k8s.conf <<-'EOF'
vm.swappiness = 0
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1

EOF
# 使配置生效
modprobe br_netfilter
sysctl -p /etc/sysctl.d/k8s.conf

#配置docker yum源
#yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
curl -o /etc/yum.repos.d/docker-ce.repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
#curl -o /etc/yum.repos.d/docker-ce.repo https://download.docker.com/linux/centos/docker-ce.repo
yum clean all
yum makecache 
yum repolist
#安装指定版本，这里安装18.06
yum list docker-ce --showduplicates | sort -r

# 卸载旧版本
yum remove -y docker \
docker-client \
docker-client-latest \
docker-common \
docker-latest \
docker-latest-logrotate \
docker-logrotate \
docker-selinux \
docker-engine-selinux \
docker-engine
#yum install -y docker-ce-18.09.9 docker-ce-cli-18.09.9 containerd.io
yum install -y docker-ce-18.06.1.ce
systemctl start docker && systemctl enable docker
echo "finished to install docker\n"

#设置docker阿里加速器
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://89cgb0wn.mirror.aliyuncs.com"],
  "insecure-registries": ["registry.zyq0.com:5000"] 
}
EOF

#sed -i "s/registry-host/$registry/g" /etc/docker/daemon.json

systemctl daemon-reload
systemctl restart docker
echo "finished to setup docker accelerator and local registry \n"

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
yum install -y kubelet-1.16.4  kubectl-1.16.4 kubeadm-1.16.4
#kubeadm reset --force

kubeadm init --image-repository registry.aliyuncs.com/google_containers --kubernetes-version v1.16.4 --pod-network-cidr=10.244.0.0/16
#启动kubelet服务
systemctl enable kubelet && systemctl start kubelet

#创建启动配置到当前用户下。
mkdir -p $HOME/.kube
cp -rf /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

#安装虚拟网络组件到K8s
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

echo "finished to create flannel network component \n"

#安装nfs网络存储系统支持k8s的PV，PVC
yum install -y nfs-utils
mkdir /data/volumes -pv
tee /etc/exports <<-'EOF'
/data/volumes 172.17.0.0/16(rw,no_root_squash)
EOF


kubectl taint node k8s-master node-role.kubernetes.io/master-
kubectl label nodes k8s-master resourceType=enough

echo "finished to make k8s master as node \n"



#安装ingress-nginx处理网络接入
#kubectl apply -f ./cloud-resources/k8s/resources/deployments/ingress-nginx.yaml
#kubectl apply -f ./m
kubectl apply -f https://kuboard.cn/install-script/v1.16.0/nginx-ingress.yaml

kubectl apply -f ./cloud-resources/k8s/resources/deployments/docker-registry.yaml

#安装mysql
#kubectl apply -f ./cloud-resources/k8s/resources/deployments/mysql.yaml
#安装Redis
#kubectl apply -f ./cloud-resources/k8s/resources/deployments/redis.yaml
#echo "finished to create some common services \n"

#创建TLS证书
#openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout mykeyfile -out mycert -subj "/CN=*.e-healthcare.net/O=test.e-healthcare.net"
#kubectl create secret tls istio-ingressgateway-certs  --key mykeyfile --cert mycert -n istio-system


#mkdir -p ./certs 
#openssl genrsa -des3 -passout pass:x -out certs/dashboard.pass.key 2048
#openssl rsa -passin pass:x -in certs/dashboard.pass.key -out certs/dashboard.key
#openssl req -new -key certs/dashboard.key -out certs/dashboard.csr -subj '/CN=kube-TLS'
#openssl x509 -req -sha256 -days 365 -in certs/dashboard.csr -signkey certs/dashboard.key -out certs/dashboard.crt
#kubectl create secret generic default-certs --from-file=certs -n ingress-nginx
#rm -rf ./certs
#echo "finished to create default ingress TLS Certs \n"

#create node join token string
#kubeadm token create --print-join-command

#kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/baremetal/service-nodeport.yaml

#安装Xci自身项目到K8s中去


#安装图形化管理界面Dashboard
