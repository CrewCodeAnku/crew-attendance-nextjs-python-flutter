import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:crew_attendance/core/models/user.dart';
import 'package:crew_attendance/util/app_url.dart';
import 'package:crew_attendance/util/shared_preference.dart';
import 'package:crew_attendance/core/services/authService.dart';
import 'package:http_parser/http_parser.dart';

enum Status {
  authenticating,
  notLoggedIn,
  notRegistered,
  loggedIn,
  sendRequesting,
  requestSuccessful,
  requestFailed
}

enum Login { teacher, student }

class AuthProvider with ChangeNotifier {
  Status _loggedInStatus = Status.notLoggedIn;
  Status _requestStatus = Status.requestFailed;
  Status get loggedInStatus => _loggedInStatus;
  Status get requestStatus => _requestStatus;
  Dio dio = Dio(options);

  static BaseOptions options = BaseOptions(
    baseUrl: AppUrl.baseURL,
    connectTimeout: 5000,
    receiveTimeout: 3000,
  );

  Future<Map<String, dynamic>> resendEmail(String email) async {
    Map<String, dynamic> result;
    final Map<String, dynamic> verifyData = {'email': email};
    _requestStatus = Status.sendRequesting;
    notifyListeners();
    try {
      var response = await AuthService().resendEmail(verifyData);
      if (response.statusCode == 200) {
        _requestStatus = Status.requestSuccessful;
        notifyListeners();
        result = {
          'status': true,
          'message': json.decode(response.body)['message']
        };
      } else {
        _requestStatus = Status.requestFailed;
        notifyListeners();
        result = {
          'status': false,
          'message': json.decode(response.body)['message'],
        };
      }
    } catch (error) {
      _requestStatus = Status.requestFailed;
      notifyListeners();
      result = {'status': false, 'message': "Something went wrong!"};
    }
    return result;
  }

  Future<Map<String, dynamic>> verifyEmail(String otp, String email) async {
    Map<String, dynamic> result;
    final Map<String, dynamic> verifyData = {'otp': otp, 'email': email};
    _requestStatus = Status.sendRequesting;
    notifyListeners();
    try {
      var response = await AuthService().verifyEmail(verifyData);
      result = {'status': true, 'message': response.data['message']};
    } on DioError catch (e) {
      _loggedInStatus = Status.requestFailed;
      notifyListeners();
      var response = _decodeErrorResponse(e);
      result = {'status': false, 'message': response['message']};
    } catch (error) {
      _loggedInStatus = Status.requestFailed;
      notifyListeners();
      result = {'status': false, 'message': "Something went wrong!"};
    }
    return result;
  }

  Future<Map<String, dynamic>> login(
      String email, String password, type) async {
    Map<String, dynamic> result;

    final Map<String, dynamic> loginData = {
      'email': email,
      'password': password,
      'usertype': type,
      'platform': 'crewattendance'
    };

    _loggedInStatus = Status.authenticating;
    notifyListeners();
    try {
      var response = await AuthService().loginUser(loginData);
      var userData = response.data["data"];
      User authUser = User.fromJson(userData);
      print(authUser);
      UserPreferences().saveUser(authUser);
      _loggedInStatus = Status.loggedIn;
      notifyListeners();
      result = {
        'status': true,
        'message': response.data["message"],
        'user': authUser
      };
    } on DioError catch (e) {
      _loggedInStatus = Status.notLoggedIn;
      notifyListeners();
      var response = _decodeErrorResponse(e);
      result = {'status': false, 'message': response['message']};
    } catch (error) {
      print(error);
      _loggedInStatus = Status.notLoggedIn;
      notifyListeners();
      result = {'status': false, 'message': "Something went wrong!"};
    }
    return result;
  }

  Future<Map<String, dynamic>> resetPassword(
      String email, String otp, String password) async {
    Map<String, dynamic> result;
    final Map<String, dynamic> resetData = {
      'email': email,
      'otp': otp,
      'password': password
    };
    _requestStatus = Status.sendRequesting;
    notifyListeners();
    try {
      var response = await AuthService().resetPassword(resetData);
      result = {'status': true, 'message': response.data['message']};
    } on DioError catch (e) {
      _requestStatus = Status.requestFailed;
      notifyListeners();
      var response = _decodeErrorResponse(e);
      result = {'status': false, 'message': response['message']};
    } catch (error) {
      _requestStatus = Status.requestFailed;
      notifyListeners();
      result = {'status': false, 'message': "Something went wrong!"};
    }
    return result;
  }

