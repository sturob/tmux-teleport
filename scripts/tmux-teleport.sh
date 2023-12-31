#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

BASE="$CURRENT_DIR"
LIST_CMD="$CURRENT_DIR/list-buffered.sh"

TMP=$(mktemp -t "srtt.XXXXXXXXX")
function cleanup {
	rm "$TMP"
}
trap cleanup EXIT

tmux set-environment -u -g cut_window_id

width=$(tput cols)
P_WIDTH=$(echo "$width-55" | bc)

fzf_output=$( "$BASE/list.sh" | \
	fzf --preview-window="right:$P_WIDTH:rounded" \
	    --prompt="> " \
		--info=hidden \
		--tiebreak=index \
		--layout=reverse \
		--tabstop=4 \
		--nth=2.. \
		--ansi \
		--preview "$BASE/preview-buffered.sh {}" \
		--bind "ctrl-o:execute-silent($BASE/window-cut.sh {})+execute-silent($BASE/list-buffered.sh>$TMP)+reload(cat $TMP)" \
		--bind "ctrl-p:execute-silent($BASE/window-paste.sh {})+execute-silent($BASE/list-buffered.sh>$TMP)+reload(cat $TMP)" \
		--bind "ctrl-g:execute-silent($BASE/window-grab.sh {})+reload(eval $LIST_CMD)" \
		--bind "ctrl-t:execute-silent($BASE/window-transport.sh {})+reload(eval $LIST_CMD)" \
		--bind "ctrl-n:execute-silent($BASE/window-new.sh {q})+clear-query+execute($BASE/list-buffered.sh>$TMP)+reload(cat $TMP)" \
		--bind "tab:execute-silent($BASE/pane-cycle-next.sh {})+refresh-preview" \
		--bind "btab:execute-silent($BASE/pane-mark.sh {})+refresh-preview" \
		--bind "ctrl-\\:execute-silent($BASE/window-rename.sh {})+execute($BASE/list-buffered.sh>$TMP)+reload(cat $TMP)" \
		--bind "ctrl-r:execute-silent($BASE/list-buffered.sh>$TMP)+reload(cat $TMP)"\
		--bind "ctrl-f:refresh-preview" \
		--bind "ctrl-l:clear-query+top+clear-screen" \
		--bind "ctrl-z:ignore" \
		--bind "del:clear-screen+execute-silent($BASE/window-delete.sh {})+execute-silent($BASE/list-buffered.sh>$TMP)+reload(cat $TMP)" \
		--bind "backward-eof:top" \
		--bind "home:top" \
		--bind "end:page-down+page-down+page-down+page-down+page-down+page-down+page-down+page-down+page-down+page-down" \
		--bind "ctrl-/:jump" \
)

first_col=$(echo "$fzf_output" | awk '{print $3}');

if [[ $first_col == '+' ]]; then
	tmux new-window -c ~

	# tmux command-prompt -p "Window name:" "rename-window '%%'"
	tmux send-keys 'tmux rename-window \;' # user can still enter a command
	tmux send-keys C-l
	exit
fi

if [[ $first_col == '?' ]]; then
	"$CURRENT_DIR/open-url.sh" "https://github.com/sturob/tmux-teleport"
	exit
fi

if [[ $first_col == '$' ]]; then
	# to avoid "sessions should be nested with care, unset $TMUX to force"
	session_id=$(tmux new-session -c ~ -d -P -F "#{session_id}")
	tmux switch-client -t "$session_id"

	tmux send-keys -t "$session_id" 'tmux rename-session '
	tmux send-keys -t "$session_id" C-l
 	exit
fi

id=$(echo "$fzf_output" | awk '{print $1}')

# $2   session id 
# @9   window id
# %28  pane id

if [ -n "$id" ]; then
	window="$id"
	current_session=$(tmux display-message -p '#{session_id}')
	session_id=$(tmux display-message -p -t "@$window" -F '#{session_id}')

	if [[ "$current_session" == "$session_id" ]]; then
		tmux select-window -t "@$window"
	else
		tmux select-window -t "@$window"
		tmux switch-client -t $session_id
	fi
	# tmux run-shell -b 'highlight-current-pane.sh'
fi

