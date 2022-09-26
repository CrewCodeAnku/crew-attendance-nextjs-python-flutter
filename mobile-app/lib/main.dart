import 'package:crew_attendance/ui/pages/authSplash.dart';
import 'package:flutter/material.dart';
import 'package:crew_attendance/core/providers/auth_provider.dart';
import 'package:crew_attendance/core/providers/user_provider.dart';
import 'package:crew_attendance/core/providers/student_provider.dart';
import 'package:crew_attendance/core/providers/teacher_provider.dart';
import 'package:crew_attendance/util/shared_preference.dart';
import 'package:crew_attendance/ui/pages/splashScreen.dart';
import 'package:provider/provider.dart';
import 'core/models/user.dart';
import 'package:crew_attendance/routes.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<User> getUserData() => UserPreferences().getUser();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => StudentCoursesProvider()),
        ChangeNotifierProvider(create: (_) => TeacherCoursesProvider()),
      ],
      child: MaterialApp(
        title: 'Crew Attendance',
        navigatorKey: navigatorKey,
        theme: ThemeData(
          fontFamily: 'Jost',
          primaryColor: const Color(0xff0277BD),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: FutureBuilder<User>(
          future: getUserData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const CircularProgressIndicator();
              default:
                if (snapshot.hasData && snapshot.data?.token == null) {
                  return SplashScreen();
                } else {
                  return AuthSplash();
                }
            }
          },
        ),
        routes: Routes.routes,
        builder: EasyLoading.init(),
      ),
    );
  }
}
