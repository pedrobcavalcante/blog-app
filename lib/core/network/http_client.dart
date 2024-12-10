import 'package:blog/core/network/interface/http_client_interface.dart';
import 'package:dio/dio.dart';

class HttpClient implements HttpClientInterface {
  final Dio _dio;

  HttpClient({required String baseUrl})
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(milliseconds: 5000),
          receiveTimeout: const Duration(milliseconds: 3000),
        )) {
    _dio.interceptors
        .add(LogInterceptor(requestBody: true, responseBody: true));
  }

  @override
  Future<Response> get(String url,
      {Map<String, dynamic>? queryParameters}) async {
    return await _dio.get(url, queryParameters: queryParameters);
  }

  @override
  Future<Response> post(String url,
      {dynamic data, Map<String, dynamic>? queryParameters}) async {
    return await _dio.post(url, data: data, queryParameters: queryParameters);
  }

  @override
  Future<Response> delete(String url,
      {dynamic data, Map<String, dynamic>? queryParameters}) async {
    return await _dio.delete(url, data: data, queryParameters: queryParameters);
  }
}
