import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crew_attendance/core/models/course.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:crew_attendance/core/services/studentService.dart';

enum Status { sendRequesting, requestSuccessful, requestFailed, notAuthorized }

class StudentCoursesProvider with ChangeNotifier {
  List result = [];
  Status _requestStatus = Status.requestFailed;
  Status get requestStatus => _requestStatus;

  Future<void> fetchCourses() async {
    try {
      var response = await StudentService().fetchCourses();
      var getCourseData = json.decode(response.data['data']) as List;
      result = getCourseData.map((i) => Course.fromJson(i)).toList();
      notifyListeners();
    } on DioError catch (e) {
      _decodeErrorResponse(e);
    } catch (error) {
      print("Error inside course provider");
      print(error);
    }
  }

  Future<Map<String, dynamic>> enrollCourse(String courseCode) async {
    Map<String, dynamic> result;
    final Map<String, dynamic> courseData = {'courseCode': courseCode};
    _requestStatus = Status.sendRequesting;
    notifyListeners();
    try {
      var response = await StudentService().enrollCourse(courseData);
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

  Future<Map<String, dynamic>> leaveCourse(String courseId) async {
    Map<String, dynamic> result;
    final Map<String, dynamic> courseData = {'course_id': courseId};
    _requestStatus = Status.sendRequesting;
    notifyListeners();
    try {
      var response = await StudentService().leaveCourse(courseData);
      await fetchCourses();
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
