#!/bin/sh

pushd .

cd ~

####################################################

# Install prerequisites

sudo apt install -y libssl-dev libz-dev luarocks

sudo luarocks install luasocket

# Deploy the application

if [ ! -d ./DeathStarBench ]; then
    git clone https://github.com/delimitrou/DeathStarBench.git
fi

kubectl apply -Rf ./DeathStarBench/hotelReservation/kubernetes/

####################################################

echo "DeathStarBench Hotel Reservation is deployed."

popd > /dev/null