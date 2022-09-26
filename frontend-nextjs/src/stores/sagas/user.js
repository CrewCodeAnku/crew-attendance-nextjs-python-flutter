import { all, put, takeLatest } from "redux-saga/effects";
import { successMessage } from "../../utilities/notification";
import { userslice } from "../slices/user";
import { setCookies } from "../../utilities/auth-helpers";

import {
  LOGIN,
  REGISTER,
  VERIFY_EMAIL,
  RESEND_VERIFY_EMAIL,
  FORGOT_PASSWORD,
  RESET_PASSWORD,
  UPDATE_NAME,
  CHANGE_PASSWORD,
  CHANGE_PROFILE_PICTURE,
} from "../actions/user.actions.types";

import httpClient from "../services/http.client";

import * as Effects from "redux-saga/effects";
const call = Effects.call;

function* registerHandler({ payload: { data, callback } }) {
  const payload = {
    data,
    method: "post",
    url: "user/signup",
  };
  const { error, result } = yield call(httpClient, {
    payload: payload,
    isLoader: true,
    authorization: false,
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

function* verifyEmailHandler({ payload: { data, callback } }) {
  const payload = {
    data,
    method: "post",
    url: "user/verifyemail",
  };

  const { error, result } = yield call(httpClient, {
    payload: payload,
    isLoader: true,
    authorization: false,
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

function* resendverifyEmailHandler({ payload: { data, callback } }) {
  const payload = {
    data,
    method: "post",
    url: "user/resendverifyemail",
  };

  const { error, result } = yield call(httpClient, {
    payload: payload,
    isLoader: true,
    authorization: false,
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

function* forgotPasswordHandler({ payload: { data, callback } }) {
  const payload = {
    data,
    method: "post",
    url: "user/forgetpassword",
  };

  const { error, result } = yield call(httpClient, {
    payload: payload,
    isLoader: true,
    authorization: false,
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

function* login({ payload: { data, callback } }) {
  console.log("Callback", callback);
  const payload = {
    data,
    method: "post",
    url: "user/login",
  };

  const { error, result } = yield call(httpClient, {
    payload: payload,
    isLoader: true,
    authorization: false,
  });
  console.log("Error", error);

  if (error) {
    if (callback) {
      callback({ success: false, data: null });
    }
  } else {
    yield put(
      userslice.actions.setAuthenticationToken(result.data?.refresh_token)
    );
    yield put(userslice.actions.loginAction(result.data));
    setCookies(true);
    if (callback) {
      callback({ success: true, data: null });
    }
  }
}

function* resetPasswordHandler({ payload: { data, callback } }) {
  const payload = {
    data,
    method: "post",
    url: "user/resetpassword",
  };

  const { error, result } = yield call(httpClient, {
    payload: payload,
    isLoader: true,
    authorization: false,
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

function* updateName({ payload: { data, callback } }) {
  const payload = {
    data,
    method: "post",
    url: "user/updateProfileName",
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
    yield put(userslice.actions.updateNameAction(result.data.name));
    successMessage(result.message);
    if (callback) {
      callback({ success: true, data: null });
    }
  }
}

function* updatePassword({ payload: { data, callback } }) {
  const payload = {
    data,
    method: "post",
    url: "user/updatePassword",
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

function* changeProfilePicture({ payload: { data, callback } }) {
  const payload = {
    data,
    method: "post",
    url: "/user/updateProfilePicture",
  };

  const { error, result } = yield call(httpClient, {
    payload: payload,
    isLoader: true,
    authorization: true,
    isFile: true,
  });

  if (error) {
    if (callback) {
      callback({ success: false, data: null });
    }
  } else {
    yield put(
      userslice.actions.updateProfileAction(result.data.profile_picture)
    );
    successMessage(result.message);
    if (callback) {
      callback({ success: true, data: null });
    }
  }
}

function* User() {
  yield all([
    takeLatest(LOGIN, login),
    takeLatest(REGISTER, registerHandler),
    takeLatest(FORGOT_PASSWORD, forgotPasswordHandler),
    takeLatest(VERIFY_EMAIL, verifyEmailHandler),
    takeLatest(RESEND_VERIFY_EMAIL, resendverifyEmailHandler),
    takeLatest(RESET_PASSWORD, resetPasswordHandler),
    takeLatest(UPDATE_NAME, updateName),
    takeLatest(CHANGE_PASSWORD, updatePassword),
    takeLatest(CHANGE_PROFILE_PICTURE, changeProfilePicture),
  ]);
}

export default User;
