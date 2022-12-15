#!/bin/false

pushd ~ > /dev/null

####################################################

# Return if some parameters are missing
if [ -z "$1" ]; then
    echo "Usage: source test.sh <rate>"
    popd > /dev/null
    return 0
fi

IP_ADDR=$(kubectl get service/productpage -n deepflow-ebpf-istio-demo -o jsonpath='{.spec.clusterIP}')

kubectl create job -n deepflow-ebpf-istio-demo my-load-generator --image=futrime/wrk2 -- \
    wrk --connections 16 --duration 30s --latency --rate $1 http://$IP_ADDR:9080/productpage

echo "Waiting for job to complete..."

kubectl wait -n deepflow-ebpf-istio-demo --for=condition=complete --timeout=60s job/my-load-generator

kubectl logs -n deepflow-ebpf-istio-demo job/my-load-generator

kubectl delete job -n deepflow-ebpf-istio-demo my-load-generator

####################################################

echo "Istio Bookinfo Demo is tested."

popd > /dev/null