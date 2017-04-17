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

# Emacs
alias emacs='emacs -nw'
alias ne='emacs'
alias clean='rm -v *~ .*~ 2>/dev/null'

# Debug
alias objdump='objdump -M intel'
alias gdb='gdb -ex "set disassembly-flavor intel"'

# System
alias 'super-cp'='rsync -ah --partial --inplace --info=progress2'
alias dd='dd status=progress'

# Archlinux
alias blue='sudo systemctl restart bluetooth'
