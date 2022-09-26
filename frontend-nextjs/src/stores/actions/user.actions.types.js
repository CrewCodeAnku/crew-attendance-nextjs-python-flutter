import { createAction } from "redux-actions";

export const LOGIN = "LOGIN";
export const login = createAction(LOGIN);

export const REGISTER = "REGISTER";
export const register = createAction(REGISTER);

export const VERIFY_EMAIL = "VERIFY_EMAIL";
export const verifyEmail = createAction(VERIFY_EMAIL);

export const RESEND_VERIFY_EMAIL = "RESEND_VERIFY_EMAIL";
export const resendVerifyEmail = createAction(RESEND_VERIFY_EMAIL);

export const FORGOT_PASSWORD = "FORGOT_PASSWORD";
export const forgotPassword = createAction(FORGOT_PASSWORD);

export const RESET_PASSWORD = "RESET_PASSWORD";
export const resetPassword = createAction(RESET_PASSWORD);

export const UPDATE_NAME = "UPDATE_NAME";
export const updateName = createAction(UPDATE_NAME);

export const CHANGE_PASSWORD = "CHANGE_PASSWORD";
export const changePassword = createAction(CHANGE_PASSWORD);

export const CHANGE_PROFILE_PICTURE = "CHANGE_PROFILE_PICTURE";
export const changeProfilePicture = createAction(CHANGE_PROFILE_PICTURE);

export const SET_AUTHENTICATION_TOKEN = "SET_AUTHENTICATION_TOKEN";
export const setAuthenticationToken = createAction(SET_AUTHENTICATION_TOKEN);

export const LOGOUT = "LOGOUT";
export const logout = createAction(LOGOUT);
