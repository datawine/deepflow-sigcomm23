#!/bin/false

SCRIPT_DIR=$(pwd)

pushd ~ > /dev/null

####################################################

# Uneploy Sptring Boot Demo
kubectl delete -f $SCRIPT_DIR/main.yaml

####################################################

echo "Spring Boot Demo is undeployed."

popd > /dev/null