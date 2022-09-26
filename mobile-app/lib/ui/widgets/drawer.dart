import 'package:crew_attendance/util/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:crew_attendance/ui/pages/student/profile.dart';
import 'package:crew_attendance/ui/pages/teacher/profile.dart';
import 'package:crew_attendance/ui/pages/teacher/teacherCourse.dart';
import 'package:crew_attendance/ui/pages/student/studentCourse.dart';
import 'package:crew_attendance/ui/pages/login.dart';

class DrawerWidget extends StatelessWidget {
  DrawerWidget();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          const UserAccountsDrawerHeader(
            accountName: Text("Anku"),
            accountEmail: Text("abc@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.cyan,
              child: Text("A"),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            trailing: Icon(Icons.arrow_forward_rounded),
            onTap: () async {
              var type = await UserPreferences().getType();
              type == "student"
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StudentCourse(),
                      ),
                    )
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TeacherCourse(),
                      ),
                    );
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: const Text("Profile"),
            trailing: const Icon(Icons.arrow_forward_rounded),
            onTap: () async {
              var type = await UserPreferences().getType();
              type == "student"
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileStudentPage(),
                      ),
                    )
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileTeacherPage(),
                      ),
                    );
            },
          ),
          const ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            trailing: Icon(Icons.arrow_forward_rounded),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout_rounded),
            title: const Text("Logout"),
            trailing: const Icon(Icons.arrow_forward_rounded),
            onTap: () async {
              UserPreferences().removeUser();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => LoginPage()));
            },
          ),
        ],
      ),
    );
  }
}
