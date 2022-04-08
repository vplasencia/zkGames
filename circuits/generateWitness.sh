#!/bin/bash

# Compile the circuit
circom sudoku.circom --r1cs --wasm --sym --c

# Copy the input file inside the multiplier_js directory
cp input.json sudoku_js/input.json

# Go inside the multiplier_js directory and generate the witness.wtns
cd sudoku_js
node generate_witness.js sudoku.wasm input.json witness.wtns