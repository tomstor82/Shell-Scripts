#!/usr/bin/bash

#ANSI colur code variables
red="\x1B[0;91m";
yellow="\x1B[0;93m";
blue="\x1B[0;94m";

reset="\033[0m";

# Add different temp sensors to array
tempArr=($(cat $(find /sys/devices/ -name 'temp1_input' 2> /dev/null)));

# Iterate over array and calculate a floating value with awk
#for i in ${tempArr[@]}; do
#    if [[ $i = ${tempArr[0]} ]]; then
#         sensor="CPU: ";
#    else sensor="GPU: ";
#    fi;
#    echo $sensor $(awk "BEGIN {print $i/1000}") C;
#done;

for (( i=0; i<${#tempArr[@]}; i++ )); do
    if [[ $i = 0 ]]; then
        sensor="CPU: ";
    else sensor="GPU: ";
    fi;
    if [[ ${tempArr[$i]} > 80 ]]; then
        color=$red;
    elif [[ ${tempArr[$i]} > 50 ]]; then
        color=$yellow;
    else color=$blue;
    fi;
    echo -e ${sensor} $(awk "BEGIN { print ${tempArr[$i]}/1000 }" )$'\xc2\xb0'C;
done;