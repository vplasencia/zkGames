import Layout from "../components/layout";
import "../styles/globals.css";
import PlausibleProvider from "next-plausible";

function MyApp({ Component, pageProps }) {
  return (
    <PlausibleProvider domain="zkgames.one">
      <Layout>
        <Component {...pageProps} />
      </Layout>
    </PlausibleProvider>
  );
}

export default MyApp;
