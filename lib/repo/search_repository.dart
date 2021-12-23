import 'dart:convert';

import '../model/base_response.dart';
import '../model/non_member_search_request_model.dart';
import '../model/people_response.dart';
import '../model/user_search_request_model.dart';
import '../repo/common_repository.dart';
import '../utils/app_preferences.dart';
import '../utils/constants.dart';
import '../utils/validation_utils.dart';
import 'package:http/http.dart' as http;

class SearchRepository {
  SearchRepository();

  Future<dynamic> dynamicSearch(
      UserSearchRequestModel request,
      bool isFromDiabetesRiskScore,
      String departmentName,
      String membershipEntitlements,
      String tempMembershipStatus) async {
    Map<String, String> header = {};
    String username = await AppPreferences.getUsername();
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    header.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);
    // print(username);
    // print("==================> CLient${AppPreferences().clientId}");
    if (request.filterData == null) request.filterData = [];
    if (!isFromDiabetesRiskScore) {
      request.filterData.add(FilterData(
          columnName: "roleName",
          columnType: "STRING",
          columnValue: ["User"],
          filterType: "EQUAL"));
      if (membershipEntitlements == null ||
          membershipEntitlements == "" ||
          membershipEntitlements.isEmpty) {
      } else {
        request.filterData.add(FilterData(
            columnName: "membershipStatus",
            columnType: "STRING",
            columnValue: ['$membershipEntitlements'],
            filterType: Constants.EQUAL_OPERATOR));
      }
      if (tempMembershipStatus == null ||
          tempMembershipStatus == "" ||
          tempMembershipStatus.isEmpty) {
      } else {
        request.filterData.add(FilterData(
            columnName: "tempMembershipStatus",
            columnType: "STRING",
            columnValue: ['$tempMembershipStatus'],
            filterType: Constants.EQUAL_OPERATOR));
      }
    }
    /* if (isFromDiabetesRiskScore) {
      request.filterData.add(FilterData(
          columnName: "roleName",
          columnType: "STRING",
          columnValue: ["User"],
          filterType: "EQUAL"));
      request.filterData.add(
        FilterData(
            columnName: "hasMembership",
            columnType: "BOOLEAN",
            columnValue: ["false"],
            filterType: "EQUAL"),
      );
      */

    request.filterData.add(FilterData(
        columnName: "departmentName",
        columnType: "STRING",
        columnValue: [
          departmentName == '' ||
                  departmentName == null ||
                  departmentName.isEmpty
              ? AppPreferences().deptmentName
              : departmentName
        ],
        filterType: "EQUAL"));

