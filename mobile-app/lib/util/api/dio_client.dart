import 'package:crew_attendance/util/api/auth_interceptor.dart';
import 'package:dio_logging_interceptor/dio_logging_interceptor.dart';
import 'package:crew_attendance/util/app_url.dart';
import 'package:dio/dio.dart';

class DioClient {
  final Dio dio = Dio(options);

  static BaseOptions options = BaseOptions(
      baseUrl: AppUrl.baseURL,
      connectTimeout: 5000,
      receiveTimeout: 3000,
      contentType: 'application/json',
      responseType: ResponseType.json);

  DioClient() {
    dio.interceptors.add(AuthInterceptor(dio));
    dio.interceptors.add(
      DioLoggingInterceptor(
        level: Level.body,
        compact: false,
      ),
    );
  }
}
