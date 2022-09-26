import 'package:crew_attendance/ui/pages/teacher/createAttendance.dart';
import 'package:flutter/material.dart';
//import 'package:crew_attendance/ui/widgets/teachers/studentListing.dart';
import 'package:crew_attendance/core/providers/teacher_provider.dart';
import 'package:provider/provider.dart';

import '../../widgets/teachers/attendanceListing.dart';

class AllAttendance extends StatefulWidget {
  final String? courseid;
  final String? coursename;
  const AllAttendance({super.key, this.courseid, this.coursename});

  @override
  _AllAttendanceState createState() =>
      _AllAttendanceState(courseid, coursename);
}

class _AllAttendanceState extends State<AllAttendance> {
  // ignore: prefer_typing_uninitialized_variables
  late final attendanceFuture;
  late final TeacherCoursesProvider attendance;
  bool isInitialised = false;
  String? courseid;
  String? coursename;
  _AllAttendanceState(this.courseid, this.coursename);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitialised) {
      attendance = Provider.of<TeacherCoursesProvider>(context);
      attendanceFuture = attendance.fetchAttendance(courseid);
      isInitialised = true;
    }
  }

  Future<void> _refreshAttendance(BuildContext context) async {
    await Provider.of<TeacherCoursesProvider>(context, listen: false)
        .fetchAttendance(courseid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: FutureBuilder(
          future: attendanceFuture,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              /*Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );*/
            }
            return RefreshIndicator(
              onRefresh: () => _refreshAttendance(context),
              child: Consumer<TeacherCoursesProvider>(
                builder: (ctx, productsData, _) => Padding(
                  padding: const EdgeInsets.all(8),
                  child: ListView.builder(
                    itemCount: productsData.attendanceresult.length,
                    itemBuilder: (_, i) => Column(
                      children: [
                        AttendanceListingWidget(
                            courseid,
                            coursename,
                            productsData.attendanceresult[i].id,
                            productsData.attendanceresult[i].attendanceDate,
                            productsData.attendanceresult[i].classImage,
                          productsData.attendanceresult[i].studentParticipated,
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreateAttendance(
                    courseId: courseid, courseName: coursename)),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
