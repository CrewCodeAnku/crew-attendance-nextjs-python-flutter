import 'dart:async';
import 'package:crew_attendance/ui/pages/student/studentCourse.dart';
import 'package:crew_attendance/ui/pages/teacher/teacherCourse.dart';
import 'package:flutter/material.dart';
import 'package:crew_attendance/ui/pages/onBoardScreen.dart';
import 'package:crew_attendance/util/color.dart';
import 'package:crew_attendance/util/shared_preference.dart';
import 'login.dart';

class AuthSplash extends StatefulWidget {
  @override
  _AuthSplashState createState() => _AuthSplashState();
}

class _AuthSplashState extends State<AuthSplash> {
  @override
  void initState() {
    super.initState();
    String? type;
    Timer(
        Duration(seconds: 3),
        () async => {
              type = await UserPreferences().getType(),
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      type != null && type == "teacher"
                          ? const TeacherCourse()
                          : const StudentCourse()))
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: orangeColors,
      body: Center(
        child: Image.asset('assets/images/logo.png'),
      ),
    );
  }
}
