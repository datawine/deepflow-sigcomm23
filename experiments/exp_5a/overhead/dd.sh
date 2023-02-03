#!/bin/bash

sum=0
for i in {1..20}
do
  # Measure the time in seconds needed to execute the command
  start=$(date +%s%N)
  dd if=/dev/zero of=/dev/null bs=1 count=100k
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