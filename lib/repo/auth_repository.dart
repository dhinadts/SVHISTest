import 'dart:convert';

import '../login/constants/api_constants.dart';
import '../model/base_response.dart';
import '../model/forget_password_response.dart';
import '../model/reset_password_request.dart';
import '../model/reset_password_response.dart';
import '../model/user_info.dart';
import '../model/user_login_model.dart';
import '../repo/common_repository.dart';
import '../utils/app_preferences.dart';
import '../utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  WebserviceHelper helper;

  AuthRepository() {
    helper = WebserviceHelper();
  }

//GetAPI department
  Future<dynamic> getDepartment(String city, String role) async {
    Map<String, String> header = {};
    header.putIfAbsent('tenant', () => WebserviceConstants.tenant);
    header.putIfAbsent(WebserviceConstants.username, () => "mobile");
    header.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);

    String url = ApiConstants.BASE_URL +
        ApiConstants.GET_USER +
        "?location=" +
        city[0].toUpperCase() +
        city.substring(1) +
        "&role_name=$role";
    final response =
        await helper.get(url, headers: header, isOAuthTokenNeeded: false);

    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      List<dynamic> jsonData;
      try {
        jsonData = jsonDecode(response.body);
        return jsonData;
      } catch (e) {}
    }

    return [];
  }

  //GetAPI department
  Future<UserInfo> getUserInfo(String username,
      {String departmentName = null}) async {
    Map<String, String> header = await WebserviceConstants.createHeader();
    //String username = await AppPreferences.getUsername();
    String deptName;
    if (departmentName == null) {
      deptName = await AppPreferences.getDeptName();
    } else {
      deptName = departmentName;
    }

    //for QA tenant servicedx_qa
    //for Jamaica tenant servicedx
    header.putIfAbsent(
        WebserviceConstants.tenant, () => WebserviceConstants.tenant);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    header.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);

    String url = WebserviceConstants.baseAdminURL +
        "/departments/" +
        deptName +
        "/users/" +
        username;

    final response =
        await helper.get(url, headers: header, isOAuthTokenNeeded: false);
    Map<String, dynamic> jsonData;
    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      try {
        // print('User Info Response...........${response.body.toString()}');
        jsonData = jsonDecode(response.body);
        UserInfo userInfo = UserInfo.fromJson(jsonData);
        // print("user info gender" + userInfo.gender);
        return userInfo;
      } catch (e) {}
    }
    jsonData = jsonDecode(response.body);
    BaseResponse baseResponse = UserInfo.fromJson(jsonData);
    return baseResponse;
  }

  //Post API helper
  Future<int> updateFcmToken(String fcmToken) async {
    String departmentName = await AppPreferences.getDeptName();
    String username = await AppPreferences.getUsername();
    var request = new http.MultipartRequest(
        "PUT",
        Uri.parse(WebserviceConstants.baseAdminURL +
            "/departments/$departmentName/users/$username/auth?auth_token=$fcmToken"));
    request.headers.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.multipartForm);
    request.headers.putIfAbsent(WebserviceConstants.username, () => username);
    request.headers.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);
    http.StreamedResponse response;
    int statusCode;
    print(" fff ${request.url}");
    try {
      response = await request.send();
      final responseString = await response.stream.bytesToString();
      print(" fff $responseString");
      // debugPrint("status code - ${response.statusCode}");
      statusCode = response.statusCode;
    } catch (e) {}
    debugPrint(" CCC $statusCode");
    return statusCode;
  }

  //Post API helper
  Future<BaseResponse> signUpMultipartRequest(UserInfo userInfo) async {
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
    BaseResponse respUser = UserInfo();
    try {
      response = await request.send();
      final responseString = await response.stream.bytesToString();
      print("Response string $responseString");
      Map<String, dynamic> obj = json.decode(responseString);
      respUser = BaseResponse.fromJson(obj);
      respUser.status = response.statusCode;
//      print("Response string $respUser");
    } catch (e) {
      respUser = onMultiTimeOut();
    }

    return respUser;
  }

  Future<dynamic> getDepartmentConfigInfo(String departmentName) async {
    Map<String, String> header = {};
    header.putIfAbsent(
        WebserviceConstants.tenant, () => WebserviceConstants.tenant);
    String userName = await AppPreferences.getUsername();
    header.putIfAbsent(WebserviceConstants.username, () => userName);
    header.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);

    String url = WebserviceConstants.baseAdminURL +
        "/departments/$departmentName/config";
    final response = await helper.get(url, headers: header);

    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      dynamic jsonData;
      try {
        jsonData = jsonDecode(response.body);
        return jsonData;
      } catch (e) {}
    }

    return null;
  }

  Future<UserLoginModel> signInMultipartRequest(
      String username, String password) async {
    var request = new http.MultipartRequest(
        "POST", Uri.parse("${WebserviceConstants.baseURL}/auth/oauth/token"));
    // print("URL Login : ${WebserviceConstants.baseURL}");
    // print("URL Tenant : ${WebserviceConstants.tenant}");
    var auth = 'Basic ' + base64Encode(utf8.encode('SOMApplication:SOMSecret'));
    request.fields["username"] = username;
    request.fields["password"] = password;
    request.fields["grant_type"] = "password";
    request.headers["Authorization"] = auth;
    request.headers.putIfAbsent("clientid", () => AppPreferences().clientId);
    request.headers.putIfAbsent(WebserviceConstants.departmentName,
        () => AppPreferences().deptmentName);
    request.headers.putIfAbsent("app_scope", () => Constants.APP_SCOPE);
    request.headers
        .putIfAbsent("client_channel", () => Constants.CLIENT_CHANNEL);
    http.StreamedResponse response;

    UserLoginModel respUser = UserLoginModel();
    try {
      response = await request.send();
      final responseString = await response.stream.bytesToString();
      // print("Response string $responseString");
      Map<String, dynamic> obj = json.decode(responseString);
      respUser = UserLoginModel.fromJson(obj);
      respUser.status = response.statusCode;
      AppPreferences.setJWTToken(respUser.accessToken);
//      print("Response string $respUser");
    } catch (e) {
      respUser = onMultiTimeOut();
    }

    return respUser;
  }

  Future<ForgetPasswordResponse> forGotPasswordRequest(String email) async {
    var request = new http.MultipartRequest(
        "POST",
        Uri.parse(
            "${WebserviceConstants.baseCommonURL}/users/forgotPassword/$email"));
    var auth = 'Basic ' + base64Encode(utf8.encode('SOMApplication:SOMSecret'));
    request.headers["Authorization"] = auth;
    request.headers.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);
    http.StreamedResponse response;

    ForgetPasswordResponse forgetPasswordResponse;
    try {
      response = await request.send();
      final responseString = await response.stream.bytesToString();
      Map<String, dynamic> obj = json.decode(responseString);
      forgetPasswordResponse = ForgetPasswordResponse.fromJson(obj);
      forgetPasswordResponse.status = response.statusCode;
    } catch (e) {
      forgetPasswordResponse =
          ForgetPasswordResponse(status: response.statusCode);
    }
    return forgetPasswordResponse;
  }

  Future<ForgetPasswordResponse> forGotUsernameRequest(String email) async {
    var request = new http.MultipartRequest(
        "POST",
        Uri.parse(
            "${WebserviceConstants.baseCommonURL}${WebserviceConstants.forgotUsernameURL}$email"));
    var auth = 'Basic ' + base64Encode(utf8.encode('SOMApplication:SOMSecret'));
    request.headers["Authorization"] = auth;
    request.headers.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);
    http.StreamedResponse response;

    ForgetPasswordResponse forgetPasswordResponse;
    try {
      response = await request.send();
      final responseString = await response.stream.bytesToString();
      Map<String, dynamic> obj = json.decode(responseString);
      forgetPasswordResponse = ForgetPasswordResponse.fromJson(obj);
      forgetPasswordResponse.status = response.statusCode;
    } catch (e) {
      forgetPasswordResponse =
          ForgetPasswordResponse(status: response.statusCode);
    }
    return forgetPasswordResponse;
  }

  Future<ResetPasswordResponse> resetPasswordRequest(
      String oldPassword, String newPassword) async {
    String username = await AppPreferences.getUsername();
    RequestResetPassword requestResetPassword = RequestResetPassword(
        userName: username, newPassword: newPassword, oldPassword: oldPassword);
    Map<String, dynamic> data = requestResetPassword.toJson();

    Map<String, String> header = {};
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    header.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);
    http.Response response;
    String url =
        WebserviceConstants.baseCommonURL + WebserviceConstants.setPasswordURL;
    ResetPasswordResponse resetPasswordResponse;
    // print("URL: $url");
    // print("CheckIn : ${requestResetPassword.toJson().toString()}");
    try {
      response = await http
          .post(url, headers: header, body: jsonEncode(data))
          .timeout(
              Duration(seconds: WebserviceConstants.apiServiceTimeOutInSeconds),
              onTimeout: _onTimeOut);

      resetPasswordResponse =
          ResetPasswordResponse.fromJson(jsonDecode(response.body));
      resetPasswordResponse.status = response.statusCode;
    } catch (e) {
      resetPasswordResponse = ResetPasswordResponse();
      resetPasswordResponse.status = response.statusCode;
      resetPasswordResponse.message = response.body;
    }

    return resetPasswordResponse;
  }

  http.Response _onTimeOut() {
    BaseResponse appBaseResponse = BaseResponse(status: 500);
    http.Response response = http.Response(jsonEncode(appBaseResponse), 500);
    return response;
  }

  BaseResponse onMultiTimeOut() {
    BaseResponse appBaseResponse = BaseResponse(status: 500);
    //BaseResponse response = BaseResponse(jsonEncode(appBaseResponse), 500);
    return appBaseResponse;
  }

  BaseResponse onMultiTimeOutLogin() {
    BaseResponse appBaseResponse = BaseResponse(status: 500);
    //BaseResponse response = BaseResponse(jsonEncode(appBaseResponse), 500);
    return appBaseResponse;
  }
}
