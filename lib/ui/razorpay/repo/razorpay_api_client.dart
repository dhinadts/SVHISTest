import 'dart:convert';

import '../../../model/user_info.dart';
import '../../../repo/common_repository.dart';
import '../../../ui/razorpay/model/razorpay_response.dart';
import '../../../utils/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RazorpayApiClient {
  final http.Client httpClient;

  RazorpayApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<http.Response> createRazorpayOrder(
      {double amount,
      String currency,
      String customerName,
      String email,
      String phone,
      String requestId,
      String departmentName,
      String userName}) async {
    Map<String, String> header = {};
    String username = await AppPreferences.getUsername();
    UserInfo userInfo = await AppPreferences.getUserInfo();
    String userFullName = userInfo.userFullName;
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    header.putIfAbsent("clientid", () => AppPreferences().clientId);
    Map<String, dynamic> requestBody = {
      "amount": amount,
      "currency": currency,
      "customerName": customerName,
      "email": email,
      "phoneNumber": phone,
      "departmentName": departmentName,
      "requestId": requestId,
      "userFullName": userFullName,
      "userName": username,
    };
    debugPrint("requestBody razorpay create --> $requestBody");
    final http.Response response = await http.post(
        "${WebserviceConstants.baseURL}" + "/payments/orderInfo",
        body: json.encode(requestBody),
        headers: header);

    //debugPrint("response is --> ${response.body}");
    return response;
  }

  Future<http.Response> updateRazorpayOrder(
      {Map<String, dynamic> orderInfo, String oldPaymentId}) async {
    Map<String, String> header = {};
    String username = await AppPreferences.getUsername();
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    header.putIfAbsent("clientid", () => AppPreferences().clientId);

    final http.Response response = await http.put(
        "${WebserviceConstants.baseURL}" + "/payments/order/$oldPaymentId",
        body: json.encode(orderInfo),
        headers: header);

    //debugPrint("response is --> ${response.body}");
    return response;
  }

  Future<RazorpayResponse> getRazorpayDetailsByRequestId(
      String requestId) async {
    final url =
        WebserviceConstants.baseURL + "/payments/order?request_id=$requestId";
    Map<String, String> header = {};
    String username = await AppPreferences.getUsername();
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    header.putIfAbsent("clientid", () => AppPreferences().clientId);

    final response = await this.httpClient.get(url, headers: header);
    RazorpayResponse razorpayResponse;

    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      if (response.body.isNotEmpty) {
        List<dynamic> data = jsonDecode(response.body);
        if (data.length > 0) {
          List<RazorpayResponse> paymentInfoList =
              data.map((data) => RazorpayResponse.fromJson(data)).toList();
          razorpayResponse = paymentInfoList.first;
          return razorpayResponse;
        } else
          return null;
      } else {
        return null;
      }
    } else
      return null;
  }
}
