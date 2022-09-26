import React from "react";
import { Formik, Form } from "formik";
import * as Yup from "yup";
import { TextInput, PasswordInput } from "../UI/form-fields";
import Link from "next/link";

const ResetForm = (props) => {
  return (
    <React.Fragment>
      <Formik
        initialValues={{
          otp: "",
          password: "",
        }}
        validationSchema={Yup.object({
          otp: Yup.string().required("Otp is required"),
          password: Yup.string()
            .required("Password is required")
            .matches(
              /^.*(?=.{8,})((?=.*[!@#$%^&*()\-_=+{};:,<.>]){1})(?=.*\d)((?=.*[a-z]){1})((?=.*[A-Z]){1}).*$/,
              "Password must contain at least 8 characters, one uppercase, one number and one special case character"
            ),
          confirmpassword: Yup.string().oneOf(
            [Yup.ref("password"), null],
            "Passwords must match"
          ),
        })}
        onSubmit={(values, { setSubmitting }) => {
          const request = {
            password: values.password,
            otp: values.otp,
          };
          props.resetPassword(request);
          setSubmitting(false);
        }}
      >
        {({ handleSubmit, isSubmitting, isValidating }) => (
          <Form onSubmit={handleSubmit} className={props.classes.formforget}>
            <div className="container py-16 mx-auto">
              <div className="max-w-lg mx-auto px-6 py-7 shadow rounded overflow-hidden bg-white">
                <h2 className="text-2xl uppercase font-medium mb-1">
                  Reset password
                </h2>
                <p className="text-gray-600 mb-6 text-sm">
                  Enter password and otp send to your email to reset password
                </p>
                <div className="space-y-4">
                  <div>
                    <TextInput
                      label="Enter Otp send to your email"
                      name="otp"
                      id="otp"
                      type="text"
                      placeholder="Enter otp here"
                      labelClassname="form-label text-gray-600 mb-2 block"
                      className="form-control  block
                    w-full
                    px-3
                    py-1.5
                    text-base
                    font-normal
                    text-gray-700
                    bg-white bg-clip-padding
                    border border-solid border-gray-300
                    rounded
                    transition
                    ease-in-out
                    m-0
                    focus:text-gray-700 focus:bg-white focus:border-blue-600 focus:outline-none"
                      isRequired
                    />
                  </div>
                  <div>
                    <PasswordInput
                      label="Enter password"
                      name="password"
                      id="password"
                      type="password"
                      placeholder="Enter password here"
                      labelClassname="form-label text-gray-600 mb-2 block"
                      className="form-control  block
                    w-full
                    px-3
                    py-1.5
                    text-base
                    font-normal
                    text-gray-700
                    bg-white bg-clip-padding
                    border border-solid border-gray-300
                    rounded
                    transition
                    ease-in-out
                    m-0
                    focus:text-gray-700 focus:bg-white focus:border-blue-600 focus:outline-none"
                      isRequired
                    />
                  </div>
                  <div>
                    <PasswordInput
                      label="Confirm password"
                      name="confirmpassword"
                      id="confirmpassword"
                      type="password"
                      placeholder="Enter password to confirm"
                      labelClassname="form-label text-gray-600 mb-2 block"
                      className="form-control  block
                    w-full
                    px-3
                    py-1.5
                    text-base
                    font-normal
                    text-gray-700
                    bg-white bg-clip-padding
                    border border-solid border-gray-300
                    rounded
                    transition
                    ease-in-out
                    m-0
                    focus:text-gray-700 focus:bg-white focus:border-blue-600 focus:outline-none"
                      isRequired
                    />
                  </div>
                </div>

                <div className="mt-4">
                  <button
                    type="submit"
                    disabled={isSubmitting || isValidating || props.loading}
                    className="inline-block px-6 py-2.5 bg-sky-600 text-white font-medium text-xs leading-tight uppercase rounded shadow-md hover:bg-sky-700 hover:shadow-lg focus:bg-blue-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-blue-800 active:shadow-lg transition duration-150 ease-in-out w-full"
                  >
                    Reset Password
                    {props.loading ? (
                      <i className="fa fa-circle-o-notch fa-spin ml-3"></i>
                    ) : null}
                  </button>
                </div>
                <p className="mt-4 text-gray-600 text-center ">
                  I haven't recieved otp?{" "}
                  <a
                    onClick={async () => {
                      await props.resendEmail();
                    }}
                    className="text-sky-600 cursor-pointer"
                  >
                    Resend
                  </a>
                </p>
              </div>
            </div>
          </Form>
        )}
      </Formik>
    </React.Fragment>
  );
};

export default ResetForm;
