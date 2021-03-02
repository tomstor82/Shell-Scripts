#!/usr/bin/bash

#ANSI colur code variables
red="\e[91m";
yellow="\e[93m";
blue="\e[94m";

reset="\e[0m";

# Add different temp sensors to array
tempArr=($(cat $(find /sys/devices/ -name 'temp1_input' 2> /dev/null)));

# Degree symbol followed by C
denominator="\xc2\xb0C";

# Iteration
for (( i=0; i<${#tempArr[@]}; i++ )); do
    if [[ $i = 0 ]]; then
        sensorType="CPU: ";
    else sensorType="GPU: ";
    fi;
    if [[ ${tempArr[$i]} > 80 ]]; then
        color=$red;
    elif [[ ${tempArr[$i]} > 50 ]]; then
        color=$yellow;
    else color=$blue;
    fi;
    sensor=$(awk "BEGIN { print ${tempArr[$i]}/1000 }");
    echo -e "${red}${sensorType}${sensor}${denominator}${reset}";
done;