  Future<Map<String, dynamic>> forgetPassword(String email) async {
    Map<String, dynamic> result;
    final Map<String, dynamic> forgetData = {'email': email};
    _requestStatus = Status.sendRequesting;
    notifyListeners();
    try {
      var response = await AuthService().forgetPassword(forgetData);
      _requestStatus = Status.requestSuccessful;
      notifyListeners();
      result = {'status': true, 'message': response.data['message']};
    } on DioError catch (e) {
      _requestStatus = Status.requestFailed;
      notifyListeners();
      var response = _decodeErrorResponse(e);
      result = {'status': false, 'message': response['message']};
    } catch (error) {
      _requestStatus = Status.requestFailed;
      notifyListeners();
      result = {'status': false, 'message': "Something went wrong!"};
    }
    return result;
  }

  Future<Map<String, dynamic>> register(
      String email, String name, String password, type) async {
    Map<String, dynamic> result;
    final Map<String, dynamic> registrationData = {
      'email': email,
      'name': name,
      'password': password,
      "usertype": type,
      "platform": "crewattendance"
    };
    _requestStatus = Status.sendRequesting;
    notifyListeners();
    try {
      var response = await AuthService().registerUser(registrationData);
      var userData = response.data['data'];
      User authUser = User.fromJson(userData);
      _requestStatus = Status.requestSuccessful;
      notifyListeners();
      result = {
        'status': true,
        'message': response.data['message'],
        'data': authUser
      };
    } on DioError catch (e) {
      _requestStatus = Status.requestFailed;
      notifyListeners();
      var response = _decodeErrorResponse(e);
      result = {'status': false, 'message': response['message']};
    } catch (error) {
      _requestStatus = Status.requestFailed;
      notifyListeners();
      result = {'status': false, 'message': "Something went wrong!"};
    }
    return result;
  }

  Future<Map<String, dynamic>> updateName(String name) async {
    Map<String, dynamic> result;
    final Map<String, dynamic> updateData = {
      'name': name,
    };
    _requestStatus = Status.sendRequesting;
    notifyListeners();
    try {
      var response = await AuthService().updateName(updateData);
      _requestStatus = Status.requestSuccessful;
      notifyListeners();
      result = {
        'status': true,
        'message': response.data['message'],
        'data': name
      };
    } on DioError catch (e) {
      _requestStatus = Status.requestFailed;
      notifyListeners();
      var response = _decodeErrorResponse(e);
      result = {'status': false, 'message': response['message']};
    } catch (error) {
      _requestStatus = Status.requestFailed;
      notifyListeners();
      result = {'status': false, 'message': "Something went wrong!"};
    }
    return result;
  }

  Future<Map<String, dynamic>> updatePassword(String name) async {
    Map<String, dynamic> result;
    final Map<String, dynamic> updateData = {
      'password': name,
    };
    _requestStatus = Status.sendRequesting;
    notifyListeners();
    try {
      var response = await AuthService().updatePassword(updateData);
      _requestStatus = Status.requestSuccessful;
      notifyListeners();
      result = {
        'status': true,
        'message': response.data['message'],
        'data': name
      };
    } on DioError catch (e) {
      _requestStatus = Status.requestFailed;
      notifyListeners();
      var response = _decodeErrorResponse(e);
      result = {'status': false, 'message': response['message']};
    } catch (error) {
      _requestStatus = Status.requestFailed;
      notifyListeners();
      result = {'status': false, 'message': "Something went wrong!"};
    }
    return result;
  }

  Future<Map<String, dynamic>> updateProfilePic(path, name) async {
    Map<String, dynamic> result;
    FormData formData = FormData.fromMap({
      "user_file": await MultipartFile.fromFile(path, filename: name),
      "type": "image/jpg"
    });
    try {
      var response = await AuthService().updateProfilePic(formData);
      result = {
        'status': true,
        'message': response.data['message'],
        'data': response.data['data']
      };
    } on DioError catch (e) {
      _requestStatus = Status.requestFailed;
      notifyListeners();
      var response = _decodeErrorResponse(e);
      result = {'status': false, 'message': response['message']};
    } catch (error) {
      _requestStatus = Status.requestFailed;
      notifyListeners();
      result = {'status': false, 'message': "Something went wrong!"};
    }
    return result;
  }

  dynamic _decodeErrorResponse(dynamic e) {
    dynamic data = {"statusCode": -1, "message": "Unknown Error"};
    if (e is DioError) {
      if (e.type == DioErrorType.response) {
        final response = e.response;
        data["message"] = response?.data['message'];
        data["statusCode"] = response?.statusCode;
      } else if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout ||
          e.type == DioErrorType.sendTimeout) {
        data["message"] = "Request timeout";
        data["statusCode"] = 408;
      } else if (e.error is SocketException) {
        data["message"] = "No Internet Connection!";
      }
    }
    return data;
  }
}
