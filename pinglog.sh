#!/bin/bash

# Ping script outputting stats to external log file
#
# Written by Tom Storebø 27/12/2020
#
# As there appears to be a bug in the terminal handling the "SIGQUIT" signal, I've decided to start and stop a "quiet" ping session at set intervals,
# and start a new ping process. This to allow for proper summary logging.

# Default logfile location and name
LOGFILE=~/ping.log;

# Logfile size max lines
LOGSIZE=100;

# Exit errors
function err0() {
	printf '\nPinglog logs statistics at specified time interval to external file,
and can display alternative traceroute isolated IP addresses.\n
usage: pinglog [-h] [--help] [-l] [--log] [status] [stop] [--stop] [ip/host] [-r] [--route] [interval] \n
default logfile is ~/ping.log (can be changed in script line 11).\n
Valid arguments for IP is IPv4, IPv6 or hostname.
Valid arguments for time are digits with or without dot separator, followed by denominator.
s/m/h for respectively seconds, minutes and hours.\n
	Example 1: pinglog 9.9.9.9 1.5h
	Example 2: pinglog yahoo.com -r
	Example 3: pinglog --log
	Example 4: pinglog stop\n';
	exit 0;
}
function err1() {
	printf "pinglog: Missing interval argument -- '1'\nTry 'pinglog --help' for more information.\n"
	exit 1;
}
function err2() {
	printf "pinglog: Missing destination argument -- '2'\nTry 'pinglog --help' for more information.\n"
	exit 2;
}
function err3() {
	printf "pinglog: Unknown arguments -- '3'\nTry 'pinglog --help' for more information.\n"
	exit 3;
}

# First argument variable

if [[ $1 == '-h' ]] || [[ $1 == '--help' ]]; then
	err0;

elif [[ $1 == '-l' ]] || [[ $1 == '--log' ]]; then
	less +F $LOGFILE;
	exit 0;

elif [[ $1 == 'status' ]]; then
	if [[ -z $(ps -A | grep -o 'pinglog.sh') ]]; then
		printf "Service not running\n";
	else
		printf "Services running. Use 'pinglog stop' to terminate\n"; # THIS APPEARS ALL THE TIME
	exit 0;
	fi;
	
elif [[ $1 == 'stop' ]] || [[ $1 == '--stop' ]]; then
	printf "Stopping all pinglog services\n";
	until [[ $remPID == 0 ]]
	do
		# Read PID from line 1 of file
		kID=$(sed -n '1p' ~/scripts/.ping.pid);
		# Kill Process
		kill "$kID" 2> /dev/null;
		# Remove first line from file as we've killed the process now
 		sed -i '1,1d' ~/scripts/.ping.pid
		# Check how many lines file now contains
		remPID=$(wc -l ~/scripts/.ping.pid | grep -Po '\d+');
	done;
	# Kill pinglog processes
	pkill pinglog.sh;

elif [ -z $1 ]; then
	err2;

elif [[ $1 =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
	IP=$1;

else
	err3;
fi;

# Second argument variable

if [[ $2 == '-r' ]] || [[ $2 == '--route' ]]; then
	if [[ -f /mnt/c/Windows/System32/TRACERT.exe ]]; then
		/mnt/c/Windows/System32/TRACERT.exe $IP | grep -Po '\d+\.\d+\.\d+\.\d+';
	else
		traceroute $IP | grep -Po '\(\d+\.\d+\.\d+\.\d+\)' | grep -v "$IP" | grep -Po '\d+\.\d+\.\d+\.\d+';
	fi;
	exit;

elif [ -z $2 ]; then
	err1;

elif [[ $2 =~ ^[0-9]+\.?[0-9]?[smhSMH]$ ]]; then
	SLEEP=$2;

else
	err3;
fi;

# Search arguments for flags
#for flag in $@
#do
#	if [[ $flag == '-s' ]] || [[ $flag == '--silent' ]]
#	then
#		verbose=false;
#	fi;
#done;

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
if [ -n $LOGFILE ]; then
	cat $LOGFILE > ${LOGFILE}.1;
fi;



function pingStats() {
	ping -q $IP 1>> $LOGFILE &
	pid=$!;
	# Store ping process id to file for termination command
	echo $pid >> ~/scripts/.ping.pid;
	until [ -z $pid ]
	do
		sleep ${SLEEP};
		echo "" >> $LOGFILE &&\
		echo '***************************************************************************' >> $LOGFILE &&\
		date >> $LOGFILE &&\
		kill -SIGINT "$pid";
		pingStats;
#	done;
#}
# function for statistics and timestamp
#function pingStats() {
#	if [[ $verbose == false ]]
#	then
#		ping -Oq "$IP" 2>> "$LOGFILE" &
#	else
##	fi;

	# store process id to pid variable
#	pid=$!;
	# declare command variable as non empty string to allow for loop to start
#	command="1";

	# do loop until command variable length is Zero
#	until [ -z command ]
#	do
		# set interval
#		sleep "${SLEEP}";
		# timestamp and send quit signal to trigger ping status
#		kill -SIGQUIT $pid &&\
#		echo "Destination $IP on $(date)" >> $LOGFILE;
		# delete first two lines of log when exceeding set log size
		if [[ $logLines -gt $LOGSIZE ]]; then
			sed -i '1,2d' "$LOGFILE";
		fi;
		# update size of logfile
		logLines=$(wc -l $LOGFILE | grep -Po '\d+');
		# update command variable
		command=$(ps "$pid" | grep -o ping);
	done;
	#tail -f $LOGFILE;
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
