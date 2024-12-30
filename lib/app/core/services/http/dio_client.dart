import 'package:connect/app/modules/auth/data/source/auth_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:connect/app/core/services/http/my_http_client.dart';
import 'package:flutter/material.dart';

class DioClient implements MyHttpClient {
  final Dio dio = Dio();
  final AuthStorageService localStorage;

  DioClient({required this.localStorage}) {
    dio.options.baseUrl = 'http://192.168.1.68:9000';

    dio.options.validateStatus = (status) {
      return status! < 500;
    };

    dio.options.receiveDataWhenStatusError = true;
    dio.options.followRedirects = true;
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.connectTimeout = Durations.extralong4 * 10;
    dio.options.receiveTimeout = Durations.extralong4 * 10;

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? accessToken = await localStorage.getAccessToken();

          if (accessToken != null) {
            options.headers['Authorization'] = accessToken;
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (response.statusCode == 401) {}
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          return handler.next(error);
        },
      ),
    );
  }

  @override
  Future<dynamic> get(String url) async {
    try {
      final response = await dio.get(url);
      return {
        "data": response.data,
        "status": response.statusCode,
      };
    } catch (e) {
      return {
        "error": e.toString(),
      };
    }
  }

  @override
  Future<dynamic> delete(String url) async {
    try {
      final response = await dio.delete(url);
      return {
        "data": response.data,
        "status": response.statusCode,
      };
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> post(String url, {dynamic data}) async {
    try {
      final response = await dio.post(url, data: data);
    
      print("resposta: $response");

      return {
        "data": response.data,
        "status": response.statusCode,
      };
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> put(String url, {dynamic data}) async {
    try {
      final response = await dio.put(url, data: data);
      return {
        "data": response.data,
        "status": response.statusCode,
      };
    } catch (e) {
      rethrow;
    }
  }
}
