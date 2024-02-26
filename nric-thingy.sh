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

# Function to validate an NRIC number
validate_nric() {
  nric=$1

  # Basic length check
  if [[ ${#nric} -ne $((NRIC_LENGTH + 1)) ]]; then
    echo "Invalid NRIC! Incorrect length."
    return 1  # Return an error code 
  fi

  # Extract the prefix, number, and checksum (similar to other functions)
  prefix=${nric:0:1}
  number=${nric:1:7}
  checksum=${nric:8:1}

  # Validate the prefix as before
  if [[ "$prefix" != "S" && "$prefix" != "T" && "$prefix" != "F" && "$prefix" != "G" ]]; then
    echo "Invalid NRIC! Invalid prefix."
    return 1 
  fi

  # Call the get_checksum function to calculate the expected checksum
  expected_checksum=$(get_checksum $prefix $number) 

  # Compare calculated and provided checksums
  if [[ "$checksum" != "$expected_checksum" ]]; then
    echo "Invalid NRIC! Checksum mismatch."

    # Debugging outputs (add these)
    echo "DEBUG - Prefix: $prefix"
    echo "DEBUG - Number: $number"
    echo "DEBUG - Expected Checksum: $expected_checksum" 
    echo "DEBUG - Provided Checksum: $checksum"

    return 1
  fi

  # If it passes all checks:
  echo "Valid NRIC!"
  return 0   # Return success
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

# Main function
main() {
  if [[ $# -lt 2 ]]; then  # Check for at least 2 arguments
    echo "Usage: $0 <action> <prefix> [number_to_generate] [NRIC]"
    echo "Actions: generate, validate"
    exit 1
  fi

  action=$1
  prefix=$2

  case $action in
    "generate")
        if [[ -z "$3" ]]; then
            echo "Missing number of NRICs to generate."
            exit 1
        fi
        num_to_generate=$3
        generate_nrics "$num_to_generate" "$prefix" 
        ;; 
    "validate")
        if [[ -z "$2" ]]; then
            echo "Missing NRIC to validate."
            exit 1
        fi
        validate_nric "$2"
        ;;
     *)
        echo "Invalid action! Use 'generate' or 'validate'."
        exit 1
        ;;
  esac
}

main "$@" 
