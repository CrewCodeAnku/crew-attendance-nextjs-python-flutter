import React, { useState } from "react";
import { useSelector, useDispatch } from "react-redux";
import {
  updateName,
  changePassword,
  changeProfilePicture,
} from "../../stores/actions/user.actions.types";
import { TextInput } from "../../components/UI/form-fields";
import { Formik, Form } from "formik";
import * as Yup from "yup";
import Cropper from "react-cropper";
import { dataUrlToFile } from "../../utilities/general-helpers";
import "cropperjs/dist/cropper.css";

const Profile = () => {
  const dispatch = useDispatch();
  const [tabs, changeTab] = useState("name");
  const name = useSelector((state) => state.user.name);
  const authData = useSelector((state) => state.user.userDetails);

  //Cropper state
  const [image, setImage] = useState("");
  const [cropper, setCropper] = useState();

  const onChange = (e) => {
    e.preventDefault();
    let files;
    if (e.dataTransfer) {
      files = e.dataTransfer.files;
    } else if (e.target) {
      files = e.target.files;
    }
    const reader = new FileReader();
    reader.onload = () => {
      setImage(reader.result);
    };
    reader.readAsDataURL(files[0]);
  };

  const makeid = (length) => {
    var result = "";
    var characters =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    var charactersLength = characters.length;
    for (var i = 0; i < length; i++) {
      result += characters.charAt(Math.floor(Math.random() * charactersLength));
    }
    return result;
  };

  const handleUpload = async () => {
    if (typeof cropper !== "undefined") {
      const file = dataUrlToFile(
        cropper.getCroppedCanvas().toDataURL(),
        makeid(5) + "profile.png"
      );
      const formData = new FormData();
      formData.append("user_file", file);
      const callback = (data) => {
        if (data.success) {
          setImage("");
        }
      };
      dispatch(changeProfilePicture({ data: formData, callback }));
      console.log("File", file);
      console.log(
        `We have File "${file.name}", now we can upload it wherever we want!`
      );
    }
  };

  return (
    <div className="container py-16 mx-auto">
      <div className="mb-4 border-b border-gray-200 dark:border-gray-700">
        <ul
          className="flex flex-wrap -mb-px text-sm font-medium text-center"
          id="myTab"
          data-tabs-toggle="#myTabContent"
          role="tablist"
        >
          <li className="mr-2" role="presentation">
            <button
              className={
                tabs === "name"
                  ? `inline-block p-4 rounded-t-lg border-b-2 text-blue-600 hover:text-blue-600 dark:text-blue-500 dark:hover:text-blue-500 border-blue-600 dark:border-blue-500`
                  : `inline-block p-4 rounded-t-lg border-b-2 border-transparent hover:text-gray-600 hover:border-gray-300 dark:hover:text-gray-300 dark:border-transparent text-gray-500 dark:text-gray-400 border-gray-100 dark:border-gray-700`
              }
              id="profile-tab"
              data-tabs-target="#profile"
              type="button"
              role="tab"
              aria-controls="profile"
              onClick={() => {
                changeTab("name");
              }}
              aria-selected={tabs === "name" ? "true" : "false"}
            >
              Change Name
            </button>
          </li>
          <li className="mr-2" role="presentation">
            <button
              className={
                tabs === "password"
                  ? `inline-block p-4 rounded-t-lg border-b-2 text-blue-600 hover:text-blue-600 dark:text-blue-500 dark:hover:text-blue-500 border-blue-600 dark:border-blue-500`
                  : `inline-block p-4 rounded-t-lg border-b-2 border-transparent hover:text-gray-600 hover:border-gray-300 dark:hover:text-gray-300 dark:border-transparent text-gray-500 dark:text-gray-400 border-gray-100 dark:border-gray-700`
              }
              id="dashboard-tab"
              data-tabs-target="#dashboard"
              type="button"
              role="tab"
              aria-controls="dashboard"
              onClick={() => {
                changeTab("password");
              }}
              aria-selected={tabs === "password" ? "true" : "false"}
            >
              Change Password
            </button>
          </li>
          <li className="mr-2" role="presentation">
            <button
              className={
                tabs === "profile"
                  ? `inline-block p-4 rounded-t-lg border-b-2 text-blue-600 hover:text-blue-600 dark:text-blue-500 dark:hover:text-blue-500 border-blue-600 dark:border-blue-500`
                  : `inline-block p-4 rounded-t-lg border-b-2 border-transparent hover:text-gray-600 hover:border-gray-300 dark:hover:text-gray-300 dark:border-transparent text-gray-500 dark:text-gray-400 border-gray-100 dark:border-gray-700`
              }
              id="settings-tab"
              data-tabs-target="#settings"
              type="button"
              role="tab"
              aria-controls="settings"
              onClick={() => {
                changeTab("profile");
              }}
              aria-selected={tabs === "profile" ? "true" : "false"}
            >
              Change Profile Picture
            </button>
          </li>
        </ul>
      </div>
      <div id="myTabContent">
        {tabs === "name" && (
          <div
            className="p-4 bg-gray-50 rounded-lg dark:bg-gray-800"
            id="profile"
            role="tabpanel"
            aria-labelledby="profile-tab"
          >
            <Formik
              initialValues={{
                name: name ? name : authData && authData.name,
              }}
              validationSchema={Yup.object({
                name: Yup.string().required("Name is required"),
              })}
              onSubmit={(values, { setSubmitting }) => {
                const request = {
                  name: values.name,
                };
                const callback = (data) => {
                  if (data.success) {
                    console.log("Update name");
                  }
                };
                dispatch(updateName({ data: request, callback }));
                setSubmitting(false);
              }}
            >
              {({ handleSubmit, isSubmitting, isValidating }) => (
                <Form onSubmit={handleSubmit}>
                  <div style={{ margin: "0 auto" }} className="w-6/12">
                    <TextInput
                      label=""
                      name="name"
                      id="name"
                      type="text"
                      placeholder="Your Name"
                      labelClassname="form-label text-gray-600 mb-2 block"
                      className="form-control  block
                    w-full
                    px-1
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
                    <button
                      type="submit"
                      disabled={isSubmitting || isValidating}
                      className="inline-block px-6 py-2.5 bg-sky-600 text-white font-medium text-xs leading-tight uppercase rounded shadow-md hover:bg-sky-700 hover:shadow-lg focus:bg-blue-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-blue-800 active:shadow-lg transition duration-150 ease-in-out w-3/12 mt-5"
                    >
                      Change Name
                    </button>
                  </div>
                </Form>
              )}
            </Formik>
          </div>
        )}
        {tabs === "password" && (
          <div
            className="p-4 bg-gray-50 rounded-lg dark:bg-gray-800"
            id="profile"
            role="tabpanel"
            aria-labelledby="profile-tab"
          >
            <Formik
              initialValues={{
                password: "",
              }}
              validationSchema={Yup.object({
                password: Yup.string().required("Password is required"),
              })}
              onSubmit={(values, { setSubmitting }) => {
                const request = {
                  password: values.password,
                };
                const callback = (data) => {
                  if (data.success) {
                    console.log("Update name");
                  }
                };
                dispatch(changePassword({ data: request, callback }));
                setSubmitting(false);
              }}
            >
              {({ handleSubmit, isSubmitting, isValidating }) => (
                <Form onSubmit={handleSubmit}>
                  <div style={{ margin: "0 auto" }} className="w-6/12">
                    <TextInput
                      label=""
                      name="password"
                      id="password"
                      type="password"
                      placeholder="Your Password"
                      labelClassname="form-label text-gray-600 mb-2 block"
                      className="form-control  block
                  w-full
                  px-1
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
                    <button
                      type="submit"
                      disabled={isSubmitting || isValidating}
                      className="inline-block px-6 py-2.5 bg-sky-600 text-white font-medium text-xs leading-tight uppercase rounded shadow-md hover:bg-sky-700 hover:shadow-lg focus:bg-blue-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-blue-800 active:shadow-lg transition duration-150 ease-in-out w-6/12 mt-5"
                    >
                      Change Password
                    </button>
                  </div>
                </Form>
              )}
            </Formik>
          </div>
        )}
        {tabs === "profile" && (
          <div
            className="p-4 bg-gray-50 rounded-lg dark:bg-gray-800"
            id="settings"
            role="tabpanel"
            aria-labelledby="settings-tab"
          >
            <div className="flex justify-center items-center w-full">
              {image && (
                <Cropper
                  style={{ height: "100%", width: "100%" }}
                  zoomTo={0.5}
                  initialAspectRatio={1}
                  preview=".img-preview"
                  src={image}
                  viewMode={1}
                  minCropBoxHeight={10}
                  minCropBoxWidth={10}
                  background={false}
                  responsive={true}
                  autoCropArea={1}
                  checkOrientation={false}
                  onInitialized={(instance) => {
                    setCropper(instance);
                  }}
                  guides={true}
                />
              )}
              {!image && (
                <label
                  htmlFor="dropzone-file"
                  className="flex flex-col justify-center items-center w-full h-64 bg-gray-50 rounded-lg border-2 border-gray-300 border-dashed cursor-pointer dark:hover:bg-bray-800 dark:bg-gray-700 hover:bg-gray-100 dark:border-gray-600 dark:hover:border-gray-500 dark:hover:bg-gray-600"
                >
                  <div className="flex flex-col justify-center items-center pt-5 pb-6">
                    <svg
                      aria-hidden="true"
                      className="mb-3 w-10 h-10 text-gray-400"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                      xmlns="http://www.w3.org/2000/svg"
                    >
                      <path
                        strokeLinecap="round"
                        strokeLinejoin="round"
                        strokeWidth={2}
                        d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12"
                      />
                    </svg>
                    <p className="mb-2 text-sm text-gray-500 dark:text-gray-400">
                      <span className="font-semibold">Click to upload</span> or
                      drag and drop
                    </p>
                    <p className="text-xs text-gray-500 dark:text-gray-400">
                      SVG, PNG, JPG or GIF (MAX. 800x400px)
                    </p>
                  </div>
                  <input
                    onChange={onChange}
                    id="dropzone-file"
                    type="file"
                    className="hidden"
                  />
                </label>
              )}
            </div>
            {image && (
              <div className="flex mt-5 flex-row-reverse">
                <button
                  type="button"
                  onClick={() => {
                    setImage("");
                  }}
                  className="inline-block px-6 py-2.5 bg-sky-600 text-white font-medium text-xs leading-tight uppercase rounded shadow-md hover:bg-sky-700 hover:shadow-lg focus:bg-blue-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-blue-800 active:shadow-lg transition duration-150 ease-in-out"
                >
                  Cancel
                </button>
                <button
                  onClick={() => {
                    handleUpload();
                  }}
                  className="inline-block px-6 py-2.5 bg-sky-600 text-white font-medium text-xs leading-tight uppercase rounded shadow-md hover:bg-sky-700 hover:shadow-lg focus:bg-blue-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-blue-800 active:shadow-lg transition duration-150 ease-in-out mr-2"
                >
                  Crop and upload
                </button>
              </div>
            )}
          </div>
        )}
      </div>
    </div>
  );
};

export default Profile;
