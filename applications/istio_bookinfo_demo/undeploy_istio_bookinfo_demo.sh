#!/bin/sh

pushd .

cd ~

####################################################

# Download Istio if not already downloaded

if [ ! -d istio-* ]; then
  curl -L https://istio.io/downloadIstio | sh -
fi

# Undeploy Bookinfo Demo

kubectl delete -f https://raw.githubusercontent.com/deepflowys/deepflow-demo/main/Istio-Bookinfo/bookinfo.yaml

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

####################################################

echo "Istio Bookinfo Demo is undeployed."

popd > /dev/null