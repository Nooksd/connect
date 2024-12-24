abstract class MyHttpClient {
  Future<dynamic> get(String url);
  Future<dynamic> post(String url, {dynamic data});
  Future<dynamic> update(String url, {dynamic data});
  Future<dynamic> delete(String url);
}
