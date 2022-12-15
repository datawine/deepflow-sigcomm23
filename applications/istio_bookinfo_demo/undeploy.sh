#!/bin/sh

SCRIPT_DIR=$(pwd)

pushd ~ > /dev/null

####################################################

# Download Istio if not already downloaded

if [ ! -d istio-* ]; then
  curl -L https://istio.io/downloadIstio | sh -
fi

# Undeploy Bookinfo Demo
kubectl delete -f $SCRIPT_DIR/main.yaml

# Uninstall Istio
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

# Remove Istio files
rm -rf istio-*

# Remove namespace istio-system
kubectl delete namespace istio-system

# Remove configmap istio-ca-root-cert
kubectl delete configmap istio-ca-root-cert

####################################################

echo "Istio Bookinfo Demo is undeployed."

popd > /dev/null