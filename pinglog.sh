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
LOGSIZE=500;

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
	Example 4: pinglog stop\n\n';
	exit 0;
}
function err1() {
	printf "\npinglog: Missing interval argument -- '1'\nTry 'pinglog --help' for more information.\n\n"
	exit 1;
}
function err2() {
	printf "\npinglog: Missing destination argument -- '2'\nTry 'pinglog --help' for more information.\n\n"
	exit 2;
}
function err3() {
	printf "\npinglog: Unknown arguments -- '3'\nTry 'pinglog --help' for more information.\n\n"
	exit 3;
}

# First argument

if [[ $1 == '-h' ]] || [[ $1 == '--help' ]]; then
	err0;

elif [[ $1 == '-l' ]] || [[ $1 == '--log' ]]; then
	tail -f $LOGFILE;
	exit 0;

elif [[ $1 == 'status' ]]; then
	PROC=($(ps -A | grep -o pinglog));
	if [[ "${#PROC[@]}" -gt 2 ]]; then
	#if [[ $(jobs pinglog.sh 2> /dev/null) ]]; then
		printf "\nServices running. Use 'pinglog stop' to terminate\n\n";
		exit 0;
	else
		printf "\nService not running\n\n";
		exit 0;
	fi;
	
elif [[ $1 == 'stop' ]] || [[ $1 == '--stop' ]]; then
	printf "Stopping all pinglog services\n";
	pkill pinglog.sh;

elif [ -z $1 ]; then
	err2;

elif [[ $1 =~ ^([0-9]{1,3}\.){3,3}[0-9]{1,3}$ ]]; then
	IP=$1;

else
	err3;
fi;

# Second argument

if [[ $2 == '-r' ]] || [[ $2 == '--route' ]]; then
	# If windows machine
	if [[ -f /mnt/c/Windows/System32/TRACERT.exe ]]; then
		/mnt/c/Windows/System32/TRACERT.exe $IP | grep -Po '([\d]{1,3}[\.]){3,3}[\d]{1,3}';
	else
		traceroute $IP | grep -Po '\(([\d]{1,3}[\.]){3,3}[\d]{1,3}\)' | grep -v "$IP" | grep -Po '([\d]{1,3}[\.]){3,3}[\d]{1,3}';
	fi;
	exit;
# No argument received
elif [ -z $2 ]; then
	err1;

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
		COUNT=$(($VALUE * 360))
		;;
		*)
		err3
		;;
	esac
else
	err3;
fi;

# check if logfile has entries and if so backup
if [ -n $LOGFILE ]; then
	cat ${LOGFILE}.1 > ${LOGFILE}.2;
	cat $LOGFILE > ${LOGFILE}.1;
fi;

function pingStats() {
	while true
	do
		echo "" >> $LOGFILE &&\
		echo '***************************************************************************' >> $LOGFILE &&\
		ping -qc "$COUNT" "$IP" 1>> $LOGFILE &&\
		printf "\n$(date)\n" >> $LOGFILE;

		# delete lines 1 through 9 of the log when exceeding set log size
		if [[ $logLines -gt $LOGSIZE ]]; then
			sed -i '1,9d' "$LOGFILE";
		fi;

		# update size of logfile
		logLines=$(wc -l $LOGFILE | grep -Po '\d+');

		# Call function again
		pingStats;
	done;
}

# Notification of logfile
echo "Ping summary stored in file $LOGFILE";

# Make initial function call
pingStats;
