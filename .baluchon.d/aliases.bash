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

alias f='fuck'

# open
if command_exists xdg-open; then
   alias open='xdg-open'
fi

# Emacs
alias emacs='emacs -nw'
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
