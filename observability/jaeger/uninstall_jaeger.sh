#!/bin/sh

pushd .

cd ~

####################################################

helm uninstall jaeger -n jaeger
kubectl delete namespace jaeger

####################################################

echo "Jaeger is uninstalled."

popd > /dev/null