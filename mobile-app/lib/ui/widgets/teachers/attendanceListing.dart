import 'package:flutter/material.dart';

//import 'package:crew_attendance/ui/pages/teacher/teacherCourseDetail.dart';
import 'package:crew_attendance/ui/pages/teacher/editAttendance.dart';
import 'package:crew_attendance/core/models/student.dart';

class AttendanceListingWidget extends StatelessWidget {
  final String? courseid;
  final String? coursename;
  final String? id;
  final String? attendanceDate;
  final String? classImage;
  final List? studentParticipated;

  AttendanceListingWidget(this.courseid, this.coursename, this.id,
      this.attendanceDate, this.classImage, this.studentParticipated);

  @override
  Widget build(BuildContext context) {
    print("Attendance id");
    print(id);
    return Container(
      height: 70,
      constraints:
          const BoxConstraints(minHeight: 70, minWidth: double.infinity),
      child: Card(
          elevation: 2.0,
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditAttendance(
                      attendanceId:id,
                      courseId: courseid, courseName: coursename, studentParticipated:studentParticipated?.map((review) => review.toJson()).toList()),
                ),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        classImage!), // no matter how big it is, it won't overflow
                  ),
                  title: Text(
                    attendanceDate!,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
