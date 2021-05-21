#!/bin/zsh

# ---- DIR CONFIG ----
export XDG_CACHE_HOME="$HOME/.cache"
export ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh"
[ -d $ZSH_CACHE_DIR ] || mkdir -p $ZSH_CACHE_DIR
export XDG_CONFIG_HOME="$HOME/.dotfiles"
export ZCONF=$XDG_CONFIG_HOME/zsh/configs # path to zsh config

# ---- MACOS ----
if [[ "$OSTYPE" == "darwin"* ]]; then # homebrew configs for macos
  export PATH="/usr/local/sbin:$PATH"
  export PATH="/usr/local/opt/sqlite/bin:$PATH"
  #export M2_REPO="~/.m2"
fi

# ---- GENERAL ----
export BLOCKSIZE=1k # set default blocksize for ls, df, du

# ---- AUTOCOMPLETE ----

#setopt MENU_COMPLETE

# ---- INPUT ----

# reduce vim timeouts
# https://www.johnhawthorn.com/2012/09/vi-escape-delays/
KEYTIMEOUT=1 # 10ms for key sequences
#bindkey -v # use vim keybinds

# ---- LOCALE ----
# (used by perl, ruby etc)
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# ---- APPS ----
export ENHANCD_FILTER=fzy;
