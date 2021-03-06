#!/bin/bash

#ANSI colur code variables \e \033 \xb1
red="\e[91m";
yellow="\e[93m";
green="\e[92m";

reset="\e[0m";

# Degree symbol followed by C
denominator="\xc2\xb0C";

# Iteration
while true; do    
    # Add different temp sensors to array
    tempArr=($(cat $(find /sys/devices/ -name 'temp1_input' 2> /dev/null)));
    
    for (( i=0; i<${#tempArr[@]}; i++ )); do
        if [[ $i = 0 ]]; then
            sensorType="CPU: ";
        else sensorType="GPU: ";
        fi;
        if [[ ${tempArr[$i]} > 80 ]]; then
            color=$red;
        elif [[ ${tempArr[$i]} > 50 ]]; then
            color=$yellow;
        else color=$green;
        fi;
        sensor=$(awk "BEGIN { print ${tempArr[$i]}/1000 }");
        echo -e "${color}${sensorType}${sensor}${denominator}${reset}";
    done;

    # Refresh interval and refresh number of lines detected by tempArr
    sleep 2;
    for (( l=${#tempArr[@]}; l > 0; l-- )); do
        tput cuu1;  # cursor up one line
        tput el;    # clear line
    done;
done;