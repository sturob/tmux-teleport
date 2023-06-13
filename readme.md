# tmux-teleport

use fzf to jump straight to windows, switch sessions, easily move windows + panes. all through one hotkey
use fzf to visualize and arrange your windows and panes, all through one hotkey

no configuration necessary

opinionated  / curated core

designed to be most useful even with a large number of window and sessions

even if you don't have a large number now, this plugin will make that an option worth exploring

## objectives

- quickly navigate to any window
- visually useful overviews
- a better way to move windows around
- muscle memory compatible
- discoverability
- create new window if no matches (ctrl-w enter)
- replace the current pane/windows mark/join confusion

## default hotkey

	alt-/   activate tmux-portal

## shortcuts

	enter    switch to window
	ctrl-x	 cut window 
	ctrl-p   paste window
	ctrl-q   cancel cut
	tab      select a pane

	ctrl-g     grab a window and pull it here
	ctrl-t     teleport current window to somewhere else

	tab        next pane
	shift-tab  un/mark pane


## next
- fix where windows get moved to
	- use move-window.sh always
- preview:
	- dynamic height for panes
- pluginize
- demo

## future possibilities

- tips for beginners when opening a new window or session
- settings
- double buffer preview:  > file; cat file
- receive http tmux events (see tmux hooks) and stay updated
	https://github.com/junegunn/fzf/pull/3094 --listen=HTTP_PORT
- file a fzf bugreport about slow list and cursor position moving
- auto refresh? (seq 100 | fzf --query 5 --sync --bind 'start:up+up+up+reload:sleep 1; seq 1000')
- preview: turn color back on, need to figure out how to s/$RESET/$BLACK/g
	- live updates https://sourcegraph.com/github.com/junegunn/fzf/-/blob/ADVANCED.md#log-tailing
- some indication of pane history used/size [==== ] 8039/10k

## options

-	escape_exits = true
-	use_unicode = true
-	session_divs = true
-	-v force vertical


## dependencies

- tmux
- fzf
- awk
- ???

## see also

- https://github.com/thuanowa/tmux-fzf-session-switch

