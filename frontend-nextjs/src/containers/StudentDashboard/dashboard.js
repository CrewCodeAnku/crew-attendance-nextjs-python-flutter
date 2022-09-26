import React, { useEffect, useState } from "react";
import { useSelector, useDispatch } from "react-redux";
import {
  fetchStudentCourses,
  enrollInCourse,
  unenrollIncourse,
} from "../../stores/actions/student.actions.types";
import { TextInput } from "../../components/UI/form-fields";
import { Formik, Form } from "formik";
import * as Yup from "yup";
import DataTable from "react-data-table-component";
import { confirmAlert } from "react-confirm-alert"; // Import
import "react-confirm-alert/src/react-confirm-alert.css"; // Import css

const Dashboard = () => {
  const dispatch = useDispatch();
  const [enroll, enrollInCourseState] = useState(false);
  const courses = JSON.parse(useSelector((state) => state.student.courses));
  useEffect(() => {
    dispatch(fetchStudentCourses({ data: null }));
  }, []);

  const [tabs, changeTab] = useState("name");

  const unenroll = (courseid) => {
    confirmAlert({
      title: "Enrollment confirmation",
      message: "Are you sure you want to unenroll.",
      buttons: [
        {
          label: "Yes",
          onClick: () => {
            const callback = (data) => {
              if (data.success) {
                dispatch(fetchStudentCourses({ data: null }));
              }
            };
            dispatch(
              unenrollIncourse({ data: { course_id: courseid }, callback })
            );
          },
        },
        {
          label: "No",
          onClick: () => {},
        },
      ],
    });
  };

  const columns = [
    {
      name: "Course Name",
      selector: (row) => (
        <span style={{ fontSize: "14px" }}>{row.courseName}</span>
      ),
      sortable: true,
    },
    {
      name: "Course Code",
      selector: (row) => (
        <span style={{ fontSize: "14px" }}>{row.courseShortName}</span>
      ),
      sortable: true,
    },
    {
      name: "Action",
      selector: (row) => {
        return (
          <button
            type="button"
            onClick={() => {
              unenroll(row.id);
            }}
            className="inline-block px-6 py-2.5 bg-sky-600 text-white font-medium text-xs leading-tight uppercase rounded shadow-md hover:bg-sky-700 hover:shadow-lg focus:bg-blue-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-blue-800 active:shadow-lg transition duration-150 ease-in-out"
          >
            Unenroll
            <i className="fas fa-sign-out-alt text-white ml-2" />
          </button>
        );
      },
      sortable: true,
    },
  ];

  return (
    <React.Fragment>
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
                My Courses
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
                Enroll In Course
              </button>
            </li>
          </ul>
        </div>
        <div id="myTabContent">
          {tabs === "name" && (
            <div
              style={{ margin: "0 auto" }}
              className="p-4 bg-white rounded-lg container mx-auto w-full"
            >
              <div className="w-9/12">
                <DataTable
                  style={{ borderRadius: "0.5rem !important" }}
                  className=""
                  columns={columns}
                  data={courses ? courses : []}
                  theme="solarized"
                />
              </div>
            </div>
          )}

          {tabs === "password" && (
            <div
              className="p-4 bg-white rounded-lg container mx-auto w-full"
              id="settings"
              role="tabpanel"
              aria-labelledby="settings-tab"
            >
              <Formik
                initialValues={{
                  courseid: "",
                }}
                validationSchema={Yup.object({
                  courseid: Yup.string().required("Course code is required"),
                })}
                onSubmit={(values, { setSubmitting }) => {
                  const request = {
                    courseCode: values.courseid,
                  };
                  const callback = (data) => {
                    enrollInCourseState(false);
                    if (data.success) {
                      dispatch(fetchStudentCourses({ data: null }));
                    }
                  };
                  dispatch(enrollInCourse({ data: request, callback }));

                  setSubmitting(false);
                }}
              >
                {({ handleSubmit, isSubmitting, isValidating }) => (
                  <Form onSubmit={handleSubmit}>
                    <div style={{ margin: "0 auto" }} className="w-6/12">
                      <TextInput
                        label=""
                        name="courseid"
                        id="courseid"
                        type="text"
                        placeholder="Course Code"
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
                        Enroll
                      </button>
                    </div>
                  </Form>
                )}
              </Formik>
            </div>
          )}
        </div>
      </div>
      {/*<div style={{ paddingTop: "50px" }} className="container mx-auto px-4">
      <div className="flex justify-between mt-5 mb-5">
        <h1 className="mt-5 text-2xl font-bold text-gray-800">My Courses</h1>
        <div className="">
          <button
            type="button"
            onClick={() => {
              enrollInCourseState(true);
            }}
            className=" mt-3 inline-block px-6 py-2.5 bg-sky-600 text-white font-medium text-xs leading-tight uppercase rounded shadow-md hover:bg-sky-700 hover:shadow-lg focus:bg-blue-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-blue-800 active:shadow-lg transition duration-150 ease-in-out"
          >
            Enroll in course
            <i className="fas fa-plus text-white ml-2" />
          </button>
        </div>
      </div>

      <div className="flex flex-wrap -mx-1 lg:-mx-4">
        <DataTable
          style={{ borderRadius: "0.5rem !important" }}
          className="shadow-sm sm:rounded-lg"
          columns={columns}
          data={courses ? courses : []}
          theme="solarized"
        />
        {enroll && (
          <div
            className="relative z-10"
            aria-labelledby="modal-title"
            role="dialog"
            aria-modal="true"
          >
            <div className="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" />
            <div className="fixed inset-0 z-10 overflow-y-auto">
              <Formik
                initialValues={{
                  courseid: "",
                }}
                validationSchema={Yup.object({
                  courseid: Yup.string().required("Course code is required"),
                })}
                onSubmit={(values, { setSubmitting }) => {
                  const request = {
                    courseCode: values.courseid,
                  };
                  const callback = (data) => {
                    enrollInCourseState(false);
                    if (data.success) {
                      dispatch(fetchStudentCourses({ data: null }));
                    }
                  };
                  dispatch(enrollInCourse({ data: request, callback }));

                  setSubmitting(false);
                }}
              >
                {({ handleSubmit, isSubmitting, isValidating }) => (
                  <Form onSubmit={handleSubmit}>
                    <div className="flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0">
                      <div className="relative transform overflow-hidden rounded-lg bg-white text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-lg">
                        <div className="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
                          <div className="sm:flex sm:items-start">
                            <div className="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left">
                              <h3
                                className="text-lg font-medium leading-6 text-gray-900"
                                id="modal-title"
                              >
                                Enter course code to enroll in course
                              </h3>
                              <div className="mt-2 xl:w-96">
                                <TextInput
                                  label=""
                                  name="courseid"
                                  id="courseid"
                                  type="text"
                                  placeholder="Course Code"
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
                              </div>
                            </div>
                          </div>
                        </div>
                        <div className="bg-gray-50 px-4 py-3 sm:flex sm:flex-row-reverse sm:px-6">
                          <button
                            type="submit"
                            disabled={isSubmitting || isValidating}
                            className="inline-flex w-full justify-center rounded-md border border-transparent bg-sky-600 px-4 py-2 text-base font-medium text-white shadow-sm hover:bg-sky-700 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-2 sm:ml-3 sm:w-auto sm:text-sm"
                          >
                            Enroll
                          </button>
                          <button
                            onClick={() => {
                              enrollInCourseState(false);
                            }}
                            type="button"
                            className="mt-3 inline-flex w-full justify-center rounded-md border border-gray-300 bg-white px-4 py-2 text-base font-medium text-gray-700 shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm"
                          >
                            Cancel
                          </button>
                        </div>
                      </div>
                    </div>
                  </Form>
                )}
              </Formik>
            </div>
          </div>
        )}
      </div>
                          </div>*/}
    </React.Fragment>
  );
};

export default Dashboard;
