#!/bin/false

SCRIPT_DIR=$(pwd)

pushd ~ > /dev/null

####################################################

# Copy config file from the directory where the script is located to current directory
cp $SCRIPT_DIR/main.yaml .

# Deploy Sptring Boot Demo
kubectl apply -f main.yaml

# Remove config file
rm main.yaml

####################################################

echo "Spring Boot Demo is deployed."

popd > /dev/null