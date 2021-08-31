#/bin/bash
/usr/local/bin/k3s-uninstall.sh
/usr/local/bin/k3s-agent-uninstall.sh
#安装Agent work node. 3S_TOKEN使用的值存储在你的服务器节点上的/var/lib/rancher/k3s/server/node-token路径下
curl -sfL http://rancher-mirror.cnrancher.com/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn K3S_URL=https://api.zhangyongqiao.com:6443 K3S_TOKEN=K1012b9e81cc0d1de90616fe51c53a7c71b13ee03cdb2c0da8910599d85b8e2b56d::server:513a5394b6a17a3c8759cd077df37db2 sh -



#安装证书管理器
wget https://github.com/jetstack/cert-manager/releases/download/v1.0.3/cert-manager.yaml
kubectl apply -f ./cert-manager.yaml
#配置证书 provider
kubectl apply -f ./cert-clusterissuer-traefik.yaml
#申请一个lets encrypt 证书
kubectl apply -f ./default-cert.request.yaml 



