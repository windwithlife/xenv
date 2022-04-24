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

export K3S_URL=https://139.224.212.36:6443
export K3S_TOKEN=K101013db2d501a95d96ce0e38574237da5c51cc4bca7453b0fd15e7c74aa62455e::server:07ef842221bbc87eb1660c62656e57be
export INSTALL_K3S_EXEC='--node-external-ip 106.15.65.143  --node-ip 172.17.75.211 '


export K3S_URL=https://139.196.106.5:6443
export K3S_TOKEN=K104f9c2ebbaee21731be8884a8a3a25fe7a7535faa4114cea88e9abfa3d0144c13::server:70227eba0c9543b360e9252a460c978e
export INSTALL_K3S_EXEC='--node-external-ip 124.222.29.87 --node-ip 10.0.0.3 --flannel-iface wg0 '
export INSTALL_K3S_EXEC='--node-external-ip 124.222.29.87 --node-ip 10.0.12.14 '
export INSTALL_K3S_EXEC='--node-external-ip 122.112.206.87 --node-ip  192.168.0.214 '
export INSTALL_K3S_EXEC='--node-external-ip 159.138.4.99 --node-ip  192.168.0.135 '



export K3S_URL=https://47.116.70.243:6443
export K3S_TOKEN=K10e0fbdbd1f259add4e5a5035ecdeace36120b02549a72baed51bc7bd0e49e51cb::server:f67264bcfbfa6aa88983872b6e7d830a
export INSTALL_K3S_EXEC='--node-external-ip 159.138.101.253 --node-ip 192.168.0.245 '
export INSTALL_K3S_EXEC='--node-external-ip 139.9.75.158 --node-ip 192.168.0.252 '
export INSTALL_K3S_EXEC='--node-external-ip 159.138.4.99 --node-ip  192.168.0.135 '


iptables -t nat -A OUTPUT -d 0.0.12.14  -j DNAT --to-destination 124.222.29.87
iptables -t nat -A OUTPUT -d 172.17.75.211  -j DNAT --to-destination 106.15.65.143


#安装Agent work node. 3S_TOKEN使用的值存储在你的服务器节点上的/var/lib/rancher/k3s/server/node-token路径下
curl -sfL http://rancher-mirror.cnrancher.com/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn sh -



#安装证书管理器
wget https://github.com/jetstack/cert-manager/releases/download/v1.6.0/cert-manager.yaml
kubectl apply -f ./cert-manager.yaml
#配置证书 provider
kubectl apply -f ./cert-clusterissuer-traefik.yaml
#申请一个lets encrypt 证书
kubectl apply -f ./default-cert.request.yaml 



