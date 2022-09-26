import 'package:flutter/material.dart';
import 'package:crew_attendance/ui/pages/teacher/teacherCourseDetail.dart';

class TeacherCoursesWidget extends StatelessWidget {
  final String? id;
  final String? courseName;
  final String? courseShortName;
  final String? courseStartDate;
  final String? courseEndDate;

  TeacherCoursesWidget(this.id, this.courseName, this.courseShortName,
      this.courseStartDate, this.courseEndDate);

  @override
  Widget build(BuildContext context) {
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TeacherCourseDetail(courseid: id, coursename: courseShortName),
                    ),
                  );
                },
                child: Text(
                  courseName!,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              subtitle: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TeacherCourseDetail(),
                    ),
                  );
                },
                child: Text(
                  courseShortName!,
                ),
              ),
              trailing: GestureDetector(
                onTap: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: 200,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              ListTile(
                                leading: Icon(Icons.share),
                                title: Text("Share Course"),
                              ),
                              ListTile(
                                leading: Icon(Icons.delete),
                                title: Text("Delete Course"),
                              ),
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
