import 'package:crew_attendance/core/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class UserPreferences {
  Future<bool> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("userId", user.userId ?? "");
    prefs.setString("name", user.name ?? "");
    prefs.setString("email", user.email ?? "");
    prefs.setString("type", user.type ?? "");
    prefs.setString("token", user.token ?? "");
    prefs.setString("renewalToken", user.renewalToken ?? "");
    prefs.setString("profilePic", user.profilePic ?? "");

    //print("object prefere");
    //print(user.renewalToken);

    return prefs.commit();
  }

  Future<bool> saveCourseId(courseId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("courseId", courseId ?? "");
    return prefs.commit();
  }

  Future<String?> getCourseId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? courseId = prefs.getString("courseId");
    return courseId;
  }

  Future<bool> saveEmail(email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", email ?? "");
    return prefs.commit();
  }

  Future<bool> saveToken(token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token ?? "");
    return prefs.commit();
  }

  Future<bool> saveRenewalToken(token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("renewalToken", token ?? "");
    return prefs.commit();
  }

  Future<bool> saveSplashScreen(issplash) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("issplash", issplash ?? "");
    return prefs.commit();
  }

  Future<bool> saveSlideScreen(isslide) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("isslide", isslide ?? "");
    return prefs.commit();
  }

  Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userId = prefs.getString("userId");
    String? name = prefs.getString("name");
    String? email = prefs.getString("email");
    String? type = prefs.getString("type");
    String? token = prefs.getString("token");
    String? renewalToken = prefs.getString("renewalToken");

    return User(
        userId: userId,
        name: name,
        email: email,
        type: type,
        token: token,
        renewalToken: renewalToken);
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("name");
    prefs.remove("email");
    prefs.remove("type");
    prefs.remove("token");
  }

  Future<bool> setUserName(name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("name", name ?? "");
    return prefs.commit();
  }

  Future<bool> setProfilePic(pic) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("profilePic", pic ?? "");
    return prefs.commit();
  }

  Future<String?> getUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString("name");
    return name;
  }

  Future<String?> getType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? type = prefs.getString("type");
    return type;
  }

  Future<String?> getProfilePic() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? type = prefs.getString("profilePic");
    return type;
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    return token;
  }

  Future<String?> getRenewalToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("renewalToken");
    return token;
  }

  Future<String?> getEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString("email");
    return email;
  }

  Future<String?> getSplash() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString("issplash");
    return email;
  }
}
