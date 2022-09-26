import 'dart:async';
import 'package:flutter/material.dart';
import 'package:crew_attendance/ui/pages/onBoardScreen.dart';
import 'package:crew_attendance/util/color.dart';
import 'package:crew_attendance/util/shared_preference.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    String? issplash;
    String? type;
    Timer(
        Duration(seconds: 3),
        () async => {
              issplash = await UserPreferences().getSplash(),
              type = await UserPreferences().getType(),
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      issplash != null ? LoginPage() : OnBoardingPage()))
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
