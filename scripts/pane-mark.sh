#!/usr/bin/env bash

window_id=$(echo $1 | awk '{print $1}')
window_name=$(tmux display-message -p -t "@$window_id" '#{window_name}')

# Get information about all panes in the window
panes=$(tmux list-panes -t "@$window_id" -F '#{pane_id} #{pane_active} #{pane_marked}')

# Iterate over the panes
while IFS= read -r pane; do
    # Split the pane information into id, active status, and marked status
    IFS=' ' read -ra parts <<< "$pane"

    # Check if the pane is active
    if [[ "${parts[1]}" == "1" ]]; then
        # Print the id and marked status of the active pane
		pane_id=${parts[0]}
		is_marked=${parts[2]}
        break
    fi
done <<< "$panes"

if [ -n $pane_id ]; then
	if [ $is_marked = '1' ]; then
		tmux select-pane -M -t "$pane_id"
	else
		tmux select-pane -m -t "$pane_id"
	fi
fi

