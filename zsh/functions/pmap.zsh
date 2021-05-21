#!/bin/zsh

# Reliable Penguin stack map
function pmap {
  if [ -z $1 ]; then
    echo "please provide a URL/partial URL"
    return
  fi
  ssh jenkins "cat /jd/configs/penguin.map" | grep $1
}
