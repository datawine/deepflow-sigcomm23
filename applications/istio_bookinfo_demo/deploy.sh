#!/bin/false

SCRIPT_DIR=$(pwd)

pushd ~ > /dev/null

####################################################

# Download Istio
curl -L https://istio.io/downloadIstio | sh -

# Set PATH
pushd istio-* > /dev/null
export PATH=$PWD/bin:$PATH
popd > /dev/null

# Install Istio
istioctl install --set profile=demo -y

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