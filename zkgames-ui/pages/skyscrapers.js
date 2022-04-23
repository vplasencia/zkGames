import Board from "../components/skyscrapers/board";
import React, { useEffect, useState } from "react";
import NumbersKeyboard from "../components/skyscrapers/numbersKeyboard";
import Head from "next/head";
import GoBack from "../components/goBack";
import styles from "../styles/Skyscrapers.module.css";
import {
  useAccount,
  useConnect,
  useContract,
  useProvider,
  useSigner,
  useNetwork,
} from "wagmi";

import { switchNetwork } from "../utils/switchNetwork";

import networks from "../utils/networks.json";

import { skyscrapersCalldata } from "../zkproof/skyscrapers/snarkjsSkyscrapers";

import contractAddress from "../utils/contractaddress.json";

import skyscrapersContractAbi from "../utils/abiFiles/Skyscrapers/Skyscrapers.json";

let skyscrapersBoolInitialTemp = [
  [false, false, false, false, false],
  [false, false, false, false, false],
  [false, false, false, false, false],
  [false, false, false, false, false],
  [false, false, false, false, false],
];

export default function Skyscrapers() {
  const [skyscrapersInitial, setSkyscrapersInitial] = useState([]);
  const [skyscrapersAmountInitial, setSkyscrapersAmountInitial] = useState([]);
  const [skyscrapers, setSkyscrapers] = useState([]);
  const [skyscrapersBoolInitial, setSkyscrapersBoolInitial] = useState(
    skyscrapersBoolInitialTemp
  );
  const [selectedPosition, setSelectedPosition] = useState([]);

  const [connectQuery, connect] = useConnect();
  const [accountQuery, disconnect] = useAccount();
  const [{ data, error, loading }] = useNetwork();

  const [loadingVerifyBtn, setLoadingVerifyBtn] = useState(false);
  const [loadingVerifyAndMintBtn, setLoadingVerifyAndMintBtn] = useState(false);
  const [loadingStartGameBtn, setLoadingStartGameBtn] = useState(false);

  const [signer] = useSigner();

  const provider = useProvider();

  const contract = useContract({
    addressOrName: contractAddress.skyscrapersContract,
    contractInterface: skyscrapersContractAbi.abi,
    signerOrProvider: signer.data || provider,
  });

  const contractNoSigner = useContract({
    addressOrName: contractAddress.skyscrapersContract,
    contractInterface: skyscrapersContractAbi.abi,
    signerOrProvider: provider,
  });

  const updatePosition = (number) => {
    if (selectedPosition.length > 0) {
      if (!skyscrapersBoolInitial[selectedPosition[0]][selectedPosition[1]])
        return;
      const temp = [...skyscrapers];
      temp[selectedPosition[0]][selectedPosition[1]] = number;
      setSkyscrapers(temp);
      console.log("skyscrapers", skyscrapers);
    }
  };

  const calculateProof = async () => {
    setLoadingVerifyBtn(true);
    console.log("skyscrapersInitial", skyscrapersInitial);
    console.log("skyscrapers", skyscrapers);
    let calldata = await skyscrapersCalldata(
      skyscrapersInitial,
      skyscrapers,
      skyscrapersAmountInitial
    );

    if (!calldata) {
      setLoadingVerifyBtn(false);
      return "Invalid inputs to generate witness.";
    }

    // console.log("calldata", calldata);

    try {
      let result;
      if (
        accountQuery.data?.address &&
        data.chain.id.toString() === networks.selectedChain
      ) {
        result = await contract.verifySkyscrapers(
          calldata[0],
          calldata[1],
          calldata[2],
          calldata[3]
        );
      } else {
        result = await contractNoSigner.verifySkyscrapers(
          calldata[0],
          calldata[1],
          calldata[2],
          calldata[3]
        );
      }
      console.log("result", result);
      setLoadingVerifyBtn(false);
      alert("Successfully verified");
    } catch (error) {
      setLoadingVerifyBtn(false);
      alert("Wrong solution");
    }
  };

  const verifySkyscrapers = async () => {
    console.log("Address", accountQuery.data?.address);
    calculateProof();
  };

  const calculateProofAndMintNft = async () => {
    setLoadingVerifyAndMintBtn(true);
    console.log("skyscrapersInitial", skyscrapersInitial);
    console.log("skyscrapers", skyscrapers);
    let calldata = await skyscrapersCalldata(
      skyscrapersInitial,
      skyscrapers,
      skyscrapersAmountInitial
    );

    if (!calldata) {
      setLoadingVerifyAndMintBtn(false);
      return "Invalid inputs to generate witness.";
    }

    // console.log("calldata", calldata);

    try {
      let txn = await contract.verifySkyscrapersAndMintNft(
        calldata[0],
        calldata[1],
        calldata[2],
        calldata[3]
      );
      await txn.wait();
      setLoadingVerifyAndMintBtn(false);
      alert(
        `Successfully verified! The NFT has been minted and sent to your wallet. You can see the contract here: ${
          networks[networks.selectedChain].blockExplorerUrls[0]
        }address/${contractAddress.skyscrapersContract}`
      );
    } catch (error) {
      setLoadingVerifyAndMintBtn(false);
      alert("Wrong solution");
    }
  };

  const verifySkyscrapersAndMintNft = async () => {
    console.log("Address", accountQuery.data?.address);
    calculateProofAndMintNft();
  };

  const renderVerifySkyscrapers = () => {
    return (
      <button
        className="flex justify-center items-center disabled:cursor-not-allowed space-x-3 verify-btn text-lg font-medium rounded-md px-5 py-3 w-full bg-gradient-to-r from-purple-600 to-indigo-600 hover:from-purple-500 hover:to-indigo-500"
        onClick={verifySkyscrapers}
        disabled={loadingVerifyBtn}
      >
        {loadingVerifyBtn && <div className={styles.loader}></div>}
        <span>Verify Skyscrapers</span>
      </button>
    );
  };

  const renderVerifySkyscrapersAndMintNft = () => {
    if (!accountQuery.data?.address) {
      return (
        <button
          className="text-lg font-medium rounded-md px-5 py-3 w-full bg-gradient-to-r from-purple-600 to-indigo-600 hover:from-purple-500 hover:to-indigo-500"
          onClick={() => {
            connect(connectQuery.data.connectors[0]);
          }}
        >
          Connect Wallet to Verify Skyscrapers & Mint NFT
        </button>
      );
    } else if (
      accountQuery.data?.address &&
      data.chain.id.toString() !== networks.selectedChain
    ) {
      return (
        <button
          className="text-lg font-medium rounded-md px-5 py-3 bg-gradient-to-r from-purple-600 to-indigo-600 hover:from-purple-500 hover:to-indigo-500"
          onClick={() => {
            switchNetwork();
          }}
        >
          Switch Network to Verify Skyscrapers & Mint NFT
        </button>
      );
    } else {
      return (
        <button
          className="flex justify-center items-center disabled:cursor-not-allowed space-x-3 verify-btn text-lg font-medium rounded-md px-5 py-3 w-full bg-gradient-to-r from-purple-600 to-indigo-600 hover:from-purple-500 hover:to-indigo-500"
          onClick={verifySkyscrapersAndMintNft}
          disabled={loadingVerifyAndMintBtn}
        >
          {loadingVerifyAndMintBtn && <div className={styles.loader}></div>}
          <span>Verify Skyscrapers & Mint NFT</span>
        </button>
      );
    }
  };

  const initializeBoard = async () => {
    try {
      let board;

      if (
        accountQuery.data?.address &&
        data.chain.id.toString() === networks.selectedChain
      ) {
        board = await contract.generateSkyscrapersBoard(new Date().toString());
      } else {
        board = await contractNoSigner.generateSkyscrapersBoard(
          new Date().toString()
        );
      }

      console.log("result", board);

      setSkyscrapersInitial(board[0]);
      setSkyscrapersAmountInitial(board[1]);

      console.log("inequalities: ", board[1]);

      let newArray = board[0].map((arr) => {
        return arr.slice();
      });
      setSkyscrapers(newArray);

      const temp = [
        [false, false, false, false, false],
        [false, false, false, false, false],
        [false, false, false, false, false],
        [false, false, false, false, false],
        [false, false, false, false, false],
      ];
      for (let i = 0; i < board[0].length; i++) {
        for (let j = 0; j < board[0].length; j++) {
          if (board[0][i][j] === 0) {
            temp[i][j] = true;
          }
        }
      }
      setSkyscrapersBoolInitial(temp);
    } catch (error) {
      console.log(error);
      alert("Failed fetching Skyscrapers board");
    }
  };

  const renderNewGame = () => {
    return (
      <button
        className="flex justify-center items-center disabled:cursor-not-allowed space-x-3 verify-btn text-lg font-medium rounded-md px-5 py-3 w-full bg-gradient-to-r from-purple-600 to-indigo-600 hover:from-purple-500 hover:to-indigo-500"
        onClick={async () => {
          setLoadingStartGameBtn(true);
          await initializeBoard();
          setLoadingStartGameBtn(false);
        }}
        disabled={loadingStartGameBtn}
      >
        {loadingStartGameBtn && <div className={styles.loader}></div>}
        <span>New Game</span>
      </button>
    );
  };

  const renderSkyscrapers = () => {
    if (skyscrapers.length !== 0) {
      return (
        <>
          <div>
            <Board
              skyscrapersAmountInitial={skyscrapersAmountInitial}
              skyscrapers={skyscrapers}
              setSelectedPosition={(pos) => setSelectedPosition(pos)}
              selectedPosition={selectedPosition}
              skyscrapersBoolInitial={skyscrapersBoolInitial}
            />
          </div>
          <div>
            <div className="flex justify-center items-center my-10">
              {renderNewGame()}
            </div>
            <NumbersKeyboard updatePosition={updatePosition} />
            <div className="flex justify-center items-center my-10">
              {renderVerifySkyscrapers()}
            </div>
            <div className="flex justify-center items-center my-10">
              {renderVerifySkyscrapersAndMintNft()}
            </div>
          </div>
        </>
      );
    } else {
      return (
        <div className="flex justify-center items-center space-x-3">
          <div className={styles.loader}></div>
          <div>Loading Game</div>
        </div>
      );
    }
  };

  useEffect(() => {
    console.log("Skyscrapers page");

    initializeBoard();

    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);
  return (
    <div>
      <Head>
        <title>zkGames - Skyscrapers</title>
        <meta name="title" content="zkGames - Skyscrapers" />
        <meta
          name="description"
          content="Zero Knowledge Games Platform - Skyscrapers"
        />
      </Head>
      <div className="mb-10">
        <GoBack />
      </div>
      <div className="flex">
        <div className="mx-5 mb-10 text-3xl font-bold text-transparent bg-clip-text bg-gradient-to-r from-purple-500 to-indigo-500">
          Skyscrapers
        </div>
      </div>
      <div className="flex flex-wrap gap-20 justify-center items-center text-slate-300">
        {renderSkyscrapers()}
      </div>
      <div className="flex place-content-center mt-20 text-lg text-slate-300">
        <div className="md:w-6/12">
          <div className="text-center my-5 font-semibold">
            Skyscrapers rules:
          </div>
          <div className="space-y-5">
            <p>
              <span className="font-semibold">Skyscrapers</span> consists of a
              square grid. The goal is to fill in each cell with numbers from 1
              to N, where N is the size of the puzzle&apos;s side.
            </p>
            <ul className="list-disc space-y-2 pl-5">
              <li>No number may appear twice in any row or column.</li>
              <li>
                The numbers along the edge of the puzzle indicate the number of
                buildings which you would see from that direction if there was a
                series of skyscrapers with heights equal the entries in that row
                or column.
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  );
}
