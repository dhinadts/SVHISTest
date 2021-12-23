import 'dart:convert';
import 'dart:io';
import '../../../login/preferences/user_preference.dart';
import '../model/base_response.dart';
import '../../../utils/app_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'nmb2b_repository.dart';

class ItemsListRepository {
  ItemsListRepository();

  WebserviceHelper helper = WebserviceHelper();

  Future<dynamic> fetchItemsList() async {
    Map<String, String> header = {};
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);

    String url =
        "${WebserviceConstants.baseURL}${WebserviceConstants.itemsListURL}";

    print("Value of Response fetchItemsList");
    final response =
        await helper.get(url, headers: header, isOAuthTokenNeeded: false);
    print("Value of Response statusCode ${response.statusCode}");

    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      print("Value of Response body${response.body}");
      print("Value of Response body data ${response.body}");
      Map<String, dynamic> jsonMapData = new Map();
      List<String> itemsList = [];

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
          itemsList.add(data);
        });
        //print("countrywiseHealthcareProvidersList ${countrywiseHealthcareProvidersList[0].name}");
        return itemsList;
      }
    }

    return BaseResponse().markAsErrorResponse();
  }

  Future<dynamic> fetchCountyList() async {
    Map<String, String> header = {};
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);

    String url =
        "${WebserviceConstants.baseURL}${WebserviceConstants.countyListURL}";

    print("Value of Response fetchCountyList");
    final response =
        await helper.get(url, headers: header, isOAuthTokenNeeded: false);
    print("Value of Response statusCode ${response.statusCode}");

    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      print("Value of Response body${response.body}");
      print("Value of Response body data ${response.body}");
      Map<String, dynamic> jsonMapData = new Map();
      List<String> countyList = [];

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
          countyList.add(data);
        });
        //print("countrywiseHealthcareProvidersList ${countrywiseHealthcareProvidersList[0].name}");
        return countyList;
      }
    }

    return BaseResponse().markAsErrorResponse();
  }

  Future<dynamic> fetchStateList() async {
    Map<String, String> header = {};
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);

    String url =
        "${WebserviceConstants.baseURL}${WebserviceConstants.stateListURL}";

    print("Value of Response fetchStateList");
    final response =
        await helper.get(url, headers: header, isOAuthTokenNeeded: false);
    print("Value of Response statusCode ${response.statusCode}");

    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      print("Value of Response body${response.body}");
      print("Value of Response body data ${response.body}");
      Map<String, dynamic> jsonMapData = new Map();
      List<String> stateList = [];

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
          stateList.add(data);
        });
        //print("countrywiseHealthcareProvidersList ${countrywiseHealthcareProvidersList[0].name}");
        return stateList;
      }
    }

    return BaseResponse().markAsErrorResponse();
  }

  Future<dynamic> fetchItemRelatedTagList(String itemName) async {
    Map<String, String> header = {};

    header.putIfAbsent(
        "Authorization", () => "Token ${AppPreferences().token}");
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);

    String url =
        "${WebserviceConstants.baseURL}${WebserviceConstants.itemRelatedTagsURL}?${WebserviceConstants.itemNameParam}$itemName";

    print("Value of Response fetchItemRelatedTagList");
    final response =
        await helper.get(url, headers: header, isOAuthTokenNeeded: false);
    print("Value of Response statusCode ${response.statusCode}");

    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      print("Value of Response body${response.body}");
      print("Value of Response body data ${response.body}");
      Map<String, dynamic> jsonMapData = new Map();
      String itemRelatedTagList;

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
        itemRelatedTagList = jsonMapData["data"];
        //print("countrywiseHealthcareProvidersList ${countrywiseHealthcareProvidersList[0].name}");
        return itemRelatedTagList;
      }
    }

    return BaseResponse().markAsErrorResponse();
  }

  Future<dynamic> fetchCategoryList() async {
    Map<String, String> header = {};
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);

    String url =
        "${WebserviceConstants.baseURL}${WebserviceConstants.categoryListURL}";

    print("Value of Response fetchCategoryList");
    final response =
        await helper.get(url, headers: header, isOAuthTokenNeeded: false);
    print("Value of Response statusCode ${response.statusCode}");

    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      print("Value of Response body${response.body}");
      print("Value of Response body data ${response.body}");
      Map<String, dynamic> jsonMapData = new Map();
      List<String> categoryList = [];

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
          categoryList.add(data);
        });
        //print("countrywiseHealthcareProvidersList ${countrywiseHealthcareProvidersList[0].name}");
        return categoryList;
      }
    }

    return BaseResponse().markAsErrorResponse();
  }

  Future<dynamic> fetchSubCategoryList(String categoryType) async {
    Map<String, String> header = {};

    header.putIfAbsent(
        "Authorization", () => "Token ${AppPreferences().token}");
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);

    String url =
        "${WebserviceConstants.baseURL}${WebserviceConstants.subCategoryListURL}?${WebserviceConstants.categoryTypeParam}$categoryType";

    print("Value of Response fetchSubCategoryList");
    final response =
        await helper.get(url, headers: header, isOAuthTokenNeeded: false);
    print("Value of Response statusCode ${response.statusCode}");

    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      print("Value of Response body${response.body}");
      print("Value of Response body data ${response.body}");
      Map<String, dynamic> jsonMapData = new Map();
      List<String> subCategoryList = [];

      // var listData = response.body.

      // List<dynamic> jsonData;
      try {
        jsonMapData = json.decode(response.body);
        //jsonData = jsonDecode(response.body[0]);
        print("Pranay jsonMapData for Subcategory ${jsonMapData["data"]}");
      } catch (e) {
        print("" + e.toString());
      }

      if (jsonMapData != null) {
        jsonMapData["data"].forEach((data) {
          subCategoryList.add(data);
        });
        //print("countrywiseHealthcareProvidersList ${countrywiseHealthcareProvidersList[0].name}");
        return subCategoryList;
      }
    }

    return BaseResponse().markAsErrorResponse();
  }
}
