# zkGames smart contracts

This folder was generated using [Hardhat](https://github.com/NomicFoundation/hardhat) and contains all the smart contracts used in the zkGames application.

There are 3 folders inside the contracts folder, one folder per game. Each game has two smart contracts: one contract for game logic (generate boards, verify boards, mint NFT) and another contract to verify the zk proof (this contract was generated using snarkjs).

## Install dependencies

```bash
yarn install
```

## Run tests

```bash
npx hardhat test
```

When you run tests you will see something like this:

![tests](https://user-images.githubusercontent.com/52170174/166123994-9c68c215-f538-4216-bd50-18d29d4fe4ba.png)

## Deploy on [Harmony Testnet](https://explorer.pops.one/)

Create a `.env` file and add to it:

```text
PRIVATE_KEY=<yourPrivateKey>
```

where `yourPrivateKey` is the private key of your wallet.

To deploy on Harmony Testnet run:

```bash
npx hardhat run scripts/deploy.js --network harmonyTestnet
```

## Deploy on [Harmony Mainnet](https://explorer.harmony.one/)

Create a `.env` file and add to it:

```text
PRIVATE_KEY=<yourPrivateKey>
```

where `yourPrivateKey` is the private key of your wallet.

To deploy on Harmony Mainnet run:

```bash
npx hardhat run scripts/deploy.js --network harmonyMainnet
```

## Futoshiki contracts graph

![futoshikiContractGraph](https://user-images.githubusercontent.com/52170174/166124021-7e4ccae1-9872-48a4-8a89-686ff35e1587.svg)

## Skyscrapers contracts graph

![skyscrapersContractGraph](https://user-images.githubusercontent.com/52170174/166124030-6b159ee9-fc06-4f8b-b64f-12427f9324e9.svg)

## Sudoku contracts graph

![sudokuContractGraph](https://user-images.githubusercontent.com/52170174/166124035-d30acdd6-7fea-4016-a872-59179da939ce.svg)
