#!/bin/bash

docker build -t datawine/deepflow-testpod .
docker push datawine/deepflow-testpod

kubectl apply -f testpod.yaml
kubectl exec -it testpod -- /bin/bash

for i in `seq 1 100`; do curl -s 10.110.75.125:9080/productpage | grep -o "<title>.*</title>"; done
