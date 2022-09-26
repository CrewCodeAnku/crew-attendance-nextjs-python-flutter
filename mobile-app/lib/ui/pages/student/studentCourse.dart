import 'package:crew_attendance/ui/pages/login.dart';
import 'package:crew_attendance/ui/pages/student/enrollCourse.dart';
import 'package:flutter/material.dart';
import 'package:crew_attendance/ui/widgets/students/courses.dart';
import 'package:crew_attendance/ui/widgets/drawer.dart';
import 'package:crew_attendance/core/providers/student_provider.dart';
import 'package:provider/provider.dart';

class StudentCourse extends StatefulWidget {
  const StudentCourse({Key? key}) : super(key: key);

  @override
  _StudentCourseState createState() => _StudentCourseState();
}

class _StudentCourseState extends State<StudentCourse> {
  // ignore: prefer_typing_uninitialized_variables
  late final courseFuture;
  late final StudentCoursesProvider course;
  bool isInitialised = false;
  String teacherName = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitialised) {
      course = Provider.of<StudentCoursesProvider>(context);
      courseFuture = course.fetchCourses();
      isInitialised = true;
    }
  }

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<StudentCoursesProvider>(context, listen: false)
        .fetchCourses();
  }

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
          "Crew Attendance",
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
      body: FutureBuilder(
          future: courseFuture,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            }
            return RefreshIndicator(
              onRefresh: () => _refreshProducts(context),
              child: Consumer<StudentCoursesProvider>(
                builder: (ctx, productsData, _) => Padding(
                  padding: const EdgeInsets.all(8),
                  child: ListView.builder(
                    itemCount: productsData.result.length,
                    itemBuilder: (_, i) => Column(
                      children: [
                        StudentCoursesWidget(
                          productsData.result[i].id,
                          productsData.result[i].courseName,
                          productsData.result[i].courseShortName,
                          productsData.result[i].courseStartDate,
                          productsData.result[i].courseEndDate,
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
            MaterialPageRoute(builder: (context) => EnrollCourse()),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
