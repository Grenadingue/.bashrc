#!/bin/sh

command_exists()
{
    command -v $1 >/dev/null 2>&1
}

ask_yes_no()
{
  answer=""
  while true; do
    echo -en "${style[bold]}${colors[blue]}-> ${style[reset]}$@ [y/n] "
    read -p "" answer
    if [ "${answer}" == "" ]; then
      answer="y";
    fi
    case $answer in
      [Yy]* ) return 0;;
      [Nn]* ) return 1;;
      * ) echo "say what?";;
    esac
  done
}

if ! command_exists git; then
  echo "git not found, updates not available"
  exit 1
fi

cd ~/

if [ ! -d "${HOME}/.git" ]; then
  echo "home directory does not appear to be a git repository"
  exit 1
fi

git status

if ask_yes_no "Do you want to perform a repository update?"; then
  git pull origin master && git submodule update --init
  exit $?
fi

exit 0
