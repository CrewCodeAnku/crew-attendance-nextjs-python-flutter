import { createAction } from "redux-actions";

export const FETCH_STUDENT_COURSES = "FETCH_STUDENT_COURSES";
export const fetchStudentCourses = createAction(FETCH_STUDENT_COURSES);

export const ENROLL_IN_COURSE = "ENROLL_IN_COURSE";
export const enrollInCourse = createAction(ENROLL_IN_COURSE);

export const UNENROLL_IN_COURSE = "UNENROLL_IN_COURSE";
export const unenrollIncourse = createAction(UNENROLL_IN_COURSE);
