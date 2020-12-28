#!/bin/bash

session=Tom;
#check=$(tmux ls | grep -o $session);

start=$(tmux new  -s $session -n Bash \;\
		split-window top \;\
		split-window 'tail -f /var/log/syslog' \;\
		select-layout main-horizontal \;\
		new-window 'ssh pi' \;\
		select-window -t 0 \;\
		select-pane -t 0);

#if [[ $check == $session ]]
#	then
#	tmux a -t $session;
#else
#	$start;
#fi;

tmux a -t $session || $start;
