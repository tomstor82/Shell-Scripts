#!/bin/bash

session=Tom;
#check=$(tmux ls | grep -o $session);

start=$(tmux new -s $session \;\
		split-window 'echo 4109 | sudo -S tail -f /var/log/syslog' \;\
		split-window top \;\
		split-window 'echo 4109 | sudo -S dmesg -T --follow' \;\
		select-pane -t 0 \;\
		select-layout tiled \;\
		select-pane -t 1 \;\
		split-window '/home/tom/scripts/temperature.sh' \;\
		select-pane -t 0 \;\
		new-window 'ssh pi' \;\
		select-window -t 0);
		

		#split-window top \;\
		#split-window 'tail -f /var/log/syslog' \;\
		#split-window 'echo 4109 | sudo -S dmesg -T --follow' \;\
		#select-layout main-horizontal \;\
		#new-window 'ssh pi' \;\
		#select-window -t 0);
		#split-window 'echo 4109 | sudo -S dmesg -T --follow' \;\
		#select-pane -t 0 \;\
		#select-layout even-vertical);

#if [[ $check == $session ]]
#	then
#	tmux a -t $session;
#else
#	$start;
#fi;

tmux a -t $session || $start;
