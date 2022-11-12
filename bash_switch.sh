#!/bin/bash

# ./bash_switch.sh user

if [ -z "$1" ]
then
    echo "\$1 is empty"
else
    echo "changing proxy of $1"
fi


if grep "#export http_proxy=http://127.0.0.1:8000" -q /home/$1/.bashrc; then
    echo "switching on http_proxy"
    sed -i 's/#export http_proxy=http:\/\/127.0.0.1:8000/export http_proxy=http:\/\/127.0.0.1:8000/g' /home/$1/.bashrc
elif grep "export http_proxy=http://127.0.0.1:8000" -q /home/$1/.bashrc; then
    echo "switching off http_proxy"
    sed -i 's/export http_proxy=http:\/\/127.0.0.1:8000/#export http_proxy=127.0.0.1:8000/g' /home/$1/.bashrc
    unset http_proxy
else
    echo "export http_proxy=http://127.0.0.1:8000" >> /home/$1/.bashrc
    echo "adding http_proxy to bashrc"
fi

if grep "#export https_proxy=http://127.0.0.1:8000" -q /home/$1/.bashrc; then
    echo "switching on https_proxy"
    sed -i 's/#export https_proxy=http:\/\/127.0.0.1:8000/export https_proxy=http:\/\/127.0.0.1:8000/g' /home/$1/.bashrc
elif grep "export https_proxy=http://127.0.0.1:8000" -q /home/$1/.bashrc; then
    echo "switching off https_proxy"
    sed -i 's/export https_proxy=http:\/\/127.0.0.1:8000/#export https_proxy=http:\/\/127.0.0.1:8000/g' /home/$1/.bashrc
    unset https_proxy
else
    echo "export https_proxy=http://127.0.0.1:8000" >> /home/$1/.bashrc
    echo "adding https_proxy to bashrc"
fi

echo "please run source ~/.bashrc or unset http_proxy/https_proxy for bash updating"
