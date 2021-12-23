import 'dart:convert';
import '../model/base_response.dart';
import '../model/user_login_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'nmb2b_repository.dart';

class AuthRepository {
  WebserviceHelper helper;

  AuthRepository() {
    helper = WebserviceHelper();
  }

  /// Login for NMB2B
  Future<UserLoginModel> signInMultipartRequest(
      String username, String password) async {
    var request = new http.MultipartRequest(
        "POST",
        Uri.parse(
            "${WebserviceConstants.baseURL}${WebserviceConstants.loginURL}"));
    request.fields["email"] = username;
    request.fields["password"] = password;
    http.StreamedResponse response;

    BaseResponse respUser = UserLoginModel();
    try {
      response = await request.send();
      final responseString = await response.stream.bytesToString();
      print("Login Response string $responseString");
      Map<String, dynamic> obj = json.decode(responseString);
      respUser = UserLoginModel.fromJson(obj);
      respUser.status = response.statusCode;
//      print("Response string $respUser");
    } catch (e) {
      respUser = onMultiTimeOut();
    }

    return respUser;
  }

  /// SignUp for NMB2B
  Future<UserLoginModel> signUpMultipartRequest(
      String username, String password, String userType) async {
    var request = new http.MultipartRequest(
        "POST",
        Uri.parse(
            "${WebserviceConstants.baseURL}${WebserviceConstants.registerURL}"));
    request.fields["email"] = username;
    request.fields["password"] = password;
    request.fields["user_type"] = userType;
    http.StreamedResponse response;

    BaseResponse respUser = UserLoginModel();
    try {
      response = await request.send();
      final responseString = await response.stream.bytesToString();
      print("SignUp  Response string: $responseString");
      // print(
      //     "Before Inside SignUp  Response string ${json.decode(responseString)}");
      Map<String, dynamic> obj = json.decode(responseString);
      respUser = UserLoginModel.fromJson(obj);
      respUser.status = response.statusCode;
      //print("Inside SignUp Response string $respUser");
    } catch (e) {
      respUser = onMultiTimeOut();
      print("Error part SignUp Response string $respUser");
    }

    return respUser;
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
