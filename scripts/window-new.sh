#!/bin/bash

selected_window_id=$(echo $1 | awk '{print $1}')

name="$1"

if [  -n "$name" ]; then
	tmux new-window -d -c ~ -n "$name"
else
	tmux new-window -d -c ~
fi

