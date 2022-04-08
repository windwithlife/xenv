#/bin/bash
/usr/local/bin/k3s-uninstall.sh
/usr/local/bin/k3s-agent-uninstall.sh

export K3S_URL=https://139.196.106.5:6443
export K3S_TOKEN=K10ed37b6ea6c478116e31607d5a0b910bb2c1a1785800eab1d55069af52359c6c1::server:f37cd71ea51312af3a0791b312267b46 

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



