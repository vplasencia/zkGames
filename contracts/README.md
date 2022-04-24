# zkGames smart contracts

This folder was generated using [Hardhat](https://github.com/NomicFoundation/hardhat) and contains all the smart contracts used in the zkGames application.

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
