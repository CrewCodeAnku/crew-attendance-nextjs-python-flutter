import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:crew_attendance/util/color.dart';
import 'package:crew_attendance/ui/widgets/btn_widget.dart';
import 'package:crew_attendance/ui/widgets/head_component.dart';
import 'package:crew_attendance/util/validators.dart';
import 'package:crew_attendance/util/widgets.dart';
import 'package:crew_attendance/core/models/user.dart';
import 'package:crew_attendance/core/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:crew_attendance/core/providers/user_provider.dart';
//import 'package:flutter/gestures.dart';
//import 'package:crew_attendance/pages/login.dart';

class RegPage extends StatefulWidget {
  @override
  _RegPageState createState() => _RegPageState();
}

enum LoginType { teacher, student }

class _RegPageState extends State<RegPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  LoginType? _character = LoginType.teacher;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    doRegister() {
      final form = formKey.currentState;
      if (form!.validate()) {
        form.save();
        final Future<Map<String, dynamic>> successfulMessage = auth.register(
            emailController.text,
            nameController.text,
            passwordController.text,
            _character == LoginType.teacher ? "teacher" : "student");

        successfulMessage.then((response) {
          if (response['status']) {
            User user = response['data'];
            Provider.of<UserProvider>(context, listen: false).setUser(user);
            Flushbar(
              title: "Registration Successful",
              message: response['message'].toString(),
              duration: const Duration(seconds: 3),
            ).show(context);
            nameController.clear();
            emailController.clear();
            passwordController.clear();
            //Navigator.pushReplacementNamed(context, '/login');
          } else {
            Flushbar(
              title: "Failed Registration",
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
      body: Container(
        padding: EdgeInsets.only(bottom: 30),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              HeaderContainer("Register"),
              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Row(children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: RadioListTile(
                              title: const Text("Student"),
                              value: LoginType.student,
                              groupValue: _character,
                              onChanged: (LoginType? value) {
                                setState(() {
                                  _character = value;
                                });
                              },
                            )),
                        Expanded(
                            flex: 1,
                            child: RadioListTile(
                              title: const Text('Teacher'),
                              value: LoginType.teacher,
                              groupValue: _character,
                              onChanged: (LoginType? value) {
                                setState(() {
                                  _character = value;
                                });
                              },
                            )),
                      ]),
                      _textInput(
                          hint: "Fullname",
                          autofocus: false,
                          obscuretext: false,
                          controller: nameController,
                          icon: Icons.person,
                          validator: validateName),
                      _textInput(
                          hint: "Email",
                          autofocus: false,
                          obscuretext: false,
                          controller: emailController,
                          icon: Icons.email,
                          validator: validateEmail),
                      _textInput(
                          hint: "Password",
                          autofocus: false,
                          obscuretext: true,
                          controller: passwordController,
                          icon: Icons.vpn_key,
                          validator: validatePassword),
                      Expanded(
                        child: Center(
                          child: auth.requestStatus == Status.sendRequesting
                              ? loading
                              : ButtonWidget(
                                  btnText: "REGISTER",
                                  onClick: () {
                                    doRegister();
                                  },
                                ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, "/login"),
                        child: RichText(
                          text: TextSpan(children: [
                            const TextSpan(
                                text: "Already a member ? ",
                                style: TextStyle(color: Colors.black)),
                            TextSpan(
                              text: "Login",
                              style: TextStyle(color: orangeColors),
                            ),
                          ]),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  var loading = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const <Widget>[
      CircularProgressIndicator(),
      Text("Registering ... Please wait")
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
