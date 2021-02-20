# show current aliases
alias als='cat ~/.bash_aliases | grep -Poh "\s\w+[=]" | grep -Po "\w+[^=]"'
# sudo apt install shortcut
alias sai='echo 4109 | sudo -S apt install -y'
# update and modify aliases
alias upd='echo 4109 | sudo -S apt update; upgradable="$(apt list --upgradable 2> /dev/null)"; sleep 1; sudo -S apt -y upgrade; sudo -S apt -y autoremove; echo $upgradable | grep -Pho "^\w+[-]\w+[-]?(\w+)?"'
alias ali='nano ~/.bash_aliases && source ~/.bash_aliases'
# fast reboot
alias reb="echo 4109 | sudo -S reboot 0"
# fast shutdown
alias off="echo 4109 | sudo -S shutdown 0"
# uptime
alias up="uptime"
# navigation
alias la='ls -1alhF --color --group-directories-first'
#alias ll='ls -l | less'
alias docs='cd ~/Documents/'
alias down="cd ~/Down*"
alias desk="cd ~/Desk*"
alias cod='cd ~/Documents/coding/'
# Display Local and Public IP
alias ip='printf "\nLocal IP address:\n\n" &&\
	ifconfig | grep -Po "inet\s((\d){1,3}\.){3}(\d){1,3}" | grep -Po "\d+.+" | grep -v "127.0.0.1" &&\
	printf "\nPublic IP address:\n\n" &&\
	dig +short myip.opendns.com @resolver1.opendns.com &&\
	printf "\n"';
# Scan allocated IP addresses
alias ipscan='~/scripts/ipScan.sh'
# transmission bit torrent client
alias torr='DISPLAY=:0 transmission-gtk &'
# fileZilla
alias ftp='DISPLAY=:0 filezilla &'
# watch media
alias vlcopen='DISPLAY=:0 vlc --fullscreen'
# battery status
alias bat='upower -d'
# firefox start. To use a variables string value quotation marks has to be used. Otherwise only the first word will be used.
alias fox='read -p "Type Firefox Search or leave blank: " input; DISPLAY=:0 firefox --new-tab --search "$input" &'
alias kbc='DISPLAY=:0 firefox --new-tab "https://online.kbc.ie/kbc-online/onlinebanking	" &'
alias netflix='DISPLAY=:0 firefox --new-tab "https://www.netflix.com/browse" &'
alias spotify='DISPLAY=:0 firefox --new-tab "https://open.spotify.com/" &'
# renew DHCP lease
alias dhcp="echo 4109 | sudo -S dhclient wlp2s0 -r &&\
	sudo -S dhclient enp1s0 -r &&\
	printf '\nIP address released and renewed.\n' &&\
	sleep 2 &&\
	ip | grep -P 'inet\s(\d{1,3}\.){3}\d{1,3}[/]\d{1,2}.+wlp2s0' &&\
	ping -O 8.8.8.8 -c4";
#alias mtek='echo 4109 | sudo -S ifconfig wlp2s0 192.168.88.3 && ip address | grep -P "inet\s(\d{1,3}\.){3}\d{1,3}[/]\d{1,2}.+wlp2s0" && p88'
#alias ubnt='echo 4109 | sudo -S ifconfig wlp2s0 192.168.1.19 && ip address | grep -P "inet\s(\d{1,3}\.){3}\d{1,3}[/]\d{1,2}.+wlp2s0" && p20'
alias eth='echo enp1s0'
alias wlan='echo wlp2s0'
# ping
alias pgo='ping -O 8.8.8.8 -c50'
alias p88='ping -O 192.168.88.1 -c50'
alias p20='ping -O 192.168.1.20 -c50'
alias p='ping -O'
alias pinglog='~/scripts/pinglog.sh'
# wireless network
alias wifi='nmcli dev wifi';
# convert mkv to mp4
alias lhost='~/scripts/lhost.sh'
# show wifi network details
alias ssid='~/scripts/ssid.sh';
# show compiler commands
alias comp='cat ~/scripts/compilers.md';
# macOS open command
function open() { nautilus ${1} & };
