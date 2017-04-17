command_exists()
{
    command -v $1 >/dev/null 2>&1
}

# Autoenv github.com/kennethreitz/autoenv
if [ -f /usr/share/autoenv-git/activate.sh ]; then
  . /usr/share/autoenv-git/activate.sh
fi

# Node version manager
if [ -f /usr/share/nvm/init-nvm.sh ]; then
  source /usr/share/nvm/init-nvm.sh
fi

# Archlinux pacman like package manager wrapper
# Try to enable pacapt as pacman if we're not on Arch
if [ -f ~/.bashrc.d/pacapt-enabler.bash ]; then
  . ~/.bashrc.d/pacapt-enabler.bash
fi

# Load bash git auto-completion script
if [ -f ~/.bashrc.d/git-completion.bash ]; then
  . ~/.bashrc.d/git-completion.bash
fi

# The fuck
if command_exists fuck; then
  eval $(thefuck --alias)
fi

# Export default editor
if command_exists emacs; then
  export EDITOR='emacs -nw'
elif command_exists vim; then
  export EDITOR='vim'
elif command_exists vi; then
  export EDITOR='emacs -nw'
fi
