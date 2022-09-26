import "../styles/globals.css";
//import "bootstrap/dist/css/bootstrap.css";
import Head from "next/head";
import Script from "next/script";
import { Provider } from "react-redux";
import configureStore from "../src/stores";
import { ReactNotifications } from "react-notifications-component";
import { PersistGate } from "redux-persist/integration/react";
import { persistStore } from "redux-persist";
const { store } = configureStore();
let persistor = persistStore(store);

function CrewAttendance({ Component, pageProps }) {
  return (
    <>
      <Head>
        <title>Crew Attendance</title>
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <Script
          src="https://unpkg.com/flowbite@1.3.3/dist/flowbite.js"
          strategy="beforeInteractive"
        />
      </Head>
      <Provider store={store}>
        <PersistGate loading={null} persistor={persistor}>
          <ReactNotifications />
          <Component {...pageProps} />
        </PersistGate>
      </Provider>
    </>
  );
}

CrewAttendance.getInitialProps = async ({ Component, ctx }) => {
  let pageProps = {};
  const extraStuff = { namespacesRequired: ["common"] };
  if (Component.getInitialProps) {
    pageProps = await Component.getInitialProps({ ctx });
  }

  return {
    extraStuff,
    pageProps,
  };
};

export default CrewAttendance;
