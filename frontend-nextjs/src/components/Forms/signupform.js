import React from "react";
import { Formik, Form } from "formik";
import * as Yup from "yup";
import { TextInput, PasswordInput } from "../UI/form-fields";
import Link from "next/link";

const ForgetForm = (props) => {
  return (
    <React.Fragment>
      <Formik
        initialValues={{
          name: "",
          email: "",
          password: "",
          confirmpassword: "",
          usertype: Yup.string().required("Usertype is required"),
        }}
        validationSchema={Yup.object({
          name: Yup.string().required("Name is required"),
          email: Yup.string()
            .email("Invalid email address")
            .required("Email address is required"),
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
          usertype: Yup.string().required("Usertype is required"),
        })}
        onSubmit={(values, { setSubmitting }) => {
          const request = {
            name: values.name,
            email: values.email,
            password: values.password,
            usertype: values.usertype,
          };
          props.signup(request);
          setSubmitting(false);
        }}
      >
        {({
          handleSubmit,
          handleChange,
          isSubmitting,
          isValidating,
          values,
        }) => (
          <Form onSubmit={handleSubmit} className={props.classes.formsignup}>
            <div className="container py-16 mx-auto">
              <div className="max-w-lg mx-auto px-6 py-7 shadow rounded overflow-hidden bg-white">
                <h2 className="text-2xl uppercase font-medium mb-1">
                  Create an account
                </h2>
                <p className="text-gray-600 mb-6 text-sm">
                  Register here if you don't have account{" "}
                </p>

                <div className="space-y-4">
                  <div className="flex justify-center">
                    <div className="form-check form-check-inline px-3">
                      <input
                        className="form-check-input form-check-input appearance-none rounded-full h-4 w-4 border border-gray-300 bg-white checked:bg-blue-600 checked:border-blue-600 focus:outline-none transition duration-200 mt-1 align-top bg-no-repeat bg-center bg-contain float-left mr-2 cursor-pointer"
                        type="radio"
                        name="usertype"
                        id="inlineRadio1"
                        defaultValue="student"
                        onChange={handleChange}
                        defaultChecked={values.usertype === "student"}
                      />
                      <label
                        className="form-check-label inline-block text-gray-800"
                        htmlFor="inlineRadio10"
                      >
                        Student
                      </label>
                    </div>
                    <div className="form-check form-check-inline px-3">
                      <input
                        className="form-check-input form-check-input appearance-none rounded-full h-4 w-4 border border-gray-300 bg-white checked:bg-blue-600 checked:border-blue-600 focus:outline-none transition duration-200 mt-1 align-top bg-no-repeat bg-center bg-contain float-left mr-2 cursor-pointer"
                        type="radio"
                        name="usertype"
                        id="inlineRadio2"
                        defaultValue="teacher"
                        onChange={handleChange}
                        defaultChecked={values.usertype === "teacher"}
                      />
                      <label
                        className="form-check-label inline-block text-gray-800"
                        htmlFor="inlineRadio20"
                      >
                        Teacher
                      </label>
                    </div>
                  </div>
                  <div>
                    <TextInput
                      label="Full Name"
                      name="name"
                      id="name"
                      type="text"
                      placeholder="Enter name here"
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
                    <TextInput
                      label="Email Address"
                      name="email"
                      id="email"
                      type="email"
                      placeholder="Enter email here"
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
                      label="Password"
                      name="password"
                      id="password"
                      type="password"
                      placeholder="Enter password here"
                      labelClassname="text-gray-600 mb-2 block"
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
                      label="Confirm Password"
                      name="confirmpassword"
                      id="confirmpassword"
                      type="password"
                      placeholder="Confirm your password"
                      labelClassname="text-gray-600 mb-2 block"
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
                    Create account
                  </button>
                </div>

                <p className="mt-4 text-gray-600 text-center ">
                  Already have an account?
                  <Link href="/sign-in">
                    <a className="text-sky-600">Login</a>
                  </Link>
                </p>
              </div>
            </div>

            {/*<div className="rounded h-100 justify-content-center align-items-center app-bg-color">
              <div
                className={`${props.classes.signupheader} text-center d-flex justify-content-center align-items-center pt-5`}
              >
                <h4 className="h3 mb-3 font-weight-normal mt-0 heading-text">
                  Sign Up
                </h4>
              </div>
              <div
                className={`${props.classes.signupbody} text-left px-4 py-4`}
              >
                <div className="form-group mb-4">
                  <TextInput
                    label="Name"
                    name="name"
                    id="name"
                    type="text"
                    placeholder="Enter name here"
                    labelClassname="form-label"
                    className="form-control"
                    isRequired
                  />
                </div>
                <div className="form-group mb-4">
                  <TextInput
                    label="Email"
                    name="email"
                    id="email"
                    type="email"
                    placeholder="Enter email here"
                    labelClassname="form-label"
                    className="form-control"
                    isRequired
                  />
                </div>
                <div className="form-group mb-4">
                  <PasswordInput
                    label="Password"
                    name="password"
                    id="password"
                    type="password"
                    placeholder="Enter password here"
                    labelClassname="form-label"
                    className="form-control"
                    isRequired
                  />
                </div>
                <button
                  className="btn w-100 app-btn"
                  type="submit"
                  disabled={isSubmitting || isValidating || props.loading}
                >
                  Sign Up{" "}
                  {props.loading ? (
                    <i
                      style={{ marginLeft: "3px" }}
                      className="fa fa-circle-o-notch fa-spin"
                    ></i>
                  ) : null}
                </button>
                <p className="text-center">
                  <Link href="/sign-in">
                    <a className="btn app-btn-link">Already have an account?</a>
                  </Link>
                </p>
              </div>
                  </div>*/}
          </Form>
        )}
      </Formik>
    </React.Fragment>
  );
};

export default ForgetForm;
