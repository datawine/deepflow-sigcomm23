#!/bin/sh

pushd .

cd ~

####################################################

# Download Istio

curl -L https://istio.io/downloadIstio | sh -

pushd .

cd istio-*

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

kubectl apply -f https://raw.githubusercontent.com/deepflowys/deepflow-demo/main/Istio-Bookinfo/bookinfo.yaml

####################################################

echo "Istio Bookinfo Demo is deployed."

popd > /dev/null