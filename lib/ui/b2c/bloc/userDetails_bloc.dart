import '../model/base_response.dart';
import '../model/category_model.dart';
import '../model/user_details_model.dart';
import '../repository/userDetails_repository.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class UserDetailsBloc extends Bloc {
  final _repositorys = UserDetailsRepository();

  final userDetailsFetcher = PublishSubject<UserDetailsModel>();
  final userProfileCreateOrUpdateFetcher = PublishSubject<BaseResponse>();
  final profileCategoryListFetcher =
      PublishSubject<List<ProfileCategoryModel>>();
  final deleteCategoryAndSubcategoryFetcher = PublishSubject<BaseResponse>();
  final addCategoryAndSubcategoryFetcher = PublishSubject<BaseResponse>();

  UserDetailsBloc(BuildContext context) : super(context);

  Stream<UserDetailsModel> get list1 => userDetailsFetcher.stream;
  Stream<BaseResponse> get createStream =>
      userProfileCreateOrUpdateFetcher.stream;
  Stream<List<ProfileCategoryModel>> get list =>
      profileCategoryListFetcher.stream;
  Stream<BaseResponse> get deleteStream =>
      deleteCategoryAndSubcategoryFetcher.stream;
  Stream<BaseResponse> get createCategoryStream =>
      addCategoryAndSubcategoryFetcher.stream;

  @override
  void init() {}
  bool isAllPagesLoaded;

  Future<void> fetchUserDetails(String token) async {
    // print("Hello Pranay in fetchUserDetails");
    UserDetailsModel response = await _repositorys.fetchUserDetails(token);

    userDetailsFetcher.sink.add(response);
  }

  Future<void> createOrUpdateUserProfile(UserDetailsModel userDetailsData,
      {bool isUpdate = false, var file}) async {
    BaseResponse response = await _repositorys.createOrUpdateUserProfile(
        userDetailsData,
        isUpdate: isUpdate,
        file: file);
    userProfileCreateOrUpdateFetcher.sink.add(response);
  }

  Future<void> addCategoryAndSubcategory(
      String categoryType, String subCategoryType) async {
    BaseResponse response = await _repositorys.addCategoryAndSubcategory(
        categoryType, subCategoryType);
    addCategoryAndSubcategoryFetcher.sink.add(response);
  }

  Future<void> fetchProfileCategoryList() async {
    //  print("Hello Pranay in fetchProfileCategoryList");
    List<ProfileCategoryModel> response =
        await _repositorys.fetchProfileCategoryList();

    profileCategoryListFetcher.sink.add(response);
  }

  Future<void> deleteCategoryAndSubcategory(
      String categoryType, String subCategoryType) async {
    BaseResponse response = await _repositorys.deleteCategoryAndSubcategory(
        categoryType, subCategoryType);
    deleteCategoryAndSubcategoryFetcher.sink.add(response);
  }

  Future<void> updateUserFcmToken(String fcmToken, String deviceId) async {
    await _repositorys.updateFcmToken(fcmToken, deviceId);
  }

  @override
  void dispose() {
    userDetailsFetcher.close();
    userProfileCreateOrUpdateFetcher.close();
    profileCategoryListFetcher.close();
    deleteCategoryAndSubcategoryFetcher.close();
    addCategoryAndSubcategoryFetcher.close();
  }
}
