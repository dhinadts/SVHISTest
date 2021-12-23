import 'dart:convert';

import '../../../model/base_response.dart';
import '../../../model/subscription_response.dart';
import '../../../model/subscriptions_model.dart';
import '../../../repo/common_repository.dart';
import '../../../ui/subscription/subscription_screen.dart';
import '../../../utils/app_preferences.dart';
import 'package:http/http.dart' as http;

class SubscriptionRepository {
  SubscriptionRepository();

  WebserviceHelper helper = WebserviceHelper();

  Future<dynamic> getSubscriptionList() async {
    Map<String, String> header = {};
    String username = await AppPreferences.getUsername();
    String dept = await AppPreferences.getDeptName();
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    final response = await helper.get(
        WebserviceConstants.baseURL +
            WebserviceConstants.getSubscription +
            "?${WebserviceConstants.departmentNameParam}$dept",
        headers: header,
        isOAuthTokenNeeded: false);

    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      // print(
      //     "History Success Http ${response.statusCode} \n Body ${response.body}");
      Map<String, dynamic> jsonMapData = new Map();
      List<dynamic> jsonData;
      try {
        jsonData = jsonDecode(response.body);
        jsonMapData.putIfAbsent("subscriptionList", () => jsonData);
      } catch (_) {
        // print("" + _);
      }

      if (jsonData != null) {
        SubscriptionResponse historyList =
            SubscriptionResponse.fromJson(jsonMapData);
        return historyList;
      }
    } else {
      // print(
      //     "History Failed Http ${response.statusCode} \n Body ${response
      //         .body}");
    }
    return [];
  }

  Future<dynamic> getSubscriptionUserList(String subscriptionName) async {
    Map<String, String> header = {};
    String username = await AppPreferences.getUsername();
    String dept = await AppPreferences.getDeptName();
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    // https://qa.servicedx.com/subscription/departments/{department_name}/subscriptions/{subscription_name}
    final response = await helper.get(
        "${WebserviceConstants.baseURL}/subscription/departments/${AppPreferences().deptmentName}/subscriptions/$subscriptionName",
        headers: header,
        isOAuthTokenNeeded: false);

    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      // print(
      //     "History Success Http ${response.statusCode} \n Body ${response
      //         .body}");
      Map<String, dynamic> jsonMapData = new Map();
      List<dynamic> jsonData;
      try {
        jsonMapData = jsonDecode(response.body);
//        jsonMapData.putIfAbsent("subscriptionList", () => jsonData);
      } catch (_) {
        // print("" + _);
      }

      if (jsonMapData != null) {
        SubscriptionsModel subscription =
            SubscriptionsModel.fromJson(jsonMapData);
        return subscription;
      }
    } else {
      // print(
      //     "History Failed Http ${response.statusCode} \n Body ${response
      //         .body}");
    }
    return [];
  }

  http.Response _onTimeOut() {
    BaseResponse appBaseResponse = BaseResponse(status: 500);
    http.Response response = http.Response(jsonEncode(appBaseResponse), 500);
    return response;
  }

  Future<dynamic> updateSubscription(
      {SubscriptionRequest request,
      String subscriptionName,
      bool isSubscribeCall,
      bool status}) async {
    String username = await AppPreferences.getUsername();

    Map<String, dynamic> data = request.toJson();

    Map<String, String> header = {};
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    http.Response response;
    //https://qa.servicedx.com/subscription/subscribe/{department_name}/{subscription_name}
    String url;
    if (isSubscribeCall)
      url =
          "${WebserviceConstants.baseURL}/subscription/subscribe/${AppPreferences().deptmentName}/$subscriptionName?status=$status";
    else {
      url =
          "${WebserviceConstants.baseURL}/subscription/unsubscribe/${AppPreferences().deptmentName}/$subscriptionName?status=$status";
    }
    // print("request $request");
    // print("URL $url");
    BaseResponse returnResponse = BaseResponse();
    try {
      response = await http
          .post(url, headers: header, body: jsonEncode([data]))
          .timeout(
              Duration(seconds: WebserviceConstants.apiServiceTimeOutInSeconds),
              onTimeout: _onTimeOut);

      returnResponse.status = response.statusCode;
      // print("response $response");
    } catch (e) {
      returnResponse = BaseResponse();
      returnResponse.status = response.statusCode;
      returnResponse.message = response.body;
    }

    return returnResponse;
  }
}
