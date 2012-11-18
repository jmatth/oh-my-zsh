#need_a_name theme

MODE_INDICATOR="%{$fg[green]%}Δ: %{$reset_color%}"

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

# prompt.zsh: A custom prompt for zsh (256 color version).

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

local return="%(?.%{$FG[064]%}☺.%{$FG[009]%}☹%?)%{$reset_color%}"
local hist="%{$FG[220]%}%!!%{$reset_color%}"
local priv="%#"

#PROMPT="${name}@${host}:${priv} "
#RPROMPT="${dir} ${return} ${vcsi}${time}"

PROMPT='${name}@${host}:${priv} $(vi_mode_prompt_info)'
RPROMPT='${dir} ${return} $(git_prompt_verbose_info)${time}'
#RPROMPT='$(git_prompt_status)%{$reset_color%}'


#PROMPT="${p}(${name}${p}@${host}${p})-${jobs}(${time}${p})-(${dir}${p}${vcsi}${p})
#(${last}${p}${hist}${p}:${priv}${p})- %{$FX[reset]%}"

#Trying to emulate my old bash prompt
#PROMPT="%{$reset_color%}${name}%{$reset_color%}@${host}%{$reset_color%}:${dir}%{$reset_color%}${vcsi}%{$reset_color%}${priv} %{$reset_color%}"
#RPROMPT="${last} ${time}%{$reset_color%}"
