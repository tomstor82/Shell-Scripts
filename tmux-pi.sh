#!/bin/bash
tmux a -t Pi || tmux new -s Pi -n Bash  \;\
 split-window top \;\
 split-window 'watch -n 1 vcgencmd measure_temp' \;\
 split-window 'tail -f /var/log/auth.log.1' \;\
 select-layout main-vertical \;\
 select-pane -t 0 \;\
 resize-pane -t 0 -x 120 \;\
 resize-pane -t 2 -y 5;
