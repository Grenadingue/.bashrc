# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-*color) color_support=yes;;
esac

if [ -n "$force_color" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_support=yes
  else
    color_support=
  fi
fi

colored_man()
{
  env LESS_TERMCAP_mb=$(printf "\e[34m") \
    LESS_TERMCAP_md=$(printf "\e[1;31m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[30;43m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;4;37m") \
    man "$@"
}

if [ "$color_support" == yes ]; then
  # enable color support of ls and also add handy aliases
  alias man='colored_man'
  if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    if [ "$OS" == "Mac OS X" ]; then
      alias ls='ls -G'
    else
      alias ls='ls --color=auto'
    fi
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
  fi
fi
