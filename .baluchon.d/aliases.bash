command_exists()
{
    command -v $1 >/dev/null 2>&1
}

# My aliases
alias cd..='cd ..'
alias cd...='cd ../..'

alias l='ls'
alias ll='ls -lh'
alias la='ls -Ah'
alias lla='ls -lah'
alias lr='ls -R'
alias llr='ll -R'
alias lar='la -R'
alias llar='lla -R'

_mkcd() { mkdir -p "${@}" && cd "${@}"; }
alias mkcd='_mkcd'

alias f='fuck'

# open
if command_exists xdg-open; then
   alias open='xdg-open'
fi

# Emacs
alias emacs='emacs-open-at-line -nw'
alias ne='emacs'
alias clean='rm -v *~ .*~ 2>/dev/null'

# Vi/Vim
if command_exists vim; then
    alias vi='vim'
elif command_exists vi && ! command_exists vim; then
    alias vim='vi'
fi

# Debug
alias objdump='objdump -M intel'
alias gdb='gdb -ex "set disassembly-flavor intel"'

# System
alias 'super-cp'='rsync -ah --partial --inplace --info=progress2'
alias dd='dd status=progress'

# Archlinux
alias blue='sudo systemctl restart bluetooth'

# Man
## Force always showing line number and percentage
## https://askubuntu.com/questions/905322/man-pages-how-to-always-show-total-lines-and-percentage-in-the-bottom-status
if alias man 2>&1 1>/dev/null; then
  alias man="LESS=+Gg $(alias man | cut -d\' -f2)"
else
  alias man='LESS=+Gg man'
fi
