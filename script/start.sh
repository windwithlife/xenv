#!/bin/bash

kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.0.3/cert-manager.yaml
kubectl apply -f ../k8s/sources/certs/cert-issuercluster-nginx.yaml
kubectl apply -f ../k8s/sources/gateway/nginx-ingress-prod.yaml
