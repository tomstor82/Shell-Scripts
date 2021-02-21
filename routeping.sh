#!/bin/bash

# Ping script outputting route stats to external log file
#
# Written by Tom Storebø 21/02/2021
#

# Prevents script from running if errors are present in code
set -o errexit
#set -o nounset
set -o pipefail

# Default logfile location and name
LOGFILE=~/routeping.log;

# Logfile size max lines
LOGSIZE=500;

# Exit errors
function err0() {
	printf '\nRouteping logs ping statistics along the route to specified destination at user specified intervals.\n
	Default time interval is hourly, if no user argument is passed.\n
usage: routeping [-h] [--help] [-l] [--log] [status] [stop] [--stop] [ip,host] [interval] \n
default logfile is ~/routeping.log (can be changed in script line 14).\n
Valid arguments for IP is IPv4, IPv6 or hostname.
Valid arguments for time are digits with or without dot separator, followed by denominator.
s/m/h for respectively seconds, minutes and hours.\n
	Example 1: routeping 9.9.9.9 1.5h
	Example 2: routeping yahoo.com
	Example 3: routeping status
	Example 4: routeping stop';
	exit 0;
}
function err1() {
	printf "\nrouteping: Missing interval argument -- '1'\nTry 'routeping --help' for more information.\n\n"
	exit 1;
}
function err2() {
	printf "\nrouteping: Missing destination argument -- '2'\nTry 'routeping --help' for more information.\n\n"
	exit 2;
}
function err3() {
	printf "\nrouteping: Unknown arguments -- '3'\nTry 'routeping --help' for more information.\n\n"
	exit 3;
}

# First argument

if [[ $1 == '-h' ]] || [[ $1 == '--help' ]]; then
	err0;

elif [[ $1 == '-l' ]] || [[ $1 == '--log' ]]; then
	tail -f $LOGFILE;
	exit 0;

elif [[ $1 == 'status' ]]; then
	PROC=($(ps -A | grep -o routeping));
	if [[ "${#PROC[@]}" -gt 2 ]]; then
		printf "\nServices running. Use 'routeping stop' to terminate\n\n";
		exit 0;
	else
		printf "\nService not running\n\n";
		exit 0;
	fi;

elif [[ $1 == 'stop' ]] || [[ $1 == '--stop' ]]; then
	printf "Stopping all routeping services\n";
	pkill routeping.sh;

elif [ -z $1 ]; then
	err2;

elif [[ $1 =~ ^([0-9]{1,3}\.){3,3}[0-9]{1,3}$ ]]; then
	IP=$1;

else
	err3;
fi;

# Second argument
ipRegEx='([\d]{1,3}[\.]){3,3}[\d]{1,3}';

# No argument received set 1hr interval
if [ -z $2 ]; then
	COUNT=3600;

# Interval filtering
elif [[ $2 =~ ^[0-9]+\.?[0-9]?[smhSMH]$ ]]; then
	DENOMINATOR=$(echo $2 | grep -Poi "[a-z]");
	VALUE=$(echo $2 | grep -Po "[\d]{1,}");
	case $DENOMINATOR in
		s)
		COUNT=$VALUE
		;;
		m)
		COUNT=$(($VALUE * 60))
		;;
		h)
		COUNT=$(($VALUE * 3600))
		;;
		*)
		err3
		;;
	esac
else
	err3;
fi;

# Creating route array
arr=($(pinglog $IP -r));

# create file if non existing
touch $LOGFILE;
# check if logfile has entries, if so back-up
if [ -s $LOGFILE ]; then
	# Create log 1 + 2 if they don't exist
	touch ${LOGFILE}.1 && touch ${LOGFILE}.2;
	cat ${LOGFILE}.1 > ${LOGFILE}.2;
	cat $LOGFILE > ${LOGFILE}.1;
fi;

function logLines() {
	wc -l $LOGFILE | grep -Po '\d+';
}

function maintainLog() {
	while true
	do
		sleep $COUNT;
		# delete first lines every minute, when log exceedes set size
		if [[ $(logLines) -gt $LOGSIZE ]]; then
			deleteLines=$(($(logLines)-$LOGSIZE));
			sed -i "1,${deleteLines}d" "$LOGFILE";
		fi;
	done;
}

function summary() {
	while true
	do
		sleep 20;
		for i in "${arr[@]}"
		do
			:
			printf "\n>> Ping ${arr[i]} Hourly Summary << $(date | awk '{print $2,$3,$4}')\n" >> $LOGFILE;
			kill -SIGQUIT $(ps -fC ping | grep ${arr[i]} | awk '{print $2}');
		done;
	done;
}

# Notification of logfile
echo "Ping summary stored in file $LOGFILE";

# Make initial function call
maintainLog & summary &
# creating ping loop
for i in "${arr[@]}"
do
	:
	ping -q ${arr[i]} 2>> $LOGFILE &
done;