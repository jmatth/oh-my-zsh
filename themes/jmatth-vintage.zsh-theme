#!/bin/zsh
#my custom theme

# Different colors and symbols depending on terminal
if [[ `tput colors` -ge 256 ]]
then
	# Mode indicator for vi-mode plugin
	MODE_INDICATOR="%{$fg[yellow]%}»%{$reset_color%}"

	# Promptchar to be displayed in a git repository
	ZSH_THEME_GIT_PROMPT_CHAR="±"

	# Characters to indicate git repo status
	ZSH_THEME_GIT_PROMPT_PREFIX="%{$FG[220]%}["
	ZSH_THEME_GIT_PROMPT_SUFFIX="%{$FG[220]%}] %{$reset_color%}"

	ZSH_THEME_GIT_PROMPT_ADDED="%{$FG[040]%}+%{$reset_color%}"
	ZSH_THEME_GIT_PROMPT_RENAMED="%{$FG[040]%}$%{$reset_color%}"
	ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$FG[196]%}?%{$reset_color%}"
	ZSH_THEME_GIT_PROMPT_MODIFIED="%{$FG[196]%}*%{$reset_color%}"
	ZSH_THEME_GIT_PROMPT_DELETED="%{$FG[196]%}×%{$reset_color%}"
	ZSH_THEME_GIT_PROMPT_UNMERGED="%{$FG[196]%}!%{$reset_color%}"
	ZSH_THEME_GIT_PROMPT_STASHED="%{$FG[207]%}&%{$reset_color%}"
	ZSH_THEME_GIT_PROMPT_AHEAD="%{$FG[123]%}>%{$reset_color%}"
	ZSH_THEME_GIT_PROMPT_BEHIND="%{$FG[123]%}<%{$reset_color%}"
	ZSH_THEME_GIT_PROMPT_DIVERGED="%{$FG[123]%}Ø%{$reset_color%}"

	if [[ $UID == 0 ]]
	then
		ZSH_THEME_NAME="%{$FX[bold]$FG[001]%}%n%{$reset_color%}"
	else
		ZSH_THEME_NAME="%{$FX[bold]$FG[027]%}%n%{$reset_color%}"
	fi

	# And different colors if over ssh
	if (($+SSH_CONNECTION)); then
		ZSH_THEME_HOST="%{$FX[bold]$FG[208]%}%m%{$reset_color%}"
	else
		ZSH_THEME_HOST="%{$FX[bold]$FG[034]%}%m%{$reset_color%}"
	fi

	ZSH_THEME_TIME="%{$FG[005]%}%*%{$reset_color%}"
	ZSH_THEME_DIR="%{$FG[045]%}%~%{$reset_color%}"

	ZSH_THEME_RETURN="%(?.%{$fg[green]%}«.%{$fg_bold[red]%}«%?)%{$reset_color%}"
else
	# Mode indicator for vi-mode plugin
	MODE_INDICATOR="%{$fg[yellow]%}>%{$reset_color%}"

	# Promptchar to be displayed in a git repository
	ZSH_THEME_GIT_PROMPT_CHAR="+"

	# Characters to indicate git repo status
	ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}["
	ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[yellow]%}] %{$reset_color%}"

	ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}+%{$reset_color%}"
	ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[green]%}$%{$reset_color%}"
	ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[red]%}?%{$reset_color%}"
	ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[red]%}*%{$reset_color%}"
	ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}x%{$reset_color%}"
	ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[red]%}!%{$reset_color%}"
	ZSH_THEME_GIT_PROMPT_STASHED="%{$fg[magenta]%}&%{$reset_color%}"
	ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[cyan]%}>%{$reset_color%}"
	ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[cyan]%}<%{$reset_color%}"
	ZSH_THEME_GIT_PROMPT_DIVERGED="%{$fg[cyan]%}0%{$reset_color%}"

	if [[ $UID == 0 ]]
	then
		ZSH_THEME_NAME="%{$fg_bold[red]%}%n%{$reset_color%}"
	else
		ZSH_THEME_NAME="%{$fg[cyan]%}%n%{$reset_color%}"
	fi

	# And different colors if over ssh
	if (($+SSH_CONNECTION)); then
		ZSH_THEME_HOST="%{$fg_bold[red]%}%m%{$reset_color%}"
	else
		ZSH_THEME_HOST="%{$fg[green]%}%m%{$reset_color%}"
	fi

	ZSH_THEME_TIME="%{$fg[magenta]%}%*%{$reset_color%}"
	ZSH_THEME_DIR="%{$fg[cyan]%}%~%{$reset_color%}"

	ZSH_THEME_RETURN="%(?.%{$fg[green]%}<.%{$fg_bold[red]%}<%?)%{$reset_color%}"
fi

# Override colors for syntax highlighting.
if (($+ZSH_HIGHLIGHT_HIGHLIGHTERS))
then
	: ${ZSH_HIGHLIGHT_STYLES[history-expansion]::=fg=magenta}
	: ${ZSH_HIGHLIGHT_STYLES[globbing]::=fg=cyan}
fi

function git_prompt_verbose_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
        ref=$(git rev-parse --short HEAD 2> /dev/null) || return
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(git_prompt_status)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

