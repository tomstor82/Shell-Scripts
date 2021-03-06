#!/bin/bash

# Prevents script from running if there are errors in it
set -o errexit
#set -o nounset
set -o pipefail

EXAMPLE="Example: 'lhost ~/Documents/index.html'\n\n";

# Run script if argument is received
# ********** if [[ -n $# ]]; then ************* ADD POSSIBILITY TO WORK WITH MORE THAN ONE ARG

if [[ $1 =~ ^.+\.(html||php||jsx||js||css||scss)$ ]]; then
	if [[ $1 =~ ^.+\.html$ ]]; then
		echo 4109 | sudo -S cp $1 /var/www/html/index.html;
	else echo 4109 | sudo -S cp $1 /var/www/html/;
	fi;
# Otherwise notify user
elif [ -z $1 ]; then
	printf "\nlhost: Missing file argument -- '1'\n\nRequires argument to copy file to the Apache Server directory.\n\n${EXAMPLE}"
	exit 1;
else
    printf "\nlhost: Wrong file extension -- '2'\n\nRequires html or php file extension.\n\n${EXAMPLE}"
	exit 2;
fi;