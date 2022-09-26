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

class OtpConfirmation extends StatefulWidget {
  @override
  _OtpConfirmationState createState() => _OtpConfirmationState();
}

enum LoginType { teacher, student }

class _OtpConfirmationState extends State<OtpConfirmation> {
  final formKey = GlobalKey<FormState>();
  OtpFieldController otpController = OtpFieldController();

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          children: <Widget>[
            HeaderContainer("Login"),
            SizedBox(height: 30),
            Text(
              "Confirm the Code",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Enter 6 digits code to reset your password",
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
                          print("Changed: " + pin);
                        },
                        onCompleted: (pin) {
                          print("Completed: " + pin);
                        },
                      ),
                      Expanded(
                        child: Center(
                          child: auth.loggedInStatus == Status.authenticating
                              ? loading
                              : ButtonWidget(
                                  onClick: () {
                                    //doLogin();
                                    Navigator.pushNamed(
                                        context, '/resetpassword');
                                  },
                                  btnText: "CONFIRM OTP",
                                ),
                        ),
                      ),
                      RichText(
                        text: TextSpan(children: [
                          const TextSpan(
                              text: "Didn't recieve the code? ",
                              style: TextStyle(color: Colors.black)),
                          TextSpan(
                            text: "Resend",
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
