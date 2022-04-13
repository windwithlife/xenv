#/bin/bash
/usr/local/bin/k3s-uninstall.sh
/usr/local/bin/k3s-agent-uninstall.sh
#安装Agent work node. 3S_TOKEN使用的值存储在你的服务器节点上的/var/lib/rancher/k3s/server/node-token路径下
export K3S_URL=https://139.196.106.5:6443
export K3S_TOKEN=K103505c0911f78a572888d0d2400f2e1babe41e73ad2dac0659e0bfb417298a64b::server:647a619e2be77a900cc89c259eba6bf1 

export INSTALL_K3S_EXEC='--node-external-ip 124.222.29.87 --node-ip 10.0.12.14 --kube-proxy-arg "proxy-mode=ipvs" "masquerade-all=true" --kube-proxy-arg "metrics-bind-address=0.0.0.0"'

curl -sfL http://rancher-mirror.cnrancher.com/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn  sh - 


#安装证书管理器
wget https://github.com/jetstack/cert-manager/releases/download/v1.6.0/cert-manager.yaml
kubectl apply -f ./cert-manager.yaml
#配置证书 provider
kubectl apply -f ./cert-clusterissuer-traefik.yaml
#申请一个lets encrypt 证书
kubectl apply -f ./default-cert.request.yaml 



