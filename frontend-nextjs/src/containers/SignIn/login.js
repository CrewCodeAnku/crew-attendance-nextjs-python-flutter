import React from "react";
import LoginForm from "../../components/Forms/signinform";
import { login } from "../../stores/actions/user.actions.types";
import classes from "./SignIn.module.css";
import { connect } from "react-redux";
import { useRouter } from "next/router";

const Login = (props) => {
  const router = useRouter();
  const signin = async (request) => {
    const callback = (data) => {
      if (data.success) {
        router.push("/dashboard");
      }
    };
    props.login({ data: request, callback });
  };

  return (
    <div className={classes.signindiv}>
      <LoginForm signin={signin} loading={props.visible} classes={classes} />
    </div>
  );
};

const mapStateToProps = (state) => ({
  userDetails: state.user.userDetails,
  visible: state.app.visible,
});

export default connect(mapStateToProps, {
  login,
})(Login);
