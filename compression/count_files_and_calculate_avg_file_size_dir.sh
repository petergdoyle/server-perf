#!/bin/sh

dir=$1
find $dir -type f -printf '%s\n' | awk '{s+=$0} END {printf "Count: %u\nAverage size: %.2f\n", NR, s/NR/1000}'
