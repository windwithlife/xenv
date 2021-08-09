#/bin/bash
/usr/local/bin/k3s-uninstall.sh
/usr/local/bin/k3s-agent-uninstall.sh
curl -sfL http://rancher-mirror.cnrancher.com/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn sh -


wget https://get.helm.sh/helm-v3.2.4-linux-amd64.tar.gz
tar -zxvf helm-v3.2.0-linux-amd64.tar.gz
cp linux-amd64/helm /usr/local/bin

//安装helm push 
helm plugin install https://github.com/chartmuseum/helm-pus