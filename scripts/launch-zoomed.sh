#!/usr/bin/env bash


tmux split-window -c "~" '~/3-projects/tmux-teleport/scripts/tmux-teleport.sh' \; resize-pane -Z

tmux split-window -Z -c "~" '~/3-projects/tmux-teleport/scripts/tmux-teleport.sh'

tmux split-window -Z ~/3-projects/tmux-teleport/scripts/tmux-teleport.sh
