#!/bin/bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/_colors.sh"

this_window_id=$(tmux display-message -p '#{window_id}')
this_session_id=$(tmux display-message -p '#{session_id}')
cut_window_id=$(tmux show-environment -g cut_window_id 2>/dev/null| awk -F "=" '{print $2}')

print_windows() {
	local session="$1"
	local windows=$(tmux list-windows -t "$session" -F '#{session_id} #{window_id} #{window_index} #{window_panes} #{window_active} #{window_last_flag} #{window_marked_flag} #{window_linked_sessions} #{window_name}')
	local first=1
	while IFS= read -r window; do
		read -r session_id id index panes_n active last marked linked_n name <<< "$window"
		window_color="$WHITE"
		session_color="$GREY"
		soft="$GREY"
		home_indicator="$ORANGE"
		div="$GREY>"
		message=""
		full_background=""
		half_background=""
		tmp_session="$session"
		pointer=""
		id_color="$BLACK"
		star=" "
		# id_color="$WHITE"

		# no name
		if [ ! -n "$name" ]; then
			name="$index $GREY$id"
		fi

		# is home (in other session)
		if [ "$active" -eq 1 ]; then
			star="$BLACK#"
			div="$ORANGE>"
			# session_color="$WHITE"
		fi

		# is home
		if [[ "$active" == '1' && "$session_id" == "$this_session_id" ]]; then
			star="*"
			# "⌂" "►" "▉" "⟩" " " "●" "▶"
			div="$ORANGE>"
			half_background="$ORANGE_BG"
			window_color="$ORANGE"
			id_color="$ORANGE"
			session_color="$WHITE"
		fi

		# is cut
		if [ "$id" == "@$cut_window_id" ]; then
			# star="|"
			session_color="$BLACK"
			name="$RED✂  $name $RESET"
			div="|"
			window_color="$GREY"
		fi

		# is first line of each session
		if [ "$first" -eq 1 ]; then
			# if [[ "$session_id" == "$this_session_id" ]]; then
			# 	session_color="$ORANGE"
			# else
				# session_color="$WHITE"
			# fi
			echo # no empty lines
		else
			echo -n
			# session_color="$GREY"
		fi

		first=0
		# marked_marker=""
		# [ "$marked" -eq 1 ] && marked_marker=" $MARKED_FG""M"
		# star="$session $this_session_id"
		id="${id:1}"
		printf -v id_column "$id_color%-4s" "$id"
		# div="$div $index"
		if [ "$linked_n" -eq 1 ]; then
			linked_n=''
		fi
		main_column="$session_color$tmp_session$soft $RESET$div $full_background$window_color$name$star$linked_n$marked_marker"

		dashes=""
		for ((i=1; i<=panes_n; i++)); do
			dashes+="▪"
		done
		count_column="$dashes"
		# count_column="$n" # TODO option
			
		echo "$RESET$full_background$half_background$id_column$RESET$home_indicator$pointer $main_column $soft$count_column                                      "
		# num2braille.sh $n
	done <<< "$windows"
}

tmux list-sessions -F '#{session_name}' | while read -r session; do
	print_windows "$session"
done

echo
echo "$INVISIBLE_BRAILLE$BLACK =  $BLUE$ new session"
echo
echo "$INVISIBLE_BRAILLE$BLACK =  $BLUE? help"
