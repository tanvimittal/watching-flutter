import 'package:dio/dio.dart';

import 'config.dart';

class HttpService {
  static final baseUrl = Config.apiBaseUrl;

  static const delayTimeMilliseconds = 1000;  // Only for debug mode

  // TODO: シングルトンでいい？
  Dio _dio;

  // https://stackoverflow.com/questions/12649573/how-do-you-build-a-singleton-in-dart
  static final HttpService _instance = HttpService._internal();

  factory HttpService() {
    return _instance;
  }

  HttpService._internal() {
    _dio = Dio(BaseOptions(baseUrl: baseUrl));
    _dio.options.headers['content-Type'] = 'application/json';

    // Show communication log
    _dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  /// This function is used for get requests
  Future<Response> getRequest(String endPoint, {String apiKey, Map<String, dynamic> queryParameters}) async {
    Options options;

    if (apiKey != null) {
      options = Options(headers: {
        "x-api-key": apiKey,
      });
    }

    if (Config.isRelease == false) {
      await Future.delayed(const Duration(milliseconds: delayTimeMilliseconds), () {});
    }

    return await _dio.get(
      endPoint,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// This function is used for post requests
  Future<Response> postRequest(String endPoint, {String apiKey, dynamic data}) async {
    Options options;

    if (apiKey != null) {
      options = Options(headers: {
        "x-api-key": apiKey,
      });
    }

    if (Config.isRelease == false) {
      await Future.delayed(const Duration(milliseconds: delayTimeMilliseconds), () {});
    }

    return await _dio.post(
      endPoint,
      data: data,
      options: options,
    );
  }

  /// This function is used for put requests
  Future<Response> putRequest(String endPoint, {String apiKey, dynamic data}) async {
    Options options;

    if (apiKey != null) {
      options = Options(headers: {
        "x-api-key": apiKey,
      });
    }

    if (Config.isRelease == false) {
      await Future.delayed(const Duration(milliseconds: delayTimeMilliseconds), () {});
    }

    return await _dio.put(
      endPoint,
      data: data,
      options: options,
    );
  }
}
