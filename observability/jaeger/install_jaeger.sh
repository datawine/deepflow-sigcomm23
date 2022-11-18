# install jaeger using helm
# ref: https://github.com/jaegertracing/helm-charts/tree/main/charts/jaeger
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts

# if istio is installed and default namespace is labeled
# then jarger should be installed on another namespace to avoid sidecars
# TODO: still uncertain how to collect data from istio, will deployed in istio-system namespace work?
kubectl create namespace jaeger
helm install jaeger jaegertracing/jaeger -n jaeger

# wait until all the components are ready
# visit the jaeger UI 
export POD_NAME=$(kubectl get pods --namespace jaeger -l "app.kubernetes.io/instance=jaeger,app.kubernetes.io/component=query" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward --namespace jaeger $POD_NAME 8080:16686
