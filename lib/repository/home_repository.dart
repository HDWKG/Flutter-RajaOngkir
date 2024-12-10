import 'package:fluttermvvm/data/app_exception.dart';
import 'package:fluttermvvm/data/network/network_api_services.dart';
import 'package:fluttermvvm/model/city.dart';
import 'package:fluttermvvm/model/costs/calculate.dart';
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

  Future<List<City>> fetchCityList(var provId) async {
    try {
      dynamic response = await _apiServices.getApiResponse('/starter/city');
      List<City> result = [];

      if (response['rajaongkir']['status']['code'] == 200) {
        result = (response['rajaongkir']['results'] as List)
            .map((e) => City.fromJson(e))
            .toList();
      }
      List<City> selectedCities = [];
      for (var c in result) {
        if (c.provinceId == provId) {
          selectedCities.add(c);
        }
      }
      return selectedCities;
    } catch (e) {
      throw Exception('Failed to fetch City list: $e');
    }
  }

  Future<CostResponse> calculateCost({
    required String origin,
    required String destination,
    required int weight,
    required String courier,
  }) async {
    try {
      final body = {
        'origin': origin,
        'destination': destination,
        'weight': weight.toString(),
        'courier': courier,
        'originType': 'city',
        'destinationType': 'city'
      };

      dynamic response = await _apiServices.postApiResponse('/cost', body);

      if (response['rajaongkir']['status']['code'] == 200) {
        return CostResponse.fromJson(response['rajaongkir']['results'][0]);
      }
      throw FetchDataException('Oops.. Something Went Wrong');
    } catch (e) {
      print("Error calculating cost: $e");
      throw e;
    }
  }
}
