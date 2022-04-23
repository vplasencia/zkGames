import Board from "../components/futoshiki/board";
import React, { useEffect, useState } from "react";
import NumbersKeyboard from "../components/futoshiki/numbersKeyboard";
import Head from "next/head";
import GoBack from "../components/goBack";
import styles from "../styles/Futoshiki.module.css";
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

import { futoshikiCalldata } from "../zkproof/futoshiki/snarkjsFutoshiki";

import contractAddress from "../utils/contractaddress.json";

import futoshikiContractAbi from "../utils/abiFiles/Futoshiki/Futoshiki.json";

let futoshikiBoolInitialTemp = [
  [false, false, false, false],
  [false, false, false, false],
  [false, false, false, false],
  [false, false, false, false],
];

export default function Futoshiki() {
  const [futoshikiInitial, setFutoshikiInitial] = useState([]);
  const [futoshikiInequalitiesInitial, setFutoshikiInequalitiesInitial] =
    useState([]);
  const [futoshiki, setFutoshiki] = useState([]);
  const [futoshikiBoolInitial, setFutoshikiBoolInitial] = useState(
    futoshikiBoolInitialTemp
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
    addressOrName: contractAddress.futoshikiContract,
    contractInterface: futoshikiContractAbi.abi,
    signerOrProvider: signer.data || provider,
  });

  const contractNoSigner = useContract({
    addressOrName: contractAddress.futoshikiContract,
    contractInterface: futoshikiContractAbi.abi,
    signerOrProvider: provider,
  });

  const updatePosition = (number) => {
    if (selectedPosition.length > 0) {
      if (!futoshikiBoolInitial[selectedPosition[0]][selectedPosition[1]])
        return;
      const temp = [...futoshiki];
      temp[selectedPosition[0]][selectedPosition[1]] = number;
      setFutoshiki(temp);
      console.log("futoshiki", futoshiki);
    }
  };

  const calculateProof = async () => {
    setLoadingVerifyBtn(true);
    console.log("futoshikiInitial", futoshikiInitial);
    console.log("futoshiki", futoshiki);
    let calldata = await futoshikiCalldata(
      futoshikiInitial,
      futoshiki,
      futoshikiInequalitiesInitial
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
        result = await contract.verifyFutoshiki(
          calldata[0],
          calldata[1],
          calldata[2],
          calldata[3]
        );
      } else {
        result = await contractNoSigner.verifyFutoshiki(
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

  const verifyFutoshiki = async () => {
    console.log("Address", accountQuery.data?.address);
    calculateProof();
  };

  const calculateProofAndMintNft = async () => {
    setLoadingVerifyAndMintBtn(true);
    console.log("futoshikiInitial", futoshikiInitial);
    console.log("futoshiki", futoshiki);
    let calldata = await futoshikiCalldata(
      futoshikiInitial,
      futoshiki,
      futoshikiInequalitiesInitial
    );

    if (!calldata) {
      setLoadingVerifyAndMintBtn(false);
      return "Invalid inputs to generate witness.";
    }

    // console.log("calldata", calldata);

    try {
      let txn = await contract.verifyFutoshikiAndMintNft(
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
        }address/${contractAddress.futoshikiContract}`
      );
    } catch (error) {
      setLoadingVerifyAndMintBtn(false);
      alert("Wrong solution");
    }
  };

  const verifyFutoshikiAndMintNft = async () => {
    console.log("Address", accountQuery.data?.address);
    calculateProofAndMintNft();
  };

  const renderVerifyFutoshiki = () => {
    return (
      <button
        className="flex justify-center items-center disabled:cursor-not-allowed space-x-3 verify-btn text-lg font-medium rounded-md px-5 py-3 w-full bg-gradient-to-r from-purple-600 to-indigo-600 hover:from-purple-500 hover:to-indigo-500"
        onClick={verifyFutoshiki}
        disabled={loadingVerifyBtn}
      >
        {loadingVerifyBtn && <div className={styles.loader}></div>}
        <span>Verify Futoshiki</span>
      </button>
    );
  };

  const renderVerifyFutoshikiAndMintNft = () => {
    if (!accountQuery.data?.address) {
      return (
        <button
          className="text-lg font-medium rounded-md px-5 py-3 w-full bg-gradient-to-r from-purple-600 to-indigo-600 hover:from-purple-500 hover:to-indigo-500"
          onClick={() => {
            connect(connectQuery.data.connectors[0]);
          }}
        >
          Connect Wallet to Verify Futoshiki & Mint NFT
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
          Switch Network to Verify Futoshiki & Mint NFT
        </button>
      );
    } else {
      return (
        <button
          className="flex justify-center items-center disabled:cursor-not-allowed space-x-3 verify-btn text-lg font-medium rounded-md px-5 py-3 w-full bg-gradient-to-r from-purple-600 to-indigo-600 hover:from-purple-500 hover:to-indigo-500"
          onClick={verifyFutoshikiAndMintNft}
          disabled={loadingVerifyAndMintBtn}
        >
          {loadingVerifyAndMintBtn && <div className={styles.loader}></div>}
          <span>Verify Futoshiki & Mint NFT</span>
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
        board = await contract.generateFutoshikiBoard(new Date().toString());
      } else {
        board = await contractNoSigner.generateFutoshikiBoard(
          new Date().toString()
        );
      }

      console.log("result", board);

      setFutoshikiInitial(board[0]);
      setFutoshikiInequalitiesInitial(board[1]);

      console.log("inequalities: ", board[1]);

      let newArray = board[0].map((arr) => {
        return arr.slice();
      });
      setFutoshiki(newArray);

      const temp = [
        [false, false, false, false],
        [false, false, false, false],
        [false, false, false, false],
        [false, false, false, false],
      ];
      for (let i = 0; i < board[0].length; i++) {
        for (let j = 0; j < board[0].length; j++) {
          if (board[0][i][j] === 0) {
            temp[i][j] = true;
          }
        }
      }
      setFutoshikiBoolInitial(temp);
    } catch (error) {
      console.log(error);
      alert("Failed fetching Futoshiki board");
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

  const renderFutoshiki = () => {
    if (futoshiki.length !== 0) {
      return (
        <>
          <div>
            <Board
              futoshikiInequalitiesInitial={futoshikiInequalitiesInitial}
              futoshiki={futoshiki}
              setSelectedPosition={(pos) => setSelectedPosition(pos)}
              selectedPosition={selectedPosition}
              futoshikiBoolInitial={futoshikiBoolInitial}
            />
          </div>
          <div>
            <div className="flex justify-center items-center my-10">
              {renderNewGame()}
            </div>
            <NumbersKeyboard updatePosition={updatePosition} />
            <div className="flex justify-center items-center my-10">
              {renderVerifyFutoshiki()}
            </div>
            <div className="flex justify-center items-center my-10">
              {renderVerifyFutoshikiAndMintNft()}
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
    console.log("Futoshiki page");

    initializeBoard();

    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);
  return (
    <div>
      <Head>
        <title>zkGames - Futoshiki</title>
        <meta name="title" content="zkGames - Futoshiki" />
        <meta
          name="description"
          content="Zero Knowledge Games Platform - Futoshiki"
        />
      </Head>
      <div className="mb-10">
        <GoBack />
      </div>
      <div className="flex">
        <div className="mx-5 mb-10 text-3xl font-bold text-transparent bg-clip-text bg-gradient-to-r from-purple-500 to-indigo-500">
          Futoshiki
        </div>
      </div>
      <div className="flex flex-wrap gap-20 justify-center items-center text-slate-300">
        {renderFutoshiki()}
      </div>
      <div className="flex place-content-center mt-20 text-lg text-slate-300">
        <div className="md:w-6/12">
          <div className="text-center my-5 font-semibold">Futoshiki rules:</div>
          <div className="space-y-5">
            <p>
              <span className="font-semibold">Futoshiki</span> (from Japanese,
              literally &quot;not equal&quot;; also known as
              &quot;Hutoshiki&quot;, &quot;Unequal&quot;) is a logic puzzle. The
              puzzle is played on a square grid, such as 4 x 4.
            </p>
            <ul className="list-disc space-y-2 pl-5">
              <li>
                The objective is to place the numbers 1 to 4 (or whatever the
                dimensions are) in each row, ensuring that each column also only
                contains the digits 1 to 4.
              </li>
              <li>Some digits may be given at the start.</li>
              <li>
                Inequality constraints are also initially specifed between some
                of the squares, such that one must be higher or lower than its
                neighbour. These constraints must be honoured as the grid is
                filled out.
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  );
}
