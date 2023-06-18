# tmux-teleport

A better way to manage tmux windows, sessions, and panes.

<img width="400px" src="https://raw.githubusercontent.com/sturob/tmux-teleport-docs/main/blank.png">

## Functionality

- Quickly navigate to any tmux window
- Easily move windows
- A useful overview of all windows and sessions
- Create new windows and sessions
- Find unnamed windows
- Delete and rename windows


## Objectives

- One hotkey + zero config needed
- Promote muscle-memory + maximize flow
- Informationally rich but not overwhelming
- Easy to learn, discoverable functionality where possible
- Handle a large number of windows
- Promote naming but support unnamed windows and sessions


## Dependencies

- [tmux](https://github.com/tmux/tmux)
- [fzf](https://github.com/junegunn/fzf)
- pstree (if you want detailed pane process information)
- awk + sed


## Installation

### Installation with [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) (recommended)

Add plugin to the list of TPM plugins in `.tmux.conf`:

    set -g @plugin 'sturob/tmux-teleport'

Hit `prefix + I` to fetch the plugin and source it. You should now be able to
use the plugin.

### Manual Installation

Clone the repo:

    $ git clone https://github.com/sturob/tmux-teleport ~/clone/path

Add this line to the bottom of `.tmux.conf`:

    run-shell ~/clone/path/teleport.tmux

Reload TMUX environment with: `$ tmux source-file ~/.tmux.conf`.
You should now be able to use the plugin.


## How it works

Launch using ALT-/ (or prefix-\*)

Enter a search query to filter the list of windows and actions. Use up+down keys to select one.

See [Key Bindings](#key-bindings) for actions that can be performed on a selected window.


### Creating new windows

There are two ways to create a new window:

1. Hit CTRL-n to create a new window named using your search query

2. Hit RETURN immediately after launch

When using the latter, tmux will inject 'tmux rename-window ;' into the new window. This is not a bug. It's intended to make it as easy as possible to rename the new window (delete the ; and enter a name), but gets out of the way if you want to enter a blind command.


### Moving windows

There are three ways to move windows:

1. Cut and paste. CTRL-x cuts, CTRL-p pastes. Paste to the 'new session' action to move the window to a new session.

2. Throw. This is for when you are working in a window (the current window) and realize it should be in a different location. Select the target window you want your current window to be next to and hit CTRL-t. You can throw to a new session.

3. Grab. Imagine there is a window elsewhere but it should be next to your current window. Select it and hit CTRL-g.


### Hotchars

Using fzf means we can use special characters to filter the list in custom ways:

	  +   new window
	  $   new session
	  ?   show help
	  =   only show actions
	  *   only show current window
	  #   only show active windows in other sessions
	  |   only show cut window
	  >   only show windows, no padding or 
	  @   only show unnamed windows

This will not work so well if you use special characters in window names. So don't do that, or do, but you have been warned.


### Key bindings

	  RETURN   Go to selected window
	
	  CTRL-n   New window, named with the search text
	  CTRL-e   Rename selected window
	  DELETE   Delete selected window
	
	  CTRL-x   Cut selected window
	  CTRL-p   Paste the cut window
	  CTRL-t   Take active window and put it next to selected window
	  CTRL-g   Grab selected window and pull it next to active window
	
	  CTRL-l   Clear search text and reset
	  CTRL-w   Wipe search text
	
	  CTRL-r   Reload list of windows (use if renames don't show)
	  CTRL-f   Refresh the overview of panes
	
	  ESCAPE   Exit


Most readline bindings (eg. CTRL-a/CTRL-e beginning/end of line) are also available.

<!-- ## Options -->

<!-- ### TODO -->

<!-- -	escape_exits = true -->
<!-- -	use_unicode = true -->
<!-- -	session_divs = true -->
<!-- -   histograms = true -->
<!-- -	-v force vertical -->



## Works well with

- [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect)
- [extrakto](https://github.com/laktak/extrakto)


