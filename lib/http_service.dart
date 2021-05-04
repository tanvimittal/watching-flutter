import 'package:dio/dio.dart';

class HttpService {
  Dio _dio;
  final baseUrl = "https://watching-server-production.herokuapp.com/v1";


  HttpService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl
      )
    );

    //initializeInterceptors();
  }

  /// This function is used for get requests
  Future<Response> getRequest(String endPoint, [String apiKey]) async {
    Response response;
    try {
      print(_dio.options.baseUrl);
      _dio.options.headers['content-Type'] = 'application/json';
      if (apiKey.isNotEmpty) {
        _dio.options.headers["x-api-key"] = apiKey;
      }
      response = await _dio.get(endPoint);
    } on DioError catch(e) {
        print(e.message);
        throw Exception(e.message);
    }
    return response;
  }

  /// This function is used for post requests
  Future<Response> postRequest(String endPoint, dynamic data, [String apiKey]) async {
    Response response;
    try {
      print(_dio.options.baseUrl);
      _dio.options.headers['content-Type'] = 'application/json';
      if (apiKey.isNotEmpty) {
        _dio.options.headers["x-api-key"] = apiKey;
      }
      response = await _dio.post(endPoint, data: data);
    } on DioError catch(e) {
      print(e.message);
      throw Exception(e.message);
    } on Exception catch(e) {
      print(e);
    }
    return response;
  }

  /// This function is used for put requests
  Future<Response> putRequest(String endPoint, dynamic data, [String apiKey]) async {
    Response response;
    try {
      print(_dio.options.baseUrl);
      _dio.options.headers['content-Type'] = 'application/json';
      if (apiKey.isNotEmpty) {
        _dio.options.headers["x-api-key"] = apiKey;
      }
      response = await _dio.put(endPoint, data: data);
    } on DioError catch(e) {
      print(e.message);
      throw Exception(e.message);
    } on Exception catch(e) {
      print(e);
    }
    return response;
  }

  initializeInterceptors(){
    _dio.interceptors.add(InterceptorsWrapper(
        onError: (error, handler){
          print(error.message);
        },
        onRequest: (request, handler){
          print("${request.method} ${request.path}");
        },
        onResponse: (response, handler){
          print(response.data);
        }
    ));

  }


}