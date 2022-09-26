import React, { createContext, useState, useEffect } from "react";
import { useNavigate, useLocation } from "react-router-dom";
import { useSelector } from "react-redux";

export const AuthContext = createContext(null);

const AuthProvider = (props) => {
  console.log("Inside auth context");
  const authData = useSelector((state) => state.user.userDetails);
  const [auth, setAuth] = useState({ data: null });
  const location = useLocation();
  const history = useNavigate();

  const setAuthData = (data) => {
    setAuth(data);
  };

  // on component mount, set the authorization data to
  // what is found in state
  useEffect(() => {
    setAuth(authData);
  }, [authData]);

  // if authentication tokens are found, update the
  useEffect(() => {
    const checkTokens = () => {
      setAuthData(authData);
    };
    checkTokens();
  }, [location, history, authData]);

  return (
    <AuthContext.Provider value={auth}>{props.children}</AuthContext.Provider>
  );
};

export default AuthProvider;
