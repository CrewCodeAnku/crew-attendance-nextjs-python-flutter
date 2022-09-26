import 'package:flutter/material.dart';
import 'package:crew_attendance/ui/pages/teacher/teacherCourseDetail.dart';

class StudentListingWidget extends StatelessWidget {
  final String? id;
  final String? name;
  final String? profile_picture;
  final String? email;

  StudentListingWidget(this.id, this.name, this.profile_picture,
      this.email);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      constraints:
          const BoxConstraints(minHeight: 90, minWidth: double.infinity),
      child: Card(
        elevation: 2.0,
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
  backgroundImage: NetworkImage(profile_picture!), // no matter how big it is, it won't overflow
),
              title: Text(
                  name!,
                  style: TextStyle(fontSize: 20),
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
                  email!,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
