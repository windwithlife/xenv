#/bin/bash
# For the accross cloud deploy.install wireguard VPN support if is above CentOS8 ,if lower than CentOs8 need to upgrade the linux kernal core
# yum update -y
# yum install epel-release https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm
# yum install kmod-wireguard
# yum install wireguard-tools
# reboot

#支持包转发
# vim /etc/sysctl.conf
#net.ipv4.ip_forward = 1
# sysctl -p


/usr/local/bin/k3s-uninstall.sh
/usr/local/bin/k3s-agent-uninstall.sh

export K3S_URL=https://139.196.106.5:6443
export K3S_TOKEN=K10bbc14a7cf54a8d9cf8a99b27a52f3bd2ad3d94b1fbfb44d4e6a80ea3804d0877::server:6cf24cd00e23be1ac031a9ab8248e625
export INSTALL_K3S_EXEC='--node-external-ip 124.222.29.87 --node-ip 10.0.0.3 --flannel-iface wg0 '
export INSTALL_K3S_EXEC='--node-external-ip 124.222.29.87 --node-ip 10.0.12.14 '

#安装Agent work node. 3S_TOKEN使用的值存储在你的服务器节点上的/var/lib/rancher/k3s/server/node-token路径下
curl -sfL http://rancher-mirror.cnrancher.com/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn sh -



#安装证书管理器
wget https://github.com/jetstack/cert-manager/releases/download/v1.6.0/cert-manager.yaml
kubectl apply -f ./cert-manager.yaml
#配置证书 provider
kubectl apply -f ./cert-clusterissuer-traefik.yaml
#申请一个lets encrypt 证书
kubectl apply -f ./default-cert.request.yaml 



