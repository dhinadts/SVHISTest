import 'dart:convert';
import '../../../login/preferences/user_preference.dart';
import '../../../model/base_response.dart';
import '../model/matched_request_data_model.dart';
import '../model/matched_supply_data_model.dart';
import '../../../utils/app_preferences.dart';
import 'package:http/http.dart' as http;

import 'nmb2b_repository.dart';

class MatchedListRepository {
  MatchedListRepository();

  WebserviceHelper helper = WebserviceHelper();

  Future<dynamic> fetchMatchedRequestList() async {
    Map<String, String> header = {};
    // header.putIfAbsent(
    //     "Authorization", () => "Token ${AppPreferences().token}");
    String accessToken = await AppPreferences.getToken();
    header.putIfAbsent("Authorization", () => "Token ${accessToken}");
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    print(header.toString());
    String url =
        "${WebserviceConstants.baseURL}${WebserviceConstants.matchedRequestURL}";

    // print("Value of Response fetchMatchedRequestList");
    final response =
        await helper.get(url, headers: header, isOAuthTokenNeeded: false);
    //  print("Value of Response statusCode  fetchMatchedRequestList ${response.statusCode}");

    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
//      print("Value of Response body${response.body}");
//      print("Value of Response body data ${response.body}");
      Map<String, dynamic> jsonMapData = new Map();
      List<MatchedRequestDataModel> matchedRequestList = [];

      // var listData = response.body.

      // List<dynamic> jsonData;
      try {
        jsonMapData = json.decode(response.body);
        //jsonData = jsonDecode(response.body[0]);
        //   print("Pranay jsonMapData ${jsonMapData["data"]}");

      } catch (e) {
        // print("" + e.toString());
      }

      if (jsonMapData != null) {
        jsonMapData["data"].forEach((data) {
          MatchedRequestDataModel tempData =
              MatchedRequestDataModel.fromJson(data);
          matchedRequestList.add(tempData);
        });
        //print("countrywiseHealthcareProvidersList ${countrywiseHealthcareProvidersList[0].name}");
        return matchedRequestList;
      }
    }

    return BaseResponse().markAsErrorResponse();
  }

  Future<dynamic> fetchMatchedSupplyList() async {
    Map<String, String> header = {};
    // header.putIfAbsent(
    //     "Authorization", () => "Token ${AppPreferences().token}");
    header.putIfAbsent(
        "Authorization", () => "Token ${UserPreference.ACCESS_TOKEN}");
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);

    String url =
        "${WebserviceConstants.baseURL}${WebserviceConstants.matchedSupplyURL}";

    //  print("Value of Response fetchMatchedSupplyList");
    final response =
        await helper.get(url, headers: header, isOAuthTokenNeeded: false);
    // print("Value of Response statusCode  fetchMatchedSupplyList ${response.statusCode}");

    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      // print("Value of Response body${response.body}");
      // print("Value of Response body data ${response.body}");
      Map<String, dynamic> jsonMapData = new Map();
      List<MatchedSupplyDataModel> matchedSupplyList = [];

      // var listData = response.body.

      // List<dynamic> jsonData;
      try {
        jsonMapData = json.decode(response.body);
        //jsonData = jsonDecode(response.body[0]);
        //  print("Pranay jsonMapData ${jsonMapData["data"]}");

      } catch (e) {
        //   print("" + e.toString());
      }

      if (jsonMapData != null) {
        jsonMapData["data"].forEach((data) {
          MatchedSupplyDataModel tempData =
              MatchedSupplyDataModel.fromJson(data);
          matchedSupplyList.add(tempData);
        });
        //print("countrywiseHealthcareProvidersList ${countrywiseHealthcareProvidersList[0].name}");
        return matchedSupplyList;
      }
    }

    return BaseResponse().markAsErrorResponse();
  }

  Future<BaseResponse> connectSupplier(
      num supplierId, num quantity, String critical) async {
//    print(
//        "supplierId  - ${supplierId} quantity- $quantity critical - ${critical} ");
//    print(
//        "acceptReject URL - ${WebserviceConstants.baseURL}${WebserviceConstants.connectSupplierURL}");
    Map<String, String> header = {};
    header.putIfAbsent(
        "Authorization", () => "Token ${AppPreferences().token}");

    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    var request = new Map<String, dynamic>();

    request["supply_id"] = supplierId;
    request["quantity"] = quantity;
    request["critical"] = critical;

    http.Response response;
    String url =
        "${WebserviceConstants.baseURL}${WebserviceConstants.connectSupplierURL}";
    BaseResponse respBase;

    try {
      response = await http
          .post(url, headers: header, body: jsonEncode(request))
          .timeout(
              Duration(seconds: WebserviceConstants.apiServiceTimeOutInSeconds),
              onTimeout: _onTimeOut);

      respBase = BaseResponse.fromJson(jsonDecode(response.body));
      respBase.status = response.statusCode;
    } catch (e) {
      respBase = onMultiTimeOut();
      respBase.status = response.statusCode;
      respBase.message = response.body;
    }

    return respBase;
  }

  http.Response _onTimeOut() {
    BaseResponse appBaseResponse = BaseResponse(
        status: 500, message: AppPreferences().getApisErrorMessage);
    http.Response response = http.Response(jsonEncode(appBaseResponse), 500);
    return response;
  }

  BaseResponse onMultiTimeOut() {
    BaseResponse appBaseResponse = BaseResponse(
        status: 500, message: AppPreferences().getApisErrorMessage);
    //BaseResponse response = BaseResponse(jsonEncode(appBaseResponse), 500);
    return appBaseResponse;
  }
}
