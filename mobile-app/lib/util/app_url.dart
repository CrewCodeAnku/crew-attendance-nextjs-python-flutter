class AppUrl {
  static const String liveBaseURL = "";
  static const String localBaseURL = "http://192.168.1.4:4000";

  static const String baseURL = localBaseURL;
  static const String login = "/user/login";
  static const String verifyemail = "/user/verifyemail";
  static const String resendemail = "/user/resendverifyemail";
  static const String register = "/user/signup";
  static const String updatename = "/user/updateProfileName";
  static const String updatepassword = "/user/updatePassword";
  static const String forgotPassword = "/user/forgetpassword";
  static const String resetPassword = "/user/resetpassword";
  static const String updateProfilePic = "/user/updateProfilePicture";
  static const String fetchStudentCourse = "/student/courseListing";
  static const String fetchTeacherCourse = "/teacher/courseListing";
  static const String fetchCourseStudents = "/teacher/courseStudents";
  static const String fetchCourseAttendance = "/teacher/courseAttendance";
  static const String fetchAttendanceResult = "/teacher/fetchAttendanceResult";
  static const String createCourse = "/teacher/createCourse";
  static const String createAttendance = "/teacher/createAttendance";
  static const String editAttendance = "/teacher/editAttendance";
  static const String enrollCourse = "/student/joinCourse";
  static const String leaveCourse = "/student/leaveCourse";
  static const String fetchRefreshToken = "/user/auth";
}
