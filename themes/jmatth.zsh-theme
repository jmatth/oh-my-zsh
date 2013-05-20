# vim: set ft=zsh ts=4 sw=4 expandtab :
functions rbenv_prompt_info >& /dev/null || rbenv_prompt_info(){}

function theme_precmd {
    local TERMWIDTH
    (( TERMWIDTH = ${COLUMNS} - 2 ))


    ###
    # Truncate the path if it's too long.

    PR_FILLBAR=""
    PR_PWDLEN=""

	local promptsize=${#${(%):---(%n@%m:%l)-------}}
    export ZSH_RUBYPROMPT_INFO=`rbenv_prompt_info`
	local rubypromptsize
    (( rubypromptsize = ${#${ZSH_RUBYPROMPT_INFO}} + 0))
    local pwdsize=${#${(%):-%~}}

	export ZSH_VIRTUALENVPROMPT_INFO=`virtualenv_prompt_info`
	local virtualenvpromptsize
	((virtualenvpromptsize = ${#${ZSH_VIRTUALENVPROMPT_INFO}} + 0))

    local prompt_chosen=false

    if ! [[ "$promptsize + $rubypromptsize + $virtualenvpromptsize + $pwdsize" -gt $TERMWIDTH ]]; then
        if [[ -n "$ZSH_RUBYPROMPT_INFO" ]]; then
            ((rubypromptsize = rubypromptsize + 2))
            ZSH_RUBYPROMPT_INFO="${PR_BRACKET_COLOR}[${PR_RED}${ZSH_RUBYPROMPT_INFO}${PR_BRACKET_COLOR}]"
        fi
        if [[ -n "$ZSH_VIRTUALENVPROMPT_INFO" ]]; then
            ((virtualenvpromptsize = virtualenvpromptsize + 3))
            ZSH_VIRTUALENVPROMPT_INFO="${PR_BRACKET_COLOR}[${PR_YELLOW}${ZSH_VIRTUALENVPROMPT_INFO}${PR_BRACKET_COLOR}]"
        fi
        PR_FILLBAR="\${(l.(($TERMWIDTH - ($promptsize + $rubypromptsize + $virtualenvpromptsize + $pwdsize)))..${PR_HBAR}.)}"
        prompt_chosen=true
    fi
    if ! $prompt_chosen && [[ $virtualenvpromptsize -gt 0 ]]; then
        ZSH_RUBYPROMPT_INFO=""
        ((virtualenvpromptsize = virtualenvpromptsize + 3))
        ZSH_VIRTUALENVPROMPT_INFO="${PR_BRACKET_COLOR}[${PR_YELLOW}${ZSH_VIRTUALENVPROMPT_INFO}${PR_BRACKET_COLOR}]"
        PR_FILLBAR="\${(l.(($TERMWIDTH - ($promptsize + $virtualenvpromptsize + $pwdsize)))..${PR_HBAR}.)}"
        prompt_chosen=true
    fi
    if ! $prompt_chosen && [[ $rubypromptsize > 0 ]]; then
        ZSH_VIRTUALENVPROMPT_INFO=""
        ((rubypromptsize = rubypromptsize + 2))
        ZSH_RUBYPROMPT_INFO="${PR_BRACKET_COLOR}[${PR_RED}${ZSH_RUBYPROMPT_INFO}${PR_BRACKET_COLOR}]"
        PR_FILLBAR="\${(l.(($TERMWIDTH - ($promptsize + $rubypromptsize + $pwdsize)))..${PR_HBAR}.)}"
        prompt_chosen=true
    fi
    if ! $prompt_chosen; then
        ZSH_RUBYPROMPT_INFO=""
        ZSH_VIRTUALENVPROMPT_INFO=""
        ((PR_PWDLEN=$TERMWIDTH - $promptsize))
    fi
}


setopt extended_glob
theme_preexec () {
    if [[ "$TERM" == "screen" || "$TERM" == "screen-256color" ]]; then
	local CMD=${1[(wr)^(*=*|sudo|-*)]}
	echo -n "\ek$CMD\e\\"
    fi
}

function vi_mode_prompt_info_left() {
  echo "${${KEYMAP/vicmd/$MODE_INDICATOR_LEFT}/(main|viins)/}"
}

function vi_mode_prompt_info_right() {
  echo "${${KEYMAP/vicmd/$MODE_INDICATOR_RIGHT}/(main|viins)/}"
}

setprompt () {
    ###
    # Need this so the prompt will work.

    setopt prompt_subst


    ###
    # See if we can use colors.

    autoload colors zsh/terminfo
    if [[ "$terminfo[colors]" -ge 8 ]]; then
	colors
    fi
    for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE GREY; do
	eval PR_$color='%{$fg[${(L)color}]%}'
	eval PR_BOLD_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
	(( count = $count + 1 ))
    done
    PR_NO_COLOR="%{$terminfo[sgr0]%}"

    ###
    # Central location for colors of repeated elements
    PR_BRACKET_COLOR=$PR_BLUE
    PR_BAR_COLOR=$PR_CYAN

    ###
    # Modify Git prompt
    ZSH_THEME_GIT_PROMPT_PREFIX="${PR_BRACKET_COLOR}[$PR_YELLOW"
    ZSH_THEME_GIT_PROMPT_SUFFIX="$PR_BRACKET_COLOR]"
    ZSH_THEME_GIT_PROMPT_DIRTY=""
    ZSH_THEME_GIT_PROMPT_CLEAN=""

    #if [[ `tput colors` -ge 256 ]]; then
        #ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%} ✚"
        #ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%} ✹"
        #ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✖"
        #ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%} ➜"
        #ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%} ═"
        #ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} ✭"
        #ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[green]%} ↓"
        #ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[green]%} ↑"
        #ZSH_THEME_GIT_PROMPT_DIVERGED="%{$fg[yellow]%} ⇅"
        #ZSH_THEME_GIT_PROMPT_STASHED="%{$fg[magenta]%} &"
    #else
        ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%} +"
        ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[cyan]%} *"
        ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} x"
        ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[green]%} $"
        ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[red]%} !"
        ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} ?"
        ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[yellow]%} <"
        ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[yellow]%} >"
        ZSH_THEME_GIT_PROMPT_DIVERGED="%{$fg[yellow]%} %"
        ZSH_THEME_GIT_PROMPT_STASHED="%{$fg[magenta]%} &"
    #fi

    #ZSH_THEME_GIT_PROMPT_ADDED="%{$FG[040]%}+%{$reset_color%}"
    #ZSH_THEME_GIT_PROMPT_RENAMED="%{$FG[040]%}$%{$reset_color%}"
    #ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$FG[196]%}?%{$reset_color%}"
    #ZSH_THEME_GIT_PROMPT_MODIFIED="%{$FG[196]%}*%{$reset_color%}"
    #ZSH_THEME_GIT_PROMPT_DELETED="%{$FG[196]%}×%{$reset_color%}"
    #ZSH_THEME_GIT_PROMPT_UNMERGED="%{$FG[196]%}!%{$reset_color%}"
    #ZSH_THEME_GIT_PROMPT_STASHED="%{$FG[207]%}&%{$reset_color%}"
    #ZSH_THEME_GIT_PROMPT_AHEAD="%{$FG[123]%}>%{$reset_color%}"
    #ZSH_THEME_GIT_PROMPT_BEHIND="%{$FG[123]%}<%{$reset_color%}"
    #ZSH_THEME_GIT_PROMPT_DIVERGED="%{$FG[123]%}Ø%{$reset_color%}"

    ###
    # Define characters to indicate vi mode
    MODE_INDICATOR_LEFT="${PR_BOLD_RED}[$PR_NO_COLOR"
    MODE_INDICATOR_RIGHT="$PR_BOLD_RED]$PR_NO_COLOR"

    ###
    # See if we can use extended characters to look nicer.

    typeset -A altchar
    set -A altchar ${(s..)terminfo[acsc]}
    PR_SET_CHARSET="%{$terminfo[enacs]%}"
    PR_SHIFT_IN="%{$terminfo[smacs]%}"
    PR_SHIFT_OUT="%{$terminfo[rmacs]%}"
    PR_HBAR=${altchar[q]:--}
    PR_ULCORNER=${altchar[l]:--}
    PR_LLCORNER=${altchar[m]:--}
    PR_LRCORNER=${altchar[j]:--}
    PR_URCORNER=${altchar[k]:--}

    # Some stuff is broken on the linux vt.
    if [[ "$TERM" == "linux" ]]; then
        PR_HBAR="-"
        PR_LRCORNER="${PR_LRCORNER} "
    fi

    ###
    # Decide if we need to set titlebar text.

    case $TERM in
	xterm*)
	    PR_TITLEBAR=$'%{\e]0;%(!.-=*[ROOT]*=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\a%}'
	    ;;
	screen)
	    PR_TITLEBAR=$'%{\e_screen \005 (\005t) | %(!.-=[ROOT]=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\e\\%}'
	    ;;
	*)
	    PR_TITLEBAR=''
	    ;;
    esac


    ###
    # Decide whether to set a screen title
    if [[ "$TERM" == "screen" ]]; then
	PR_STITLE=$'%{\ekzsh\e\\%}'
    else
	PR_STITLE=''
    fi


    ###
    # Finally, the prompt.

    PROMPT='$PR_SET_CHARSET$PR_STITLE${(e)PR_TITLEBAR}\
$PR_BAR_COLOR$PR_SHIFT_IN$PR_ULCORNER$PR_HBAR$PR_SHIFT_OUT\
${PR_BRACKET_COLOR}[$PR_CYAN%(!.%S${PR_RED}ROOT%s.%n)$PR_NO_COLOR@$PR_GREEN%m:%l$PR_BRACKET_COLOR]\
$PR_BAR_COLOR$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$ZSH_RUBYPROMPT_INFO\
$PR_BAR_COLOR$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$ZSH_VIRTUALENVPROMPT_INFO\
$PR_BAR_COLOR$PR_SHIFT_IN$PR_HBAR$PR_HBAR\
${(e)PR_FILLBAR}$PR_HBAR$PR_SHIFT_OUT\
${PR_BRACKET_COLOR}[$PR_GREEN%$PR_PWDLEN<...<%~%<<$PR_BRACKET_COLOR]\
$PR_BAR_COLOR$PR_SHIFT_IN$PR_HBAR$PR_URCORNER$PR_SHIFT_OUT\

