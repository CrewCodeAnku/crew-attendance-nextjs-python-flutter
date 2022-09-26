import { createAction } from "redux-actions";

export const HIDE_LOADER = "HIDE_LOADER";
export const hideLoader = createAction(HIDE_LOADER);

export const SHOW_LOADER = "SHOW_LOADER";
export const showLoader = createAction(SHOW_LOADER);

export const SHOW_TOAST = "SHOW_TOAST";
export const showToast = createAction(SHOW_TOAST);
