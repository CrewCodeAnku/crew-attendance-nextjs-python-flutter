import 'package:another_flushbar/flushbar.dart';
import 'package:crew_attendance/core/providers/student_provider.dart';
import 'package:crew_attendance/util/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/auth_provider.dart';

class StudentCoursesWidget extends StatelessWidget {
  final String? id;
  final String? courseName;
  final String? courseShortName;
  final String? courseStartDate;
  final String? courseEndDate;

  StudentCoursesWidget(this.id, this.courseName, this.courseShortName,
      this.courseStartDate, this.courseEndDate);

  @override
  Widget build(BuildContext context) {
    StudentCoursesProvider student =
        Provider.of<StudentCoursesProvider>(context, listen: false);

    leaveCourse(id) {
      final Future<Map<String, dynamic>> successfulMessage =
          student.leaveCourse(
        id,
      );

      successfulMessage.then((response) {
        if (response['status']) {
          Flushbar(
            title: "Course Unenrollment",
            message: response['message'].toString(),
            duration: const Duration(seconds: 3),
          ).show(context);
        } else {
          Flushbar(
            title: "Failed unenrollment",
            message: response['message'].toString(),
            duration: const Duration(seconds: 3),
          ).show(context);
        }
      });
    }

    return Container(
      height: 150,
      constraints:
          const BoxConstraints(minHeight: 150, minWidth: double.infinity),
      child: Card(
        elevation: 2.0,
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: GestureDetector(
                onTap: () {},
                child: Text(
                  courseName!,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              subtitle: GestureDetector(
                onTap: () {},
                child: Text(
                  courseShortName!,
                ),
              ),
              trailing: GestureDetector(
                onTap: () async {
                  await UserPreferences().saveCourseId(id);
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: 70,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ListTile(
                                  leading: const Icon(Icons.exit_to_app),
                                  title: const Text("Leave Course"),
                                  onTap: () async {
                                    Navigator.pop(context);
                                    await leaveCourse(id);
                                  }),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: const Icon(Icons.more_horiz),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Teacher:Hassan Ali",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
