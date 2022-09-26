import { createSlice } from "@reduxjs/toolkit";

const initialState = {
  userDetails: null,
  token: null,
  name: null,
  profile_pic: null,
};

export const userslice = createSlice({
  name: "user",
  initialState,
  reducers: {
    setAuthenticationToken: (state = initialState, { payload }) => {
      return {
        ...state,
        token: payload,
      };
    },
    loginAction: (state = initialState, { payload }) => {
      return {
        ...state,
        userDetails: payload,
      };
    },
    updateNameAction: (state = initialState, { payload }) => {
      return {
        ...state,
        name: payload,
      };
    },
    updateProfileAction: (state = initialState, { payload }) => {
      return {
        ...state,
        profile_pic: payload,
      };
    },
  },
  extraReducers: {},
});
