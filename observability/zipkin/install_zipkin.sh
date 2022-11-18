# apply in-memory zipkin along with istio-system
kubectl apply -f install_zipkin.yaml

# use port-forward to visit zipkin UI
# need to change the pod name accordingly
kubectl port-forward -n istio-system zipkin-854994fb96-tqtvr 9411:9411