$PR_BAR_COLOR$PR_SHIFT_IN$PR_LLCORNER$PR_HBAR$PR_SHIFT_OUT\
`git_prompt_verbose_info`\
$PR_BAR_COLOR$PR_SHIFT_IN$PR_HBAR$PR_HBAR$PR_SHIFT_OUT\
$PR_NO_COLOR%#$PR_BAR_COLOR${$(vi_mode_prompt_info_left):-">"} '

    # display exitcode on the right when >0
    return_code="%(?..%{$fg[red]%}%?! $PR_NO_COLOR)"
    RPROMPT=' $return_code$PR_BAR_COLOR${$(vi_mode_prompt_info_right):-"<"}$PR_BAR_COLOR$PR_SHIFT_IN$PR_HBAR$PR_HBAR$PR_SHIFT_OUT\
${PR_BRACKET_COLOR}[$PR_YELLOW%!$PR_BRACKET_COLOR]$PR_BAR_COLOR$PR_SHIFT_IN$PR_HBAR$PR_LRCORNER$PR_SHIFT_OUT$PR_NO_COLOR'
    PS2='$PR_NO_COLOR$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_BLUE$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT(\
$PR_BOLD_GREEN%_$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_NO_COLOR$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT$PR_NO_COLOR '
}

setprompt

autoload -U add-zsh-hook
add-zsh-hook precmd  theme_precmd
add-zsh-hook preexec theme_preexec
