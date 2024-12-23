import 'package:connect/app/modules/auth/data/source/auth_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:connect/app/core/services/http/my_http_client.dart';

class DioClient implements MyHttpClient {
  final Dio dio = Dio();
  final AuthStorageService authStorageService;

  DioClient({required this.authStorageService}) {
    dio.options.baseUrl = 'http://192.168.1.68:9000';

    dio.options.validateStatus = (status) {
      return status! < 500;
    };

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? accessToken = await authStorageService.getAccessToken();
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (response.statusCode == 401) {
            // TODO: implement
          }
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
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> delete(String url) async {
    try {
      final response = await dio.delete(url);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> post(String url, {dynamic data}) async {
    try {
      final response = await dio.post(url, data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> update(String url, {dynamic data}) async {
    try {
      final response = await dio.put(url, data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
