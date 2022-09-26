import 'package:crew_attendance/ui/pages/student/studentCourse.dart';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:crew_attendance/util/validators.dart';
import 'package:crew_attendance/util/widgets.dart';
import 'package:provider/provider.dart';
import 'package:crew_attendance/ui/widgets/btn_widget.dart';

import '../../../core/providers/student_provider.dart';

class EnrollCourse extends StatefulWidget {
  @override
  _EnrollCourseState createState() => _EnrollCourseState();
}

class _EnrollCourseState extends State<EnrollCourse> {
  final formKey = GlobalKey<FormState>();
  final courseCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    StudentCoursesProvider student =
        Provider.of<StudentCoursesProvider>(context);
    enrollCourse() {
      final form = formKey.currentState;
      if (form!.validate()) {
        form.save();
        final Future<Map<String, dynamic>> successfulMessage =
            student.enrollCourse(courseCodeController.text);

        successfulMessage.then((response) {
          if (response['status']) {
            Flushbar(
              title: "Enroll successful!",
              message: response['message'].toString(),
              duration: const Duration(seconds: 3),
            ).show(context);
            courseCodeController.clear();
            Navigator.pushNamed(context, '/studentdashboard');
          } else {
            Flushbar(
              title: "Failed enrolling",
              message: response['message'].toString(),
              duration: const Duration(seconds: 3),
            ).show(context);
          }
        });
      } else {
        print("form is invalid");
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => // Ensure Scaffold is in context
              IconButton(
            icon: const Icon(Icons.arrow_back_sharp),
            color: Theme.of(context).primaryColor,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const StudentCourse()),
            ),
          ),
        ),
        title: Text(
          "Course Enrollment",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      _textInput(
                          hint: "Enter course code",
                          autofocus: false,
                          obscuretext: false,
                          controller: courseCodeController,
                          icon: Icons.grade,
                          validator: validateCourseCode),
                      Container(
                        margin: const EdgeInsets.all(20.0),
                        child: Center(
                          child: student.requestStatus == Status.sendRequesting
                              ? loading
                              : ButtonWidget(
                                  onClick: () {
                                    enrollCourse();
                                    //Navigator.pushNamed(context, '/dashboard');
                                  },
                                  btnText: "Enroll In Course",
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  var loading = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const <Widget>[
      CircularProgressIndicator(),
      Text(" Enrolling ... Please wait")
    ],
  );

  Widget _textInput(
      {controller, hint, autofocus, obscuretext, icon, validator}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(left: 10),
      child: TextFormField(
        autofocus: autofocus,
        obscureText: obscuretext,
        controller: controller,
        validator: validator,
        decoration: buildInputDecoration(
          hintText: hint,
          icon: icon,
        ),
      ),
    );
  }
}
