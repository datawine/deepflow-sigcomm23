#! /bin/bash

SCRIPT_DIR=$(pwd)

####################################################

# Install protobuf-compiler
sudo apt install -y protobuf-compiler

# Check protobuf version
protoc --version

####################################################

echo "Protobuf is installed"
