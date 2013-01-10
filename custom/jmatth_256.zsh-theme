#!/bin/zsh
#my custom theme

# Mode indicator for vi-mode plugin
MODE_INDICATOR="%{$fg[yellow]%}Δ%{$reset_color%}"

# Promptchar to be displayed in a git repository
local git_prompt_char="±"

# Characters to indicate git repo status
ZSH_THEME_GIT_PROMPT_PREFIX="%{$FG[220]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$FG[220]%}] %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}⚡%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[red]%}⌚%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[red]%}⍰%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}⚛%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[red]%}⚡%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[red]%}↷%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}⊗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[red]%}✕%{$reset_color%}"

# Override colors for syntax highlighting.
: ${ZSH_HIGHLIGHT_STYLES[history-expansion]::=fg=magenta}
: ${ZSH_HIGHLIGHT_STYLES[path]::=none}

# Functions used to display the custom prompt character.
function inGit ()
{
	git status -z &> /dev/null && echo "${git_prompt_char}"
}

function promptChar ()
{
	echo "${$(vi_mode_prompt_info):-${$(inGit):-${priv}}}"
}

if [[ $UID == 0 ]]
then
	local name="%{$FX[bold]$FG[001]%}%n%{$reset_color%}"
else
	local name="%{$FX[bold]$FG[027]%}%n%{$reset_color%}"
fi

# And different colors if over ssh
if (($+SSH_CONNECTION)); then
	local host="%{$FX[bold]$FG[208]%}%m%{$reset_color%}"
else
	local host="%{$FX[bold]$FG[034]%}%m%{$reset_color%}"
fi

local time="%{$FG[005]%}%*%{$reset_color%}"
local dir="%{$FG[045]%}%~%{$reset_color%}"

local return="%(?.%{$fg[green]%}☺.%{$fg_bold[red]%}☹%?)%{$reset_color%}"
local hist="%{$FG[220]%}%!!%{$reset_color%}"
local priv="%#"

#PROMPT="${name}@${host}:${priv} "
#RPROMPT="${dir} ${return} ${vcsi}${time}"

PROMPT='${name}@${host}:$(promptChar) '
RPROMPT='${dir} ${return} $(git_prompt_verbose_info)${time}'
