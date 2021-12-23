import '../model/base_response.dart';
import '../model/simplify_login_model.dart';
import '../model/user_info.dart';
import '../repo/auth_repository.dart';
import '../repo/check_in_repo.dart';
import '../utils/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:io';
import 'bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfoBloc extends Bloc {
  final _repository = CheckInRepository();
  final _authRepository = AuthRepository();

  final createFetcher = PublishSubject<BaseResponse>();
  final countryCodeFetcher = PublishSubject<String>();
  final simplifyLoginModelFetcher = PublishSubject<SimplifyLoginModel>();

  UserInfoBloc(BuildContext context) : super(context);

  Stream<BaseResponse> get resp => createFetcher.stream;

  Stream<String> get code => countryCodeFetcher.stream;

  @override
  void init() {}

  Future<void> createUser(UserInfo userInfo) async {
    BaseResponse response =
        await _repository.submitSignUpMultipartRequest(userInfo);
    createFetcher.sink.add(response);
  }

  Future<void> createUserInfo(UserInfo userInfo, addressProofImage) async {
    BaseResponse response = await _repository.submitUserInfoMultipartRequest(
        userInfo, addressProofImage);
    createFetcher.sink.add(response);
  }

  Future<void> updateUserInfo(UserInfo userInfo, File addressProofImage) async {
    BaseResponse response = await _repository.updateUserInfoMultipartRequest(
        userInfo, addressProofImage);
    createFetcher.sink.add(response);
  }

  Future<bool> updateUserDepartmentname(UserInfo userInfo,
      File addressProofImage, String sourceDepartname) async {
    bool check = await _repository.updateUserDepartmentMultipartRequest(
        userInfo, addressProofImage, sourceDepartname);
    return check;
  }

  Future<void> updateCountryCode(String country) async {
    countryCodeFetcher.sink.add(country);
  }

  Future<void> simplifyLoginDetails(SimplifyLoginModel model) async {
    simplifyLoginModelFetcher.sink.add(model);
  }

  Future<void> updateUserFcmToken(String fcmToken) async {
    await _authRepository.updateFcmToken(fcmToken);
  }

  Future removeFcmTokenFromFireStore() async {
    if ((AppPreferences().loginStatus)) {
      String username = await AppPreferences.getUsername();
      Firestore.instance.collection('users').document(username).delete();
    }
  }

  @override
  void dispose() {
    createFetcher.close();
    countryCodeFetcher.close();
    simplifyLoginModelFetcher.close();
  }
}
