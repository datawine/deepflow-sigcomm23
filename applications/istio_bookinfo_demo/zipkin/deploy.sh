#!/bin/bash

SCRIPT_DIR=$(pwd)

pushd ~ > /dev/null

####################################################

# Enable sidecar injection
kubectl label namespace default istio-injection=enabled

#

curl -L https://istio.io/downloadIstio | sh -
cd istio-*
export PATH=$PWD/bin:$PATH
istioctl install --set profile=default -y


# Install official bookinfo microservice
kubectl apply -f bookinfo.yaml

# Check installation
kubectl get pods
kubectl get svc

kubectl exec -it $(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}') -c ratings -- curl productpage:9080/productpage | grep -o "<title>.*</title>"


curl -s "http://${GATEWAY_URL}/productpage" | grep -o "<title>.*</title>"

####################################################

echo "Istio Bookinfo Demo is deployed."

popd > /dev/null