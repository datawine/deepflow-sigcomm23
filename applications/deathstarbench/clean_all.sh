#!/bin/false

SCRIPT_DIR=$(pwd)

pushd ~ > /dev/null

####################################################

# Undeploy all applications

source $SCRIPT_DIR/hotel_reservation/undeploy.sh

# Clean files

rm -rf ./DeathStarBench/

####################################################

echo "DeathStarBench is cleaned."

popd > /dev/null