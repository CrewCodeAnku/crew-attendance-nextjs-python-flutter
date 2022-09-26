import 'package:another_flushbar/flushbar.dart';
import 'package:crew_attendance/util/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:crew_attendance/ui/pages/register.dart';
import 'package:crew_attendance/util/color.dart';
import 'package:crew_attendance/util/widgets.dart';
import 'package:crew_attendance/core/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:crew_attendance/ui/widgets/btn_widget.dart';
import 'package:crew_attendance/ui/widgets/head_component.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class EmailVerify extends StatefulWidget {
  @override
  _EmailVerifyState createState() => _EmailVerifyState();
}

enum LoginType { teacher, student }

class _EmailVerifyState extends State<EmailVerify> {
  final formKey = GlobalKey<FormState>();
  OtpFieldController otpController = OtpFieldController();
  String otp = "";

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    doverify() async {
      var email = await UserPreferences().getEmail();
      if (email != "" && otp != "") {
        final Future<Map<String, dynamic>> successfulMessage =
            auth.verifyEmail(otp, email!);
        successfulMessage.then((response) {
          if (response['status']) {
            Flushbar(
              title: "Verification Success",
              message: response['message'].toString(),
              duration: const Duration(seconds: 3),
            ).show(context);
            Navigator.pushNamed(context, '/login');
          } else {
            Flushbar(
              title: "Failed Verification",
              message: response['message'].toString(),
              duration: const Duration(seconds: 3),
            ).show(context);
          }
        });
      } else {
        Flushbar(
          title: "Validation",
          message: "Enter otp",
          duration: const Duration(seconds: 3),
        ).show(context);
      }
    }

    resendEmail() async {
      var email = await UserPreferences().getEmail();
      if (email != "") {
        final Future<Map<String, dynamic>> successfulMessage =
            auth.resendEmail(email!);
        successfulMessage.then((response) {
          if (response['status']) {
            Flushbar(
              title: "Sent Successful",
              message: response['message'].toString(),
              duration: const Duration(seconds: 3),
            ).show(context);
            //Navigator.pushNamed(context, '/login');
          } else {
            Flushbar(
              title: "Failed Sending",
              message: response['message'].toString(),
              duration: const Duration(seconds: 3),
            ).show(context);
          }
        });
      } else {
        Flushbar(
          title: "Validation",
          message: "Enter otp",
          duration: const Duration(seconds: 3),
        ).show(context);
      }
    }

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          children: <Widget>[
            HeaderContainer("Login"),
            SizedBox(height: 30),
            Text(
              "Verify your email",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Enter 6 digits code to send to your email",
              style: TextStyle(fontSize: 12),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
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
                      Expanded(
                        child: Center(
                          child: auth.requestStatus == Status.sendRequesting
                              ? loading
                              : ButtonWidget(
                                  onClick: () {
                                    doverify();
                                  },
                                  btnText: "VERIFY",
                                ),
                        ),
                      ),
                      RichText(
                        text: TextSpan(children: [
                          const TextSpan(
                              text: "Didn't recieve the code or otp expired? ",
                              style: TextStyle(color: Colors.black)),
                          TextSpan(
                            text: "Resend",
                            style: TextStyle(color: orangeColors),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => resendEmail(),
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
