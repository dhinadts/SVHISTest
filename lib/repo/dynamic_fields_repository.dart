import 'dart:convert';

import '../model/base_response.dart';
import '../model/dynamic_fields_new_response.dart';
import '../model/dynamic_fields_reponse.dart';
import '../repo/common_repository.dart';
import '../utils/app_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class DynamicFieldsRepository {
  DynamicFieldsRepository();

  WebserviceHelper helper = WebserviceHelper();

  Future<List<DynamicFieldsResponse>> fetchDynamicFieldsData(
      String fieldsCategory) async {
    Map<String, String> header = {};
    header.putIfAbsent("Accept", () => "application/json");
    String username = await AppPreferences.getUsername();
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    header.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);
    String url =
        "${WebserviceConstants.baseAdminURL}/dynamic-fields/$fieldsCategory";
    debugPrint("URL - $url");
    final http.Response response = await http.get(
      url,
      headers: header,
    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      List<DynamicFieldsResponse> dynamicFieldsList =
          (json.decode(response.body) as List)
              .map((i) => DynamicFieldsResponse.fromJson(i))
              .toList();
      return dynamicFieldsList;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      Fluttertoast.showToast(msg: "Unable to load data");
      return null;
    }
  }

  Future<BaseResponse> postDynamicFieldCheckInData(
      Map postData, bool isUpdate) async {
    Map<String, String> header = {};
    String username = await AppPreferences.getUsername();
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    String url = WebserviceConstants.baseAdminURL + '/checkin';
    debugPrint("URL - $url");
    debugPrint("IsUpdate - $isUpdate");

    BaseResponse respBase;
    http.Response response;
    try {
      if (isUpdate) {
        response =
            await http.put(url, headers: header, body: jsonEncode(postData));
      } else {
        response =
            await http.post(url, headers: header, body: jsonEncode(postData));
      }
      print("response --> ${response.body}");
      respBase = BaseResponse.fromJson(jsonDecode(response.body));
      respBase.status = response.statusCode;
    } catch (e) {
      respBase = onMultiTimeOut();
      respBase.status = response.statusCode;
      respBase.message = response.body;
    }
    return respBase;
  }

  Future<List<DynamicFieldsResponse>> fetchDynamicFieldCheckInData(
      String id) async {
    Map<String, String> header = {};
    String username = await AppPreferences.getUsername();
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    header.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);
    String url = WebserviceConstants.baseAdminURL + '/checkin/$id';
    debugPrint("URL - $url");

    BaseResponse respBase;
    http.Response response;
    try {
      final response = await helper.get(url, headers: header);
      //print("response --> ${response.body}");
      if (response.statusCode == 200) {
        // If the server did return a 201 CREATED response,
        // then parse the JSON.
        List<DynamicFieldsResponse> dynamicFieldsList =
            (json.decode(response.body) as List)
                .map((i) => DynamicFieldsResponse.fromJson(i))
                .toList();
        return dynamicFieldsList;
      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.
        //Fluttertoast.showToast(msg: "Unable to load data");
        return [];
      }
    } catch (e) {
      respBase = onMultiTimeOut();
      respBase.status = response.statusCode;
      respBase.message = response.body;
    }
    return [];
  }

  Future<BaseResponse> postDynamicFieldHistoryData(
      Map postData, bool isUpdate) async {
    Map<String, String> header = {};
    String username = await AppPreferences.getUsername();
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    String url = WebserviceConstants.baseAdminURL + '/history';
    debugPrint("URL - $url");
    debugPrint("isUpdate History - $isUpdate");

    BaseResponse respBase;
    http.Response response;
    try {
      if (isUpdate) {
        response =
            await http.put(url, headers: header, body: jsonEncode(postData));
      } else {
        response =
            await http.post(url, headers: header, body: jsonEncode(postData));
      }
      print("response --> ${response.body}");
      respBase = BaseResponse.fromJson(jsonDecode(response.body));
      respBase.status = response.statusCode;
    } catch (e) {
      respBase = onMultiTimeOut();
      respBase.status = response.statusCode;
      respBase.message = response.body;
    }
    return respBase;
  }

  BaseResponse onMultiTimeOut() {
    BaseResponse appBaseResponse = BaseResponse(status: 500);
    return appBaseResponse;
  }

  Future<BaseResponse> postGroupEntity(Map postData) async {
    Map<String, String> header = {};
    String username = await AppPreferences.getUsername();
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    String url =
        WebserviceConstants.baseAdminURL + WebserviceConstants.groupEntity;
    debugPrint("URL - $url");

    BaseResponse respBase;
    http.Response response;
    try {
      response =
          await http.post(url, headers: header, body: jsonEncode(postData));
      respBase = BaseResponse.fromJson(jsonDecode(response.body));
      respBase.status = response.statusCode;
    } catch (e) {
      respBase = onMultiTimeOut();
      respBase.status = response.statusCode;
      respBase.message = response.body;
    }
    return respBase;
  }

  Future<BaseResponse> postDynamicFieldDataWithHelpOfFieldCategory(
      Map postData, String fieldsCategory) async {
    Map<String, String> header = {};
    String username = await AppPreferences.getUsername();
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    String url =
        "${WebserviceConstants.baseAdminURL}/dynamic-fields/$fieldsCategory?${WebserviceConstants.usernameParam}$username&${WebserviceConstants.departmentNameParam}${AppPreferences().deptmentName}";

    debugPrint("URL - $url");

    BaseResponse respBase;
    http.Response response;
    try {
      response =
          await http.post(url, headers: header, body: jsonEncode(postData));
      respBase = BaseResponse.fromJson(jsonDecode(response.body));
      respBase.status = response.statusCode;
    } catch (e) {
      respBase = onMultiTimeOut();
      respBase.status = response.statusCode;
      respBase.message = response.body;
    }
    return respBase;
  }

  Future<List<DynamicFieldsResponse>> getDynamicFieldWithFieldCategory(
      String fieldsCategory,
      {String departmentName,
      String username}) async {
    Map<String, String> header = {};
    header.putIfAbsent("Accept", () => "application/json");
    if (username == null) {
      username = await AppPreferences.getUsername();
    }
    if (departmentName == null) {
      departmentName = AppPreferences().deptmentName;
    }
    String headerUsername = await AppPreferences.getUsername();
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => headerUsername);
    String url =
        "${WebserviceConstants.baseAdminURL}/departments/$departmentName/dynamic-fields/$fieldsCategory?${WebserviceConstants.usernameParam}$username";
    debugPrint("URL - $url");
    debugPrint("URL - $header");
    final http.Response response = await http.get(
      url,
      headers: header,
    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      DynamicFieldsNewResponse newResponse =
          DynamicFieldsNewResponse.fromJson(jsonDecode(response.body));

      List<DynamicFieldsResponse> dynamicFieldsList = List();
      if (newResponse?.DATTApp != null && newResponse.DATTApp.isNotEmpty) {
        dynamicFieldsList = newResponse?.DATTApp;
      } else if (newResponse?.HealthCare != null &&
          newResponse.HealthCare.isNotEmpty) {
        dynamicFieldsList = newResponse?.HealthCare;
      } else {
        dynamicFieldsList = newResponse?.WorkForce ?? List();
      }
      return dynamicFieldsList;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      Fluttertoast.showToast(msg: "Unable to load data");
      return [];
    }
  }
}
