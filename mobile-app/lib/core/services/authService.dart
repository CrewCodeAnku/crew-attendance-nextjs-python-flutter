// ignore: file_names
import 'package:crew_attendance/util/app_url.dart';
import 'package:dio/dio.dart';
import 'package:crew_attendance/util/api/dio_client.dart';

class AuthService extends DioClient {
  Future<dynamic> registerUser(Map<String, dynamic> data) async {
    final response = await dio.post(AppUrl.register,
        data: data, options: Options(headers: {"requiresToken": false}));
    return response;
  }

  Future<dynamic> updateName(Map<String, dynamic> data) async {
    final response = await dio.post(AppUrl.updatename,
        data: data, options: Options(headers: {"requiresToken": true}));
    return response;
  }

  Future<dynamic> updatePassword(Map<String, dynamic> data) async {
    final response = await dio.post(AppUrl.updatepassword,
        data: data, options: Options(headers: {"requiresToken": true}));
    return response;
  }

  Future<dynamic> loginUser(Map<String, dynamic> data) async {
    var response = await dio.post(AppUrl.login,
        data: data, options: Options(headers: {"requiresToken": false}));
    return response;
  }

  Future<dynamic> resendEmail(Map<String, dynamic> data) async {
    Response response = await dio.post(AppUrl.resendemail,
        data: data, options: Options(headers: {"requiresToken": false}));
    return response;
  }

  Future<dynamic> verifyEmail(Map<String, dynamic> data) async {
    Response response = await dio.post(AppUrl.verifyemail,
        data: data, options: Options(headers: {"requiresToken": false}));
    return response;
  }

  Future<dynamic> resetPassword(Map<String, dynamic> data) async {
    Response response = await dio.post(AppUrl.resetPassword, data: data);
    return response;
  }

  Future<dynamic> forgetPassword(Map<String, dynamic> data) async {
    Response response = await dio.post(AppUrl.forgotPassword,
        data: data, options: Options(headers: {"requiresToken": false}));
    return response;
  }

  Future<dynamic> updateProfilePic(data) async {
    dio.options.headers['content-Type'] = 'multipart/form-data';
    Response response = await dio.post(AppUrl.updateProfilePic,
        data: data, options: Options(headers: {"requiresToken": true}));
    return response;
  }
}
