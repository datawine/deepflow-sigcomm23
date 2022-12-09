#!/bin/sh

pushd .

cd ~

####################################################

# Download Istio if not already downloaded

if [ ! -d istio-* ]; then
  curl -L https://istio.io/downloadIstio | sh -
fi

# Activate istioctl

pushd .

cd istio-*

export PATH=$PWD/bin:$PATH

popd > /dev/null

####################################################

echo "istioctl is activated."

popd > /dev/null