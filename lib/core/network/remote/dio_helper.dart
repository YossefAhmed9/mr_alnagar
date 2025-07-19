import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;
  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://admin.mohamed-elnagar.com/api/',
        receiveDataWhenStatusError: true,
        responseType: ResponseType.json,
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? data,
    String lang = 'ar',
    String? token,
  }) async {
    // Set the default headers
    dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization': 'Bearer $token',
    };

    return await dio.get(
      url,
      queryParameters: query,
      data: data,
      // Note: GET requests should not usually have a body (`data`)
    );
  }

  static Future<Response> postFormUrlEncoded({
    required String url,
    required Map<String, dynamic> data,
    String? token,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    return await dio.post(url, data: data);
  }


  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
    String lang = 'ar',
    String? token,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization': 'Bearer $token',
    };
    return await dio.post(url, queryParameters: query, data: data);
  }
  static Future<Response> postFormData({
    required String url,
    required Map<String, dynamic> data,
    String? token,
  }) async {
    FormData formData = FormData.fromMap(data);

    return await dio.post(
      url,
      data: formData,
      options: Options(
        headers: token != null
            ? {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        }
            : {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }


  static Future<Response> putData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
    String lang = 'ar',
    String? token,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': 'en',
      'Authorization': 'Bearer $token',
    };
    return await dio.put(url, queryParameters: query, data: data);
  }

  static Future<Response> delData({
    required String url,
    Map<String, dynamic>? data,
  }) async {
    dio.options.headers = {'Content-Type': 'application/json'};
    return await dio.delete(url, data: data);
  }
}
