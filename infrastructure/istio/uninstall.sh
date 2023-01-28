#!/bin/bash

SCRIPT_DIR=$(pwd)

pushd ~ > /dev/null

####################################################

# Disable Istio mTLS
kubectl delete -f - <<EOF
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: "default"
  namespace: "istio-system"
spec:
  mtls:
    mode: DISABLE
EOF

istioctl uninstall --set profile=demo --purge -y

# Remove Istio
istioctl uninstall --purge

# Remove namespace istio-system
kubectl delete namespace istio-system

# Remove configmap istio-ca-root-cert
kubectl delete configmap istio-ca-root-cert

####################################################

echo "Istio is uninstalled."

popd > /dev/null

