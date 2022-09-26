import 'package:crew_attendance/util/app_url.dart';
import 'package:dio/dio.dart';
import 'package:crew_attendance/util/api/dio_client.dart';

class StudentService extends DioClient {
  Future<dynamic> fetchCourses() async {
    Response response = await dio.get(AppUrl.fetchStudentCourse,
        options: Options(headers: {"requiresToken": true}));
    return response;
  }

  Future<dynamic> enrollCourse(Map<String, dynamic> data) async {
    final response = await dio.post(AppUrl.enrollCourse,
        data: data, options: Options(headers: {"requiresToken": true}));
    return response;
  }

  Future<dynamic> leaveCourse(Map<String, dynamic> data) async {
    final response = await dio.post(AppUrl.leaveCourse,
        data: data, options: Options(headers: {"requiresToken": true}));
    return response;
  }
}
