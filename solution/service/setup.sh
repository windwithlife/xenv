#!/bin/bash
yum install -y docker
yum list installed | grep docker
systemctl enable docker
systemctl restart docker.service

curl -SL https://github.com/docker/compose/releases/download/v2.12.2/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
