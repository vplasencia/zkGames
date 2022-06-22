import Header from "./header";
import Footer from "./footer";
import Head from "next/head";
import Script from "next/script";
import { Provider as WagmiProvider } from "wagmi";
import { providers } from "ethers";

import networks from "../utils/networks.json";

// Provider that will be used when no wallet is connected (aka no signer)
const provider = providers.getDefaultProvider(
  networks[networks.selectedChain].rpcUrls[0]
);

export default function Layout({ children }) {
  return (
    <>
      <Head>
        <link rel="icon" href="/favicon.ico" />
        <link rel="apple-touch-icon" href="/apple-touch-icon.png" />
        <title>zkGames</title>
        <meta name="title" content="zkGames" />
        <meta name="description" content="Zero Knowledge Games Platform" />
        <meta name="theme-color" content="#ea580c" />

        {/* Twitter */}
        <meta property="twitter:card" content="summary_large_image" />
        <meta property="twitter:url" content="https://zkgames.vercel.app/" />
        <meta property="twitter:title" content="zkGames" />
        <meta
          property="twitter:description"
          content="Zero Knowledge Games Platform"
        />
        <meta property="twitter:image" content="https://zkgames.vercel.app/socialMedia.png" />

        {/* Open Graph */}
        <meta property="og:type" content="website" key="ogtype" />
        <meta
          property="og:url"
          content="https://zkgames.vercel.app/"
          key="ogurl"
        />
        <meta property="og:image" content="https://zkgames.vercel.app/socialMedia.png" key="ogimage" />
        <meta property="og:title" content="zkGames" key="ogtitle" />
        <meta
          property="og:description"
          content="Zero Knowledge Games Platform"
          key="ogdesc"
        />
      </Head>
      <WagmiProvider autoConnect provider={provider}>
        <div className="flex flex-col min-h-screen px-2 bg-slate-900 text-slate-300">
          <Header />
          <main className="mb-auto">{children}</main>
          <Footer />
        </div>
      </WagmiProvider>
    </>
  );
}
