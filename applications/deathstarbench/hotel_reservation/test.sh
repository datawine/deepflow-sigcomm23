#!/bin/sh

pushd .

cd ~

echo "Start testing DeathStarBench..."

####################################################

# Make wrk if not exist
if [ ! -f ~/DeathStarBench/hotelReservation/wrk2/wrk ]; then
    make --directory="~/DeathStarBench/hotelReservation/wrk2"
fi

# Start testing
# Please refer to <https://github.com/delimitrou/DeathStarBench/tree/master/hotelReservation/kubernetes>
./DeathStarBench/hotelReservation/wrk2/wrk \
    -D exp \
    -t 1 \
    -c 1 \
    -d 30 \
    -L \
    -s ./DeathStarBench/hotelReservation/wrk2/scripts/hotel-reservation/mixed-workload_type_1.lua \
    http://10.98.24.1:5000 \
    -R 1

####################################################

echo "DeathStarBench Hotel Reservation is tested."

popd > /dev/null