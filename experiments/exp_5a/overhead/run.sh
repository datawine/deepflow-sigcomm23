#!/bin/bash

if [ ! -d "bin" ]; then
  mkdir bin
fi

src=""
dst=""
if [ "$1" = "write" ]; then
  src="./src/write5.c"
  dst="./bin/write5"
elif [ "$1" = "read" ]; then
  src="./src/read5.c"
  dst="./bin/read5"
elif [ "$1" = "sendmsg" ]; then
  src="./src/sendmsg5.c"
  dst="./bin/sendmsg5"
elif [ "$1" = "sendmmsg" ]; then
  src="./src/sendmmsg5.c"
  dst="./bin/sendmmsg5"
elif [ "$1" = "recvmsg" ]; then
  src="./src/recvmsg5.c"
  dst="./bin/recvmsg5"
elif [ "$1" = "recvmmsg" ]; then
  src="./src/recvmmsg5.c"
  dst="./bin/recvmmsg5"
else
  echo "Invalid argument: $1"
fi

gcc -o $dst $src

echo "About to run $dst"

sum=0
for i in {1..20}
do
  # Measure the time in seconds needed to execute the command
  start=$(date +%s%N)
  $dst
  end=$(date +%s%N)

  # Calculate the elapsed time in nanoseconds
  elapsed_time=$((end-start))

  # Add the elapsed time to the sum
  sum=$((sum + elapsed_time))
done

# Divide the sum by the number of iterations to get the average
average=$((sum / 20))

# Convert the average from nanoseconds to milliseconds
average_ms=$((average / 1000000))

# Output the average system time to the command line
echo "Average time: $average_ms milliseconds"