import { createSlice } from "@reduxjs/toolkit";

const initialState = {
  visible: false,
};

export const appslice = createSlice({
  name: "app",
  initialState,
  reducers: {
    setLoadingAction: (state = initialState, { payload }) => {
      return {
        ...state,
        visible: payload,
      };
    },
  },
  extraReducers: {},
});
