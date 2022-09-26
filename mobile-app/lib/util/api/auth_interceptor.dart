import 'package:crew_attendance/util/app_url.dart';
import 'package:crew_attendance/util/shared_preference.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:crew_attendance/main.dart';

enum TokenErrorType {
  tokenNotFound,
  refreshTokenHasExpired,
  failedToRegenerateAccessToken,
  invalidAccessToken
}

class AuthInterceptor extends Interceptor {
  final Dio _dio;
  AuthInterceptor(this._dio);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.headers["requiresToken"] == false) {
      // if the request doesn't need token, then just continue to the next interceptor
      options.headers.remove("requiresToken"); //remove the auxiliary header
      return handler.next(options);
    }
    // get tokens from local storage, you can use Hive or flutter_secure_storage
    final accessToken = await UserPreferences().getToken();
    final refreshToken = await UserPreferences().getRenewalToken();

    if (accessToken == null || refreshToken == null) {
      _performLogout(_dio);
      // create custom dio error
      options.extra["tokenErrorType"] = TokenErrorType
          .tokenNotFound; // I use enum type, you can chage it to string
      final error = DioError(requestOptions: options, type: DioErrorType.other);
      return handler.reject(error);
    }

    // check if tokens have already expired or not
    // I use jwt_decoder package
    // Note: ensure your tokens has "exp" claim
    final accessTokenHasExpired = JwtDecoder.isExpired(accessToken);
    final refreshTokenHasExpired = JwtDecoder.isExpired(refreshToken);

    var _refreshed = true;

    if (refreshTokenHasExpired) {
      _performLogout(_dio);

      // create custom dio error
      options.extra["tokenErrorType"] = TokenErrorType.refreshTokenHasExpired;
      final error = DioError(requestOptions: options, type: DioErrorType.other);

      return handler.reject(error);
    } else if (accessTokenHasExpired) {
      print("Inside regenration of token");

      // regenerate access token
      _dio.interceptors.requestLock.lock();
      _refreshed = await _regenerateAccessToken();
      _dio.interceptors.requestLock.unlock();
    }

    if (_refreshed) {
      // add access token to the request header
      options.headers["AccessToken"] = accessToken;
      return handler.next(options);
    } else {
      // create custom dio error
      options.extra["tokenErrorType"] =
          TokenErrorType.failedToRegenerateAccessToken;
      final error = DioError(requestOptions: options, type: DioErrorType.other);
      return handler.reject(error);
    }
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 403 || err.response?.statusCode == 401) {
      // for some reasons the token can be invalidated before it is expired by the backend.
      // then we should navigate the user back to login page

      _performLogout(_dio);

      // create custom dio error
      err.type = DioErrorType.other;
      err.requestOptions.extra["tokenErrorType"] =
          TokenErrorType.invalidAccessToken;
    }

    return handler.next(err);
  }

  void _performLogout(Dio dio) async {
    print("Inside logout interceptor");

    _dio.interceptors.requestLock.clear();
    _dio.interceptors.requestLock.lock();

    UserPreferences().removeUser(); // remove token from local storage
    // back to login page without using context
    // check this https://stackoverflow.com/a/53397266/9101876
    navigatorKey.currentState?.pushReplacementNamed("/login");

    _dio.interceptors.requestLock.unlock();
  }

  /// return true if it is successfully regenerate the access token
  Future<bool> _regenerateAccessToken() async {
    try {
      BaseOptions options = BaseOptions(
          baseUrl: AppUrl.baseURL,
          connectTimeout: 5000,
          receiveTimeout: 3000,
          contentType:
              'application/json'); // should create new dio instance because the request interceptor is being locked

      var dio = Dio(options);
      // get refresh token from local storage
      final refreshToken = await UserPreferences().getRenewalToken();
      final token = await UserPreferences().getToken();

      // make request to server to get the new access token from server using refresh token
      final response = await dio.get(
        AppUrl.fetchRefreshToken,
        options: Options(
            headers: {"AccessToken": token, "RefreshToken": refreshToken}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final newAccessToken = response.data[
            "new_access_token"]; // parse data based on your JSON structure
        await UserPreferences()
            .saveToken(newAccessToken); // save to local storage
        return true;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        // it means your refresh token no longer valid now, it may be revoked by the backend
        _performLogout(_dio);
        return false;
      } else {
        print(response.statusCode);
        return false;
      }
    } on DioError catch (e) {
      if(e.response != null && (e.response?.statusCode == 403 || e.response?.statusCode == 401)){
        print("Inside error");
        _performLogout(_dio);
        return false;
      }
      print("Error inside interceptor");
      print(e.message);
      return false;
    } catch (e) {
      return false;
    }
  }
}
