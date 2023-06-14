#!/bin/bash

# if [[ $1 =~ .*new$ || $1 == '' ]]; then
# 	exit
# fi

selected_window_id=$(echo $1 | awk '{print $1}')

tmux unlink-window -k -t "@$selected_window_id"
