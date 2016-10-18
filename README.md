# Baluchon
My home configuration

## Quick setup
*Important note: This setup method will override your home configuration*
```
$ cd
$ git clone https://github.com/Grenadingue/baluchon.git
$ mv baluchon/.git .
$ git checkout .bashrc .bashrc.d .gitignore .gitmodules README.md
$ rm -rf baluchon
$ git submodule init
$ git submodule update
```

## Update
```
$ cd
$ git pull origin master
$ git submodule init
$ git submodule update
```
