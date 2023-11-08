#/bin/bash


/usr/local/bin/k3s-uninstall.sh

# export INSTALL_K3S_EXEC='--node-external-ip 139.196.106.5  --advertise-address 139.196.106.5 --node-ip 10.0.0.1 --flannel-iface wg0 '
# export INSTALL_K3S_EXEC='--node-external-ip 106.15.65.143  --advertise-address 106.15.65.143 --node-ip 172.17.75.211 '


curl -sfL https://rancher-mirror.rancher.cn/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn sh -

#安装Agent work node. 3S_TOKEN使用的值存储在你的服务器节点上的/var/lib/rancher/k3s/server/node-token路径下
#curl -sfL http://rancher-mirror.cnrancher.com/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn K3S_URL=https://api.zhangyongqiao.com:6443 K3S_TOKEN=K1012b9e81cc0d1de90616fe51c53a7c71b13ee03cdb2c0da8910599d85b8e2b56d::server:513a5394b6a17a3c8759cd077df37db2 sh -

#r为了使flannel网络能使用各node 的公网地址
# kubectl get node master-node -o yaml
# kubectl annotate nodes master-node flannel.alpha.coreos.com/public-ip-overwrite=<master_pub_ip>
# kubectl annotate nodes work-node flannel.alpha.coreos.com/public-ip-overwrite=<work_pub_ip>


# kubectl annotate nodes zyq-gateway flannel.alpha.coreos.com/public-ip-overwrite=139.196.106.5
# kubectl annotate nodes huawei-zyq-2-4 flannel.alpha.coreos.com/public-ip-overwrite=122.112.206.87
# kubectl annotate nodes tecent-zyq-2-4 flannel.alpha.coreos.com/public-ip-overwrite=124.222.29.87



#//配置k3s可操作
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
cat /var/lib/rancher/k3s/server/node-token

#安装适用可定制控制面板
kubectl apply -f https://addons.kuboard.cn/kuboard/kuboard-v3.yaml


#安装证书管理器
wget https://github.com/jetstack/cert-manager/releases/download/v1.6.0/cert-manager.yaml
kubectl apply -f ./cert-manager.yaml
#配置证书 provider---clusterissuer
kubectl apply -f ./cert-clusterissuer-traefik.yaml
#申请一个lets encrypt 证书
#kubectl apply -f ./default-cert-request-zyq.yaml 


 #安装helm push 
 #wget https://get.helm.sh/helm-v3.5.0-linux-amd64.tar.gz
 wget https://mirrors.huaweicloud.com/helm/v3.8.0/helm-v3.8.0-linux-amd64.tar.gz
 tar -zxvf helm-v3.8.0-linux-amd64.tar.gz
 chmod 755 linux-amd64/helm
 cp linux-amd64/helm /usr/local/bin/
 #helm plugin install https://github.com/chartmuseum/helm-pus
