import 'base_response.dart';

class CountrywiseHealthcareProvidersModel extends BaseResponse {
  String name;
  int value;

  CountrywiseHealthcareProvidersModel({
    this.name,
    this.value,
  });

  CountrywiseHealthcareProvidersModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }
}
