#! /bin/bash

SCRIPT_DIR=$(pwd)

pushd ~ > /dev/null || echo "pushd ~ failed"

####################################################

# Download golang
wget https://go.dev/dl/go1.19.5.linux-amd64.tar.gz

# Remove any previous Go installation
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.19.5.linux-amd64.tar.gz

# Add /usr/local/go/bin to the PATH environment variable.
echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc

# Verify that Go installation
go version

# clear env
rm go1.19.5.linux-amd64.tar.gz

####################################################

echo "Golang is installed"

popd > /dev/null || echo "popd failed"