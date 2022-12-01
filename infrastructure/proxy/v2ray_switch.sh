#!/bin/bash

status=$(sudo systemctl is-active v2ray)

if [ "$status" = "inactive" ]; then
    echo "v2ray is inactive, switching it to active"
    sudo systemctl start v2ray
elif [ "$status" = "active" ]; then
    echo "v2ray is active, switching it to inactive"
    sudo systemctl stop v2ray
else
    echo "v2ray is in some other state"
fi

echo "current v2ray status is $(sudo systemctl is-active v2ray)"