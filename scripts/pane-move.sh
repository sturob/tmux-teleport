#!/usr/bin/env bash

if [[ $1 =~ .*new$ || $1 == '' ]]; then
	exit
fi

window_id=$(echo $1 | awk '{print $1}')
window_name=$(echo $1 | awk '{print $4}')

target_pane_id=$(tmux list-panes -t "@$window_id" -F '#{pane_id} #{pane_active}' | awk '$2 == "1" {print $1}')

marked_pane_id=$(tmux list-panes -a -F '#{pane_id} #{pane_marked}' | awk '$2 == "1" {print $1}') # %NNN

tmux join-pane -s "$marked_pane_id" -t "$target_pane_id"
