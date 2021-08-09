#/bin/bash
./k3s-uninstall.sh 
./k3s-agent-uninstall.sh
curl -sfL http://rancher-mirror.cnrancher.com/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn sh -