# zkGames <!-- omit in toc -->

![zkGamesRepoImage](https://user-images.githubusercontent.com/52170174/164951489-8f3d9b0a-4334-4dfb-b0d6-b6a87ff81424.png)

zkGames is a platform that allows users to play zk (zero knowledge) games and mint an NFT as proof that they have won.

<!-- The project is currently on [Harmony Testnet](https://explorer.pops.one/) and the frontend is hosted on [Vercel](https://github.com/vercel/vercel). -->

The project is currently on [Harmony Mainnet](https://explorer.harmony.one/) and the frontend is hosted on [Vercel](https://github.com/vercel/vercel).

zkGames has 3 games so far: Futoshiki, Skyscrapers and Sudoku.

zkGames Link:

<https://zkgames.one/>

zkGames Demo Video:

<https://youtu.be/EpeK3WzmS8Y>

## Table of Contents <!-- omit in toc -->

- [Project Structure](#project-structure)
  - [circuits](#circuits)
  - [contracts](#contracts)
  - [zkgames-ui](#zkgames-ui)
- [Zero Knowledge Structure](#zero-knowledge-structure)
- [Run Locally](#run-locally)
  - [Clone the Repository](#clone-the-repository)
  - [Run circuits](#run-circuits)
  - [Run contracts](#run-contracts)
  - [Run zkgames-ui](#run-zkgames-ui)
- [Steps to Add a New Game](#steps-to-add-a-new-game)
- [Some Images of the zkGames Application](#some-images-of-the-zkgames-application)
  - [Initial page](#initial-page)
  - [Futoshiki Game](#futoshiki-game)
  - [Skyscrapers Game](#skyscrapers-game)
  - [Sudoku Game](#sudoku-game)

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

## Zero Knowledge Structure

The following graphic shows the structure of the most important zero knowledge elements of the zkGames project.

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

```bash
git clone https://github.com/vplasencia/zkGames.git
```

### Run circuits

To run cicuits, go inside the `circuits` folder:

```bash
cd circuits
```

Then, follow the intructions in the [README file](/circuits/README.md) in the `circuits` folder.

### Run contracts

To run contracts, go inside the `contracts` folder:

```bash
cd contracts
```

Then, follow the intructions in the [README file](/contracts/README.md) in the `contracts` folder.

### Run zkgames-ui

To run the frontend, go inside the `zkgames-ui` folder:

```bash
cd zkgames-ui
```

Then, follow the intructions in the [README file](/zkgames-ui/README.md) in the `zkgames-ui` folder.

## Steps to Add a New Game

Steps to follow to add a new game (in each step you can check how is done with the other games):

1\. **Create the required circom circuits:**

- Inside the circuits folder, create a new folder and inside the new folder, create the necessary circom circuits.
- Compile the circuit and generate the `wasm`, `zkey` and `verifier.sol` files using the `execute.sh` file.

2\. **Create the necessary smart contracts:**

- Inside the `contracts/contracts` folder, create a new folder with the necessary smart contracts. Add here the verifier.sol generated before using snarkjs.
- Change the solidity version to `^0.8.4` (it is the version used in the other smart contracts) and the contract name (to `<gameName>Verifier`) in `verifier.sol`.
- Test the functionalities of the new smart contracts in `scripts/run.js`.
- Update the `contracts/scripts/deploy.js` file and deploy smart contracts.

3\. **Create the user interface of the game:**

- Inside `zkgames-ui/components`, add a new folder to create all the components needed to render the game.
- Add a new page inside `zkgames-ui/pages` to access the new game.
- Create the css of that page inside `zkgames-ui/styles`, called `<GameName>.module.css`.
- Add an image inside `zkgames-ui/assets` to represent the game (width: 700 pixels and height: 700 pixels).
- Inside `zkgames-ui/public/zkproof` add a new folder with the wasm and zkey elements generated before.
- Inside `zkgames-ui/utils/abiFiles`, add a new folder with the `json` abi file of the smart contract.
- In `zkgames-ui/utils/contractaddress.json`, add the new contract address.
- In `zkgames-ui/zkproof`, create a new folder and inside the new folder create a new file called `snarkjs<NewGame>.js` with the code to export the call data.
- In `zkgames-ui/components/gameList.js` add the game as follows:

```javascript
 {
   nameGame: "<nameGame>",
   imageGame: nameGameImage,
   urlGame: "/<nameGame>",
 }
```

## Some Images of the zkGames Application

### Initial page

![InitialPage](https://user-images.githubusercontent.com/52170174/164957823-ea7dfb78-c151-4830-b714-e3f66a424d57.png)

### Futoshiki Game

![FutoshikiGame](https://user-images.githubusercontent.com/52170174/164957832-95c27552-8248-453c-a6e3-7bca2d97d087.png)

### Skyscrapers Game

![SkyscrapersGame](https://user-images.githubusercontent.com/52170174/164957837-959530b8-399b-4551-8a37-145e9ff70e3e.png)

### Sudoku Game

![SudokuGame](https://user-images.githubusercontent.com/52170174/164957841-08d9166d-99ba-4dbe-88b1-86a507734e6c.png)
