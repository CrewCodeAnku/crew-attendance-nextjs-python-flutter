//import 'package:crew_attendance/ui/pages/teacher/teacherCourse.dart';
import 'package:flutter/material.dart';
import 'package:crew_attendance/ui/pages/teacher/students.dart';
import 'package:crew_attendance/ui/pages/teacher/attendance.dart';
//import 'package:crew_attendance/ui/pages/teacher/createAttendance.dart';
import 'package:crew_attendance/ui/widgets/teachers/profile.dart';
//import 'package:crew_attendance/ui/pages/teacher/profile.dart';
import 'package:crew_attendance/ui/widgets/drawer.dart';

class TeacherCourseDetail extends StatefulWidget {
  final String? courseid;
  final String? coursename;
  const TeacherCourseDetail({super.key, this.courseid, this.coursename});

  @override
  _TeacherCourseDetail createState() => _TeacherCourseDetail(courseid,coursename);
}

class _TeacherCourseDetail extends State<TeacherCourseDetail> {
  int pageIndex = 0;
  String? courseid;
  String? coursename;
  _TeacherCourseDetail(this.courseid, this.coursename)
      : pages = [
          AllStudents(courseid: courseid, coursename:coursename),
          AllAttendance(courseid: courseid, coursename:coursename),
          const Profile(),
        ];
  final List<Widget> pages;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        leading: Builder(
          builder: (context) => // Ensure Scaffold is in context
              IconButton(
            icon: const Icon(Icons.menu),
            color: Theme.of(context).primaryColor,
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          "Course: ${coursename}",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      drawer: DrawerWidget(),
      body: pages[pageIndex],
      bottomNavigationBar: buildMyNavBar(context),
    );
  }

  Container buildMyNavBar(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 0;
              });
            },
            icon: pageIndex == 0
                ? const Icon(
                    Icons.people_alt,
                    color: Colors.white,
                    size: 35,
                  )
                : const Icon(
                    Icons.people_alt_outlined,
                    color: Colors.white,
                    size: 35,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 1;
              });
            },
            icon: pageIndex == 1
                ? const Icon(
                    Icons.school_rounded,
                    color: Colors.white,
                    size: 35,
                  )
                : const Icon(
                    Icons.school_outlined,
                    color: Colors.white,
                    size: 35,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 2;
              });
            },
            icon: pageIndex == 2
                ? const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 35,
                  )
                : const Icon(
                    Icons.person_outline,
                    color: Colors.white,
                    size: 35,
                  ),
          ),
        ],
      ),
    );
  }
}
