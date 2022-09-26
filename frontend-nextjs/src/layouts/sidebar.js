import React from "react";
import Link from "next/link";
import cookie from "js-cookie";
import { logout } from "../stores/actions/user.actions.types";
import { connect } from "react-redux";
//import { useRouter } from "next/router";
import { setCookies } from "../utilities/auth-helpers";

const Sidebar = (props) => {
  const isLoggedIn = cookie.get("isLoggedIn");
  return (
    <div
      className="d-flex flex-column flex-shrink-0 p-3 bg-light sidebar"
      style={{ width: "16.66666667%" }}
    >
      <div className="sidebar-sticky">
        <ul className="nav nav-pills flex-column mb-auto ">
          <li>
            <a href="#" className="nav-link link-dark">
              <i className="fa fa-graduation-cap px-2"></i>
              Courses
            </a>
          </li>
        </ul>
      </div>
    </div>
  );
};

const mapStateToProps = (state) => ({
  userDetails: state.user.userDetails,
  visible: state.app.visible,
});

export default connect(mapStateToProps, {
  logout,
})(Sidebar);
