# zkGames circom circuits

This folder contains all the [circom circuits](https://github.com/iden3/circom) used in the zkGames application.

## Install dependencies

To install all the dependencies run:

```console
yarn install
```

## Compile circuits and generate and verify the zk-proof using [snarkjs](https://github.com/iden3/snarkjs)

To know how is everything generated, you can see the `execute.sh` file inside each folder (futoshiki, skyscrapers, sudoku).

To compile and run the circuits, go inside each folder.

Run the first time:

```console
chmod u+x execute.sh
```

And after that, you can always run:

```console
./execute.sh
```
