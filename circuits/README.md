# zkGames circom circuits

This folder contains all the [circom circuits](https://github.com/iden3/circom) used in the zkGames application.

There are 3 circom circuits. There is a circuit for each game: `futoshiki.circom`, `skyscrapers.circom`, `sudoku.circom`.

Each folder contains all the information required for a game, so there is one folder per game.

## Install dependencies

To install all the dependencies run:

```bash
yarn install
```

## Compile circuits and generate and verify the zk-proof using [snarkjs](https://github.com/iden3/snarkjs)

To know how is everything generated, you can see the `execute.sh` file inside each folder (futoshiki, skyscrapers, sudoku).

To compile and run the circuits, go inside each folder.

Run the first time:

```bash
chmod u+x execute.sh
```

And after that, you can always run:

```bash
./execute.sh
```
