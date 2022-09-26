import React from "react";
import Link from "next/link";
import cookie from "js-cookie";
import { logout } from "../stores/actions/user.actions.types";
import { connect } from "react-redux";
//import { useRouter } from "next/router";
import { setCookies } from "../utilities/auth-helpers";

const Header = (props) => {
  const isLoggedIn = cookie.get("isLoggedIn");
  //const router = useRouter();
  return (
    <header className="fixed w-full top-0">
      <nav className="bg-sky-600 shadow-sm shadow-slate-300 ">
        <div className="container mx-auto px-4 py-3 flex items-center ">
          <a className="text-white" href="#">
            <span className="text-white text-2xl font-semibold">
              Crew Attendance
            </span>
          </a>
          {!isLoggedIn ? (
            <React.Fragment>
              <div className="ml-auto hidden lg:block">
                <Link href="/sign-in">
                  <a className="flex items-center hover:text-blue-700 transition text-white">
                    <span className="mr-2">
                      <i className="far fa-user text-white" />
                    </span>
                    <span className="text-white">Login</span>
                  </a>
                </Link>
              </div>
              <div className="ml-5 hidden lg:block">
                <Link href="/sign-up">
                  <a className="flex items-center hover:text-blue-700 transition">
                    <span className="mr-2">
                      <i className="far fa-user text-white" />
                    </span>
                    <span className="text-white">SignUp</span>
                  </a>
                </Link>
              </div>
            </React.Fragment>
          ) : (
            <React.Fragment>
              <div className="ml-auto hidden lg:block">
                <Link href="/dashboard">
                  <a className="flex items-center hover:text-blue-700 transition text-white">
                    <span className="mr-2">
                      <i className="fas fa-graduation-cap text-white" />
                    </span>
                    <span className="text-white">My Courses</span>
                  </a>
                </Link>
              </div>
              <div className="ml-5 hidden lg:block">
                <Link href="/profile">
                  <a
                    onClick={(e) => {
                      //props.logout();
                      //setCookies(false);
                    }}
                    className="flex items-center hover:text-blue-700 transition"
                  >
                    <span className="mr-2">
                      <i className="far fa-user text-white" />
                    </span>
                    <span className="text-white">My Profile</span>
                  </a>
                </Link>
              </div>
              <div className="ml-5 hidden lg:block">
                <Link href="/sign-in">
                  <a
                    onClick={(e) => {
                      props.logout();
                      setCookies(false);
                    }}
                    className="flex items-center hover:text-blue-700 transition"
                  >
                    <span className="mr-2">
                      <i className="fas fa-sign-out-alt text-white" />
                    </span>
                    <span className="text-white">Sign Out</span>
                  </a>
                </Link>
              </div>
            </React.Fragment>
          )}

          <div
            className="text-xl text-gray-700 cursor-pointer xl:hidden block hover:text-blue-700 transition ml-auto"
            id="open_sidebar"
          >
            <i className="fas fa-bars " />
          </div>
        </div>
      </nav>
    </header>
  );
};

const mapStateToProps = (state) => ({
  userDetails: state.user.userDetails,
  visible: state.app.visible,
});

export default connect(mapStateToProps, {
  logout,
})(Header);
