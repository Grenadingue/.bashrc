#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Set user's bin directory path
export PATH=$PATH:~/bin

# Source: unix.stackexchange.com/a/9607
# Detect ssh session
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  SESSION_TYPE="remote/ssh"
# many other tests omitted
else
  case $(ps -o comm= -p $PPID) in
      sshd|*/sshd) SESSION_TYPE="remote/ssh";;
  esac
fi

# Detect operating system
if [ "$(uname)" == "Darwin" ]; then
    OS_NAME="OSX"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    OS_NAME="Linux"
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    OS_NAME="Windows"
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    if [ "$OS_NAME" == "OSX" ]; then
	alias ls='ls -G'
    else
	alias ls='ls --color=auto'
    fi
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Load bash git auto-completion script
if [ -f ~/.bashrc.d/git-completion.bash ]; then
  . ~/.bashrc.d/git-completion.bash
fi

# Load colored man pages bash script
if [ -f ~/.bashrc.d/colored-man.bash ]; then
  . ~/.bashrc.d/colored-man.bash
fi

# My aliases
alias cd..='cd ..'
alias cd...='cd ../..'

alias l='ls'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lr='ls -R'
alias llr='ls -lR'
alias lar='ls -aR'
alias llar='ls -laR'

# Emacs
alias emacs='emacs -nw'
alias ne='emacs'
alias clean='rm -v *~ .*~ 2>/dev/null'

# Debug
alias objdump='objdump -M intel'
alias gdb='gdb -ex "set disassembly-flavor intel"'

# Archlinux
alias blue='sudo systemctl restart bluetooth'

# Define user prompt
PROMPT_COLOR=7 # white

if [ "$SESSION_TYPE" == "remote/ssh" ]; then
  PROMPT_COLOR=2 # green
fi

if [ "$USER" == "root" ]; then
  PROMPT_COLOR=1 # red
fi

# Custom bash prompt via kirsle.net/wizards/ps1.html
PS1="\[$(tput bold)\]\[$(tput setaf $PROMPT_COLOR)\][\u@\h \W]\\$ \[$(tput sgr0)\]"
