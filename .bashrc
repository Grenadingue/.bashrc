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
if [ ! $SUDO_USER ] && [ -f ~/.baluchon.d/whereami/whereami ]; then
  . ~/.baluchon.d/whereami/whereami
fi

# Enable handy aliases
if [ -f ~/.baluchon.d/aliases.bash ]; then
  . ~/.baluchon.d/aliases.bash
fi

# Enable color support
# force_color=yes # uncomment to force color support
if [ -f ~/.baluchon.d/enable-color.bash ]; then
  . ~/.baluchon.d/enable-color.bash
fi

# Set custom prompt
if [ -f ~/.baluchon.d/prompt.bash ]; then
  . ~/.baluchon.d/prompt.bash
fi

# Init some shell commands
if [ -f ~/.baluchon.d/init-commands.bash ]; then
  . ~/.baluchon.d/init-commands.bash
fi
