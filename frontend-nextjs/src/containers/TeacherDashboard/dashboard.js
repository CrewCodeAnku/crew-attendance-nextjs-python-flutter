import React, { useEffect, useState } from "react";
import { useSelector, useDispatch } from "react-redux";
import {
  fetchTeacherCourses,
  createCourse,
} from "../../stores/actions/teacher.actions.types";
import { TextInput } from "../../components/UI/form-fields";
import { Formik, Form } from "formik";
import * as Yup from "yup";
import DataTable from "react-data-table-component";
//import { confirmAlert } from "react-confirm-alert"; // Import
import "react-confirm-alert/src/react-confirm-alert.css"; // Import css
import DatePicker from "react-datepicker";
import "react-datepicker/dist/react-datepicker.css";

const DatePickerField = ({ name, value, onChange, className, placeholder }) => {
  return (
    <DatePicker
      selected={(value && new Date(value)) || null}
      onChange={(val) => {
        onChange(name, val);
      }}
      className={className}
      placeholderText={placeholder}
    />
  );
};

const Dashboard = () => {
  const dispatch = useDispatch();
  const courses = JSON.parse(useSelector((state) => state.teacher.courses));
  useEffect(() => {
    dispatch(fetchTeacherCourses({ data: null }));
  }, []);

  const [tabs, changeTab] = useState("name");

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
              coursedetail(row.id);
            }}
            className="inline-block px-6 py-2.5 bg-sky-600 text-white font-medium text-xs leading-tight uppercase rounded shadow-md hover:bg-sky-700 hover:shadow-lg focus:bg-blue-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-blue-800 active:shadow-lg transition duration-150 ease-in-out"
          >
            View Course Detail
            <i className="fas fa-eye text-white ml-2" />
          </button>
        );
      },
    },
    {
      name: "Action",
      selector: (row) => {
        return (
          <button
            type="button"
            onClick={() => {
              deletecourse(row.id);
            }}
            className="inline-block px-6 py-2.5 bg-sky-600 text-white font-medium text-xs leading-tight uppercase rounded shadow-md hover:bg-sky-700 hover:shadow-lg focus:bg-blue-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-blue-800 active:shadow-lg transition duration-150 ease-in-out"
          >
            Delete Course
            <i className="fas fa-trash text-white ml-2" />
          </button>
        );
      },
    },
    {
      name: "Action",
      selector: (row) => {
        return (
          <button
            type="button"
            onClick={() => {
              coursedetail(row.id);
            }}
            className="inline-block px-6 py-2.5 bg-sky-600 text-white font-medium text-xs leading-tight uppercase rounded shadow-md hover:bg-sky-700 hover:shadow-lg focus:bg-blue-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-blue-800 active:shadow-lg transition duration-150 ease-in-out"
          >
            Share Course
            <i className="fas fa-sign-out-alt text-white ml-2" />
          </button>
        );
      },
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
                Create Course
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
              <div className="w-full">
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
                  courseName: "",
                  courseShortName: "",
                  courseStartDate: "",
                  courseEndDate: "",
                }}
                validationSchema={Yup.object({
                  courseName: Yup.string().required("Course name is required"),
                  courseShortName: Yup.string().required(
                    "Course short name is required"
                  ),
                  courseStartDate: Yup.string().required(
                    "Course start date is required"
                  ),
                  courseEndDate: Yup.string().required(
                    "Course end date is required"
                  ),
                })}
                onSubmit={(values, { setSubmitting }) => {
                  const request = {
                    courseName: values.courseName,
                    courseShortName: values.courseShortName,
                    courseStartDate: values.courseStartDate,
                    courseEndDate: values.courseEndDate,
                  };
                  const callback = (data) => {
                    if (data.success) {
                      dispatch(fetchTeacherCourses({ data: null }));
                      changeTab("password");
                    }
                  };
                  dispatch(createCourse({ data: request, callback }));
                  setSubmitting(false);
                }}
              >
                {({
                  handleSubmit,
                  isSubmitting,
                  isValidating,
                  setFieldValue,
                  values,
                }) => (
                  <Form onSubmit={handleSubmit}>
                    <div style={{ margin: "0 auto" }} className="w-6/12">
                      <TextInput
                        label=""
                        name="courseName"
                        id="courseName"
                        type="text"
                        placeholder="Course Name"
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
                      <TextInput
                        label=""
                        name="courseShortName"
                        id="courseShortName"
                        type="text"
                        placeholder="Course Short Name"
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
                    focus:text-gray-700 focus:bg-white focus:border-blue-600 focus:outline-none mt-5"
                        isRequired
                      />
                      <DatePickerField
                        name="courseStartDate"
                        value={values.courseStartDate}
                        onChange={setFieldValue}
                        placeholder="Course Start Date"
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
                    focus:text-gray-700 focus:bg-white focus:border-blue-600 focus:outline-none mt-5"
                      />
                      <DatePickerField
                        name="courseEndDate"
                        value={values.courseEndDate}
                        onChange={setFieldValue}
                        placeholder="Course End Date"
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
                    focus:text-gray-700 focus:bg-white focus:border-blue-600 focus:outline-none mt-5"
                      />
                      <button
                        type="submit"
                        disabled={isSubmitting || isValidating}
                        className="inline-block px-6 py-2.5 bg-sky-600 text-white font-medium text-xs leading-tight uppercase rounded shadow-md hover:bg-sky-700 hover:shadow-lg focus:bg-blue-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-blue-800 active:shadow-lg transition duration-150 ease-in-out w-3/12 mt-5"
                      >
                        Create Course
                      </button>
                    </div>
                  </Form>
                )}
              </Formik>
            </div>
          )}
        </div>
      </div>
    </React.Fragment>
  );
};

export default Dashboard;
