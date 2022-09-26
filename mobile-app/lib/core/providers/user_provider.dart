import 'package:flutter/foundation.dart';
import 'package:crew_attendance/core/models/user.dart';

class UserProvider with ChangeNotifier {
  User _user = User();

  User get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
}
