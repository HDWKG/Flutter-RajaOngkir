import 'package:fluttermvvm/data/network/network_api_services.dart';
import 'package:fluttermvvm/model/model.dart';

class HomeRepository {
  final _apiServices = NetworkApiServices();

  Future<List<Province>> fetchProvinceList() async {
    try {
      dynamic response = await _apiServices.getApiResponse('/starter/province');
      List<Province> result = [];

      if (response['rajaongkir']['status']['code'] == 200) {
        result = (response['rajaongkir']['results'] as List)
            .map((e) => Province.fromJson(e))
            .toList();
      }

      return result;
    } catch (e) {
      throw Exception('Failed to fetch province list: $e');
    }
  }
}
