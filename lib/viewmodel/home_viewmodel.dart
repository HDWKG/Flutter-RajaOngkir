import 'package:flutter/material.dart';
import 'package:fluttermvvm/data/response/api_response.dart';
import 'package:fluttermvvm/model/model.dart';
import 'package:fluttermvvm/repository/home_repository.dart';

class HomeViewmodel with ChangeNotifier {
  final _homeRepo = HomeRepository();

  ApiResponse<List<Province>> provinceList = ApiResponse.loading();

  void setProvinceList(ApiResponse<List<Province>> response) {
    provinceList = response;
    notifyListeners();
  }

  Future<void> getProvinceList() async {
    setProvinceList(ApiResponse.loading());
    _homeRepo.fetchProvinceList().then((value) {
      setProvinceList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setProvinceList(ApiResponse.error(error.toString()));
    });
  }
}
