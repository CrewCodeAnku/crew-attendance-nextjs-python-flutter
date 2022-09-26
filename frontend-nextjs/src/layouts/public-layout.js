import React from "react";
import { useEffect } from "react";
import PropTypes from "prop-types";
import Head from "./head";
import Header from "./header";
import Footer from "./footer";

const PublicLayout = ({ title, component: Component }) => {
  useEffect(() => {
    document.body.classList.add("font-poppins");
    /*document.body.classList.add("d-flex");
    document.body.classList.add("flex-column");
    document.body.classList.add("min-vh-100");*/
  });

  return (
    <div className="flex flex-col h-screen justify-between">
      <Head title={title} />
      <Header
        heading="Login to your account"
        paragraph="Don't have an account yet? "
        linkName="Signup"
        linkUrl="/signup"
      />
      <main className="mb-auto">
        <Component />
      </main>
    </div>
  );
};

PublicLayout.propTypes = {
  title: PropTypes.string,
};

PublicLayout.defaultProps = { title: "" };

export default PublicLayout;
