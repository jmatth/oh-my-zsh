# Changing/making/removing directory
setopt auto_name_dirs
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus

alias ..='cd ..'
alias cd..='cd ..'
alias cd...='cd ../..'
alias cd....='cd ../../..'
alias cd.....='cd ../../../..'
alias cd/='cd /'

alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

alias md='mkdir -p'
alias rd=rmdir
alias d='dirs -v | head -10'

# mkdir & cd to it
function mkcd() { 
  mkdir -p "$1" && cd "$1"; 
}

# move up n directories
function up () {

	if (( $# == 0 ))
	then
		cd ../
	elif (( $# > 1 ))
	then
		echo "Usage: up [int]"
		return 2
	else
		case $1 in
			''|*[!0-9]*) echo "Usage: up [int]"; return 2 ;;
		esac
		numdirs=""
		for i in `seq 1 $1`
		do
			numdirs="$numdirs../"
		done
		cd $numdirs
	fi
}
