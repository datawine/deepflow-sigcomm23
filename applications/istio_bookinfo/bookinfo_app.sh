# run bookinfo app
kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml
# add istio gateway
kubectl apply -f samples/bookinfo/networking/bookinfo-gateway.yaml
# check everything works well
istioctl analyze

# get ingress port and host
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
# note: this might be the public ip, we can use internal ip instead by finding the correspond pod's node's internal ip
export INGRESS_HOST=$(kubectl get po -l istio=ingressgateway -n istio-system -o jsonpath='{.items[0].status.hostIP}')

# check: visit http://$INGRESS_HOST:$INGRESS_PORT/productpage on browser