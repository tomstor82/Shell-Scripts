#!/bin/bash

# IP subnet start input
read -p 'Enter IP start point e.g 192.168.1 : ' input;

is_alive_ping() {
  ping -c 1 $1 > /dev/null
  [ $? -eq 0 ] && echo 'Node with IP:  '$i' is up.';
}

for i in $input.{1..254}
do
	is_alive_ping $i & disown
done
