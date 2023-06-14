#!/bin/bash

INVISIBLE_BRAILLE="⠀"
GREY=$(tput setaf 8)
# echo "$GREY$INVISIBLE_BRAILLE =   + new window"

RESET=$(tput sgr0)
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
ORANGE=$(tput setaf 3)
WHITE=$(tput setaf 15)

# BOLD=$(tput bold)
# NORMAL=$(tput sgr0)

HIGHLIGHT_BG=$(tput setab 8)
MARKED_FG=$(tput setaf 5)
BLACK_BG=$(tput setab 16)
ORANGE_BG=$(tput setab 3)


this_window_id=$(tmux display-message -p '#{window_id}')
this_session_id=$(tmux display-message -p '#{session_id}')

cut_window_id=$(tmux show-environment -g cut_window_id 2>/dev/null| awk -F "=" '{print $2}')

print_windows() {
	local session="$1"
	local windows=$(tmux list-windows -t "$session" -F '#{session_id} #{window_id} #{window_panes} #{window_active} #{window_last_flag} #{window_marked_flag} #{window_name}')
	local first=1
	while IFS= read -r window; do
		read -r session_id id n active last marked name <<< "$window"
		echo -n $RESET
		if [ "$this_window_id" != "$id" ]; then # until we support popup
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

			# is cut
			if [ "$id" == "@$cut_window_id" ]; then
				star="$WHITE✂ "
				session_color="$BLACK"
				message=" $RED✂ ✂ ✂ "
				window_color="$GREY"
			else
				star=" "
			fi
			
			# is home
			if [[ "$last" == '1' && "$session_id" == "$this_session_id" ]]; then
				# star="$WHITE*"
				# "⌂" "►" "▉" "⟩" " " "●" "▶"
				div="$ORANGE>"
				half_background="$ORANGE_BG"
				window_color="$ORANGE"
				id_color="$ORANGE"
				session_color="$WHITE"
			fi

			# is home (in other session)
			if [ "$active" -eq 1 ]; then
				div="$ORANGE>"
				# session_color="$WHITE"
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

			main_column="$session_color$tmp_session$soft $RESET$div $full_background$window_color$name $marked_marker"

			dashes=""
			for ((i=1; i<=n; i++)); do
				dashes+="▪"
			done
			count_column="$dashes"
			# count_column="$n" # TODO option
				
			echo "$full_background$half_background$id_column$RESET$home_indicator$pointer $main_column $soft$count_column  $message                                      $RESET"
			# num2braille.sh $n
		fi
	done <<< "$windows"
}

tmux list-sessions -F '#{session_name}' | while read -r session; do
	print_windows "$session"
done

echo
echo "$INVISIBLE_BRAILLE =   ? help"
echo
echo "$INVISIBLE_BRAILLE =   $ new session"
echo
