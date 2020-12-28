#!/bin/bash

# Ping script outputting stats to external log file
#
# Written by Tom Storebø 27/12/2020
#
# Two arguments are required
#
# First argument is the address to ping
# Second argument is the time interval in minutes for sending statistics to external log file
#
# Logfile location and name
logfile=~/ping.log;
logLen=50;

# Check if arguments are passed
if [ -z $1 ]
then
	echo "Please supply IP or Host Name for ping destination, as first argument";
	echo "Example: pinglog 7.7.7.7 10"
	exit;
else
	IP=$1;
fi;
if [ -z $2 ]
then
	echo "Please supply interval in minutes for writing to log file, as second argument";
	echo "Example: pinglog 7.7.7.7 10"
	exit;
else
	SLEEP=$2;
fi;

# check if logfile has entries and if so backup
if [ -n $logfile ]
then
	cat $logfile > ${logfile}.1;
fi;

# function for statistics and timestamp
pingStats() {
	# store process id to PID variable
	PID=$!;

	# add header and clear logfile
	echo "Destination $IP" > "$logfile";
	
	# declare command variable as non empty string to allow for loop to start
	command='start';

	# do loop until command variable length is Zero
	until [ -z command ]
	do
		# set interval
		sleep "${SLEEP}m";
		# timestamp and send quit signal to trigger ping status
		date >> $logfile & kill -SIGQUIT "$PID";
		# delete line 2 and 3 leaving line 1 as it contains the header, when log exceeds 50 lines
		if [[ $logLines -gt 50 ]]
		then
			sed -i '2,3d' "$logfile";
		fi;
		# update size of logfile
		logLines=$(wc -l $logfile | grep -Po '\d+');
		# update command variable
		command=$(ps "$PID" | grep -o ping);
	done;
}

# Starting ping application
ping -O "$IP" 2>> "$logfile" & pingStats;