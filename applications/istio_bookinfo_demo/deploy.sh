#!/bin/false

SCRIPT_DIR=$(pwd)

pushd ~ > /dev/null

####################################################

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

# Deploy Bookinfo Demo
kubectl apply -f $SCRIPT_DIR/main.yaml

####################################################

echo "Istio Bookinfo Demo is deployed."

popd > /dev/null