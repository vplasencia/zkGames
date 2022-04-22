#!/bin/bash

# Compile the circuit
circom skyscrapers.circom --r1cs --wasm --sym --c

# Copy the input file inside the skyscrapers_js directory
cp input.json skyscrapers_js/input.json

# Go inside the skyscrapers_js directory and generate the witness.wtns
cd skyscrapers_js
node generate_witness.js skyscrapers.wasm input.json witness.wtns