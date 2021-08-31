#/bin/bash
/usr/local/bin/k3s-uninstall.sh
/usr/local/bin/k3s-agent-uninstall.sh
curl -sfL http://rancher-mirror.cnrancher.com/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn sh -
#安装Agent work node. 3S_TOKEN使用的值存储在你的服务器节点上的/var/lib/rancher/k3s/server/node-token路径下
#curl -sfL http://rancher-mirror.cnrancher.com/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn K3S_URL=https://api.zhangyongqiao.com:6443 K3S_TOKEN=K1012b9e81cc0d1de90616fe51c53a7c71b13ee03cdb2c0da8910599d85b8e2b56d::server:513a5394b6a17a3c8759cd077df37db2 sh -


#安装配置好 helm及helm push
# wget https://get.helm.sh/helm-v3.2.4-linux-amd64.tar.gz
# tar -zxvf helm-v3.2.4-linux-amd64.tar.gz
# cp linux-amd64/helm /usr/local/bin

#阿里云的Helm私人仓库
#helm repo add $NAMESPACE https://repomanage.rdc.aliyun.com/helm_repositories/$NAMESPACE --username=zx7h6P --password=F4EpoIe7Ms
#//配置k3s可操作
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

#安装helm push 
helm plugin install https://github.com/chartmuseum/helm-pus

#安装证书管理器
wget https://github.com/jetstack/cert-manager/releases/download/v1.0.3/cert-manager.yaml
kubectl apply -f ./cert-manager.yaml
#配置证书 provider---clusterissuer
kubectl apply -f ./cert-issuecluster-traefik.yaml
#申请一个lets encrypt 证书
#kubectl apply -f ./default-cert.request.yaml 

#临时打开traefik 的 Dashboard
 #kubectl port-forward deploy/traefik 9000:9000 --address='0.0.0.0' -n kube-system


