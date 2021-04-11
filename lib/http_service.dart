import 'package:dio/dio.dart';

class HttpService {
  Dio _dio;
  final baseUrl = "https://watching-server-production.herokuapp.com/v1/";

  HttpService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl
      )
    );

    initializeInterceptors();
  }

  /// This function is used for get requests
  Future<Response> getRequest(String endPoint) async{
    Response response;

    try {
      response = await _dio.get(endPoint);
    } on DioError catch(e) {
        print(e.message);
        throw Exception(e.message);
    }
  }

  /// This function is used for post requests
  Future<Response> postRequest(String endPoint, Map data) async {
    Response response;
    try {
      response = await _dio.post(endPoint, data: data);
    } on DioError catch(e) {
      print(e.message);
      throw Exception(e.message);
    }
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