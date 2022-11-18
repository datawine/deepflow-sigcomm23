# download istio package
curl -L https://istio.io/downloadIstio | sh -
cd istio-1.16.0
export PATH=$PWD/bin:$PATH

# install istio
cd ~
istioctl install --set profile=demo -y
# automatically inject sidecar for namespace default
kubectl label namespace default istio-injection=enabled