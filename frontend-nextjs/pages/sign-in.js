import React from "react";
import cookie from "js-cookie";
import LoginContainer from "../src/containers/SignIn/login";
import PublicLayout from "../src/layouts/public-layout";
import { auth } from "../src/utilities/auth-helpers";

const Login = () => {
  return (
    <PublicLayout title="Crew Attendance | Login" component={LoginContainer} />
  );
};

Login.getInitialProps = async ({ Component, ctx }) => {
  let pageProps = {};

  const extraStuff = { namespacesRequired: ["common"] };

  pageProps = auth(ctx, cookie.get("role") === "guest" ? "private" : "public");

  return {
    extraStuff,
    pageProps,
  };
};

export default Login;
