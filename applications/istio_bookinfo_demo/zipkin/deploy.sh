#!/bin/bash

SCRIPT_DIR=$(pwd)

pushd ~ > /dev/null

####################################################

# Enable sidecar injection
kubectl label namespace default istio-injection=enabled

# Reconfigure Istio, set sampling to 100.0
istioctl install -f ./tracing.yaml

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

# Print productpage addr
IP_ADDR=$(kubectl get service/productpage -o jsonpath='{.spec.clusterIP}')
echo $IP_ADDR

# Deploy zipkin
kubectl -n istio-system apply -f zipkin.yaml

# Port forward
kubectl port-forward -n istio-system svc/zipkin 9411:9411 --address="0.0.0.0"

####################################################

echo "Istio Bookinfo Demo is deployed."

popd > /dev/null