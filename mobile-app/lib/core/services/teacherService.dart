import 'package:crew_attendance/util/app_url.dart';
import 'package:dio/dio.dart';
import 'package:crew_attendance/util/api/dio_client.dart';

class TeacherService extends DioClient {
  Future<dynamic> fetchCourses() async {
    Response response = await dio.get(AppUrl.fetchTeacherCourse,
        options: Options(headers: {"requiresToken": true}));
    return response;
  }

  Future<dynamic> fetchStudents(courseid) async {
    Response response = await dio.get(
        "${AppUrl.fetchCourseStudents}?courseid=$courseid",
        options: Options(headers: {"requiresToken": true}));
    return response;
  }

  Future<dynamic> fetchAttendance(courseid) async {
    Response response = await dio.get(
        "${AppUrl.fetchCourseAttendance}?courseid=$courseid",
        options: Options(headers: {"requiresToken": true}));
    return response;
  }

  Future<dynamic> postAttendanceImage(data) async {
    dio.options.headers['content-Type'] = 'multipart/form-data';
    Response response = await dio.post(AppUrl.fetchAttendanceResult,
        data: data, options: Options(headers: {"requiresToken": true}));
    return response;
  }

  Future<dynamic> createCourse(Map<String, dynamic> data) async {
    final response = await dio.post(AppUrl.createCourse,
        data: data, options: Options(headers: {"requiresToken": true}));
    return response;
  }

  Future<dynamic> createAttendance(Map<String, dynamic> data) async {
    final response = await dio.post(AppUrl.createAttendance,
        data: data, options: Options(headers: {"requiresToken": true}));
    return response;
  }

  Future<dynamic> editAttendance(Map<String, dynamic> data) async {
    final response = await dio.post(AppUrl.editAttendance,
        data: data, options: Options(headers: {"requiresToken": true}));
    return response;
  }
}
