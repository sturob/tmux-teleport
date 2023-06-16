# tmux-teleport

Use fzf to manage windows, sessions, and panes.

Launch with one hotkey, no configuration necessary. 

## Functionality

- quickly navigate to any tmux window
- easily move windows
- a useful overview of all windows and session
- create new windows and session
- find un-named windows
- delete and rename windows

## Objectives

- informational but not overwhelming
- be easy to learn, discoverable functionality
- promote muscle-memory
- maximize flow
- handle a large number of windows
- promote window naming but support unnamed windows

## Default Hotkey

	alt-/   activate tmux-portal

## How it works

After launching search for any window or session. Use up/down keys to select a window. See Key Bindings for actions that can be performed on the selected window.

### Creating new windows

There are three ways to create a new window:

1. hit return immediately after launch (+ new window is preselected)

2. if a search has no matches, hit return to create a window named after your search query

3. at any time, hit ctrl-] to create a new window named after your search query

When #1 is performed, tmux will inject 'tmux rename-window ;' into the new window. This is not a bug. It's intended to make it as easy as possible to rename the new window (delete the ; and enter a name), but gets out of the way if you want to enter a blind command.

### Moving windows

There are three ways to move windows:

1. cut and paste. ctrl-x cuts, ctrl-p pastes.

2. teleport. this is for when you are working in a window (let's call it your home window) and realize it should be in a different session. select the window you want to move your home window next to and hit ctrl-t.

3. grab. there's a window somewhere else that should be in your current session. select it and hit ctrl-g

### Extras

Using fzf means we can use special characters to filter the window list in custom ways, and expose addition functionality.

	=  show additional functionality
	+  new window
	$  new session
	?  show help
	*  only show current/home window
	%  only show cut window
	>  only show windows, no padding
	@  only show unnamed windows

This will not work so well if you use special characters in window names. So don't do that, or do, but you have been warned.


## Key bindings

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

Most readline bindings (eg. ctrl-a/ctrl-e beginning/end of line) are also available.

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

## see also

- https://github.com/thuanowa/tmux-fzf-session-switch

