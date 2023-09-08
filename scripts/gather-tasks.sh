#!/bin/bash

RESET=$(tput sgr0)
YELLOW=$(tput setaf 11)

# Function to print windows for a given session (local execution)
print_windows() {
    local session="$1"
    local windows=$(tmux list-windows -t "$session" -F '#{window_name}')

    local window_list=""
    while IFS= read -r window; do
        window_list+=" $window "
    done <<< "$windows"

    echo "  $YELLOW$session$RESET: $window_list"
}

# Function to print windows for a given session (remote execution)
print_windows_remote() {
    local session="$1"
    local remote_host="$2"
    local windows=$(ssh "$remote_host" "tmux list-windows -t '$session' -F '#{window_name}'")

    local window_list=""
    while IFS= read -r window; do
        window_list+=" $window "
    done <<< "$windows"

    echo "  $YELLOW$session$RESET: $window_list"
}

# Main script
if [ "$#" -eq 1 ]; then
    remote_host="$1"
    sessions=$(ssh "$remote_host" 'tmux list-sessions -F "#{session_name}"')

    for session in $sessions; do
        print_windows_remote "$session" "$remote_host"
    done
else
    sessions=$(tmux list-sessions -F '#{session_name}')

    for session in $sessions; do
        print_windows "$session"
    done
fi
