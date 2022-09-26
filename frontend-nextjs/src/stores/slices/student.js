import { createSlice } from "@reduxjs/toolkit";

const initialState = {
  courses: null,
};

export const studentslice = createSlice({
  name: "student",
  initialState,
  reducers: {
    setCourses: (state = initialState, { payload }) => {
      return {
        ...state,
        courses: payload,
      };
    },
  },
  extraReducers: {},
});
