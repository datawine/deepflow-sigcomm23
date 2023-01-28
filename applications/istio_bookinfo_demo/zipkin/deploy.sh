#!/bin/bash

SCRIPT_DIR=$(pwd)

pushd ~ > /dev/null

####################################################

# Enable sidecar injection
kubectl label namespace default istio-injection=enabled

# Disable Istio mTLS
kubectl apply -f - <<EOF
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: "default"
  namespace: "istio-system"
spec:
  mtls:
    mode: DISABLE
EOF

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