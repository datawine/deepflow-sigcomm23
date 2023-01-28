#!/bin/bash

SCRIPT_DIR=$(pwd)

pushd ~ > /dev/null

####################################################

# Remove Istio
istioctl uninstall --purge

# Remove namespace istio-system
kubectl delete namespace istio-system

# Remove configmap istio-ca-root-cert
kubectl delete configmap istio-ca-root-cert

# rm files
rm -rf istio-*

####################################################

echo "Istio is uninstalled."

popd > /dev/null

