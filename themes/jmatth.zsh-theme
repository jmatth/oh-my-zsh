# vim: set ft=zsh ts=4 sw=4 expandtab :
functions rbenv_prompt_info >& /dev/null || rbenv_prompt_info(){}

function theme_precmd {
    local TERMWIDTH
    (( TERMWIDTH = ${COLUMNS} - 2 ))

    ###
    # Fit as much info in the top line as possible

    PR_FILLBAR=""
    PR_PWDLEN=""

    local promptsize=${#${(%):---(%n@%m:%l)----}}

    local pwdsize=${#${(%):-%~}}

    export ZSH_RUBYPROMPT_INFO=`rbenv_prompt_info | tr -d '\n'`
    local rubypromptsize=${#${ZSH_RUBYPROMPT_INFO}}
    if [[ -n "$ZSH_RUBYPROMPT_INFO" ]]; then
        (( rubypromptsize = rubypromptsize + 3 ))
        ZSH_RUBYPROMPT_INFO="$PR_BAR_COLOR$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT${PR_BRACKET_COLOR}[${PR_RED}${ZSH_RUBYPROMPT_INFO}${PR_BRACKET_COLOR}]"
    else
        ZSH_RUBYPROMPT_INFO=""
    fi

    export ZSH_VIRTUALENVPROMPT_INFO=`virtualenv_prompt_info`
    local virtualenvpromptsize=${#${ZSH_VIRTUALENVPROMPT_INFO}}
    if [[ -n "$ZSH_VIRTUALENVPROMPT_INFO" ]]; then
        (( virtualenvpromptsize = virtualenvpromptsize + 3 ))
        ZSH_VIRTUALENVPROMPT_INFO="$PR_BAR_COLOR$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT${PR_BRACKET_COLOR}[${PR_YELLOW}${ZSH_VIRTUALENVPROMPT_INFO}${PR_BRACKET_COLOR}]"
    else
        ZSH_VIRTUALENVPROMPT_INFO=""
    fi

    local prompt_chosen=false
    if [[ "$promptsize + $rubypromptsize + $virtualenvpromptsize + $pwdsize" -le $TERMWIDTH ]]; then
        PR_FILLBAR="\${(l.(($TERMWIDTH - ($promptsize + $rubypromptsize + $virtualenvpromptsize + $pwdsize)))..${PR_HBAR}.)}"
        prompt_chosen=true
    fi
    if ! $prompt_chosen && [[ $virtualenvpromptsize -gt 1 ]] && \
        [[ "$virtualenvpromptsize + $promptsize + $pwdsize" -le $TERMWIDTH ]]; then
        ZSH_RUBYPROMPT_INFO=""
        PR_FILLBAR="\${(l.(($TERMWIDTH - ($promptsize + $virtualenvpromptsize + $pwdsize)))..${PR_HBAR}.)}"
        prompt_chosen=true
    fi
    if ! $prompt_chosen && [[ $rubypromptsize -gt 0 ]] && \
        [[ "$rubypromptsize + $promptsize + $pwdsize" -le $TERMWIDTH ]]; then
        ZSH_VIRTUALENVPROMPT_INFO=""
        PR_FILLBAR="\${(l.(($TERMWIDTH - ($promptsize + $rubypromptsize + $pwdsize)))..${PR_HBAR}.)}"
        prompt_chosen=true
    fi
    if ! $prompt_chosen && [[ "$pwdsize + $promptsize" -le $TERMWIDTH ]]; then
        ZSH_RUBYPROMPT_INFO=""
        ZSH_VIRTUALENVPROMPT_INFO=""
        PR_FILLBAR="\${(l.(($TERMWIDTH - ($promptsize + $pwdsize)))..${PR_HBAR}.)}"
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
    PR_BAR_COLOR=$PR_BLUE

    ###
    # Modify Git prompt
    ZSH_THEME_GIT_PROMPT_PREFIX="${PR_BRACKET_COLOR}[$PR_YELLOW"
    ZSH_THEME_GIT_PROMPT_SUFFIX="$PR_BRACKET_COLOR]"
    ZSH_THEME_GIT_PROMPT_DIRTY=""
    ZSH_THEME_GIT_PROMPT_CLEAN=""

    ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%} +"
    ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[red]%} *"
    ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} x"
    ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[green]%} $"
    ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[red]%} !"
    ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[red]%} ?"
    ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[yellow]%} <"
    ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[yellow]%} >"
    ZSH_THEME_GIT_PROMPT_DIVERGED="%{$fg[yellow]%} %"
    ZSH_THEME_GIT_PROMPT_STASHED="%{$fg[magenta]%} &"

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
    # Use different color for hostname over ssh
    if (($+SSH_CONNECTION)); then
        PR_HOST_COLOR=$PR_YELLOW
    else
        PR_HOST_COLOR=$PR_GREEN
    fi

    ###
    # Finally, the prompt.

    PROMPT='$PR_SET_CHARSET$PR_STITLE${(e)PR_TITLEBAR}\
$PR_BAR_COLOR$PR_SHIFT_IN$PR_ULCORNER$PR_HBAR$PR_SHIFT_OUT\
${PR_BRACKET_COLOR}[$PR_GREEN%$PR_PWDLEN<...<%~%<<$PR_BRACKET_COLOR]\
$PR_BAR_COLOR$PR_SHIFT_IN${(e)PR_FILLBAR}$PR_SHIFT_OUT\
$ZSH_VIRTUALENVPROMPT_INFO\
$ZSH_RUBYPROMPT_INFO\
$PR_BAR_COLOR$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
${PR_BRACKET_COLOR}[%(!.%S${PR_RED}ROOT%s.$PR_CYAN%n)$PR_NO_COLOR@$PR_HOST_COLOR%m:%l$PR_BRACKET_COLOR]\
$PR_BAR_COLOR$PR_SHIFT_IN$PR_HBAR$PR_URCORNER$PR_SHIFT_OUT\

$PR_BAR_COLOR$PR_SHIFT_IN$PR_LLCORNER$PR_HBAR$PR_SHIFT_OUT\
`git_prompt_verbose_info`\
$PR_BAR_COLOR$PR_SHIFT_IN$PR_HBAR$PR_HBAR$PR_SHIFT_OUT\
$PR_NO_COLOR%#$PR_BAR_COLOR${$(vi_mode_prompt_info_left):-">"} '

    # display exitcode on the right when >0
    return_code="%(?..%{$fg[red]%}%?! $PR_NO_COLOR)"
    RPROMPT=' $return_code$PR_BAR_COLOR${$(vi_mode_prompt_info_right):-"<"}$PR_BAR_COLOR$PR_SHIFT_IN$PR_HBAR$PR_HBAR$PR_SHIFT_OUT\
${PR_BRACKET_COLOR}[$PR_MAGENTA%!$PR_BRACKET_COLOR]$PR_BAR_COLOR$PR_SHIFT_IN$PR_HBAR$PR_LRCORNER$PR_SHIFT_OUT$PR_NO_COLOR'
    PS2='$PR_NO_COLOR$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_BLUE$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT(\
$PR_BOLD_GREEN%_$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_NO_COLOR$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT$PR_NO_COLOR '
}

setprompt

autoload -U add-zsh-hook
add-zsh-hook precmd  theme_precmd
add-zsh-hook preexec theme_preexec
