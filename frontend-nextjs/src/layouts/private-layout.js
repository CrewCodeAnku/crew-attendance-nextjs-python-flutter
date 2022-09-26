import React from "react";
import PropTypes from "prop-types";
import Head from "./head";
import Header from "./header";
import Footer from "./footer";
import Sidebar from "./sidebar";

const PrivateLayout = ({ title, component: Component }) => (
  <div className="">
    <Head title={title} />
    <Header
      heading="Login to your account"
      paragraph="Don't have an account yet? "
      linkName="Signup"
      linkUrl="/signup"
    />
    <Component />

    {/*<Footer />*/}
  </div>
);

PrivateLayout.propTypes = { component: PropTypes.any.isRequired };

export default PrivateLayout;
