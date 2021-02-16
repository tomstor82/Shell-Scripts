#!/bin/bash

# View WiFi saved WiFi profiles and password details

# If windows machine
if [[ -f /mnt/c/Windows/System32/netsh.exe ]]; then
	netsh="/mnt/c/Windows/System32/netsh.exe";
    ${netsh} wlan show profile | more && read -p "Type Wireless Profile Name: " ssid && ${netsh} wlan show profile ${ssid} key=clear | more;
# Unix like machine
else
	echo "Saved Networks:" && echo "" && ls /etc/NetworkManager/system-connections/ | more && echo "" && read -p "Type SSID name for details: " ssid && echo 4109 | sudo -S cat /etc/NetworkManager/system-connections/$ssid | more && echo "";
fi;