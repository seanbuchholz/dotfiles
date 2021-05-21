#!/bin/zsh

# make directories and files access rights sane
function fixperms() { chmod -R u=rwX,g=rX,o= "$@" ; }
