# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
  *i*) ;;
	*) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000000
HISTFILESIZE=2000000
HISTTIMEFORMAT="%F %T "

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

colors=$(tput colors)
#echo "$colors colors supported."
#if (($colors >= 256)); then
	# Terminal supports 256 colours
	# I do not yet support more than 8...
#	color_root='\[\e[38;5;9m\]'
#	color_user='\[\e[38;5;10m\]'
#	color_undo='\[\e[0m\]'
#el
if (($colors >= 8)); then
	# Terminal supports only eight colours
	color_undo='\[\e[0m\]'
	exec_ret_t='\[\e[0;32m\]'
	exec_ret_f='\[\e[0;31m\]'
	color_root='\[\e[1;31m\]'
	color_user='\[\e[1;34m\]'
	color_host='\[\e[0;33m\]'
	color_cdir='\[\e[1;36m\]'
else
	# Terminal may not support colour at all
	color_undo=
	exec_ret_t='y'
	exec_ret_f='n'
	color_root=
	color_user=
	color_host=
	color_cdir=
fi

PS1="\$(ret=\$?; if [ \$ret = 0 ]; then echo -en \"${exec_ret_t}0${color_undo}\"; else echo -en \"${exec_ret_f}\${ret}${color_undo}\"; fi)";
if ((EUID == 0)); then
	PS1="$PS1 ${color_root}\u${color_undo}@${color_host}\h${color_undo}:${color_cdir}\$(pwd)${color_undo}\\$ ";
else
	PS1="$PS1 ${color_user}\u${color_undo}@${color_host}\h${color_undo}:${color_cdir}\w${color_undo}\\$ ";
fi;
unset color_undo exec_ret_t exec_ret_f color_root color_user color_host color_cdir;

# If this is an xterm set the title to user@host:dir
case "$TERM" in
	xterm*|rxvt*)
		PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\H: \w\a\]$PS1"
		;;
	*)
		;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	#alias dir='dir --color=auto'
	#alias vdir='vdir --color=auto'

	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

export PROMPT_COMMAND='history -a'
export PATH=$PATH:~/bin/

source ~/.startup/00-index.sh;
