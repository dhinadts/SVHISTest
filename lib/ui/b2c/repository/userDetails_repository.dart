import 'dart:convert';

import '../../../login/preferences/user_preference.dart';
import '../model/base_response.dart';
import '../../../ui/b2c/model/category_model.dart';
import '../../../ui/b2c/model/user_details_model.dart';
import '../../../utils/app_preferences.dart';
import 'package:http/http.dart' as http;

import 'nmb2b_repository.dart';

class UserDetailsRepository {
  UserDetailsRepository();

  WebserviceHelper helper = WebserviceHelper();

  Future<dynamic> fetchUserDetails(String token) async {
    Map<String, String> header = {};
    header.putIfAbsent("Authorization", () => "Token $token");
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);

    String url =
        "${WebserviceConstants.baseURL}${WebserviceConstants.userDetailsURL}";

    final response =
        await helper.get(url, headers: header, isOAuthTokenNeeded: false);

    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      print("Value of Response body${response.body}");
      print("Value of Response body data ${response.body}");
      Map<String, dynamic> jsonMapData = new Map();
      UserDetailsModel userDetails = new UserDetailsModel();

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
        userDetails = UserDetailsModel.fromJson(jsonMapData["data"]);

        print("userDetails Pranay  ${userDetails.firstName}");
        return userDetails;
      }
    }

    return BaseResponse().markAsErrorResponse();
  }

  Future<BaseResponse> createOrUpdateUserProfile(
      UserDetailsModel userDetailsData,
      {bool isUpdate = false,
      var file}) async {
    Map<String, dynamic> data = userDetailsData.toJson();
    Map<String, String> header = {};

    header.putIfAbsent(
        "Authorization", () => "Token ${AppPreferences().token}");
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    http.Response response;
    String url =
        WebserviceConstants.baseURL + WebserviceConstants.userDetailsURL;
    BaseResponse respBase;
    print(isUpdate);
    print("URL: $url");
    print("userDetailsData : ${userDetailsData.toJson().toString()}");
    try {
      response = await http
          .post(url, headers: header, body: jsonEncode(data))
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

  Future<dynamic> fetchProfileCategoryList() async {
    Map<String, String> header = {};

    header.putIfAbsent(
        "Authorization", () => "Token ${AppPreferences().token}");
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);

    String url =
        "${WebserviceConstants.baseURL}${WebserviceConstants.userDetailsURL}${WebserviceConstants.categoryListURL}";

    print("Value of Response fetchProfileCategoryList");
    final response =
        await helper.get(url, headers: header, isOAuthTokenNeeded: false);
    print("Value of Response statusCode ${response.statusCode}");

    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      print("Value of Response body${response.body}");
      print("Value of Response body data ${response.body}");
      Map<String, dynamic> jsonMapData = new Map();
      List<ProfileCategoryModel> profileCategoryList = [];

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
          ProfileCategoryModel tempData = ProfileCategoryModel.fromJson(data);
          profileCategoryList.add(tempData);
        });
        //print("countrywiseHealthcareProvidersList ${countrywiseHealthcareProvidersList[0].name}");
        return profileCategoryList;
      }
    }

    return BaseResponse().markAsErrorResponse();
  }

  Future<BaseResponse> addCategoryAndSubcategory(
      String categoryType, String subCategoryType) async {
    print(
        "categoryType  - ${categoryType} subCategoryType - ${subCategoryType}");
    print(
        "addCategoryAndSubcategory URL - ${WebserviceConstants.baseURL}${WebserviceConstants.userDetailsURL}${WebserviceConstants.categoryListURL}");
    Map<String, String> header = {};

    header.putIfAbsent(
        "Authorization", () => "Token ${AppPreferences().token}");
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);

    //  {"category_list":[{"category_type":"112", "subcategory_type":"222"}]}
    // {"category_type":[{"category_type":"Arts, crafts, and collectibles","subcategory_type":"Antiques"}]}

    Map data = {
      "category_list": [
        {
          'category_type': "$categoryType",
          'subcategory_type': "$subCategoryType"
        }
      ]
    };

    http.Response response;
    String url =
        "${WebserviceConstants.baseURL}${WebserviceConstants.userDetailsURL}${WebserviceConstants.categoryListURL}";
    BaseResponse respBase;

    print("Value of body of addCategoryAndSubcategory ${jsonEncode(data)}");

    try {
      response = await http
          .post(url, headers: header, body: jsonEncode(data))
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

  Future<BaseResponse> deleteCategoryAndSubcategory(
      String categoryType, String subCategoryType) async {
    Map<String, String> header = {};

    header.putIfAbsent(
        "Authorization", () => "Token ${AppPreferences().token}");
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);

    String url =
        "${WebserviceConstants.baseURL}${WebserviceConstants.userDetailsURL}${WebserviceConstants.categoryListURL}?${WebserviceConstants.profileCategoryTypeParam}$categoryType&${WebserviceConstants.profileSubcategoryTypeParam}$subCategoryType";

    print("Value of Response deleteCategoryAndSubcategory url $url");
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

  Future<int> updateFcmToken(String fcmToken, String deviceId) async {
    Map<String, String> header = {};

    header.putIfAbsent(
        "Authorization", () => "Token ${AppPreferences().token}");
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    http.Response response;
    String url =
        WebserviceConstants.baseURL + WebserviceConstants.addFcmTokenURL;
    BaseResponse respBase;
    print("URL: $url");
    Map<String, String> requestData = new Map<String, String>();

    requestData["device_token"] = fcmToken.toString();
    requestData["device_id"] = deviceId.toString();
    print("jsonEncode(requestData) ${jsonEncode(requestData)}");

    // print("userDetailsData : ${userDetailsData.toJson().toString()}");
    try {
      response = await http
          .post(url, headers: header, body: jsonEncode(requestData))
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

    print("Status after posting FCMToken ${respBase.status}");

    return respBase.status;
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
