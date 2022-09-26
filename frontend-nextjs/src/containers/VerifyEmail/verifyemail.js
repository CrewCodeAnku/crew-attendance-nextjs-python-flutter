import React from "react";
import classes from "./VerifyEmail.module.css";
import {
  verifyEmail,
  resendVerifyEmail,
} from "../../stores/actions/user.actions.types";
import VerifyEmailForm from "../../components/Forms/emailverifyform";
import { connect } from "react-redux";
import { useRouter } from "next/router";

const VerifyEmail = (props) => {
  const router = useRouter();
  const { email } = router.query;

  const verifyemail = async (request) => {
    let params = {
      otp: request.otp,
      email: email,
    };
    const callback = (data) => {
      if (data.success) {
        router.push("/sign-in");
      }
    };
    props.verifyEmail({ data: params, callback });
  };

  const resendEmail = async () => {
    console.log("Inside resend email");
    let paramsdata = {
      email: email,
    };
    const callback = (data) => {};
    props.resendVerifyEmail({ data: paramsdata, callback });
  };

  return (
    <VerifyEmailForm
      verifyEmail={verifyemail}
      resendEmail={resendEmail}
      loading={props.visible}
      classes={classes}
    />
  );
};

const mapStateToProps = ({ app: { visible } }) => ({
  visible,
});

export default connect(mapStateToProps, {
  verifyEmail,
  resendVerifyEmail,
})(VerifyEmail);
