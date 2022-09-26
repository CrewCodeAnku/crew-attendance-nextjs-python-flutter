import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/gestures.dart';
import 'package:crew_attendance/ui/pages/register.dart';
import 'package:crew_attendance/util/color.dart';
import 'package:crew_attendance/util/validators.dart';
import 'package:crew_attendance/util/widgets.dart';
import 'package:crew_attendance/core/models/user.dart';
import 'package:crew_attendance/core/providers/auth_provider.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import 'package:crew_attendance/core/providers/user_provider.dart';
import 'package:crew_attendance/ui/widgets/btn_widget.dart';
import 'package:crew_attendance/ui/widgets/head_component.dart';
import 'package:crew_attendance/util/shared_preference.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

enum LoginType { teacher, student }

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final formKey = GlobalKey<FormState>();
  OtpFieldController otpController = OtpFieldController();
  String otp = "";
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  LoginType? _character = LoginType.teacher;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    sendEmail() async {
      var email = await UserPreferences().getEmail();
      final Future successfulMessage = auth.forgetPassword(email!);

      successfulMessage.then((response) {
        if (response['status']) {
          Flushbar(
            title: "Otp sent!",
            message: response['message'].toString(),
            duration: const Duration(seconds: 3),
          ).show(context);
          //Navigator.pushNamed(context, '/resetpassword');
        } else {
          Flushbar(
            title: "Failed",
            message: response['message'].toString(),
            duration: const Duration(seconds: 3),
          ).show(context);
        }
      });
    }

    resetPassword() async {
      var email = await UserPreferences().getEmail();
      final form = formKey.currentState;
      if (form!.validate()) {
        form.save();
        final Future<Map<String, dynamic>> successfulMessage =
            auth.resetPassword(email!, otp, passwordController.text);

        successfulMessage.then((response) {
          if (response['status']) {
            Navigator.pushReplacementNamed(context, '/login');
          } else {
            Flushbar(
              title: "Failed Reset",
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
            HeaderContainer("Reset Password"),
            SizedBox(height: 30),
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        "Enter 5 digits code to send to your email",
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(height: 10),
                      OTPTextField(
                        controller: otpController,
                        length: 5,
                        width: MediaQuery.of(context).size.width,
                        textFieldAlignment: MainAxisAlignment.spaceAround,
                        fieldWidth: 45,
                        fieldStyle: FieldStyle.box,
                        outlineBorderRadius: 15,
                        style: TextStyle(fontSize: 17),
                        onChanged: (pin) {
                          setState(() {
                            otp = pin;
                          });
                          print("Changed: " + pin);
                        },
                        onCompleted: (pin) {
                          print("Completed: " + pin);
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Enter your new password",
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(height: 10),
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
                                  onClick: () {
                                    resetPassword();
                                    //Navigator.pushNamed(context, '/dashboard');
                                  },
                                  btnText: "RESET PASSWORD",
                                ),
                        ),
                      ),
                      RichText(
                        text: TextSpan(children: [
                          const TextSpan(
                              text: "Otp expired or Didn't recieve the otp!",
                              style: TextStyle(color: Colors.black)),
                          TextSpan(
                            text: "Resend",
                            style: TextStyle(color: orangeColors),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => sendEmail(),
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
      Text(" Processing ... Please wait")
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
