#!/bin/sh

pushd .

cd ~

####################################################

if [ ! -d ./DeathStarBench ]; then
    git clone https://github.com/delimitrou/DeathStarBench.git
fi

kubectl delete -Rf ./DeathStarBench/hotelReservation/kubernetes/

####################################################

echo "DeathStarBench Hotel Reservation is undeployed."

popd > /dev/null