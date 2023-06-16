# tmux-teleport

use fzf to jump straight to windows, switch sessions, easily move windows + panes. all through one hotkey

use fzf to visualize and arrange your windows and panes, all through one hotkey

visualize, navigate and organize your windows, sessions and panes, all through one hotkey, no configuration necessary

opinionated  / curated core

designed to be most useful even with a large number of window and sessions

## objectives

- quickly navigate to any window
- useful overview
- better ways to move windows around
- muscle-memory compatible
- discoverable functionality
- replace the current pane/windows mark/join confusion


## default hotkey

	alt-/   activate tmux-portal


## key bindings
	esc      exit

	enter    switch to window
	ctrl-x	 cut window 
	ctrl-p   paste window (or marked pane)

	tab        select a pane
	shift-tab  un/mark pane

	ctrl-g   grab window 
	ctrl-t   transport home window

	ctrl-]   add a window, named with the contents of the query string
	ctrl-l   reset everything
	ctrl-f   refresh preview
	ctrl-r   refresh list
	ctrl-/   vim motion

	del      delete window


## options

-	escape_exits = true
-	use_unicode = true
-	session_divs = true
-   histograms = true
-	-v force vertical


## dependencies

- tmux
- fzf
- awk
- ???

## see also

- https://github.com/thuanowa/tmux-fzf-session-switch

