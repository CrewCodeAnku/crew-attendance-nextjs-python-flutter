import React from "react";
import cookie from "js-cookie";
import HomeContainer from "../src/containers/Home/Home";
import PublicLayout from "../src/layouts/public-layout";
import { auth } from "../src/utilities/auth-helpers";

const Home = () => {
  return (
    <PublicLayout title="Crew Attendance | Home" component={HomeContainer} />
  );
};

Home.getInitialProps = async ({ Component, ctx }) => {
  let pageProps = {};

  const extraStuff = { namespacesRequired: ["common"] };

  pageProps = auth(ctx, cookie.get("role") === "guest" ? "private" : "public");

  return {
    extraStuff,
    pageProps,
  };
};

export default Home;
