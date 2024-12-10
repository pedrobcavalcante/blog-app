import 'package:dio/dio.dart';

abstract class HttpClientInterface {
  Future<Response> get(String url, {Map<String, dynamic>? queryParameters});
  Future<Response> post(String url,
      {dynamic data, Map<String, dynamic>? queryParameters});
  Future<Response> delete(String url,
      {dynamic data, Map<String, dynamic>? queryParameters});
}
