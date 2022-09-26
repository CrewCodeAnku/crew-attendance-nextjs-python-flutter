import 'package:crew_attendance/ui/pages/teacher/teacherCourse.dart';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:crew_attendance/util/validators.dart';
import 'package:crew_attendance/util/widgets.dart';
import 'package:provider/provider.dart';
import 'package:crew_attendance/core/providers/teacher_provider.dart';
import 'package:crew_attendance/ui/widgets/btn_widget.dart';

class CreateCourse extends StatefulWidget {
  @override
  _CreateCourseState createState() => _CreateCourseState();
}

class _CreateCourseState extends State<CreateCourse> {
  final formKey = GlobalKey<FormState>();
  final courseNameController = TextEditingController();
  final courseShortNameController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TeacherCoursesProvider teacher =
        Provider.of<TeacherCoursesProvider>(context);
    createCourse() {
      final form = formKey.currentState;
      if (form!.validate()) {
        form.save();
        final Future<Map<String, dynamic>> successfulMessage =
            teacher.createCourse(
                courseNameController.text,
                courseShortNameController.text,
                startDateController.text,
                endDateController.text);

        successfulMessage.then((response) {
          if (response['status']) {
            Flushbar(
              title: "Course created",
              message: response['message'].toString(),
              duration: const Duration(seconds: 3),
            ).show(context);
            courseNameController.clear();
            courseShortNameController.clear();
            startDateController.clear();
            endDateController.clear();
            Navigator.pushNamed(context, '/dashboard');
          } else {
            Flushbar(
              title: "Failed creation",
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
              MaterialPageRoute(builder: (context) => const TeacherCourse()),
            ),
          ),
        ),
        title: Text(
          "Create Course",
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
                          hint: "Enter course name",
                          autofocus: false,
                          obscuretext: false,
                          controller: courseNameController,
                          icon: Icons.grade,
                          validator: validateCourseName),
                      _textInput(
                          hint: "Enter course short name",
                          autofocus: false,
                          obscuretext: false,
                          controller: courseShortNameController,
                          icon: Icons.grade,
                          validator: validateCourseShortName),
                      _textInput(
                          hint: "Select course start date",
                          autofocus: false,
                          obscuretext: false,
                          controller: startDateController,
                          icon: Icons.date_range,
                          validator: validateCourseStartDate,
                          onTap: () async {
                            DateTime? date = DateTime(1900);
                            FocusScope.of(context).requestFocus(FocusNode());
                            date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100));
                            if (date != null) {
                              startDateController.text = date.toIso8601String();
                            }
                          }),
                      _textInput(
                          hint: "Select course end date",
                          autofocus: false,
                          obscuretext: false,
                          controller: endDateController,
                          icon: Icons.date_range,
                          validator: validateCourseEndDate,
                          onTap: () async {
                            DateTime? date = DateTime(1900);
                            FocusScope.of(context).requestFocus(FocusNode());
                            date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100));
                            if (date != null) {
                              endDateController.text = date.toIso8601String();
                            }
                          }),
                      Container(
                        margin: const EdgeInsets.all(20.0),
                        child: Center(
                          child: teacher.requestStatus == Status.sendRequesting
                              ? loading
                              : ButtonWidget(
                                  onClick: () {
                                    createCourse();
                                    //Navigator.pushNamed(context, '/dashboard');
                                  },
                                  btnText: "Create Course",
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
      Text(" Creating ... Please wait")
    ],
  );

  Widget _textInput(
      {controller, hint, autofocus, obscuretext, icon, validator, onTap}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(left: 10),
      child: TextFormField(
        autofocus: autofocus,
        obscureText: obscuretext,
        controller: controller,
        validator: validator,
        onTap: onTap,
        decoration: buildInputDecoration(
          hintText: hint,
          icon: icon,
        ),
      ),
    );
  }
}
