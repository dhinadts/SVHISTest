import 'dart:async';

import '../model/base_response.dart';
import '../model/forget_password_response.dart';
import '../model/reset_password_response.dart';
import '../model/user_info.dart';
import '../model/user_login_model.dart';
import '../repo/auth_repository.dart';
import '../utils/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class AuthBloc extends Bloc {
  UserInfo getUserInfo;

  final _repository = AuthRepository();

  final userInfoResponse = PublishSubject<UserInfo>();
  final departmentResp = PublishSubject<String>();
  final baseRespFetcher = PublishSubject<UserLoginModel>();
  final forgotRespFetcher = PublishSubject<ForgetPasswordResponse>();
  final resetPasswordRespFetcher = PublishSubject<ResetPasswordResponse>();

  AuthBloc(BuildContext context) : super(context);

  Stream<UserInfo> get list => userInfoResponse.stream;

  Stream<BaseResponse> get baseResponse => baseRespFetcher.stream;

  Stream<String> get departStream => departmentResp.stream;

  @override
  void init() {}

  Future<void> getDepartment(String city, String role) async {
    List<dynamic> list = await _repository.getDepartment(city, role);
    String departmentName = list.length > 0 ? list[0]["departmentName"] : "";
    departmentResp.sink.add(departmentName);
  }

  Future<void> authLogin(String username, String password) async {
    UserLoginModel response =
        await _repository.signInMultipartRequest(username, password);
    baseRespFetcher.sink.add(response);
  }

  Future<void> authForgotPassword(String email) async {
    ForgetPasswordResponse response =
        await _repository.forGotPasswordRequest(email);
    forgotRespFetcher.sink.add(response);
  }

  Future<void> authForgotUsername(String email) async {
    ForgetPasswordResponse response =
        await _repository.forGotUsernameRequest(email);
    forgotRespFetcher.sink.add(response);
  }

  Future<void> authResetPassword(String oldPassword, String newPassword) async {
    ResetPasswordResponse response =
        await _repository.resetPasswordRequest(oldPassword, newPassword);
    resetPasswordRespFetcher.sink.add(response);
  }

  Future<UserInfo> getUserInformation() async {
    String username = await AppPreferences.getUsername();
    getUserInfo = await _repository.getUserInfo(username);
    // print(
    //     'From auth_bloc....userInfo.......${getUserInfo.toJson().toString()}');
    if (getUserInfo != null) {
      try {
        //AppPreferences.setDeptName(getUserInfo.departmentName);
        await AppPreferences.setPhoneNo(getUserInfo.mobileNo);
        await AppPreferences.setEmail(getUserInfo.emailId);
        await AppPreferences.setDOB(getUserInfo.birthDate);
        await AppPreferences.setUserInfo(getUserInfo);
        String address = (getUserInfo.addressLine1 ?? '' + "@@");
        address = "$address${getUserInfo.addressLine2 ?? ""}@@";
        address = "$address${getUserInfo.cityName}@@";
        address = "$address${getUserInfo.stateName}@@";
        address = "$address${getUserInfo.countryName}@@";
        address = "$address${getUserInfo.zipCode}";
        
        await AppPreferences.setAddress(address);
        await AppPreferences.setFullName(
            '${getUserInfo.lastName}, ${getUserInfo.firstName}');
        await AppPreferences.setSecondFullName(
            '${getUserInfo.firstName} ${getUserInfo.lastName}');
        await AppPreferences.setCountry(getUserInfo.country);
      await  AppPreferences.setUserMembershipType(getUserInfo.membershipType);


        await AppPreferences.setHistorySaved(
            getUserInfo.hasAdditionalInfo ?? false);
      } catch (_) {
        debugPrint(_.toString());
      }
    }
    return getUserInfo;
  }

  Future<void> getDepartmentConfigInformation() async {
    String departmentName = await AppPreferences.getDeptName();
    Map<String, dynamic> departmentConfig =
        await _repository.getDepartmentConfigInfo(departmentName);
    if (departmentConfig != null) {
      try {
        debugPrint("departmentConfig --> ${departmentConfig.toString()}");
        if (departmentConfig.containsKey("clientId")) {
          String clientId = departmentConfig["clientId"];
          if (clientId != null && clientId.isNotEmpty) {
            AppPreferences.setClientId(clientId);
          }
        }
        String consideredDomain;
        if (departmentConfig.containsKey("domain")) {
          List<dynamic> domainList =
              departmentConfig["domain"] as List<dynamic>;
          if (domainList != null) {
            domainList.forEach((element) {
              if (element.isNotEmpty) {
                if (element == "WorkForce" || element == "DATTApp") {
                  consideredDomain = element;
                }
              }
            });
          }

          if (consideredDomain == null || consideredDomain.isEmpty) {
            consideredDomain = "DATTApp";
          }
          debugPrint("consideredDomain --> $consideredDomain");
          // AppPreferences.setConsideredDomain(consideredDomain);
        }
      } catch (_) {
        debugPrint(_);
      }
    }
  }

  @override
  void dispose() {
    userInfoResponse.close();
    departmentResp.close();
    baseRespFetcher.close();
    forgotRespFetcher.close();
    resetPasswordRespFetcher.close();
  }
}