    print(
        "URL : ${WebserviceConstants.baseAdminURL}${WebserviceConstants.dynamicSearch}");
    print("request : ${request.toJson().toString()}");
    final http.Response response = await http.post(
        "${WebserviceConstants.baseAdminURL}${WebserviceConstants.dynamicSearch}",
        body: json.encode(request),
        headers: header);
    print("Response body ${response.body}");
    if (ValidationUtils.isSuccessResponse(response.statusCode)) {
      Map<String, dynamic> jsonMapData = new Map();
      List<dynamic> jsonData;
      try {
        if (response.statusCode == 200) {
          //print("response data --> ${response.body}");
          jsonData = jsonDecode(response.body);
        } else {
          jsonData = [];
        }
        jsonMapData.putIfAbsent("peopleResponse", () => jsonData);
      } catch (_) {
        print("" + _);
      }

      if (jsonData != null) {
        PeopleResponse historyList = PeopleResponse.fromJson(jsonMapData);
        print("============>  Length is ${historyList.peopleResponse.length}");
        return historyList;
      }
    }
    return BaseResponse().markAsErrorResponse();
  }

  Future<dynamic> dynamicMembershipSearch(
      NonMemberSearchRequestModel request, bool isFromDiabetesRiskScore) async {
    Map<String, String> header = {};
    String username = await AppPreferences.getUsername();
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    header.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);
    if (request.filterData == null) request.filterData = [];
    if (!isFromDiabetesRiskScore) {
      request.filterData.add(NonMemberFilterData(
          columnName: "roleName",
          columnType: "STRING",
          columnValue: ["User"],
          filterType: "EQUAL"));
    }

    request.filterData.add(NonMemberFilterData(
        columnName: "departmentName",
        columnType: "STRING",
        columnValue: [AppPreferences().deptmentName],
        filterType: "EQUAL"));

    print(
        "URL : ${WebserviceConstants.baseFilingURL}${WebserviceConstants.dynamicMembershipSearch}");
    print("request : ${request.toJson().toString()}");
    final http.Response response = await http.post(
        "${WebserviceConstants.baseFilingURL}${WebserviceConstants.dynamicMembershipSearch}",
        body: json.encode(request),
        headers: header);
    print("Response body ${response.body}");
    if (ValidationUtils.isSuccessResponse(response.statusCode)) {
      Map<String, dynamic> jsonMapData = new Map();
      List<dynamic> jsonData;
      try {
        if (response.statusCode == 200) {
          //print("response data --> ${response.body}");
          jsonData = jsonDecode(response.body);
        } else {
          jsonData = [];
        }
        jsonMapData.putIfAbsent("peopleResponse", () => jsonData);
      } catch (_) {
        print("" + _);
      }

      if (jsonData != null) {
        PeopleResponse historyList = PeopleResponse.fromJson(jsonMapData);
        return historyList;
      }
    }
    return BaseResponse().markAsErrorResponse();
  }

  BaseResponse onMultiTimeOut() {
    BaseResponse appBaseResponse = BaseResponse(status: 500);
    //BaseResponse response = BaseResponse(jsonEncode(appBaseResponse), 500);
    return appBaseResponse;
  }

  /// Global Search
  Future<dynamic> dynamicGlobalSearch(
    UserSearchRequestModel request,
    bool isFromDiabetesRiskScore,
    String departmentName,
    String membershipEntitlements,
    String tempMembershipStatus,
  ) async {
    Map<String, String> header = {};
    String username = await AppPreferences.getUsername();
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    header.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);
    // print(username);
    // print("==================> CLient${AppPreferences().clientId}");
    if (request.filterData == null) request.filterData = [];
    if (!isFromDiabetesRiskScore) {
      request.filterData.add(FilterData(
          columnName: "roleName",
          columnType: "STRING",
          columnValue: ["User"],
          filterType: "EQUAL"));
      if (membershipEntitlements == null ||
          membershipEntitlements == "" ||
          membershipEntitlements.isEmpty) {
      } else {
        request.filterData.add(FilterData(
            columnName: "membershipStatus",
            columnType: "STRING",
            columnValue: ['$membershipEntitlements'],
            filterType: Constants.EQUAL_OPERATOR));
      }
      if (tempMembershipStatus == null ||
          tempMembershipStatus == "" ||
          tempMembershipStatus.isEmpty) {
      } else {
        request.filterData.add(FilterData(
            columnName: "tempMembershipStatus",
            columnType: "STRING",
            columnValue: ['$tempMembershipStatus'],
            filterType: Constants.EQUAL_OPERATOR));
      }
    }
    /* if (isFromDiabetesRiskScore) {
      request.filterData.add(FilterData(
          columnName: "roleName",
          columnType: "STRING",
          columnValue: ["User"],
          filterType: "EQUAL"));
      request.filterData.add(
        FilterData(
            columnName: "hasMembership",
            columnType: "BOOLEAN",
            columnValue: ["false"],
            filterType: "EQUAL"),
      );
      */

    request.filterData.add(FilterData(
        columnName: "departmentName",
        columnType: "STRING",
        columnValue: [
          departmentName == '' ||
                  departmentName == null ||
                  departmentName.isEmpty
              ? AppPreferences().deptmentName
              : departmentName
        ],
        filterType: "EQUAL"));

    print(
        "URL Global : ${WebserviceConstants.baseAdminURL}${WebserviceConstants.dynamicGlobalSearch}");
    print("request Global : ${request.toJson().toString()}");
    final http.Response response = await http.post(
        "${WebserviceConstants.baseAdminURL}${WebserviceConstants.dynamicGlobalSearch}",
        body: json.encode(request),
        headers: header);
    print("Response body Global ::: ${response.body}");
    if (ValidationUtils.isSuccessResponse(response.statusCode)) {
      Map<String, dynamic> jsonMapData = new Map();
      List<dynamic> jsonData;
      try {
        if (response.statusCode == 200) {
          //print("response data --> ${response.body}");
          jsonData = jsonDecode(response.body);
        } else {
          jsonData = [];
        }
        jsonMapData.putIfAbsent("peopleResponse", () => jsonData);
      } catch (_) {
        print("" + _);
      }

      if (jsonData != null) {
        PeopleResponse historyList = PeopleResponse.fromJson(jsonMapData);
        print("============>  Length is ${historyList.peopleResponse.length}");
        return historyList;
      }
    }
    return BaseResponse().markAsErrorResponse();
  }
}
