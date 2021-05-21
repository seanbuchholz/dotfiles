#!/bin/zsh

# create ZIP archive of a file or folder
function zipf() { zip -r "${1%%/}.zip" "$1" ; }
