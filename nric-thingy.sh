#!/bin/bash 

DisplayHelp() {
  echo -e "Usage:\t./nric-thingy.bat generate <num>"
  echo -e "\tThis will generate <num> NRICs."
}

# Take for example the NRIC number S1234567. 
# first digit you multiply by 2, 
# second multiply by 7, 
# third by 6, 
# fourth by 5, 
# fifth by 4, 
# sixth by 3, 
# seventh by 2. 
# Add the totals together. 
# So 1×2 + 2×7 + 3×6 + 4×5 + 5×4 + 6×3 + 7×2 = 106

GetChecksum() {
  prefixIsSorT=("J" "Z" "I" "H" "G" "F" "E" "D" "C" "B" "A")
  prefixIsForG=("X" "W" "U" "T" "R" "Q" "P" "N" "M" "L" "K")

  PREFIX=$2
  # echo "==============="
  let SUM=0

  for (( i = 0; i < ${#1}; ++i )); do
    if [[ "$i" == 0 ]]; then
      let CURR="$((2 * ${1:$i:1}))"
      let SUM+="$CURR"
    elif [[ $i -gt 0 ]]; then 
      let CURR="$(((8 - $i) * ${1:$i:1}))"
      let SUM+="$CURR"
    fi
  done

  echo $SUM
  if [[ "$PREFIX" == "T" || "$PREFIX" == "G" ]]; then
    let SUM+=4
  fi

  let RMD="$(($SUM % 11))"

  if [[ "$PREFIX" == "S" || "$PREFIX " == "T" ]]; then
    echo ${prefixIsSorT[$RMD]}
  elif [[ "$PREFIX" == "F" || "$PREFIX " == "G" ]]; then
    echo ${prefixIsForG[$RMD]}
  fi
}

GenerateNumber() {
  digits=7

  rand=$(od -A n -t d -N 2 /dev/urandom |tr -d ' ')
  num=$((rand % 10))
  while [ ${#num} -lt $digits ]; do
    rand=$(od -A n -t d -N 1 /dev/urandom |tr -d ' ')
    num="${num}$((rand % 10))"
  done

  echo $num
}

# Verified with online verification thingy - Should return a D.
GetChecksum '1234567' 'S'

# GenerateNumber F
# GetChecksum $(GenerateNumber F)