#!/bin/bash

SCRIPT_DIR=$(pwd)

pushd ~ > /dev/null

####################################################

# Download Istio
curl -L https://istio.io/downloadIstio | sh -

# Set PATH
pushd istio-* > /dev/null
export PATH=$PWD/bin:$PATH
popd > /dev/null

# Install Istio
istioctl install --set profile=default -y

####################################################

echo "Istio Bookinfo Demo is deployed."

popd > /dev/null