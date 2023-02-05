#!/bin/bash

if [ ! -d "bin" ]; then
  mkdir bin
fi

src=""
dst=""
if [ "$1" = "write" ]; then
  src="./src/write5.c"
  dst="./bin/write5"
  gcc -o $dst $src
elif [ "$1" = "read" ]; then
  src="./src/read5.c"
  dst="./bin/read5"
  gcc -o $dst $src
elif [ "$1" = "sendmsg" ]; then
  src="./src/sendmsg5.c"
  dst="./bin/sendmsg5"
  gcc -o $dst $src
elif [ "$1" = "sendmmsg" ]; then
  src="./src/sendmmsg5.c"
  dst="./bin/sendmmsg5"
  gcc -o $dst $src
elif [ "$1" = "recvmsg" ]; then
  src="./src/recvmsg5.c"
  dst="./bin/recvmsg5"
  gcc -o $dst $src
elif [ "$1" = "recvmmsg" ]; then
  src="./src/recvmmsg5.c"
  dst="./bin/recvmmsg5"
  gcc -o $dst $src
elif [ "$1" = "writev" ]; then
  src="./src/writev5.c"
  dst="./bin/writev5"
  gcc -o $dst $src
elif [ "$1" = "readv" ]; then
  src="./src/readv5.c"
  dst="./bin/readv5"
  gcc -o $dst $src
elif [ "$1" = "sendto" ]; then
  src="./src/sendto5.c"
  dst="./bin/sendto5"
  gcc -o $dst $src
elif [ "$1" = "recvfrom" ]; then
  src="./src/recvfrom5.c"
  dst="./bin/recvfrom5"
  gcc -o $dst $src
elif [ "$1" = "ssl_read" ]; then
  gcc -o ./bin/ssl_read ./src/ssl_read.c -lssl -lcrypto
  dst="./bin/ssl_read"
elif [ "$1" = "ssl_write" ]; then
  gcc -o ./bin/ssl_write ./src/ssl_write.c -lssl -lcrypto
  dst="./bin/ssl_write"
elif [ "$1" = "empty" ]; then
  gcc -o ./bin/empty ./src/empty.c
  dst="./bin/empty"
fi

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