import { call, select, put, delay } from "redux-saga/effects";
import Idx from "idx";
import { appslice } from "../slices/app";
import { logout } from "../actions/user.actions.types";
import axiosInstance from "../../utilities/axios-instance";
import axiosInstanceFile from "../../utilities/axios-instance-file-upload";
import { errorMessage } from "../../utilities/notification";

function* HttpClient({
  payload,
  isLoader = true,
  authorization = true,
  isFile = false,
}) {
  if (isLoader) {
    yield put(appslice.actions.setLoadingAction(true));
    yield delay(250);
  }

  const data = { ...payload };
  if (authorization) {
    const authToken = yield select(({ user: { token } }) => token);
    if (authToken) {
      data.headers = { AccessToken: authToken };
    } else {
      yield put(appslice.actions.setLoadingAction(false));
      return {
        error: true,
        result: null,
      };
    }
  }

  try {
    const { data: result } = yield call(
      isFile ? axiosInstanceFile : axiosInstance,
      data
    );

    yield put(appslice.actions.setLoadingAction(false));
    return {
      error: null,
      result,
    };
  } catch (error) {
    yield put(appslice.actions.setLoadingAction(false));

    if (Idx(error, (_) => _.code)) {
      if (error.code === "ECONNABORTED") {
        const message = "Please try later our servers are not responding.";
        errorMessage(message);
      } else if (error.code === 401) {
        yield delay(500);
        yield put(logout());
      } else if (error.code === 402) {
      } else {
        errorMessage(error.message);
      }
    } else {
      errorMessage(error.message);
    }
    return {
      error,
      result: null,
    };
  }
}

export default HttpClient;
