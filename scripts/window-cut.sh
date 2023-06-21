#!/usr/bin/env bash

selected_window_id=$(echo $1 | awk '{print $1}')

cut_window_id=$(tmux show-environment -g cut_window_id 2>/dev/null| awk -F "=" '{print $2}')

if [[ "$cut_window_id" == "$selected_window_id" ]]; then
	tmux set-environment -g -u cut_window_id 
else
	tmux set-environment -g cut_window_id "$selected_window_id"
fi

