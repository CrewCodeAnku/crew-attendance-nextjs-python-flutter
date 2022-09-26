import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/gestures.dart';
import 'package:crew_attendance/ui/pages/login.dart';
import 'package:crew_attendance/util/color.dart';
import 'package:crew_attendance/util/validators.dart';
import 'package:crew_attendance/util/widgets.dart';
import 'package:crew_attendance/core/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:crew_attendance/ui/widgets/btn_widget.dart';
import 'package:crew_attendance/ui/widgets/head_component.dart';
import 'package:crew_attendance/util/shared_preference.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    sendEmail() {
      final form = formKey.currentState;

      if (form!.validate()) {
        form.save();
        final Future successfulMessage =
            auth.forgetPassword(emailController.text);

        successfulMessage.then((response) {
          if (response['status']) {
            Flushbar(
              title: "Email Sent",
              message: response['message'].toString(),
              duration: const Duration(seconds: 3),
            ).show(context);
            Navigator.pushNamed(context, '/resetpassword');
          } else {
            Flushbar(
              title: "Failed",
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
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          children: <Widget>[
            HeaderContainer("Forget Password"),
            SingleChildScrollView(
              child: Container(
                height: 200,
                margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      _textInput(
                          hint: "Email",
                          autofocus: false,
                          obscuretext: false,
                          controller: emailController,
                          icon: Icons.email,
                          validator: validateEmail),
                      Expanded(
                        child: Center(
                          child: auth.requestStatus == Status.sendRequesting
                              ? loading
                              : ButtonWidget(
                                  onClick: () {
                                    //Navigator.pushNamed(context, '/otpscreen');
                                    UserPreferences()
                                        .saveEmail(emailController.text);
                                    sendEmail();
                                  },
                                  btnText: "SEND EMAIL",
                                ),
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                                text: "Remember your password? ",
                                style: TextStyle(color: Colors.black)),
                            TextSpan(
                              text: "Login",
                              style: TextStyle(color: orangeColors),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoginPage(),
                                      ),
                                    ),
                            ),
                          ],
                        ),
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
      Text(" Sending Email ... Please wait")
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
