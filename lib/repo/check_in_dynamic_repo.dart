import 'dart:convert';

import '../model/base_response.dart';
import '../model/check_in_dynamic.dart';
import '../model/user_info.dart';
import '../repo/common_repository.dart';
import '../utils/app_preferences.dart';
import 'package:http/http.dart' as http;

class CheckInDynamicRepository {
  CheckInDynamicRepository();

//Post API helper
  Future<BaseResponse> createOrUpdateCheckInDynamic(CheckInDynamic checkIn,
      {bool isUpdate = false}) async {
    Map<String, dynamic> data = checkIn.toJson();
    Map<String, String> header = await WebserviceConstants.createHeader();
    http.Response response;
    String url = WebserviceConstants.baseAdminURL +
        WebserviceConstants.checkInDynamicURL;
    BaseResponse respBase;
    // print(isUpdate);
    // print("URL: $url");
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
  } //Post API helper

  //Post API helper
  Future<BaseResponse> submitSignUpMultipartRequest(UserInfo userInfo) async {
    BaseResponse respUser = UserInfo();
    try {
      var request = new http.MultipartRequest(
          "POST",
          Uri.parse(WebserviceConstants.baseCommonURL +
              WebserviceConstants.CreateURL +
              userInfo.departmentName +
              "/users"));

      request.fields['user'] = jsonEncode(userInfo.toJson());
      request.headers.putIfAbsent(WebserviceConstants.contentType,
          () => WebserviceConstants.multipartForm);
      request.headers.putIfAbsent(WebserviceConstants.username, () => "admin");
      request.headers.putIfAbsent(
          WebserviceConstants.clientId, () => AppPreferences().clientId);
      http.StreamedResponse response;
      response = await request.send();
      final responseString = await response.stream.bytesToString();
//      print("Response string $responseString");
      Map<String, dynamic> obj = json.decode(responseString);
      respUser = BaseResponse.fromJson(obj);
      respUser.status = response.statusCode;
//      print("Response string $respUser");
    } catch (e) {
      respUser = onMultiTimeOut();
    }

    return respUser;
  }

  //Post API helper
  Future<BaseResponse> submitUserInfoMultipartRequest(UserInfo userInfo) async {
    var request = new http.MultipartRequest(
        "POST",
        Uri.parse(WebserviceConstants.baseCommonURL +
            WebserviceConstants.CreateURL +
            userInfo.departmentName +
            "/users"));

    request.fields['user'] = jsonEncode(userInfo.toJson());
    request.headers.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.multipartForm);
    request.headers.putIfAbsent(
        WebserviceConstants.username, () => AppPreferences().username);
    request.headers.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);
    http.StreamedResponse response;
    BaseResponse respUser = UserInfo();
    try {
      response = await request.send();
      final responseString = await response.stream.bytesToString();
//      print("Response string $responseString");
      Map<String, dynamic> obj = json.decode(responseString);
      respUser = BaseResponse.fromJson(obj);
      respUser.status = response.statusCode;
//      print("Response string $respUser");
    } catch (e) {
      respUser = onMultiTimeOut();
    }

    return respUser;
  }

  //Post API helper
  Future<BaseResponse> updateUserInfoMultipartRequest(UserInfo userInfo) async {
    String username = await AppPreferences.getUsername();
    var request = new http.MultipartRequest(
        "PUT",
        Uri.parse(WebserviceConstants.baseCommonURL +
            WebserviceConstants.CreateURL +
            userInfo.departmentName +
            "/users/" +
            username));

    request.fields['user'] = jsonEncode(userInfo.toJson());
    request.headers.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.multipartForm);
    request.headers.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);
    request.headers.putIfAbsent(WebserviceConstants.username, () => username);
    http.StreamedResponse response;
    BaseResponse respUser = UserInfo();
    try {
      response = await request.send();
      final responseString = await response.stream.bytesToString();
//      print("Response string $responseString");
      Map<String, dynamic> obj = json.decode(responseString);
      respUser = BaseResponse.fromJson(obj);
      respUser.status = response.statusCode;
//      print("Response string $respUser");
    } catch (e) {
      respUser = onMultiTimeOut();
    }

    return respUser;
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
