import React from "react";
import SignUpForm from "../../components/Forms/signupform";
import classes from "./SignUp.module.css";
import { connect } from "react-redux";
import { register } from "../../stores/actions/user.actions.types";
import { useRouter } from "next/router";

const SignUp = (props) => {
  const router = useRouter();
  const signup = async (request) => {
    try {
      const callback = (data) => {
        if (data.success) {
          router.push(`/verify-email/${request.email}`);
        }
      };
      props.register({
        data: {
          email: request.email,
          name: request.name,
          password: request.password,
          usertype: request.usertype,
        },
        callback,
      });
    } catch (error) {
      console.log("Error", error);
    }
  };

  return (
    <div className={classes.signupdiv}>
      <SignUpForm signup={signup} loading={props.visible} classes={classes} />
    </div>
  );
};

const mapStateToProps = ({ app: { visible } }) => ({
  visible,
});

export default connect(mapStateToProps, {
  register,
})(SignUp);
