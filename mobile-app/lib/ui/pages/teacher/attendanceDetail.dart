import 'package:crew_attendance/ui/pages/teacher/teacherCourseDetail.dart';
import 'package:crew_attendance/ui/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:crew_attendance/ui/widgets/attendance_image.dart';


class AttendanceDetail extends StatefulWidget {
  final String? courseid;
  final String? coursename;

  const AttendanceDetail({super.key, this.courseid, this.coursename});

  @override
  _AttendanceDetail createState() => _AttendanceDetail();
}

class _AttendanceDetail extends State<AttendanceDetail> {
  String? courseid;
  String? coursename;

  _AttendanceDetail({this.courseid, this.coursename});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        leading: Builder(
          builder: (context) => // Ensure Scaffold is in context
          IconButton(
            icon: const Icon(Icons.arrow_back_sharp),
            color: Theme.of(context).primaryColor,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TeacherCourseDetail(),
              ),
            ),
          ),
        ),
        title: Text(
          "Attendance Detail",
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
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 70,
            child: Card(
              elevation: 2.0,
              margin:
              const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(children: const [Text('Total'), Text('13')]),
                  Column(
                    children: const [Text('Participants'), Text('11')],
                  ),
                  Column(
                    children: const [Text('Absent'), Text('2')],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          AttendanceImage(
            image:"",
            onFileChanged: (imageUrl) {
              print(imageUrl);
            },
          ),
          Expanded(
            flex: 2,
            child: Container(
              child: ListView.builder(
                itemCount: 5,
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
                          leading: const CircleAvatar(
                            backgroundColor: Colors.cyan,
                            child: Text("A"),
                          ),
                          title: const Text(' Anku Singh'),
                          trailing: Checkbox(
                            value: false,
                            onChanged: (val) {
                              // ignore: avoid_print
                              print(val);
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
