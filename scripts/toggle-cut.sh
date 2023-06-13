#!/bin/bash

# if [[ $1 =~ .*new$ || $1 == '' ]]; then
# 	exit
# fi

selected_window_id=$(echo $1 | awk '{print $1}')

output=$(tmux show-environment -g cut_window_id 2>/dev/null)

# Check if the command was successful
if [ $? -eq 0 ]; then
    # Load the variable
    eval "$output"
fi

# tmux display-message "$cut_window_id -- $selected_window_id"

# if [ -z $1 ]; then
# 	tmux set-environment -g -r cut_window_id 
# else	
	if [[ "$cut_window_id" == "$selected_window_id" ]]; then
		tmux set-environment -g -r cut_window_id 
	else
		tmux set-environment -g cut_window_id "$selected_window_id"
	fi
# fi



# # move selected window to current session
# current_session=$(tmux display-message -p '#{session_id}')
# current_window=$(tmux display-message -p '#{window_id}')


# # tmux move-window -d -s "@$selected_window_id" -t $current_session:
# current_window=$(tmux list-windows -t "$session" -F '#{window_id} #{window_last_flag}' | awk '$2 == "1" {print $1}')
# tmux move-window -a -d -s "@$selected_window_id" -t "$current_window"


