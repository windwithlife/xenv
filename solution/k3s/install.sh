#/bin/bash
/usr/local/bin/k3s-uninstall.sh
/usr/local/bin/k3s-agent-uninstall.sh
curl -sfL http://rancher-mirror.cnrancher.com/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn sh -


//安装配置好 helm及helm push
wget https://get.helm.sh/helm-v3.2.4-linux-amd64.tar.gz
tar -zxvf helm-v3.2.4-linux-amd64.tar.gz
cp linux-amd64/helm /usr/local/bin

//阿里云的Helm私人仓库
#helm repo add $NAMESPACE https://repomanage.rdc.aliyun.com/helm_repositories/$NAMESPACE --username=zx7h6P --password=F4EpoIe7Ms

//安装helm push 
helm plugin install https://github.com/chartmuseum/helm-pus

//安装证书管理器
kubectl apply -f ./cert-manager.yaml
//配置证书 provider
kubectl apply -f ./cert-issuecluster-traefik.yaml
//申请一个lets encrypt 证书
kubectl apply -f ./default-cert.request.yaml 

//临时打开traefik 的 Dashboard
 kubectl port-forward deploy/traefik 9000:9000 --address='0.0.0.0' -n kube-system

 #export NAMESPACE=138405-windwithlife
 #helm repo add $NAMESPACE https://repomanage.rdc.aliyun.com/helm_repositories/$NAMESPACE --username=zx7h6P --password=F4EpoIe7Ms
 #helm plugin install https://github.com/chartmuseum/helm-push
