import 'dart:convert';
import 'dart:io';
import '../../../login/preferences/user_preference.dart';
import '../model/base_response.dart';
import '../../../ui/b2c/model/requested_item_inprocess_model.dart';
import '../../../ui/b2c/model/requested_item_model.dart';
import '../../../utils/app_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'nmb2b_repository.dart';

class RequestedItemsListRepository {
  RequestedItemsListRepository();

  WebserviceHelper helper = WebserviceHelper();

  Future<dynamic> fetchRequestedItemsList() async {
    Map<String, String> header = {};
    header.putIfAbsent(
        "Authorization", () => "Token ${AppPreferences().token}");
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);

    String url =
        "${WebserviceConstants.baseURL}${WebserviceConstants.requestedItemsListURL}";

    print("Value of Response fetchRequestedItemsList");
    final response =
        await helper.get(url, headers: header, isOAuthTokenNeeded: false);
    print("Value of Response statusCode ${response.statusCode}");

    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      print("Value of Response body${response.body}");
      print("Value of Response body data ${response.body}");
      Map<String, dynamic> jsonMapData = new Map();
      List<RequestedItemModel> requestedItemsList = [];

      // var listData = response.body.

      // List<dynamic> jsonData;
      try {
        jsonMapData = json.decode(response.body);
        //jsonData = jsonDecode(response.body[0]);
        print("Pranay jsonMapData ${jsonMapData["data"]}");
      } catch (e) {
        print("" + e.toString());
      }

      if (jsonMapData != null) {
        jsonMapData["data"].forEach((data) {
          RequestedItemModel tempData = RequestedItemModel.fromJson(data);
          requestedItemsList.add(tempData);
        });
        //print("countrywiseHealthcareProvidersList ${countrywiseHealthcareProvidersList[0].name}");
        return requestedItemsList;
      }
    }

    return BaseResponse().markAsErrorResponse();
  }

  Future<dynamic> fetchRequestedItemsInProcessList() async {
    Map<String, String> header = {};

    header.putIfAbsent(
        "Authorization", () => "Token ${AppPreferences().token}");
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);

    String url =
        "${WebserviceConstants.baseURL}${WebserviceConstants.inProcessRequestURL}";

    print("Value of Response fetchRequestedItemsInProcessList");
    final response =
        await helper.get(url, headers: header, isOAuthTokenNeeded: false);
    print("Value of Response statusCode ${response.statusCode}");

    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      print("Value of Response body${response.body}");
      print("Value of Response body data ${response.body}");
      Map<String, dynamic> jsonMapData = new Map();
      List<RequestedItemInProcessDataModel> requestedItemsInProcessList = [];

      // var listData = response.body.

      // List<dynamic> jsonData;
      try {
        jsonMapData = json.decode(response.body);
        //jsonData = jsonDecode(response.body[0]);
        print("Pranay jsonMapData ${jsonMapData["data"]}");
      } catch (e) {
        print("" + e.toString());
      }

      if (jsonMapData != null) {
        jsonMapData["data"].forEach((data) {
          RequestedItemInProcessDataModel tempData =
              RequestedItemInProcessDataModel.fromJson(data);
          requestedItemsInProcessList.add(tempData);
        });
        //print("countrywiseHealthcareProvidersList ${countrywiseHealthcareProvidersList[0].name}");
        return requestedItemsInProcessList;
      }
    }

    return BaseResponse().markAsErrorResponse();
  }

  Future<BaseResponse> createOrUpdateRequest(RequestedItemModel newRequestData,
      {bool isUpdate = false}) async {
    Map<String, dynamic> data = newRequestData.toJson();
    Map<String, String> header = {};

    header.putIfAbsent(
        "Authorization", () => "Token ${AppPreferences().token}");
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    http.Response response;
    String url =
        WebserviceConstants.baseURL + WebserviceConstants.requestedItemsListURL;
    BaseResponse respBase;
    print(isUpdate);
    print("URL: $url");
    print("newRequestData : ${newRequestData.toJson().toString()}");
    try {
      if (isUpdate) {
        response = await http
            .put(url, headers: header, body: jsonEncode(data))
            .timeout(
                Duration(
                    seconds: WebserviceConstants.apiServiceTimeOutInSeconds),
                onTimeout: _onTimeOut);
      } else {
        response = await http
            .post(url, headers: header, body: jsonEncode(data))
            .timeout(
                Duration(
                    seconds: WebserviceConstants.apiServiceTimeOutInSeconds),
                onTimeout: _onTimeOut);
      }

      respBase = BaseResponse.fromJson(jsonDecode(response.body));
      respBase.status = response.statusCode;
    } catch (e) {
      respBase = onMultiTimeOut();
      respBase.status = response.statusCode;
      respBase.message = response.body;
    }

    return respBase;
  }

  Future<BaseResponse> deleteRequest(num itemId) async {
    Map<String, String> header = {};
    header.putIfAbsent(
        "Authorization", () => "Token ${AppPreferences().token}");
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);

    String url =
        "${WebserviceConstants.baseURL}${WebserviceConstants.requestedItemsListURL}?${WebserviceConstants.itemIdParam}$itemId";

    print("Value of Response fetchRequestedItemsList");
    http.Response response;
    BaseResponse respBase;
    try {
      response =
          await helper.delete(url, headers: header, isOAuthTokenNeeded: false);
      print("Value of Response statusCode ${response.statusCode}");

      respBase = BaseResponse.fromJson(jsonDecode(response.body));
      respBase.status = response.statusCode;
    } catch (e) {
      respBase = onMultiTimeOut();
      respBase.status = response.statusCode;
      respBase.message = response.body;
    }

    return respBase;
  }

  Future<BaseResponse> completeOrderStatus(
      String orderConfirm, num orderId) async {
    print("orderConfirm  - ${orderConfirm} orderId - ${orderId} ");
    print(
        "acceptReject URL - ${WebserviceConstants.baseURL}${WebserviceConstants.orderStatusCompleteURL}");
    Map<String, String> header = {};

    header.putIfAbsent(
        "Authorization", () => "Token ${AppPreferences().token}");

    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    var request = new Map<String, dynamic>();

    request["order-confirm"] = orderConfirm;
    request["id"] = orderId.toString();

    http.Response response;
    String url =
        "${WebserviceConstants.baseURL}${WebserviceConstants.orderStatusCompleteURL}";
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
