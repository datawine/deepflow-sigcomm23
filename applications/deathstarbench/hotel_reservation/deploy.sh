#!/bin/sh

set -o errexit

pushd .

cd ~

####################################################

# Clone if not exist

if [ ! -d ./DeathStarBench ]; then
    git clone https://github.com/delimitrou/DeathStarBench.git
fi

# Install prerequisites

sudo apt install -y libssl-dev libz-dev luarocks

sudo luarocks install luasocket

# Build the application

./DeathStarBench/hotelReservation/kubernetes/scripts/build-docker-images.sh

docker buildx rm mybuilder

# Deploy the application

kubectl apply -Rf ./DeathStarBench/hotelReservation/kubernetes/

####################################################

echo "DeathStarBench Hotel Reservation is deployed."

popd > /dev/null