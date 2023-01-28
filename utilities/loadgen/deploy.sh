#!/bin/bash

#docker build -t datawine/deepflow-loadgen .
#docker push datawine/deepflow-loadgen

kubectl apply -f service-pods.yaml
