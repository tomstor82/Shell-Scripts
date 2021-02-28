#!/bin/bash

# Add different temp sensors to array
tempArr=($(cat $(find /sys/devices/ -name 'temp1_input' 2> /dev/null)));

# Iterate over array and calculate a floating value with awk
for i in ${tempArr[@]}; do
    if [[ $i = ${tempArr[0]} ]]; then
         sensor="CPU: ";
    else sensor="GPU: ";
    fi;
    echo $sensor $(awk "BEGIN {print $i/1000}") C;
done;