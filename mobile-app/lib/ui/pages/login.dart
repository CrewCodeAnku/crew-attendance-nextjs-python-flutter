import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/gestures.dart';
import 'package:crew_attendance/ui/pages/register.dart';
import 'package:crew_attendance/util/color.dart';
import 'package:crew_attendance/util/validators.dart';
import 'package:crew_attendance/util/widgets.dart';
import 'package:crew_attendance/core/models/user.dart';
import 'package:crew_attendance/core/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:crew_attendance/core/providers/user_provider.dart';
import 'package:crew_attendance/ui/widgets/btn_widget.dart';
import 'package:crew_attendance/ui/widgets/head_component.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

enum LoginType { teacher, student }

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  LoginType? _character = LoginType.teacher;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    doLogin() {
      final form = formKey.currentState;
      if (form!.validate()) {
        form.save();
        final Future<Map<String, dynamic>> successfulMessage = auth.login(
            emailController.text,
            passwordController.text,
            _character == LoginType.teacher ? "teacher" : "student");

        successfulMessage.then((response) {
          if (response['status']) {
            User user = response['user'];
            Provider.of<UserProvider>(context, listen: false).setUser(user);
            if (_character == LoginType.teacher) {
              Navigator.pushNamed(context, '/dashboard');
            } else {
              Navigator.pushNamed(context, '/studentdashboard');
            }
          } else {
            if (response['error_code'] == "email_not_verified") {
              Navigator.pushNamed(context, '/verifyemail');
            } else {
              Flushbar(
                title: "Failed Login",
                message: response['message'].toString(),
                duration: const Duration(seconds: 3),
              ).show(context);
            }
          }
        });
      } else {
        print("form is invalid");
      }
    }

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          children: <Widget>[
            HeaderContainer("Login"),
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
                child: Form(
                  key: formKey,
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
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/forgetpass");
                          },
                          child: const Text(
                            "Forgot Password?",
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: auth.loggedInStatus == Status.authenticating
                              ? loading
                              : ButtonWidget(
                                  onClick: () {
                                    doLogin();
                                  },
                                  btnText: "LOGIN",
                                ),
                        ),
                      ),
                      RichText(
                        text: TextSpan(children: [
                          const TextSpan(
                              text: "Don't have an account ? ",
                              style: TextStyle(color: Colors.black)),
                          TextSpan(
                            text: "Register",
                            style: TextStyle(color: orangeColors),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegPage())),
                          ),
                        ]),
                      )
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
      Text(" Authenticating ... Please wait")
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
