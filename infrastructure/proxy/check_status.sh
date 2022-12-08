#!/bin/bash

# ./check_status.sh user
if [ -z "$1" ]
then
    echo "\$1 is empty"
    exit
else
    echo "checking status of user of $1"
fi

# v2ray status
echo "current v2ray status is $(sudo systemctl is-active v2ray)"

# bash status
if grep "#export http_proxy=http://127.0.0.1:8000" -q /home/$1/.bashrc; then
    echo "http_proxy is off"
elif grep "export http_proxy=http://127.0.0.1:8000" -q /home/$1/.bashrc; then
    echo "http_proxy is on"
else
    echo "http_proxy is null"
fi

if grep "#export https_proxy=http://127.0.0.1:8000" -q /home/$1/.bashrc; then
    echo "https_proxy is off"
elif grep "export https_proxy=http://127.0.0.1:8000" -q /home/$1/.bashrc; then
    echo "https_proxy is on"
else
    echo "https_proxy is null"
fi

# docker status
path="/etc/systemd/system/docker.service.d/http-proxy.conf"
if [ -f $path ]; then
    echo "docker proxy is on"
else
    echo "docker proxy is off"
fi

# containerd status
path="/etc/systemd/system/containerd.service.d/http-proxy.conf"
if [ -f $path ]; then
    echo "containerd proxy is on"
else
    echo "containerd proxy is off"
fi

