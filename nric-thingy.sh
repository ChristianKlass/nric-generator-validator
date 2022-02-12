#!/bin/bash 

DisplayHelp() {
  echo -e "Usage:\t./nric-thingy.bat generate <num>"
  echo -e "\tThis will generate <num> NRICs."
}

GenerateNRIC() {
  prefix=$1
  digits=7

  rand=$(od -A n -t d -N 2 /dev/urandom |tr -d ' ')
  num=$((rand % 10))
  while [ ${#num} -lt $digits ]; do
    rand=$(od -A n -t d -N 1 /dev/urandom |tr -d ' ')
    num="${num}$((rand % 10))"
  done

  echo $prefix$num
}

GenerateNRIC F