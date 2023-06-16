#!/bin/bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

FZF_VERSION=$(fzf --version | cut -d ' ' -f 1)
FZF_VERSION_NUMBER=$(echo "$FZF_VERSION" | cut -d '.' -f 2)

width=$(tput cols)
P_WIDTH=$(echo "$width-55" | bc)

BASE="$CURRENT_DIR"
LIST_CMD="$CURRENT_DIR/list-buffered.sh"

TMP="/tmp/tmux-teleport.tmp"

tmux set-environment -u -g cut_window_id

# fixme for 1.x
# Compare the version number to a minimum required version
if [[ "$FZF_VERSION_NUMBER" -lt "24" ]]; then
	echo not yet
else
	fzf_output=$( $BASE/list-buffered.sh \
	    | fzf --preview-window="right:$P_WIDTH:rounded" \
	          --prompt="> " \
			  --info=hidden \
			  --tiebreak=index \
			  --layout=reverse \
			  --tabstop=4 \
			  --nth=2.. \
			  --ansi \
	          --preview "$BASE/"'preview-buffered.sh {}' \
			  --bind "ctrl-x:execute-silent($BASE/"'window-cut.sh'" {})+execute-silent($BASE/list-buffered.sh>$TMP)+reload(cat $TMP)" \
			  --bind "ctrl-p:execute-silent($BASE/"'window-paste.sh'" {})+execute-silent($BASE/list-buffered.sh>$TMP)+reload(cat $TMP)" \
			  --bind "ctrl-g:execute-silent($BASE/"'window-grab.sh'" {})+reload(eval $LIST_CMD)" \
			  --bind "ctrl-t:execute($BASE/"'window-transport.sh'" {})+reload(eval $LIST_CMD)" \
			  --bind "ctrl-w:execute(tmux new-window -d -c ~ -n {q})+clear-query+execute($BASE/list-buffered.sh>$TMP)+reload(cat $TMP)" \
			  --bind "ctrl-a:execute-silent($BASE/"'pane-move.sh'" {})+execute($BASE/list-buffered.sh>$TMP)+reload(cat $TMP)" \
		      --bind "tab:execute-silent($BASE/"'pane-cycle-next.sh {})+refresh-preview' \
			  --bind "btab:execute-silent($BASE/"'pane-mark.sh'" {})+refresh-preview" \
			  --bind "ctrl-e:execute($BASE/"'window-rename.sh'" {})+execute($BASE/list-buffered.sh>$TMP)+reload(cat $TMP)" \
			  --bind "ctrl-r:execute($BASE/list-buffered.sh>$TMP)+reload(cat $TMP)"\
	          --bind "ctrl-f:refresh-preview" \
	          --bind "ctrl-l:clear-query+top+clear-screen" \
			  --bind "ctrl-z:ignore" \
			  --bind "del:clear-screen+execute-silent($BASE/window-delete.sh {})+execute-silent($BASE/list-buffered.sh>$TMP)+reload(cat $TMP)" \
	          --bind "home:top" \
			  --bind "end:page-down+page-down+page-down+page-down+page-down+page-down+page-down+page-down+page-down+page-down" \
	          --bind "ctrl-/:jump" \
		  )
fi

first_col=$(echo $fzf_output | awk '{print $3}');

if [[ $first_col == '+' ]]; then
	tmux new-window -c ~

	# tmux command-prompt -p "Window name:" "rename-window '%%'"
	tmux send-keys 'tmux rename-window \;' # user can still enter a command
	tmux send-keys C-l
	exit
fi

if [[ $first_col == '?' ]]; then
	garcon-url-handler "https://github.com/sturob/tmux-teleport"
	exit
fi

if [[ $first_col == '$' ]]; then
	# tmux command-prompt -p "Session name:" "new-session -c ~ -s '%%'"
	# tmux new-session -c ~
	# tmux rename-session

	# to avoid "sessions should be nested with care, unset $TMUX to force"
	session_id=$(tmux new-session -c ~ -d -P -F "#{session_id}")
	tmux switch-client -t "$session_id"

	# tmux command-prompt -p "Session name:" "rename-session -t '%%'"

	# if bash echo shortcuts for new-window rename-window 
	# send-keys tmux rename-session -t ""
 	exit
fi

id=$(echo $fzf_output | awk '{print $1}')

# $2   session id 
# @9   window id
# %28  pane id

if [ -n "$id" ]; then
	window="$id"
	current_session=$(tmux display-message -p -t "$pane_id" '#{session_id}')
	session=$(tmux display-message -p -t "@$window" -F '#{session_id}')

	if [[ "$current_session" == "$session" ]]; then
		tmux set-environment back close
		tmux select-window -t "@$window"
	else
		tmux set-environment back far
		tmux select-window -t "@$window"
		tmux switch-client -t $session
	fi

	# tmux run-shell -b 'highlight-current-pane.sh'
fi

