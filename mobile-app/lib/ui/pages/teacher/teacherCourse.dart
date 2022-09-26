import 'package:flutter/material.dart';
import 'package:crew_attendance/ui/widgets/teachers/courses.dart';
import 'package:crew_attendance/ui/widgets/drawer.dart';
import 'package:crew_attendance/core/providers/teacher_provider.dart';
import 'package:provider/provider.dart';
import 'package:crew_attendance/ui/pages/teacher/createCourse.dart';

class TeacherCourse extends StatefulWidget {
  const TeacherCourse({Key? key}) : super(key: key);

  @override
  _TeacherCourseState createState() => _TeacherCourseState();
}

class _TeacherCourseState extends State<TeacherCourse> {
  // ignore: prefer_typing_uninitialized_variables
  late final courseFuture;
  late final TeacherCoursesProvider course;
  bool isInitialised = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitialised) {
      course = Provider.of<TeacherCoursesProvider>(context);
      courseFuture = course.fetchCourses();
      isInitialised = true;
    }
  }

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<TeacherCoursesProvider>(context, listen: false)
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
              /*Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );*/
            }
            return RefreshIndicator(
              onRefresh: () => _refreshProducts(context),
              child: Consumer<TeacherCoursesProvider>(
                builder: (ctx, productsData, _) => Padding(
                  padding: const EdgeInsets.all(8),
                  child: ListView.builder(
                    itemCount: productsData.result.length,
                    itemBuilder: (_, i) => Column(
                      children: [
                        TeacherCoursesWidget(
                            productsData.result[i].id,
                            productsData.result[i].courseName,
                            productsData.result[i].courseShortName,
                            productsData.result[i].courseStartDate,
                            productsData.result[i].courseEndDate),
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
            MaterialPageRoute(builder: (context) => CreateCourse()),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
