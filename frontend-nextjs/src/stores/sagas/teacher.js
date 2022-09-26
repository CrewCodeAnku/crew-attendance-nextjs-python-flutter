import { all, put, takeLatest } from "redux-saga/effects";
import { teacherslice } from "../slices/teacher";
import {
  GET_TEACHER_COURSES,
  CREATE_COURSE,
} from "../actions/teacher.actions.types";
import httpClient from "../services/http.client";
import { successMessage } from "../../utilities/notification";

import * as Effects from "redux-saga/effects";
const call = Effects.call;

function* fetchTeacherCoursesHandler({ payload: { data, callback } }) {
  const payload = {
    data,
    method: "get",
    url: "teacher/courseListing",
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
    yield put(teacherslice.actions.setCourses(result.data));
    if (callback) {
      callback({ success: true, data: null });
    }
  }
}

function* createCoursesHandler({ payload: { data, callback } }) {
  const payload = {
    data,
    method: "post",
    url: "teacher/createCourse",
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
    successMessage(result.message);
    if (callback) {
      callback({ success: true, data: null });
    }
  }
}

function* Teacher() {
  yield all([takeLatest(GET_TEACHER_COURSES, fetchTeacherCoursesHandler)]);
  yield all([takeLatest(CREATE_COURSE, createCoursesHandler)]);
}

export default Teacher;
