#
# Aliases
#

alias ta='tmux attach -t'
alias ts='tmux new-session -s'
alias tl='tmux list-sessions'

# Only run if tmux is actually installed
if ! which tmux &> /dev/null
then
	print "zsh tmux plugin: tmux not found. Please install tmux before using this plugin."
	return
fi

# Configuration variables
#
# Automatically start tmux
[[ -n "$ZSH_TMUX_AUTOSTART" ]] || ZSH_TMUX_AUTOSTART=false
# Only autostart once. If set to false, tmux will attempt to
# autostart every time your zsh configs are reloaded.
[[ -n "$ZSH_TMUX_AUTOSTART_ONCE" ]] || ZSH_TMUX_AUTOSTART_ONCE=true
# Automatically connect to a previous session if it exists
[[ -n "$ZSH_TMUX_AUTOCONNECT" ]] || ZSH_TMUX_AUTOCONNECT=true
# When automatically connecting, try to connect to an empty session first,
# otherwise start one if autostart is turned on.
[[ -n "$ZSH_TMUX_AUTOCONNECT_EXISTING" ]] || ZSH_TMUX_AUTOCONNECT_EXISTING=false
# Automatically close the terminal when tmux exits
[[ -n "$ZSH_TMUX_AUTOQUIT" ]] || ZSH_TMUX_AUTOQUIT=$ZSH_TMUX_AUTOSTART
# Set term to screen or screen-256color based on current terminal support
[[ -n "$ZSH_TMUX_FIXTERM" ]] || ZSH_TMUX_FIXTERM=true
# Set '-CC' option for iTerm2 tmux integration
[[ -n "$ZSH_TMUX_ITERM2" ]] || ZSH_TMUX_ITERM2=false
# The TERM to use for non-256 color terminals.
# Tmux states this should be screen, but you may need to change it on
# systems without the proper terminfo
[[ -n "$ZSH_TMUX_FIXTERM_WITHOUT_256COLOR" ]] || ZSH_TMUX_FIXTERM_WITHOUT_256COLOR="screen"
# The TERM to use for 256 color terminals.
# Tmux states this should be screen-256color, but you may need to change it on
# systems without the proper terminfo
[[ -n "$ZSH_TMUX_FIXTERM_WITH_256COLOR" ]] || ZSH_TMUX_FIXTERM_WITH_256COLOR="screen-256color"


# Get the absolute path to the current directory
local zsh_tmux_plugin_path="$(cd "$(dirname "$0")" && pwd)"

# Determine if the terminal supports 256 colors
if [[ `tput colors` == "256" ]]
then
	export ZSH_TMUX_TERM=$ZSH_TMUX_FIXTERM_WITH_256COLOR
else
	export ZSH_TMUX_TERM=$ZSH_TMUX_FIXTERM_WITHOUT_256COLOR
fi

# Set the correct local config file to use.
if [[ "$ZSH_TMUX_ITERM2" == "false" ]] && [[ -f $HOME/.tmux.conf || -h $HOME/.tmux.conf ]]
then
	#use this when they have a ~/.tmux.conf
	export _ZSH_TMUX_FIXED_CONFIG="$zsh_tmux_plugin_path/tmux.extra.conf"
else
	#use this when they don't have a ~/.tmux.conf
	export _ZSH_TMUX_FIXED_CONFIG="$zsh_tmux_plugin_path/tmux.only.conf"
fi

# Wrapper function for tmux.
function _zsh_tmux_plugin_run()
{
	local iterm=`[[ "$ZSH_TMUX_ITERM2" == "true" ]] && echo '-CC '`
	local fixterm=`[[ "$ZSH_TMUX_FIXTERM" == "true" ]] && echo '-f '$_ZSH_TMUX_FIXED_CONFIG`
	# We have other arguments, just run them
	if [[ -n "$@" ]]
	then
		\tmux $@
	elif [[ "$ZSH_TMUX_AUTOCONNECT" == "true" ]]
	then
		# Try to connect to an existing session.
		if [[ "$ZSH_TMUX_AUTOCONNECT_EXISTING" == "true" ]]; then
			# Try to find an existing but unattached session to use.
			local avail=$(=tmux list-sessions -F '#{?session_attached,,#S}' 2> /dev/null | grep -v '^$' | head -n1)
			if [[ -n "$avail" ]]; then
				\tmux attach -t $avail
			else
				\tmux $iterm $fixterm new-session
			fi
		else
			\tmux $iterm attach || =tmux $iterm $fixterm new-session
		fi
		[[ "$ZSH_TMUX_AUTOQUIT" == "true" ]] && exit
	else
		\tmux $iterm $fixterm
		[[ "$ZSH_TMUX_AUTOQUIT" == "true" ]] && exit
	fi
}

# Use the completions for tmux for our function
compdef _tmux _zsh_tmux_plugin_run

# Alias tmux to our wrapper function.
alias tmux=_zsh_tmux_plugin_run

# Autostart if not already in tmux and enabled.
if [[ ! -n "$TMUX" && "$ZSH_TMUX_AUTOSTART" == "true" ]]
then
	# Actually don't autostart if we already did and multiple autostarts are disabled.
	if [[ "$ZSH_TMUX_AUTOSTART_ONCE" == "false" || "$ZSH_TMUX_AUTOSTARTED" != "true" ]]
	then
		export ZSH_TMUX_AUTOSTARTED=true
		_zsh_tmux_plugin_run
	fi
fi

# vim: set noexpandtab :
