#!/bin/sh

pushd .

cd ~

####################################################

# Deploy Sptring Boot Demo

#https://raw.githubusercontent.com/deepflowys/deepflow-demo/main/DeepFlow-EBPF-Sping-Demo/deepflow-ebpf-spring-demo.yaml
kubectl apply -f deepflow-ebpf-spring-demo.yaml

####################################################

echo "Spring Boot Demo is deployed."

popd > /dev/null