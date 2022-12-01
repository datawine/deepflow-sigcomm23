#!/bin/sh

pushd .

cd ~

####################################################

# Undeploy all applications

. ~/deepflow-sigcomm23/applications/deathstarbench/undeploy_hotel_reservation.sh

# Clean files

rm -rf ./DeathStarBench/

####################################################

echo "DeathStarBench is cleaned."

popd > /dev/null