import Link from "next/link";
import { useAccount, useConnect, useNetwork } from "wagmi";
import networks from "../utils/networks.json";

import { switchNetwork } from "../utils/switchNetwork";

export default function Header() {
  const [connectQuery, connect] = useConnect();
  const [accountQuery, disconnect] = useAccount();
  const [{ data, error, loading }] = useNetwork();

  const truncateRegex = /^(0x[a-zA-Z0-9]{4})[a-zA-Z0-9]+([a-zA-Z0-9]{4})$/;
  const truncateEthAddress = (address) => {
    const match = address.match(truncateRegex);
    if (!match) return address;
    return `${match[1]}…${match[2]}`;
  };

  // const switchNetwork = async () => {
  //   if (window.ethereum) {
  //     try {
  //       // Try to switch to the chain
  //       await ethereum.request({
  //         method: "wallet_switchEthereumChain",
  //         params: [
  //           { chainId: `0x${parseInt(networks.selectedChain).toString(16)}` },
  //         ],
  //       });
  //     } catch (switchError) {
  //       // This error code indicates that the chain has not been added to MetaMask.
  //       if (switchError.code === 4902) {
  //         try {
  //           await ethereum.request({
  //             method: "wallet_addEthereumChain",
  //             params: [
  //               {
  //                 chainId: `0x${parseInt(networks.selectedChain).toString(16)}`,
  //                 chainName: networks[networks.selectedChain].chainName,
  //                 rpcUrls: networks[networks.selectedChain].rpcUrls,
  //                 nativeCurrency: {
  //                   symbol:
  //                     networks[networks.selectedChain].nativeCurrency.symbol,
  //                   decimals: 18,
  //                 },
  //                 blockExplorerUrls:
  //                   networks[networks.selectedChain].blockExplorerUrls,
  //               },
  //             ],
  //           });
  //         } catch (addError) {
  //           console.log(addError);
  //         }
  //       }
  //       // handle other "switch" errors
  //     }
  //   } else {
  //     // If window.ethereum is not found then MetaMask is not installed
  //     alert(
  //       "MetaMask is not installed. Please install it to use this app: https://metamask.io/download/"
  //     );
  //   }
  // };

  const renderConnectWallet = () => {
    if (!accountQuery.data?.address) {
      return (
        <button
          className="text-lg font-medium rounded-md px-5 py-3 bg-gradient-to-r from-purple-600 to-indigo-600 hover:from-purple-500 hover:to-indigo-500"
          onClick={() => {
            connect(connectQuery.data.connectors[0]);
          }}
        >
          Connect Wallet
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
          Switch Network
        </button>
      );
    } else {
      return (
        <div className="flex flex-wrap gap-5 justify-center items-center">
          <div className="p-3 bg-slate-700 text-lg font-medium rounded-md">
            <span>{truncateEthAddress(accountQuery.data?.address)}</span>
          </div>
          <button
            onClick={disconnect}
            className="text-lg font-medium rounded-md px-5 py-3 bg-gradient-to-r from-purple-600 to-indigo-600 hover:from-purple-500 hover:to-indigo-500"
          >
            Disconnect
          </button>
        </div>
      );
    }
  };

  return (
    <header className="flex flex-wrap justify-between p-5 mb-10">
      <Link href="/">
        <a className="text-xl md:mb-auto mb-5 font-bold text-transparent bg-clip-text bg-gradient-to-r from-purple-500 to-indigo-500">
          zkGames
        </a>
      </Link>
      <div className="flex justify-center items-center">
        <div>{renderConnectWallet()}</div>
      </div>
    </header>
  );
}
