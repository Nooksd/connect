abstract class MyHttpClient {
  Future<dynamic> get(String url);
  Future<dynamic> post(String url);
  Future<dynamic> update(String url);
  Future<dynamic> delete(String url);
}