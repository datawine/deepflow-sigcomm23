#!/bin/false

SCRIPT_DIR=$(pwd)

pushd ~ > /dev/null

####################################################

# Deploy Sptring Boot Demo
kubectl apply -f $SCRIPT_DIR/main.yaml

####################################################

echo "Spring Boot Demo is deployed."

popd > /dev/null