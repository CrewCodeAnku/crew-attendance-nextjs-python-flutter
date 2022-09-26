import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crew_attendance/core/models/course.dart';
import 'package:crew_attendance/core/models/student.dart';
import 'package:crew_attendance/core/models/attendance.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:crew_attendance/core/services/teacherService.dart';

enum Status { sendRequesting, requestSuccessful, requestFailed, notAuthorized }

class TeacherCoursesProvider with ChangeNotifier {
  List result = [];
  List studentresult = [];
  List attendanceresult = [];
  List createAttendanceDetail = [];
  List editAttendanceDetail = [];
  Status _requestStatus = Status.requestFailed;
  Status get requestStatus => _requestStatus;

  Future<void> fetchCourses() async {
    try {
      var response = await TeacherService().fetchCourses();
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

  Future<void> fetchStudents(courseId) async {
    try {
      var response = await TeacherService().fetchStudents(courseId);
      var getStudentData = json.decode(response.data['data']) as List;
      studentresult = getStudentData[0]['courseStudent']
          .map((i) => Student.fromJson(i))
          .toList();
      notifyListeners();
    } on DioError catch (e) {
      _decodeErrorResponse(e);
    } catch (error) {
      print("Error inside course provider");
      print(error);
    }
  }

  Future<void> fetchAttendance(courseId) async {
    try {
      var response = await TeacherService().fetchAttendance(courseId);
      var getAttendanceData = json.decode(response.data['data']) as List;
      attendanceresult = getAttendanceData
          .map((i) => Attendance.fromJson(i))
          .toList();
      notifyListeners();
    } on DioError catch (e) {
      _decodeErrorResponse(e);
    } catch (error) {
      print("Error inside course provider");
      print(error);
    }
  }

  Future<Map<String, dynamic>> createAttendance(
      String present,
      String absent,
      List studentParticipated,
      String courseId) async {
    Map<String, dynamic> result;
    final Map<String, dynamic> attendanceData = {
      'present': present,
      'absent': absent,
      'classImage':"",
      'studentParticipated': studentParticipated,
      'courseId':courseId
    };
    try {
      var response = await TeacherService().createAttendance(attendanceData);
      result = {'status': true, 'message': response.data['message']};
    }on DioError catch (e) {
      var response = _decodeErrorResponse(e);
      result = {'status': false, 'message': response['message']};
    }catch (error) {
      result = {'status': false, 'message': "Something went wrong!"};
    }
    return result;
  }

  Future<Map<String, dynamic>> editAttendance(
      String attendanceId,
      String present,
      String absent,
      List studentParticipated,
      String courseId) async {
    Map<String, dynamic> result;
    final Map<String, dynamic> attendanceData = {
      'attendanceId': attendanceId,
      'present': present,
      'absent': absent,
      'classImage':"",
      'studentParticipated': studentParticipated,
      'courseId':courseId
    };
    try {
      var response = await TeacherService().editAttendance(attendanceData);
      result = {'status': true, 'message': response.data['message']};
    }on DioError catch (e) {
      var response = _decodeErrorResponse(e);
      result = {'status': false, 'message': response['message']};
    }catch (error) {
      result = {'status': false, 'message': "Something went wrong!"};
    }
    return result;
  }

  Future<Map<String, dynamic>> createCourse(
      String courseName,
      String courseShortName,
      String courseStartDate,
      String courseEndDate) async {
    Map<String, dynamic> result;
    final Map<String, dynamic> courseData = {
      'courseName': courseName,
      'courseShortName': courseShortName,
      'courseStartDate': courseStartDate,
      "courseEndDate": courseEndDate
    };
    _requestStatus = Status.sendRequesting;
    notifyListeners();
    try {
      var response = await TeacherService().createCourse(courseData);
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

  Future<Map<String, dynamic>> postAttendanceImage(path, name) async {
    Map<String, dynamic> result;
    FormData formData = FormData.fromMap({
      "user_file": await MultipartFile.fromFile(path, filename: name),
      "type": "image/jpg"
    });
    try {
      var response = await TeacherService().postAttendanceImage(formData);
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
