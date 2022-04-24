# zkGames <!-- omit in toc -->

![zkGamesRepoImage](https://user-images.githubusercontent.com/52170174/164951489-8f3d9b0a-4334-4dfb-b0d6-b6a87ff81424.png)


zkGames is a platform that allows users to play zk (zero knowledge) games and mint an NFT as proof that they have won.

The project is currently on [Harmony Testnet](https://explorer.pops.one/) and the frontend is hosted on [Vercel](https://github.com/vercel/vercel).

zkGames Link:

<https://zkgames.vercel.app/>

## Table of Contents <!-- omit in toc -->

- [Project Structure](#project-structure)
  - [circuits](#circuits)
  - [contracts](#contracts)
  - [zkgames-ui](#zkgames-ui)
- [Run Locally](#run-locally)
  - [Clone the Repository](#clone-the-repository)
  - [Run circuits](#run-circuits)
  - [Run contracts](#run-contracts)
  - [Run zkgames-ui](#run-zkgames-ui)
- [Add New Game](#add-new-game)

## Project Structure

The project has three main folders:

- circuits
- contracts
- zkgames-ui

### circuits

The [circuits folder](/circuits/) contains all the circuits used in zkGames.

To learn more about the zkGames circuits, read the [README file](/circuits/README.md) inside the `circuits` folder.

### contracts

The [contracts folder](/contracts/) contains all the smart contracts used in zkGames.

To learn more about the zkGames smart contracts, read the [README file](/contracts/README.md) inside the `contracts` folder.

### zkgames-ui

The [zkgames-ui folder](/zkgames-ui/) contains the zkGames frontend.

To learn more about the zkGames frontend, read the [README file](/zkgames-ui/README.md) in the `zkgames-ui` folder.

```text
├── circuits
│   ├── futoshiki
│   │   ├── futoshiki.circom
│   ├── skyscrapers
│   │   ├── skyscrapers.circom
│   ├── sudoku
│   │   ├── sudoku.circom
├── contracts
│   ├── contracts
│   │   ├── Futoshiki
│   │   │   ├── Futoshiki.sol
│   │   │   ├── verifier.sol
│   │   ├── Skyscrapers
│   │   │   ├── Skyscrapers.sol
│   │   │   ├── verifier.sol
│   │   ├── Sudoku
│   │   │   ├── Sudoku.sol
│   │   │   ├── verifier.sol
├── zkgames-ui
│   ├── public
│   │   ├── zkproof
│   │   │   ├── futoshiki
│   │   │   │   ├── futoshiki.wasm
│   │   │   │   ├── futoshiki_0001.zkey
│   │   │   ├── skyscrapers
│   │   │   │   ├── skyscrapers.wasm
│   │   │   │   ├── skyscrapers_0001.zkey
│   │   │   ├── sudoku
│   │   │   │   ├── sudoku.wasm
│   │   │   │   ├── sudoku_0001.zkey
│   ├── zkproof
│   │   ├── futoshiki
│   │   │   ├── snarkjsFutoshiki.js
│   │   ├── skyscrapers
│   │   │   ├── snarkjsSkyscrapers.js
│   │   ├── sudoku
│   │   │   ├── snarkjsSudoku.js
│   │   ├── snarkjsZkproof.js
```

## Run Locally

### Clone the Repository

```console
git clone https://github.com/vplasencia/zkGames.git
```

### Run circuits

To run cicuits, go inside the `circuits` folder:

```console
cd circuits
```

Then, follow the intructions in the [README file](/circuits/README.md) in the `circuits` folder.

### Run contracts

To run contracts, go inside the `contracts` folder:

```console
cd contracts
```

Then, follow the intructions in the [README file](/contracts/README.md) in the `contracts` folder.

### Run zkgames-ui

To run the frontend, go inside the `zkgames-ui` folder:

```console
cd zkgames-ui
```

Then, follow the intructions in the [README file](/zkgames-ui/README.md) in the `zkgames-ui` folder.

## Add New Game
