import React from "react";
import cookie from "js-cookie";
import VerifyEmailContainer from "../../../src/containers/VerifyEmail/verifyemail";
import PublicLayout from "../../../src/layouts/public-layout";
import { auth } from "../../../src/utilities/auth-helpers";

const VerifyEmail = () => {
  return (
    <PublicLayout
      title="Crew Attendance | Verify Email"
      component={VerifyEmailContainer}
    />
  );
};

VerifyEmail.getInitialProps = async ({ Component, ctx }) => {
  let pageProps = {};

  const extraStuff = { namespacesRequired: ["common"] };

  pageProps = auth(ctx, cookie.get("role") === "guest" ? "private" : "public");

  return {
    extraStuff,
    pageProps,
  };
};

export default VerifyEmail;
