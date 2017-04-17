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
HISTSIZE=30000
HISTFILESIZE=${HISTSIZE}

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

# Get information about current execution environment
# (Like operating system, distribution, kernel, ...)
if [ ! $SUDO_USER ] && [ -f ~/.bashrc.d/whereami/whereami ]; then
  . ~/.bashrc.d/whereami/whereami
fi

if [ -f ~/.bashrc.d/aliases.bash ]; then
  . ~/.bashrc.d/aliases.bash
fi

# Enable color support
if [ -f ~/.bashrc.d/color/colored-base.bash ]; then
  . ~/.bashrc.d/color/colored-base.bash
fi
if [ -f ~/.bashrc.d/color/colored-man.bash ]; then
  . ~/.bashrc.d/color/colored-man.bash
fi

# Load bash git auto-completion script
if [ -f ~/.bashrc.d/git-completion.bash ]; then
  . ~/.bashrc.d/git-completion.bash
fi

# Init some shell commands
if [ -f ~/.bashrc.d/commands_init.bash ]; then
  . ~/.bashrc.d/commands_init.bash
fi

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
