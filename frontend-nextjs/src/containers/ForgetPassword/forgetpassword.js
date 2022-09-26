import React from "react";
import classes from "./ForgetPassword.module.css";
import ForgetPassForm from "../../components/Forms/forgetpassform";
import { forgotPassword } from "../../stores/actions/user.actions.types";
import { connect } from "react-redux";
import { useRouter } from "next/router";

const ForgetPassword = (props) => {
  const router = useRouter();
  const forgetPassword = async (request) => {
    const callback = (data) => {
      if (data.success) {
        router.push(`/reset-password/${request.email}`);
      }
    };
    props.forgotPassword({ data: request, callback });
  };

  return (
    <div className={classes.forgetdiv}>
      <ForgetPassForm
        forgetPassword={forgetPassword}
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
  forgotPassword,
})(ForgetPassword);
