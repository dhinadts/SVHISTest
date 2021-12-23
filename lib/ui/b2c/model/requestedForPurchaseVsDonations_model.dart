import 'base_response.dart';

class RequestedForPurchaseVsDonationsModel extends BaseResponse {
  String token;
  String statusCode;
  dynamic error;

  RequestedForPurchaseVsDonationsModel({
    this.token,
    this.error,
    this.statusCode,
  });

  RequestedForPurchaseVsDonationsModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    statusCode = json['status'];
    error = json['error'];
  }
}
