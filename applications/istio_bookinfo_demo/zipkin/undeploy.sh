#!/bin/bash

SCRIPT_DIR=$(pwd)

pushd ~ > /dev/null

####################################################

# Uninstall official bookinfo microservice
./cleanup.sh

# Deploy zipkin
kubectl -n istio-system delete -f zipkin.yaml

####################################################

echo "Istio Bookinfo Demo is undeployed."

popd > /dev/null