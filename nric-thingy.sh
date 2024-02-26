#!/bin/bash

# Constants
NRIC_LENGTH=8
WEIGHTS=(2 7 6 5 4 3 2)
PREFIX_ST=("J" "Z" "I" "H" "G" "F" "E" "D" "C" "B" "A")
PREFIX_FG=("X" "W" "U" "T" "R" "Q" "P" "N" "M" "L" "K")

# Get checksum for an NRIC number (without the checksum character)
get_checksum() {
  local prefix=$1 number=$2 sum=0

  for (( i=0; i<${#number}; i++ )); do
    sum=$(( sum + ${WEIGHTS[i]} * ${number:$i:1} ))
  done

  if [[ "$prefix" == "T" || "$prefix" == "G" ]]; then
    sum=$(( sum + 4 ))
  fi

  remainder=$(( sum % 11 ))

  if [[ "$prefix" == "S" || "$prefix" == "T" ]]; then
    echo "${PREFIX_ST[$remainder]}"
  else
    echo "${PREFIX_FG[$remainder]}" 
  fi
}

# Generate a random NRIC number
generate_nric() {
  local prefix=$1

  # Generate random 7-digit number
  number=$(printf "%07d" $(shuf -i 0-9999999 -n 1)) 

  # Get checksum
  checksum=$(get_checksum $prefix $number)

  # Construct the full NRIC
  echo "$prefix$number$checksum"
}

# Main function
generate_nrics() {
  local num_to_generate=$1 prefix=$2

  # Input validation
  if [[ -z "$num_to_generate" || -z "$prefix" ]]; then
    echo "Usage: $0 <number_to_generate> <prefix>"
    exit 1
  fi

  valid_prefixes=("S" "T" "F" "G")
  if [[ ! " ${valid_prefixes[*]} " =~ " $prefix " ]]; then
    echo "Invalid prefix!"
    exit 1
  fi

  # Generate NRICs
  for (( i=0; i<$num_to_generate; i++ )); do
    generate_nric "$prefix"
  done
}

generate_nrics "$@" 
