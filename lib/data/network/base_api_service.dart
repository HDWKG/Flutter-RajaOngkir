abstract class BaseApiServies {
  Future<dynamic> getApiResponse(String endpoint);
  Future<dynamic> postApiResponse(String url, dynamic data);
}
