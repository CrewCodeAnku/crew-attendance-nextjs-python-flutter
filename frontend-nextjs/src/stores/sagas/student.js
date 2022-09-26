import { all, put, takeLatest } from "redux-saga/effects";
import { studentslice } from "../slices/student";
import {
  FETCH_STUDENT_COURSES,
  ENROLL_IN_COURSE,
  UNENROLL_IN_COURSE,
} from "../actions/student.actions.types";
import httpClient from "../services/http.client";

import * as Effects from "redux-saga/effects";
const call = Effects.call;

function* fetchCoursesHandler({ payload: { data, callback } }) {
  const payload = {
    data,
    method: "get",
    url: "student/courseListing",
  };
  const { error, result } = yield call(httpClient, {
    payload: payload,
    isLoader: true,
    authorization: true,
  });

  if (error) {
    if (callback) {
      callback({ success: false, data: null });
    }
  } else {
    yield put(studentslice.actions.setCourses(result.data));
    if (callback) {
      callback({ success: true, data: null });
    }
  }
}

function* enrollCoursesHandler({ payload: { data, callback } }) {
  const payload = {
    data,
    method: "post",
    url: "student/joinCourse",
  };
  const { error, result } = yield call(httpClient, {
    payload: payload,
    isLoader: true,
    authorization: true,
  });

  if (error) {
    if (callback) {
      callback({ success: false, data: null });
    }
  } else {
    if (callback) {
      callback({ success: true, data: null });
    }
  }
}

function* unenrollCoursesHandler({ payload: { data, callback } }) {
  const payload = {
    data,
    method: "post",
    url: "student/leaveCourse",
  };
  const { error, result } = yield call(httpClient, {
    payload: payload,
    isLoader: true,
    authorization: true,
  });

  if (error) {
    if (callback) {
      callback({ success: false, data: null });
    }
  } else {
    if (callback) {
      callback({ success: true, data: null });
    }
  }
}

function* Student() {
  yield all([takeLatest(FETCH_STUDENT_COURSES, fetchCoursesHandler)]);
  yield all([takeLatest(ENROLL_IN_COURSE, enrollCoursesHandler)]);
  yield all([takeLatest(UNENROLL_IN_COURSE, unenrollCoursesHandler)]);
}

export default Student;
