import 'package:flutter/material.dart';
import 'package:crew_attendance/ui/widgets/teachers/studentListing.dart';
import 'package:crew_attendance/ui/widgets/drawer.dart';
import 'package:crew_attendance/core/providers/teacher_provider.dart';
import 'package:provider/provider.dart';
import 'package:crew_attendance/ui/pages/teacher/createCourse.dart';

class AllStudents extends StatefulWidget {
  final String? courseid;
  final String? coursename;
  const AllStudents({super.key, this.courseid, this.coursename});

  @override
  _AllStudentsState createState() => _AllStudentsState(courseid, coursename);
}

class _AllStudentsState extends State<AllStudents> {
  // ignore: prefer_typing_uninitialized_variables
  late final studentFuture;
  late final TeacherCoursesProvider student;
  bool isInitialised = false;
  String? courseid;
  String? coursename;
  _AllStudentsState(this.courseid, this.coursename);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitialised) {
      student = Provider.of<TeacherCoursesProvider>(context);
      studentFuture = student.fetchStudents(courseid);
      isInitialised = true;
    }
  }

  Future<void> _refreshStudents(BuildContext context) async {
    await Provider.of<TeacherCoursesProvider>(context, listen: false)
        .fetchStudents(courseid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: FutureBuilder(
          future: studentFuture,
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
              onRefresh: () => _refreshStudents(context),
              child: Consumer<TeacherCoursesProvider>(
                builder: (ctx, productsData, _) => Padding(
                  padding: const EdgeInsets.all(8),
                  child: ListView.builder(
                    itemCount: productsData.studentresult.length,
                    itemBuilder: (_, i) => Column(
                      children: [
                        StudentListingWidget(
                            productsData.studentresult[i].id,
                            productsData.studentresult[i].name,
                            productsData.studentresult[i].profile_picture,
                            productsData.studentresult[i].email
                            ),
                        const Divider(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
