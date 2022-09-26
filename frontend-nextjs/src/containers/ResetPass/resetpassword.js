import React from "react";
import classes from "./ResetPass.module.css";
import ResetPassForm from "../../components/Forms/resetpassform";
import {
  resetPassword,
  forgotPassword,
} from "../../stores/actions/user.actions.types";
import { connect } from "react-redux";
import { useRouter } from "next/router";

const ResetPass = (props) => {
  const router = useRouter();
  const { email } = router.query;
  const resetpass = async (request) => {
    let params = {
      otp: request.otp,
      password: request.password,
      email: email,
    };
    const callback = (data) => {
      if (data.success) {
      }
    };
    props.resetPassword({ data: params, callback });
  };

  const resendemail = async () => {
    let params = {
      email: email,
    };
    const callback = (data) => {
      if (data.success) {
        router.push(`/sign-in`);
      }
    };
    props.forgotPassword({ data: params, callback });
  };

  return (
    <div className={classes.resetdiv}>
      <ResetPassForm
        resendEmail={resendemail}
        resetPassword={resetpass}
        loading={props.visible}
        classes={classes}
      />
    </div>
  );
};

const mapStateToProps = ({ app: { visible } }) => ({
  visible,
});

export default connect(mapStateToProps, {
  resetPassword,
  forgotPassword,
})(ResetPass);
