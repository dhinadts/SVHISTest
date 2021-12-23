import 'dart:convert';
import '../../../login/preferences/user_preference.dart';
import '../model/base_response.dart';
import '../../../ui/b2c/model/supplier_item_inprocess_model.dart';
import '../../../ui/b2c/model/supplier_item_model.dart';
import '../../../utils/app_preferences.dart';
import 'package:http/http.dart' as http;
import 'nmb2b_repository.dart';

class SupplierItemsListRepository {
  SupplierItemsListRepository();

  WebserviceHelper helper = WebserviceHelper();

  Future<dynamic> fetchSupplierItemsList() async {
    Map<String, String> header = {};
    header.putIfAbsent(
        "Authorization", () => "Token ${UserPreference.ACCESS_TOKEN}");
    // header.putIfAbsent(
    //     "Authorization", () => "Token ${AppPreferences().token}");
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);

    String url =
        "${WebserviceConstants.baseURL}${WebserviceConstants.supplierItemsListURL}";

    print("Value of Response fetchSupplierItemsList");
    final response =
        await helper.get(url, headers: header, isOAuthTokenNeeded: false);
    print("Value of Response statusCode ${response.statusCode}");

    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      print("Value of Response body${response.body}");
      print("Value of Response body data ${response.body}");
      Map<String, dynamic> jsonMapData = new Map();
      List<SupplierItemModel> supplierItemsList = [];

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
          SupplierItemModel tempData = SupplierItemModel.fromJson(data);
          supplierItemsList.add(tempData);
        });
        //print("countrywiseHealthcareProvidersList ${countrywiseHealthcareProvidersList[0].name}");
        return supplierItemsList;
      }
    }

    return BaseResponse().markAsErrorResponse();
  }

  Future<dynamic> fetchSupplierItemsInProcessList() async {
    Map<String, String> header = {};
    header.putIfAbsent(
        "Authorization", () => "Token ${UserPreference.ACCESS_TOKEN}");
    // header.putIfAbsent(
    //     "Authorization", () => "Token ${AppPreferences().token}");
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);

    String url =
        "${WebserviceConstants.baseURL}${WebserviceConstants.inProcessRequestURL}";

    print("Value of Response fetchSupplierItemsInProcessList");
    final response =
        await helper.get(url, headers: header, isOAuthTokenNeeded: false);
    print("Value of Response statusCode ${response.statusCode}");

    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      print("Value of Response body${response.body}");
      print("Value of Response body data ${response.body}");
      Map<String, dynamic> jsonMapData = new Map();
      List<SupplierItemInProcessDataModel> supplierItemsInProcessList = [];

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
          SupplierItemInProcessDataModel tempData =
              SupplierItemInProcessDataModel.fromJson(data);
          supplierItemsInProcessList.add(tempData);
        });
        //print("countrywiseHealthcareProvidersList ${countrywiseHealthcareProvidersList[0].name}");
        return supplierItemsInProcessList;
      }
    }

    return BaseResponse().markAsErrorResponse();
  }

  Future<BaseResponse> createOrUpdateSupply(SupplierItemModel newSupplyData,
      {bool isUpdate = false}) async {
    Map<String, dynamic> data = newSupplyData.toJson();
    Map<String, String> header = {};
    header.putIfAbsent(
        "Authorization", () => "Token ${UserPreference.ACCESS_TOKEN}");
    // header.putIfAbsent(
    //     "Authorization", () => "Token ${AppPreferences().token}");
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    http.Response response;
    String url =
        WebserviceConstants.baseURL + WebserviceConstants.supplierItemsListURL;
    BaseResponse respBase;
    print(isUpdate);
    print("URL: $url");
    print("newSupplyData : ${newSupplyData.toJson().toString()}");
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

  Future<BaseResponse> deleteSupply(num itemId) async {
    Map<String, String> header = {};
    header.putIfAbsent(
        "Authorization", () => "Token ${UserPreference.ACCESS_TOKEN}");
    // header.putIfAbsent(
    //     "Authorization", () => "Token ${AppPreferences().token}");
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);

    String url =
        "${WebserviceConstants.baseURL}${WebserviceConstants.supplierItemsListURL}?${WebserviceConstants.itemIdParam}$itemId";

    print("Value of Response fetchSupplierItemsList");
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

  Future<BaseResponse> acceptRejectOrder(
      String orderConfirm, num itemId, String comment) async {
    print(
        "orderConfirm  - ${orderConfirm} itemId - ${itemId} comment - ${comment}");
    print(
        "acceptReject URL - ${WebserviceConstants.baseURL}${WebserviceConstants.acceptRejectOrderURL}");
    Map<String, String> header = {};

    header.putIfAbsent(
        "Authorization", () => "Token ${AppPreferences().token}");

    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    var request = new Map<String, dynamic>();

    request["order-confirm"] = orderConfirm;
    request["order_id"] = itemId.toString();
    request["comment"] = comment;

    http.Response response;
    String url =
        "${WebserviceConstants.baseURL}${WebserviceConstants.acceptRejectOrderURL}";
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
