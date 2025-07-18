#!/bin/bash

sudo mkdir -p /etc/systemd/system/docker.service.d

sudo cp ./http-proxy.conf /etc/systemd/system/docker.service.d/http-proxy.conf.bak

path="/etc/systemd/system/docker.service.d/http-proxy.conf"
if [ -f $path ]; then
    echo "rm docker http-proxy.conf"
    sudo rm /etc/systemd/system/docker.service.d/http-proxy.conf
else
    echo "add docker http-proxy.conf"
    sudo cp /etc/systemd/system/docker.service.d/http-proxy.conf.bak /etc/systemd/system/docker.service.d/http-proxy.conf
    cat /etc/systemd/system/docker.service.d/http-proxy.conf
fi

sudo systemctl daemon-reload
sudo systemctl restart docker
