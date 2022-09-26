import React from "react";
import cookie from "js-cookie";
import ResetPasswordContainer from "../../../src/containers/ResetPass/resetpassword";
import PublicLayout from "../../../src/layouts/public-layout";
import { auth } from "../../../src/utilities/auth-helpers";

const ResetPassword = () => {
  return (
    <PublicLayout
      title="Crew Attendance | Reset Password"
      component={ResetPasswordContainer}
    />
  );
};

ResetPassword.getInitialProps = async ({ Component, ctx }) => {
  let pageProps = {};

  const extraStuff = { namespacesRequired: ["common"] };

  pageProps = auth(ctx, cookie.get("role") === "guest" ? "private" : "public");

  return {
    extraStuff,
    pageProps,
  };
};

export default ResetPassword;
