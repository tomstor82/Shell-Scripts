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

# Features to be considered
# 1. Multiple Destination Arguments
# 2. Verbose and silent mode * use loop to iterate over arguments $@

# ********** Investigate if script can be run simultaneously without causing error to file writing *************

# Default logfile location and name
LOGFILE=~/ping.log;

# Logfile size max lines
LOGSIZE=100;

# Check arguments
if [[ $1 == '-h' ]] || [[ $1 == '--help' ]]
then
	printf '\npinglog logs statistics at specified time interval to external file,
and can display alternative traceroute isolated IPs.\n
usage: pinglog [-h] [--help] [-l] [--log] [ip/host...] [-r] [--route] [time]\n
default logfile is ~/ping.log (can be changed in script line 21).\n
Valid arguments for IP is IPv4, IPv6 and hostname.
Valid arguments for time are digits followed by denominator.
s/m/h for respectively seconds, minutes and hours.\n
	Example 1: pinglog 9.9.9.9 1.5h
	Example 2: pinglog yahoo.com -r;
	Example 3: pinglog --log\n';
	exit;
elif [[ $1 == '-l' ]] || [[ $1 == '--log' ]]
then
	tail -f $LOGFILE;
	exit;
elif [ -z $1 ]
then
	printf "Please supply IP or Host Name for ping destination, as first argument\n
	Example: pinglog 7.7.7.7 10m\n";
	exit;
else
	IP=$1;
fi;

if [[ $2 == '-r' ]] || [[ $2 == '--route' ]]
then
	traceroute $IP | grep -Po '\(\d+\.\d+\.\d+\.\d+\)' | grep -v "$IP" | grep -Po '\d+\.\d+\.\d+\.\d+';
	exit;
elif [ -z $2 ]
then
	printf "Please supply time interval for writing to log file, as second argument\n
	Formats accepted are: 30s/10m/1h\n
	Example: pinglog 7.7.7.7 30s\n";
	exit;
else
	SLEEP=$2;
fi;

# Search arguments for flags
for flag in $@
do
	if [[ $flag == '-v' ]] || [[ $flag == '--verbose' ]]
	then
		verbose=true;
	fi;
done;

# ************ Needs to be tested ******************
# Switch statement
#for flag in $@
#do
#	case "$flag" in
#	'-v') verbose=true;;
#	'--verbose') verbose=true;;
#	'-h') help=true;;
#	'--help') help=true;;
#	'-r') route=true;;
#	'--route') route=true;;
#	'-l') log=true;;
#	'--log') log=true;;
#	*) ;;
#	esac;
#done;


# check if logfile has entries and if so backup
if [ -n $LOGFILE ]
then
	cat $LOGFILE > ${LOGFILE}.1;
fi;

# function for statistics and timestamp
function pingStats() {
	if [[ $verbose == true ]]
	then
		ping -O "$IP" 2>> "$LOGFILE" &
	else
		ping -O "$IP" 1> /dev/null 2>> "$LOGFILE" &
	fi;

	# store process id to pid variable
	pid=$!;
	# declare command variable as non empty string to allow for loop to start
	command="1";

	# do loop until command variable length is Zero
	until [ -z command ]
	do
		# set interval
		sleep "${SLEEP}";
		# timestamp and send quit signal to trigger ping status
		echo "Destination $IP on $(date)" >> $LOGFILE &&\
		sleep 2;
		kill -SIGQUIT "$pid";
		# delete first two lines of log when exceeding set log size
		if [[ $logLines -gt $LOGSIZE ]]
		then
			sed -i '1,2d' "$LOGFILE";
		fi;
		# update size of logfile
		logLines=$(wc -l $LOGFILE | grep -Po '\d+');
		# update command variable
		command=$(ps "$pid" | grep -o ping);
	done;
	tail -f $LOGFILE;
}

# Notification of logfile
echo "Ping summary stored in file $LOGFILE";

# Running script
pingStats;
#if [[ $verbose == true ]]
#then
#	ping -O "$IP" 2>> "$LOGFILE" & pingStats;	
#else
#	ping -O "$IP" 1> /dev/null 2>> "$LOGFILE" & pingStats;
#fi;