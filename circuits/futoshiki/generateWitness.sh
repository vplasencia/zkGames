#!/bin/bash

# Compile the circuit
circom futoshiki.circom --r1cs --wasm --sym --c

# Copy the input file inside the futoshiki_js directory
cp input.json futoshiki_js/input.json

# Go inside the futoshiki_js directory and generate the witness.wtns
cd futoshiki_js
node generate_witness.js futoshiki.wasm input.json witness.wtns