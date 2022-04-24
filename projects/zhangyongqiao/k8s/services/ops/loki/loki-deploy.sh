#/bin/bash
helm repo add loki https://grafana.github.io/loki/charts && helm repo update
helm pull loki/loki-stack
tar xf loki-stack-2.1.2.tgz
kubectl create ns ops
helm install loki -n ops loki-stack/