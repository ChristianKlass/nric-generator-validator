# NRIC Generator

## What is this?

A simple NRIC generator to make generation of fake NRICs for testing easy. They pass the validation check, as they have a valid checksum. It's possible that this script generates real used NRICs, but it's expected, I guess? It's all random.

## Generate Valid NRIC Numbers

To generate things run this:

```bash
# ./nric-thingy.sh <num> <prefix>

./nric-thingy.sh 10 S

# will produce something like this
S4719028B
S6914817D
S7564105B
S6811811E
S3200258G
S9333137J
S9290627B
S4946930F
S5971354Z
S1214482B
```

These would pass the validation tests, as in, they are valid NRICs, but they are not official ones. They are for **TESTING PURPOSES ONLY**. Don't use this for illegal things, please.

## Valid Prefixes

There is a check where you can only use valid Prefixes, namely 'S', 'T', 'F', and 'G'. Anything else would not work.
