import Head from "next/head";
import GoBack from "../components/goBack";

export default function About() {
  return (
    <div>
      <Head>
        <title>zkGames - About</title>
        <meta name="title" content="zkGames - About" />
        <meta
          name="description"
          content="Zero Knowledge Games Platform - About"
        />
      </Head>
      <div className="mb-10">
        <GoBack />
      </div>
      <div className="grid place-items-center">
        <div className="flex justify-center items-center mb-10 text-4xl font-bold text-transparent bg-clip-text bg-gradient-to-r from-purple-500 to-indigo-500">
          zkGames
        </div>
        <div className="flex justify-center items-center text-lg md:w-96 w-auto text-slate-300">
          zkGames is a platform that allows users to play zk (zero knowledge)
          games and mint an NFT as proof that they have won.
        </div>
      </div>
    </div>
  );
}
