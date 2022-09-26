import React, { useEffect } from "react";
import StudentDashboardContainer from "../src/containers/StudentDashboard/dashboard";
import TeacherDashboardContainer from "../src/containers/TeacherDashboard/dashboard";
import PrivateLayout from "../src/layouts/private-layout";
import { auth } from "../src/utilities/auth-helpers";
import { useSelector } from "react-redux";

const Dashboard = () => {
  const authData = useSelector((state) => state.user.userDetails);

  return (
    <PrivateLayout
      title="Crew Attendance | Dashboard"
      component={
        authData.type === "student"
          ? StudentDashboardContainer
          : TeacherDashboardContainer
      }
    />
  );
};

Dashboard.getInitialProps = async ({ Component, ctx }) => {
  let pageProps = {};

  const extraStuff = { namespacesRequired: ["common"] };

  pageProps = auth(ctx);

  return {
    extraStuff,
    pageProps,
  };
};

export default Dashboard;
