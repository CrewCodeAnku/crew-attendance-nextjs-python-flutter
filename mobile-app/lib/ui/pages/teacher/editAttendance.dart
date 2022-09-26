import 'package:another_flushbar/flushbar.dart';
//import 'package:crew_attendance/core/models/student.dart';
import 'package:crew_attendance/core/providers/teacher_provider.dart';
import 'package:crew_attendance/ui/pages/teacher/teacherCourseDetail.dart';
import 'package:crew_attendance/ui/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:crew_attendance/ui/widgets/attendance_image.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class EditAttendance extends StatefulWidget {
  String? attendanceId;
  final String? courseId;
  final String? courseName;
  final List? studentParticipated;

  EditAttendance({super.key, this.attendanceId,this.courseId, this.courseName, this.studentParticipated});

  @override
  _EditAttendance createState() => _EditAttendance(attendanceId, courseId, courseName, studentParticipated);
}

class _EditAttendance extends State<EditAttendance> {
  String? attendanceId;
  String? courseId;
  String? courseName;
  List? studentParticipated;
  List selectedStudent = <String>[];

  _EditAttendance(this.attendanceId,this.courseId, this.courseName, this.studentParticipated);

  @override
  void initState() {
    super.initState();
    selectedStudent = studentParticipated?.map((student)=>student['id']).toList()??[];
  }

  @override
  Widget build(BuildContext context) {
    TeacherCoursesProvider teacherProvider =
    Provider.of<TeacherCoursesProvider>(context);
    final List studentlist = teacherProvider.studentresult;
    editAttendance() async {
      await EasyLoading.show(
        status: 'Updating...',
        maskType: EasyLoadingMaskType.black,
      );
      var present = selectedStudent.length.toString();
      var absent = (studentlist.length - selectedStudent.length).toString();
      final Future<Map<String, dynamic>> successfulMessage = teacherProvider
          .editAttendance(attendanceId!,present, absent, selectedStudent, courseId!);
      successfulMessage.then((response) async {
        await EasyLoading.dismiss();
        if (response['status']) {
          Navigator.of(context).pop();
        }else{
          Flushbar(
            title: "Failed Updation",
            message: response['message'].toString(),
            duration: const Duration(seconds: 3),
          ).show(context);
        }
      });
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        leading: Builder(
          builder: (context) => // Ensure Scaffold is in context
          IconButton(
            icon: const Icon(Icons.arrow_back_sharp),
            color: Theme.of(context).primaryColor,
            onPressed: () => Navigator.of(context).pop()
          ),
        ),
        title: Text(
          "Edit Attendance",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save_rounded),
            color: Theme.of(context).primaryColor,
            tooltip: 'Save Attendance',
            onPressed: () {
              editAttendance();
            },
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      drawer: DrawerWidget(),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 10),
          SizedBox(
            height: 100,
            child: Card(
              elevation: 2.0,
              margin:
              const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          studentlist.length.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Present',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          selectedStudent.length.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightGreen,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Absent',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          (studentlist.length - selectedStudent.length)
                              .toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          AttendanceImage(
            image: "",
            onFileChanged: (imageUrl) {
              print(imageUrl);
            },
          ),
          Expanded(
            flex: 2,
            child: Container(
              child: ListView.builder(
                itemCount: studentlist.length,
                padding: const EdgeInsets.only(top: 10.0),
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2.0,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 6.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: studentlist[index].profile_picture != ""
                              ? CircleAvatar(
                            radius: 18.0,
                            backgroundImage: NetworkImage(
                                studentlist[index].profile_picture),
                            backgroundColor: Colors.transparent,
                          )
                              : CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            child: Text(
                                studentlist[index].name[0].toUpperCase()),
                          ),
                          title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  studentlist[index].name,
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  studentlist[index].email,
                                  style: TextStyle(color: Colors.grey),
                                )
                              ]),
                          trailing: Checkbox(
                            value:
                            selectedStudent.contains(studentlist[index].id),
                            onChanged: (selected) {
                              if (selected == true) {
                                setState(() =>
                                    selectedStudent.add(studentlist[index].id));
                              } else {
                                setState(() => selectedStudent
                                    .remove(studentlist[index].id));
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
