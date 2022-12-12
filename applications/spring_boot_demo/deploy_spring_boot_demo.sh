#!/bin/sh

pushd ~ > /dev/null

####################################################

# Deploy Sptring Boot Demo

kubectl apply -f https://raw.githubusercontent.com/deepflowys/deepflow-demo/main/DeepFlow-EBPF-Sping-Demo/deepflow-ebpf-spring-demo.yaml

####################################################

echo "Spring Boot Demo is deployed."

popd > /dev/null