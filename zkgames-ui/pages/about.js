import Head from "next/head";

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
      <span className="flex justify-center items-center mb-10 text-3xl font-bold text-transparent bg-clip-text bg-gradient-to-r from-purple-500 to-indigo-500">
        About Page
      </span>
    </div>
  );
}

