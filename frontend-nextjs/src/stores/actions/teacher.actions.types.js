import { createAction } from "redux-actions";

export const GET_TEACHER_COURSES = "GET_TEACHER_COURSES";
export const fetchTeacherCourses = createAction(GET_TEACHER_COURSES);

export const CREATE_COURSE = "CREATE_COURSE";
export const createCourse = createAction(CREATE_COURSE);

export const FETCH_COURSE_ATTENDANCE = "FETCH_COURSE_ATTENDANCE";
export const fetchCourseAttendance = createAction(FETCH_COURSE_ATTENDANCE);

export const CREATE_ATTENDANCE = "CREATE_ATTENDANCE";
export const createAttendance = createAction(CREATE_ATTENDANCE);

export const EDIT_ATTENDANCE = "EDIT_ATTENDANCE";
export const editAttendance = createAction(EDIT_ATTENDANCE);
