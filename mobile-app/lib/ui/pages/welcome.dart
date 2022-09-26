import 'package:flutter/material.dart';
import 'package:crew_attendance/core/models/user.dart';
import 'package:crew_attendance/core/providers/user_provider.dart';
import 'package:provider/provider.dart';

class Welcome extends StatelessWidget {
  final User? user;

  Welcome({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<UserProvider>(context).setUser(user!);

    return Scaffold(
      body: Container(
        child: const Center(
          child: Text("WELCOME PAGE"),
        ),
      ),
    );
  }
}