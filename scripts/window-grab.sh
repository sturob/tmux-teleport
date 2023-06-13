#!/bin/bash

# if [[ $1 =~ .*new$ || $1 == '' ]]; then
# 	exit
# fi

selected_window_id=$(echo $1 | awk '{print $1}')
# window_name=$(echo $1 | awk '{print $4}')
# marked_window_id=$(tmux list-windows -a -F '#{window_id} #{window_marked_flag}' | awk '$2 == "1" {print $1}') # @NNN

# move selected window to current session
current_session=$(tmux display-message -p '#{session_id}')
current_window=$(tmux display-message -p '#{window_id}')

# tmux move-window -d -s "@$selected_window_id" -t $current_session:
current_window=$(tmux list-windows -t "$session" -F '#{window_id} #{window_last_flag}' | awk '$2 == "1" {print $1}')
tmux move-window -a -d -s "@$selected_window_id" -t "$current_window"

