import 'dart:convert';

import '../model/membership_search_request_model.dart';
import '../model/payment_info.dart';
import '../repo/common_repository.dart';
import '../utils/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MembershipApiClient {
  final http.Client httpClient;

  MembershipApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<PaymentInfo>> getMembershipTransactionDetails(
      {String requestId, String transactionType}) async {
    final url = WebserviceConstants.baseFilingURL +
        "/payment?request_id=$requestId&transaction_type=[$transactionType]";
    Map<String, String> header = await WebserviceConstants.createHeader();
    final response = await this.httpClient.get(url, headers: header);
    debugPrint("response transaction detials --> ${response.body}");
    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      List<dynamic> data = jsonDecode(response.body);
      List<PaymentInfo> paymentInfoList =
          data.map((data) => PaymentInfo.fromJson(data)).toList();
      return paymentInfoList;
    } else
      return List<PaymentInfo>();
  }

  Future<http.Response> cashPaymentInitiate(
      {String email,
      String name,
      String phone,
      String total,
      String paymentDescription}) async {
    MembershipSearchRequestModel request = MembershipSearchRequestModel();
    request.filterData = [];
    request.entity = "Membership";

    Map<String, String> header = await WebserviceConstants.createHeader();

    debugPrint("request is --> ${request.toJson()}");
    final http.Response response = await http.post(
        "${WebserviceConstants.baseFilingURL}" +
            "/payment/cash/initiate?${WebserviceConstants.emailParam}$email&${WebserviceConstants.nameParam}$name&${WebserviceConstants.phoneParam}$phone&${WebserviceConstants.totalParam}$total&${WebserviceConstants.paymentDescriptionParam}$paymentDescription",
        body: json.encode(request),
        headers: header);

    debugPrint("response is --> ${response.body}");
    return response;
  }
}
