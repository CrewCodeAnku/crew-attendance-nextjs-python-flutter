import React from "react";
import StudentProfileContainer from "../src/containers/StudentProfile/profile";
import TeacherProfileContainer from "../src/containers/TeacherProfile/profile";
import PrivateLayout from "../src/layouts/private-layout";
import { auth } from "../src/utilities/auth-helpers";
import { useSelector } from "react-redux";

const Profile = () => {
  const authData = useSelector((state) => state.user.userDetails);

  return (
    <PrivateLayout
      title="Crew Attendance | Profile"
      component={
        authData.type === "student"
          ? StudentProfileContainer
          : TeacherProfileContainer
      }
    />
  );
};

Profile.getInitialProps = async ({ Component, ctx }) => {
  let pageProps = {};

  const extraStuff = { namespacesRequired: ["common"] };

  pageProps = auth(ctx);

  return {
    extraStuff,
    pageProps,
  };
};

export default Profile;
