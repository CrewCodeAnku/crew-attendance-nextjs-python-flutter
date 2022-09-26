import 'package:crew_attendance/ui/pages/emailVerify.dart';
import 'package:flutter/widgets.dart';
import 'package:crew_attendance/ui/pages/teacher/teacherCourse.dart';
import 'package:crew_attendance/ui/pages/student/studentCourse.dart';
import 'package:crew_attendance/ui/pages/login.dart';
import 'package:crew_attendance/ui/pages/register.dart';
import 'package:crew_attendance/ui/pages/forgetPassword.dart';
import 'package:crew_attendance/ui/pages/otpConfirmation.dart';
import 'package:crew_attendance/ui/pages/resetPassword.dart';

class Routes {
  Routes._();

  static const String dashboard = '/dashboard';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgetpass = '/forgetpass';
  static const String otpscreen = '/otpscreen';
  static const String verifyemail = '/verifyemail';
  static const String resetpassword = '/resetpassword';
  static const String studentdashboard = '/studentdashboard';

  static final routes = <String, WidgetBuilder>{
    dashboard: (BuildContext context) => TeacherCourse(),
    login: (BuildContext context) => LoginPage(),
    register: (BuildContext context) => RegPage(),
    forgetpass: (BuildContext context) => ForgetPassword(),
    otpscreen: (BuildContext context) => OtpConfirmation(),
    verifyemail: (BuildContext context) => EmailVerify(),
    resetpassword: (BuildContext context) => ResetPasswordPage(),
    studentdashboard: (BuildContext context) => StudentCourse()
  };
}
