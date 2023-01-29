#!/bin/bash

SCRIPT_DIR=$(pwd)

pushd ~ > /dev/null

####################################################

# Enable sidecar injection
kubectl label namespace default istio-injection=enabled

# Reconfigure Istio, set enableTracing to false
istioctl install -f ./tracing.yaml -y

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

# Install deepflow bookinfo microservice
kubectl apply -f bookinfo.yaml

# Check bookinfo installation
kubectl get pods
kubectl get svc

# Print productpage addr
IP_ADDR=$(kubectl get service/productpage -o jsonpath='{.spec.clusterIP}')
echo $IP_ADDR

# Deploy storage class
kubectl apply -f https://openebs.github.io/charts/openebs-operator.yaml
## config default storage class
kubectl patch storageclass openebs-hostpath  -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

# Deploy DeepFLow
helm repo add deepflow https://deepflowys.github.io/deepflow
helm repo update deepflow # use `helm repo update` when helm < 3.7.0
helm install deepflow -n deepflow deepflow/deepflow --create-namespace

# Check deepflow installation
kubectl -n deepflow get pods
kubectl -n deepflow get svc

kubectl -n deepflow logs deepflow-agent-r6txl

# get
NODE_PORT=$(kubectl get --namespace deepflow -o jsonpath="{.spec.ports[0].nodePort}" services deepflow-grafana)
NODE_IP=$(kubectl get nodes -o jsonpath="{.items[0].status.addresses[0].address}")
echo -e "Grafana URL: http://$NODE_IP:$NODE_PORT  \nGrafana auth: admin:deepflow"


####################################################

echo "DeepFlow Istio Bookinfo Demo is deployed."

popd > /dev/null