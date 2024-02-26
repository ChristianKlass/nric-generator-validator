# NRIC Generator

## What is this?

A simple NRIC generator to make generation of fake NRICs for testing easy. They pass the validation check, as they have a valid checksum. It's possible that this script generates real used NRICs, but it's expected, I guess? It's all random.

It will also validate NRICs that you pass it to ensure that it has the correct length, valid prefix, and passes the checksum.

## Generate Valid NRIC Numbers

To generate things run this:

```bash
# ./nric-thingy.sh generate <prefix> <number of NRIC to generate>

./nric-thingy.sh generate S 10

# will produce something like this
S3537782D
S0994205Z
S7745138B
S0934718F
S4607229D
S7598938E
S9875449J
S2373801E
S5475428J
S9760868G
```

## Validate NRIC Numbers

To validate existing numbers, run this:

```bash
# ./nric-thing.sh validate <NRIC>

./nric-thingy.sh validate S3915339D

Valid NRIC!
```

These would pass the validation tests, as in, they are valid NRICs, but they are not official ones. They are for **TESTING PURPOSES ONLY**. Don't use this for illegal things, please.

## Valid Prefixes

There is a check where you can only use valid Prefixes, namely 'S', 'T', 'F', and 'G'. Anything else would not work.
