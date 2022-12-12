#!/bin/sh

pushd ~ > /dev/null

echo "Testing Spring Boot Demo..."

####################################################

# Install wrk2 if wrk2 is not installed
if ! command -v wrk &> /dev/null
then
    echo "Installing wrk2..."

    # Install dependencies
    sudo apt-get update
    sudo apt-get install -y build-essential libssl-dev git zlib1g-dev

    # Clone wrk2
    git clone https://github.com/giltene/wrk2.git

    # Build wrk2
    make --directory=wrk2

    # Install wrk2
    sudo cp wrk2/wrk /usr/local/bin
fi

# Forward the entry port
kubectl port-forward service/foo-svc 10080:80 -n deepflow-ebpf-spring-demo > /dev/null 2> /dev/null &

# Sleep for 1 second
sleep 1

# Test with wrk2
wrk --connections 16 --duration 30s --latency --rate 2k http://localhost:10080

# Kill the port-forward process when the script exits
kill $!

####################################################

echo "Spring Boot Demo is tested."

popd > /dev/null