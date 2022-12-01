#!/bin/sh

pushd .

cd ~

####################################################

# Uneploy Sptring Boot Demo

kubectl delete -f https://raw.githubusercontent.com/deepflowys/deepflow-demo/main/DeepFlow-EBPF-Sping-Demo/deepflow-ebpf-spring-demo.yaml

####################################################

echo "Spring Boot Demo is undeployed."

popd > /dev/null