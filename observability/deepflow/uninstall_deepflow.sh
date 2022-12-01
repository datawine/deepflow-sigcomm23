#!/bin/sh

pushd .

cd ~

####################################################

# Uninstall deepflow-ctl

sudo rm -f /usr/bin/deepflow-ctl

# Undeploy All-in-One DeepFlow

helm uninstall deepflow --namespace deepflow

kubectl delete namespace deepflow

####################################################

echo "DeepFlow is uninstalled."

popd > /dev/null