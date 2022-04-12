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
export K3S_TOKEN=K104cd7572cab8ff144aea8469c21e69faae9944c5e6dd6a00035e9cd41866b8e5a::server:7795911d742fb37abccdfb919e54f08f
export INSTALL_K3S_EXEC='--node-external-ip 124.222.29.87 --node-ip 10.0.0.3 --flannel-iface wg0 '
export INSTALL_K3S_EXEC='--node-external-ip 124.222.29.87 --node-ip 10.0.12.14 '


export K3S_URL=https://106.15.65.143:6443
export K3S_TOKEN=K106b00cf6e2311aae7561259d3a27f24af1d02a48ce0b2a063010108aac8dbfd5e::server:bd9d1764957d024fc76e23a16b770157
export INSTALL_K3S_EXEC='--node-external-ip 159.138.101.253 --node-ip 192.168.0.245 '

#安装Agent work node. 3S_TOKEN使用的值存储在你的服务器节点上的/var/lib/rancher/k3s/server/node-token路径下
curl -sfL http://rancher-mirror.cnrancher.com/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn sh -



#安装证书管理器
wget https://github.com/jetstack/cert-manager/releases/download/v1.6.0/cert-manager.yaml
kubectl apply -f ./cert-manager.yaml
#配置证书 provider
kubectl apply -f ./cert-clusterissuer-traefik.yaml
#申请一个lets encrypt 证书
kubectl apply -f ./default-cert.request.yaml 



