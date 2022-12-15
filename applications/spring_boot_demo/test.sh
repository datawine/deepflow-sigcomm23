#!/bin/false

pushd ~ > /dev/null

####################################################

# Return if some parameters are missing
if [ -z "$1" ]; then
    echo "Usage: source test.sh <rate>"
    popd > /dev/null
    return 0
fi

IP_ADDR=$(kubectl get service/foo-svc -n deepflow-ebpf-spring-demo -o jsonpath='{.spec.clusterIP}')

kubectl create job -n deepflow-ebpf-spring-demo my-load-generator --image=futrime/wrk2 -- \
    wrk --connections 16 --duration 30s --latency --rate $1 http://$IP_ADDR

echo "Waiting for job to complete..."

kubectl wait -n deepflow-ebpf-spring-demo --for=condition=complete --timeout=60s job/my-load-generator

kubectl logs -n deepflow-ebpf-spring-demo job/my-load-generator

kubectl delete job -n deepflow-ebpf-spring-demo my-load-generator

####################################################

echo "Spring Boot Demo is tested."

popd > /dev/null