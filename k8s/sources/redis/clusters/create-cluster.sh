#!/bin/bash
#创建集群每一个主都有一个从
#kubectl exec -it redis-app-0  -- redis-cli --cluster create --cluster-replicas 1 $(kubectl get pods  -l  app=redis -o jsonpath='{range.items[*]}{.status.podIP}:6379 ')
#创建集群，每一个主有0个从服务器
kubectl exec -it redis-app-0  -- redis-cli --cluster create $(kubectl get pods  -l  app=redis -o jsonpath='{range.items[*]}{.status.podIP}:6379 ')
