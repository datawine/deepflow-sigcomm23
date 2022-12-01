#!/bin/sh

pushd .

cd ~

####################################################

# Deploy All-in-One DeepFlow

helm repo add deepflow https://deepflowys.github.io/deepflow

helm repo update deepflow

cat << EOF > deepflow-installation-config.yaml
global:
  allInOneLocalStorage: true
EOF

helm install deepflow -n deepflow deepflow/deepflow --create-namespace \
  -f deepflow-installation-config.yaml

rm deepflow-installation-config.yaml

# Install deepflow-ctl

sudo curl -o /usr/bin/deepflow-ctl https://deepflow-ce.oss-cn-beijing.aliyuncs.com/bin/ctl/stable/linux/$(arch | sed 's|x86_64|amd64|' | sed 's|aarch64|arm64|')/deepflow-ctl

sudo chmod a+x /usr/bin/deepflow-ctl

####################################################

echo "DeepFlow is installed."

popd > /dev/null