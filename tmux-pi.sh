#!/bin/bash

session=Pi;

start=$(tmux new -s $session \;\
    split-window top \;\
    split-window 'echo 4109 | sudo -S dmesg -T --follow' \;\
    split-window 'watch -n 1 vcgencmd measure_temp' \;\
    select-layout tiled \;\
    select-pane -t 0);
    
    
    
    
    
    
    #split-window top \;\
    #split-window 'watch -n 1 vcgencmd measure_temp' \;\
    #split-window 'tail -f /var/log/auth.log.1' \;\
    #select-layout main-vertical \;\
    #select-pane -t 0 \;\
    #resize-pane -t 0 -x 120 \;\
    #resize-pane -t 2 -y 5;

tmux a -t $session || $start;