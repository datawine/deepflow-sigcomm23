#!/bin/false

SCRIPT_DIR=$(pwd)

pushd ~ > /dev/null

####################################################

# Copy config file from the directory where the script is located to current directory
cp $SCRIPT_DIR/main.yaml .

# Uneploy Sptring Boot Demo
kubectl delete -f main.yaml

# Remove config file
rm main.yaml

####################################################

echo "Spring Boot Demo is undeployed."

popd > /dev/null