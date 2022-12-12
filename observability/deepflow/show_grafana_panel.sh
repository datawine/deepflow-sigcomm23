#!/bin/sh

pushd ~ > /dev/null

####################################################

NODE_PORT=$(kubectl get --namespace deepflow -o jsonpath="{.spec.ports[0].nodePort}" services deepflow-grafana)
NODE_IP=$(kubectl get nodes -o jsonpath="{.items[0].status.addresses[0].address}")
echo -e "Grafana URL: http://$NODE_IP:$NODE_PORT  \nGrafana auth: admin:deepflow"
echo -e "\nIf you would like to access via SSH tunnel, please run the following command on your local computer:"
echo -e "\n   ssh -L $NODE_PORT:localhost:$NODE_PORT $USER@$NODE_IP"
echo -e "\nThen open your browser and go to <http://localhost:$NODE_PORT>"

####################################################

popd > /dev/null