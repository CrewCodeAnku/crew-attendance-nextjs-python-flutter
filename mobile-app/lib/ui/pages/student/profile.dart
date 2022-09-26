import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:crew_attendance/util/validators.dart';
import 'package:crew_attendance/util/widgets.dart';
import 'package:crew_attendance/ui/widgets/drawer.dart';
import 'package:crew_attendance/util/shared_preference.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../core/providers/auth_provider.dart';
import '../../widgets/btn_widget.dart';
import '../../widgets/user_image.dart';

class ProfileStudentPage extends StatefulWidget {
  @override
  _ProfileStudentPageState createState() => _ProfileStudentPageState();
}

class _ProfileStudentPageState extends State<ProfileStudentPage> {
  final formKey = GlobalKey<FormState>();
  final formKey1 = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String? username = "";
  String? useremail = "";

  String capitalize(s) {
    if (s != "") {
      return "${s[0].toUpperCase()}${s[1].toUpperCase()}";
    } else {
      return "";
    }
  }

  getUserDetail() async {
    var name = await UserPreferences().getUserName();
    var email = await UserPreferences().getEmail();
    setState(() {
      username = name;
    });
    setState(() {
      useremail = email;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserDetail();
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    doUpdateName() async {
      final form = formKey.currentState;
      if (form!.validate()) {
        form.save();
        await EasyLoading.show(
          status: 'Updating...',
          maskType: EasyLoadingMaskType.black,
        );
        final Future<Map<String, dynamic>> successfulMessage =
            auth.updateName(nameController.text);
        successfulMessage.then(
          (response) async {
            await EasyLoading.dismiss();
            if (response['status']) {
              await UserPreferences().setUserName(nameController.text);
              setState(() {
                username = nameController.text;
              });
              Flushbar(
                title: "Update success",
                message: response['message'].toString(),
                duration: const Duration(seconds: 3),
              ).show(context);
              //Navigator.pop(context);
              nameController.clear();
            } else {
              Flushbar(
                title: "Update failure",
                message: response['message'].toString(),
                duration: const Duration(seconds: 3),
              ).show(context);
            }
          },
        );
      }
    }

    doUpdatePassword() async {
      final form = formKey1.currentState;
      if (form!.validate()) {
        form.save();
        await EasyLoading.show(
          status: 'Updating...',
          maskType: EasyLoadingMaskType.black,
        );
        final Future<Map<String, dynamic>> successfulMessage =
            auth.updatePassword(passwordController.text);
        successfulMessage.then(
          (response) async {
            await EasyLoading.dismiss();
            if (response['status']) {
              Flushbar(
                title: "Update Success",
                message: response['message'].toString(),
                duration: const Duration(seconds: 3),
              ).show(context);
              //Navigator.pop(context);
              passwordController.clear();
            } else {
              Flushbar(
                title: "Update failure",
                message: response['message'].toString(),
                duration: const Duration(seconds: 3),
              ).show(context);
            }
          },
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => // Ensure Scaffold is in context
              IconButton(
            icon: const Icon(Icons.menu),
            color: Theme.of(context).primaryColor,
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          "Profile",
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
      body: Container(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 100,
              child: Card(
                elevation: 2.0,
                margin: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.lightBlue.shade200,
                      child: Text(capitalize(username)),
                    ),
                    title: Text(username!),
                    subtitle: Text(useremail!),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text("My Account"),
            SizedBox(
              height: 350,
              child: Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Card(
                  elevation: 2.0,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        const Text("Change Profile Image"),
                        UserImage(
                          onFileChanged: (imageUrl) {
                            print(imageUrl);
                          },
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet<void>(
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                return Padding(
                                  padding: MediaQuery.of(context).viewInsets,
                                  child: Container(
                                      height:
                                          280, //height or you can use Get.width-100 to set height
                                      child: SizedBox(
                                        height: 280,
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: Form(
                                              key: formKey,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  const Text(
                                                    "Update name",
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  _textInput(
                                                    hint: "Enter name",
                                                    autofocus: false,
                                                    obscuretext: false,
                                                    controller: nameController,
                                                    icon: Icons.account_circle,
                                                    validator: validateName,
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 20.0,
                                                            bottom: 20.0),
                                                    child: auth.requestStatus ==
                                                            Status
                                                                .sendRequesting
                                                        ? loading
                                                        : ButtonWidget(
                                                            btnText: "Update",
                                                            onClick: () {
                                                              doUpdateName();
                                                            },
                                                          ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )),
                                );
                              },
                            );
                          },
                          child: const ListTile(
                            leading: Icon(Icons.account_box_outlined),
                            title: Text("Change Profile name"),
                            subtitle: Text("You can change your profile name"),
                            trailing: Icon(Icons.arrow_forward_rounded),
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet<void>(
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                return Padding(
                                    padding: MediaQuery.of(context).viewInsets,
                                    child: SizedBox(
                                      height: 300,
                                      child: Center(
                                        child: Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: Form(
                                              key: formKey1,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  const Text(
                                                    "Update password",
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  _textInput(
                                                    hint: "Enter password",
                                                    autofocus: false,
                                                    obscuretext: true,
                                                    controller:
                                                        passwordController,
                                                    icon: Icons.lock,
                                                    validator: validatePassword,
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 20.0,
                                                            bottom: 20.0),
                                                    child: auth.requestStatus ==
                                                            Status
                                                                .sendRequesting
                                                        ? loading
                                                        : ButtonWidget(
                                                            btnText: "Update",
                                                            onClick: () {
                                                              doUpdatePassword();
                                                            },
                                                          ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ),
                                    ));
                              },
                            );
                          },
                          child: const ListTile(
                            leading: Icon(Icons.lock),
                            title: Text("Change Password"),
                            subtitle: Text("You can change your password"),
                            trailing: Icon(Icons.arrow_forward_rounded),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 100,
              child: Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
                child: const Card(
                  elevation: 2.0,
                  child: ListTile(
                    leading: Icon(Icons.logout_rounded),
                    title: Text("Logout"),
                    trailing: Icon(Icons.arrow_forward_rounded),
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
      Text("Updating ... Please wait")
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
