#!/bin/bash

if [[ -z $SSH_PORT ]]; then
    echo custom ssh port is not specified, default value will be used;
    SSH_PORT=54322;
else
    SSH_PORT=$SSH_PORT;
fi

sudo apt update

# Change ssh port
echo "    Port $SSH_PORT" >> /etc/ssh/ssh_config
systemctl restart sshd

# Ports withe list
sudo apt install ufw
sudo ufw allow $SSH_PORT
sudo ufw allow https
sudo ufw status verbose

sudo ufw enable

# Docker
sudo apt install docker.io docker-compose

# https://habr.com/ru/articles/735536/
# https://habr.com/ru/articles/728696/

# https://github.com/2dust/v2rayNG
# https://github.com/MatsuriDayo/NekoBoxForAndroid

docker run -d \
    -p 54321:54321 -p 443:443 -p 80:80 \
    -e XRAY_VMESS_AEAD_FORCED=false \
    -v $PWD/db/:/etc/x-ui/ \
    -v $PWD/cert/:/root/cert/ \
    --name x-ui --restart=unless-stopped \
    alireza7/x-ui:latest

docker logs x-ui
