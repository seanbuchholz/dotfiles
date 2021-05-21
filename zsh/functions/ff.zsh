#!/bin/zsh

# find file with pattern in name
function ff() { find . ! -readable -prune -o -type f -iname '*'"$*"'*' -ls -print; }