# Functions used to display the custom prompt character.
function inGit ()
{
	git status -z &> /dev/null && echo "${ZSH_THEME_GIT_PROMPT_CHAR}"
}

function promptChar ()
{
	echo "${$(vi_mode_prompt_info):-${$(inGit):-${ZSH_THEME_PRIV}}}"
}

#lochist="%{$FG[220]%}%!!%{$reset_color%}"
ZSH_THEME_PRIV="%#"

PROMPT='${ZSH_THEME_NAME}@${ZSH_THEME_HOST}:$(promptChar) '
RPROMPT='${ZSH_THEME_DIR} ${ZSH_THEME_RETURN} $(git_prompt_verbose_info)${ZSH_THEME_TIME}'

# Set LS_COLORS
LS_COLORS='no=00:fi=00:di=36:ln=35:pi=30;44:so=35;44:do=35;44:bd=33;44:cd=37;44:or=05;37;41:mi=05;37;41:ex=01;31:*.cmd=01;31:*.exe=01;31:*.com=01;31:*.bat=01;31:*.reg=01;31:*.app=01;31:*.txt=32:*.org=32:*.md=32:*.mkd=32:*.h=32:*.c=32:*.C=32:*.cc=32:*.cpp=32:*.cxx=32:*.objc=32:*.sh=32:*.csh=32:*.zsh=32:*.el=32:*.vim=32:*.java=32:*.pl=32:*.pm=32:*.py=32:*.rb=32:*.hs=32:*.php=32:*.htm=32:*.html=32:*.shtml=32:*.xml=32:*.rdf=32:*.css=32:*.js=32:*.man=32:*.0=32:*.1=32:*.2=32:*.3=32:*.4=32:*.5=32:*.6=32:*.7=32:*.8=32:*.9=32:*.l=32:*.n=32:*.p=32:*.pod=32:*.tex=32:*.bmp=33:*.cgm=33:*.dl=33:*.dvi=33:*.emf=33:*.eps=33:*.gif=33:*.jpeg=33:*.jpg=33:*.JPG=33:*.mng=33:*.pbm=33:*.pcx=33:*.pdf=33:*.pgm=33:*.png=33:*.ppm=33:*.pps=33:*.ppsx=33:*.ps=33:*.svg=33:*.svgz=33:*.tga=33:*.tif=33:*.tiff=33:*.xbm=33:*.xcf=33:*.xpm=33:*.xwd=33:*.xwd=33:*.yuv=33:*.aac=33:*.au=33:*.flac=33:*.mid=33:*.midi=33:*.mka=33:*.mp3=33:*.mpa=33:*.mpeg=33:*.mpg=33:*.ogg=33:*.ra=33:*.wav=33:*.anx=33:*.asf=33:*.avi=33:*.axv=33:*.flc=33:*.fli=33:*.flv=33:*.gl=33:*.m2v=33:*.m4v=33:*.mkv=33:*.mov=33:*.mp4=33:*.mp4v=33:*.mpeg=33:*.mpg=33:*.nuv=33:*.ogm=33:*.ogv=33:*.ogx=33:*.qt=33:*.rm=33:*.rmvb=33:*.swf=33:*.vob=33:*.wmv=33:*.doc=31:*.docx=31:*.rtf=31:*.dot=31:*.dotx=31:*.xls=31:*.xlsx=31:*.ppt=31:*.pptx=31:*.fla=31:*.psd=31:*.7z=1;35:*.apk=1;35:*.arj=1;35:*.bin=1;35:*.bz=1;35:*.bz2=1;35:*.cab=1;35:*.deb=1;35:*.dmg=1;35:*.gem=1;35:*.gz=1;35:*.iso=1;35:*.jar=1;35:*.msi=1;35:*.rar=1;35:*.rpm=1;35:*.tar=1;35:*.tbz=1;35:*.tbz2=1;35:*.tgz=1;35:*.tx=1;35:*.war=1;35:*.xpi=1;35:*.xz=1;35:*.z=1;35:*.Z=1;35:*.zip=1;35:*.ANSI-30-black=30:*.ANSI-01;30-brblack=01;30:*.ANSI-31-red=31:*.ANSI-01;31-brred=01;31:*.ANSI-32-green=32:*.ANSI-01;32-brgreen=01;32:*.ANSI-33-yellow=33:*.ANSI-01;33-bryellow=01;33:*.ANSI-34-blue=34:*.ANSI-01;34-brblue=01;34:*.ANSI-35-magenta=35:*.ANSI-01;35-brmagenta=01;35:*.ANSI-36-cyan=36:*.ANSI-01;36-brcyan=01;36:*.ANSI-37-white=37:*.ANSI-01;37-brwhite=01;37:*.log=01;32:*~=01;32:*#=01;32:*.bak=01;33:*.BAK=01;33:*.old=01;33:*.OLD=01;33:*.org_archive=01;33:*.off=01;33:*.OFF=01;33:*.dist=01;33:*.DIST=01;33:*.orig=01;33:*.ORIG=01;33:*.swp=01;33:*.swo=01;33:*,v=01;33:*.gpg=34:*.gpg=34:*.pgp=34:*.asc=34:*.3des=34:*.aes=34:*.enc=34:';
export LS_COLORS
