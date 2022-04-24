# zkGames smart contracts

This folder was generated using [Hardhat](https://github.com/NomicFoundation/hardhat) and contains all the smart contracts used in the zkGames application.

There are 3 folders inside the contracts folder, one folder per game. Each game has two smart contracts: one contract for game logic (generate boards, verify boards, mint NFT) and another contract to verify the zk proof (this contract was generated using snarkjs).

## Install dependencies

```console
yarn install
```

## Run the functionalities of the application

```console
npx hardhat run scripts/run.js
```

## Deploy on [Harmony Testnet](https://explorer.pops.one/)

Create a `.env` file and add to it:

```text
PRIVATE_KEY=<yourPrivateKey>
```

where `yourPrivateKey` is the private key of your wallet.

To deploy on Harmony Testnet run:

```console
npx hardhat run scripts/deploy.js --network harmonyTestnet
```

<!-- ## Run tests

```console
npx hardhat test
``` -->

## Futoshiki contracts graph

![futoshikiContractGraph](https://user-images.githubusercontent.com/52170174/164951666-c0b74a7d-17e9-45e0-a960-b267d9c1d6f7.svg)

## Skyscrapers contracts graph

![skyscrapersContractGraph](https://user-images.githubusercontent.com/52170174/164951736-55b28772-b09f-4972-b1ad-5806ca1ccc17.svg)

## Sudoku contracts graph

![sudokuContractGraph](https://user-images.githubusercontent.com/52170174/164951740-416b7009-b2b6-4f1f-b8b5-79ff52ad2530.svg)
