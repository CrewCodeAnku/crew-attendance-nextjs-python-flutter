import { createSlice } from "@reduxjs/toolkit";

const initialState = {
  courses: null,
};

export const teacherslice = createSlice({
  name: "teacher",
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
