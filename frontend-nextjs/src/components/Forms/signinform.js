import React from "react";
import { Formik, Form } from "formik";
import * as Yup from "yup";
import { TextInput, PasswordInput } from "../UI/form-fields";
import Link from "next/link";

const SignInForm = (props) => {
  return (
    <React.Fragment>
      <Formik
        initialValues={{
          email: "",
          password: "",
          usertype: "student",
        }}
        validationSchema={Yup.object({
          email: Yup.string()
            .email("Invalid email address")
            .required("Email address is required"),
          password: Yup.string().required("Password is required"),
          usertype: Yup.string().required("Usertype is required"),
        })}
        onSubmit={(values, { setSubmitting }) => {
          const request = {
            email: values.email,
            password: values.password,
            usertype: values.usertype,
            platform: "demo",
          };
          props.signin(request);
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
          <Form onSubmit={handleSubmit} className={props.classes.formsignin}>
            <div className="container py-16 mx-auto">
              <div className="max-w-lg mx-auto px-6 py-7 shadow rounded overflow-hidden bg-white">
                <h2 className="text-2xl uppercase font-medium mb-1">Login</h2>
                <p className="text-gray-600 mb-6 text-sm">
                  Login if you are a returing customer
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
                </div>
                <div className="flex items-center justify-between mt-6 ">
                  <div className="flex items-center ">
                    <input
                      type="checkbox"
                      id="agrement"
                      className="text-primary focus:ring-0 rounded-sm cursor-pointer "
                    />
                    <label
                      htmlFor="agrement"
                      className="text-gray-600 ml-3 cursor-pointer"
                    >
                      Remember Me
                    </label>
                  </div>
                  <Link href="/forget-password">
                    <a className="text-sky-600">Forgot Password?</a>
                  </Link>
                </div>
                <div className="mt-4">
                  <button
                    type="submit"
                    disabled={isSubmitting || isValidating || props.loading}
                    className="inline-block px-6 py-2.5 bg-sky-600 text-white font-medium text-xs leading-tight uppercase rounded shadow-md hover:bg-sky-700 hover:shadow-lg focus:bg-blue-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-blue-800 active:shadow-lg transition duration-150 ease-in-out w-full"
                  >
                    Login{" "}
                    {props.loading ? (
                      <i className="fa fa-circle-o-notch fa-spin ml-3"></i>
                    ) : null}
                  </button>
                </div>
                <p className="mt-4 text-gray-600 text-center ">
                  Don't have an account?{" "}
                  <Link href="/sign-up">
                    <a className="text-sky-600">Register Now </a>
                  </Link>
                </p>
                {/* ---- End Login with Social ----- */}
              </div>
            </div>
          </Form>
        )}
      </Formik>
    </React.Fragment>
  );
};

export default SignInForm;
