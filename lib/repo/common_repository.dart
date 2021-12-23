import 'dart:convert';

import '../model/base_response.dart';
import '../model/check_in_dynamic_response.dart';
import '../model/dynamic_fields_new_response.dart';
import '../model/dynamic_fields_reponse.dart';
import '../model/people.dart';
import '../model/people_response.dart';
import '../model/request_model_group_entity.dart';

import '../ui/custom_drawer/remainders_list_data.dart';
import '../utils/app_preferences.dart';
import '../utils/validation_utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class CommonRepository {
  CommonRepository();

  WebserviceHelper helper = WebserviceHelper();

  Future<dynamic> fetchHistoryDynamicList(String username, String dept) async {
    Map<String, String> header = {};
    //String username = await AppPreferences.getUsername();
    String accessToken = await AppPreferences.getJWTToken();
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    // header.putIfAbsent(
    //     WebserviceConstants.authorization, () => "Bearer" + accessToken);
    final response = await helper.get(
        WebserviceConstants.baseAdminURL +
            WebserviceConstants.historyDynamicURL +
            "?${WebserviceConstants.usernameParam}$username&${WebserviceConstants.departmentNameParam}$dept",
        headers: header,
        isOAuthTokenNeeded: false);
    // print(
    //     "UROL ${WebserviceConstants.baseAdminURL + WebserviceConstants.historyDynamicURL + "?${WebserviceConstants.usernameParam}$username&${WebserviceConstants.departmentNameParam}$dept"}");
    if (ValidationUtils.isSuccessResponse(response.statusCode)) {
      DynamicFieldsNewResponse dynamicList =
          DynamicFieldsNewResponse.fromJson(jsonDecode(response.body));
      List<DynamicFieldsResponse> dynamicFieldsList;
      if (dynamicList.HealthCare != null && dynamicList.HealthCare.isNotEmpty) {
        dynamicFieldsList = dynamicList.HealthCare;
      } else if (dynamicList.DATTApp != null &&
          dynamicList.DATTApp.isNotEmpty) {
        dynamicFieldsList = dynamicList.DATTApp;
      } else {
        dynamicFieldsList = dynamicList.WorkForce ?? List();
      }
      return dynamicFieldsList;
    } else {
      print(
          "History dynamic failed Http ${response.statusCode} \n Body ${response.body}");
    }
    return BaseResponse().markAsErrorResponse();
  }

  Future<dynamic> fetchCheckInDynamicList(People people) async {
    Map<String, String> header = {};
    String dptName =
        people.departmentName ?? await AppPreferences.getDeptName();
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => people.userName);
    header.putIfAbsent(WebserviceConstants.username, () => people.userName);
    header.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);
    final response = await helper.get(
        WebserviceConstants.baseAdminURL +
            WebserviceConstants.checkInDynamicURL +
            "?${WebserviceConstants.usernameParam}${people.userName}&${WebserviceConstants.departmentNameParam}$dptName",
        headers: header,
        isOAuthTokenNeeded: false);

    //print("response --> ${response.body}");

    if (ValidationUtils.isSuccessResponse(response.statusCode)) {
      Map<String, dynamic> jsonMapData = new Map();
      List<dynamic> jsonData;
      try {
        jsonData = jsonDecode(response.body);
        jsonMapData.putIfAbsent("checkInList", () => jsonData);
      } catch (_) {
        print("" + _);
      }

      if (jsonData != null) {
        CheckInDynamicResponse checkInDynamicList =
            CheckInDynamicResponse.fromJson(jsonMapData);
        return checkInDynamicList;
      }
    }

    return List();
  }

  Future<List<RemaindersListData>> getWishesList() async {
    Map<String, String> header = await WebserviceConstants.createHeader();
    String dptName = await AppPreferences.getDeptName();

    if (dptName == null || dptName == "") {
      remaindersListData = null;
      return remaindersListData;
    } else {
      final response = await http.get(
        "${WebserviceConstants.baseAdminURL}${WebserviceConstants.wishAnniversaryURL}$dptName",
        // "https://qa.servicedx.com/admin/Anniversary/remainder/TodaysUpdateByDepartment/$dptName",
        headers: header,
      );
      debugPrint("response.statusCode :::  ${response.statusCode}");
      if (response.statusCode > 199 && response.statusCode < 299) {
        List<dynamic> data = jsonDecode(response.body);
        List<RemaindersListData> meals =
            data.map((data) => RemaindersListData.fromJson(data)).toList();
        remaindersListData = meals;
        return remaindersListData;
      } else
        return [];
    }
  }

  Future<bool> updateWishesList(RemaindersListData sampledata,
      String anniversaryRemaindersId, String msg, String usrName) async {
    Map<String, String> header = {};
    Map postData;

    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);
    // header.putIfAbsent(
    //     WebserviceConstants.username, () => AppPreferences().username);

    if (anniversaryRemaindersId == null || anniversaryRemaindersId == "") {
      return false;
    } else {
      postData = {
        "active": true,
        "anniversaryRemaindersId": "${sampledata.anniversaryRemaindersId}",
        // "createdBy": "${sampledata.createdBy}",
        // "createdOn": sampledata.createdOn,
        "departmentName": sampledata.departmentName,
        "emailId": sampledata.emailId,
        "firstName": sampledata.firstName,
        "lastName": sampledata.lastName,
        "messageInfo": {
          "wishesList": [
            {"message": msg, "userName": usrName}
          ]
        },
        // "modifiedBy": sampledata.modifiedBy,
        // "modifiedOn": sampledata.modifiedOn,
        "occasionalDate": sampledata.occasionalDate,
        "occasionalType": sampledata.occasionalType,
        "phoneNo": sampledata.phoneNo,
        "profilePic": sampledata.profilePic,
        "userName": sampledata.userName
      };

      print(
        "${WebserviceConstants.baseAdminURL}${WebserviceConstants.updateAnniversary}$anniversaryRemaindersId",
      );
      final response = await http.put(
          "${WebserviceConstants.baseAdminURL}${WebserviceConstants.updateAnniversary}$anniversaryRemaindersId",
          // /Anniversary/remainder/{id}
          headers: header,
          body: jsonEncode(postData));

      if (response.statusCode > 199 && response.statusCode < 299) {
        var data = jsonDecode(response.body);
        print(data);
        return true;
      } else {
        return false;
      }

      /* if (data["errorCode"] != null) {
        return false;
      } else {
        return true;
      } */
    }
  }

  Future<dynamic> fetchCheckInGroupEntityDynamicList(People people) async {
    Map<String, String> header = {};
    String dptName = await AppPreferences.getDeptName();
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => people.userName);
    header.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);
    final response = await helper.get(
        WebserviceConstants.baseAdminURL +
            WebserviceConstants.checkInGrpEntityDynamicURL +
            "?${WebserviceConstants.usernameParam}${people.userName}&${WebserviceConstants.departmentNameParam}$dptName",
        headers: header,
        isOAuthTokenNeeded: false);

    //print("response --> ${response.body}");

    if (ValidationUtils.isSuccessResponse(response.statusCode)) {
      Map<String, dynamic> jsonMapData = new Map();
      List<dynamic> jsonData;
      try {
        jsonMapData = jsonDecode(response.body);
      } catch (_) {
        print("" + _.toString());
      }

      if (jsonMapData != null) {
        RequestModelGroupEntity requestModelGroupEntity =
            RequestModelGroupEntity.fromJson(jsonMapData);
        return requestModelGroupEntity;
      }
    }

    return List();
  }

  Future<dynamic> fetchCheckInDynamicById(
      String departmentName, String userName, String id) async {
    Map<String, String> header = {};
    String dptName = departmentName ?? await AppPreferences.getDeptName();
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => userName);
    header.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);
    final response = await helper.get(
        WebserviceConstants.baseAdminURL +
            WebserviceConstants.checkInDynamicURL +
            "/$id" +
            "?${WebserviceConstants.usernameParam}$userName&${WebserviceConstants.departmentNameParam}$dptName&id=$id",
        headers: header,
        isOAuthTokenNeeded: false);
    if (ValidationUtils.isSuccessResponse(response.statusCode)) {
      DynamicFieldsNewResponse dynamicList =
          DynamicFieldsNewResponse.fromJson(jsonDecode(response.body));
      List<DynamicFieldsResponse> dynamicFieldsList;
      if (dynamicList.HealthCare != null && dynamicList.HealthCare.isNotEmpty) {
        dynamicFieldsList = dynamicList.HealthCare;
      } else if (dynamicList.DATTApp != null &&
          dynamicList.DATTApp.isNotEmpty) {
        dynamicFieldsList = dynamicList.DATTApp ?? List();
      } else {
        dynamicFieldsList = dynamicList.WorkForce ?? List();
      }
      return dynamicFieldsList;
    }
    return BaseResponse().markAsErrorResponse();
  }

  Future<dynamic> fetchPeopleList(
      {String searchUsernameString, bool onlyPrimary}) async {
    String deptName = await AppPreferences.getDeptName();
    Map<String, String> header = await WebserviceConstants.createHeader();
    Map<String, String> data = {};

    String url =
        "${WebserviceConstants.baseCommonURL}${WebserviceConstants.peopleListURL}?${WebserviceConstants.departmentNameParam}$deptName";
    if (searchUsernameString != null && searchUsernameString.isNotEmpty) {
      url =
          "${WebserviceConstants.baseCommonURL}${WebserviceConstants.peopleListURL}?${WebserviceConstants.departmentNameParam}$deptName&${WebserviceConstants.usernameParam}%25$searchUsernameString%25";
    }
    if (onlyPrimary) {
      url = (url + "&user_relation=PRIMARY");
    }
    final response =
        await helper.get(url, headers: header, isOAuthTokenNeeded: false);

    if (ValidationUtils.isSuccessResponse(response.statusCode)) {
      Map<String, dynamic> jsonMapData = new Map();
      List<dynamic> jsonData;
      try {
        jsonData = jsonDecode(response.body);
        jsonMapData.putIfAbsent("peopleResponse", () => jsonData);
      } catch (_) {
        print("" + _);
      }

      if (jsonData != null) {
        PeopleResponse peopleList = PeopleResponse.fromJson(jsonMapData);
        return peopleList;
      }
    }

    return BaseResponse().markAsErrorResponse();
  }

  Future<dynamic> fetchSearchPeopleList(
      String state,
      String city,
      String pinCode,
      String date,
      String relationShip,
      String lastReportedDate) async {
    //String deptName = await AppPreferences.getDeptName();
    Map<String, String> header = await WebserviceConstants.createHeader();
    //Map<String, String> data = {};

    final response = await helper.get(
        "${WebserviceConstants.baseCommonURL}${WebserviceConstants.searchPeopleListURL1}/${AppPreferences().deptmentName}${WebserviceConstants.searchPeopleListURL2}?${WebserviceConstants.stateParam}$state&${WebserviceConstants.cityParam}$city&${WebserviceConstants.zipCodeParam}$pinCode&${WebserviceConstants.createdDateParam}$date&${WebserviceConstants.userRelationParam}$relationShip&${WebserviceConstants.lastReportedDate}$lastReportedDate",
        headers: header,
        isOAuthTokenNeeded: false);

    if (ValidationUtils.isSuccessResponse(response.statusCode)) {
      Map<String, dynamic> jsonMapData = new Map();
      List<dynamic> jsonData;
      try {
        print("response data --> ${response.body}");
        jsonData = jsonDecode(response.body);
        jsonMapData.putIfAbsent("peopleResponse", () => jsonData);
      } catch (_) {
        print("" + _);
      }

      if (jsonData != null) {
        PeopleResponse peopleList = PeopleResponse.fromJson(jsonMapData);
        return peopleList;
      }
    }

    return BaseResponse().markAsErrorResponse();
  }

  Future<dynamic> fetchSecondaryUserList(String parentUserName,
      String departmentName, bool isFromAddUserFamily) async {
    String username = await AppPreferences.getUsername();
    Map<String, String> header = {};
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    http.Response response;
    debugPrint("isFromAddUserFamily --> $isFromAddUserFamily");
    if (isFromAddUserFamily) {
      response = await helper.get(
          "${WebserviceConstants.baseCommonURL}${WebserviceConstants.peopleListURL}?${WebserviceConstants.departmentNameParam}$departmentName&${WebserviceConstants.parentUserNameParam}$parentUserName",
          headers: header,
          isOAuthTokenNeeded: false);
    } else {
      response = await helper.get(
          "${WebserviceConstants.baseCommonURL}${WebserviceConstants.peopleListURL}?${WebserviceConstants.departmentNameParam}$departmentName&${WebserviceConstants.parentUserNameParam}$parentUserName&with_primary=true",
          headers: header,
          isOAuthTokenNeeded: false);
    }

    //}

    if (ValidationUtils.isSuccessResponse(response.statusCode)) {
      Map<String, dynamic> jsonMapData = new Map();
      List<dynamic> jsonData;
      try {
        jsonData = jsonDecode(response.body);
        jsonMapData.putIfAbsent("peopleResponse", () => jsonData);
      } catch (_) {
        print("" + _.toString());
      }

      if (jsonData != null) {
        PeopleResponse peopleList = PeopleResponse.fromJson(jsonMapData);
        return peopleList;
      }
    }

    return BaseResponse().markAsErrorResponse();
  }
}

class WebserviceHelper {
  // next three lines makes this class a Singleton
  static WebserviceHelper _instance = WebserviceHelper.internal();

  static const int WEB_SUCCESS_STATUS_CODE = 200;
  static const int WEB_SUCCESS_STATUS_CODE_2 = 201;
  static const int WEB_ERROR_STATUS_CODE = 500;

  WebserviceHelper.internal();

  factory WebserviceHelper() => _instance;

  /// Get API call
  Future<http.Response> get(String url,
      {Map<String, String> headers, bool isOAuthTokenNeeded = true}) async {
    print("\n URL $url");
    print("Header $headers");
    final http.Response response = await http
        .get(url, headers: headers)
        .timeout(
            Duration(seconds: WebserviceConstants.apiServiceTimeOutInSeconds),
            onTimeout: _onTimeOut);
    return response;
  }

  http.Response _onTimeOut() {
    BaseResponse appBaseResponse = BaseResponse(status: 500);
    http.Response response = http.Response(jsonEncode(appBaseResponse), 500);
    return response;
  }
}

class WebserviceConstants {
  static const contentType = "Content-Type";
  static const applicationJson = "application/json; charset=utf-8";
  static const multipartForm = "multipart/form-data";
  static const webServerError = "error";
  static const success = "success";
  static const username = "username";
  static const password = "password";
  static const formDataUrlEncoded = "application/x-www-form-urlencoded";
  static const authorization = "Authorization";
  static const bearer = "Bearer ";
  static const clientId = "clientid";
  static const name = "name";
  static const departmentNameParam = "department_name=";
  static const contactDate = "contact_date=";
  static const usernameParam = "user_name=";
  static const cityParam = "city=";
  static const stateParam = "state=";
  static const zipCodeParam = "zipcode=";
  static const createdDateParam = "created_date=";
  static const userRelationParam = "user_relation=";
  static const lastReportedDate = "last_reported_date=";
  static const parentUserNameParam = "parent_user_name=";
  static const xAuthToken = "x-auth-token";
  static const emailParam = "email=";
  static const nameParam = "name=";
  static const totalParam = "total=";
  static const paymentDescriptionParam = "payment_description=";
  static const userFullNameParam = "user_full_name=";
  static const phoneParam = "phone=";

  static const int apiServiceTimeOutInSeconds = 60;
  static String baseAdminURL = "${AppPreferences().apiURL}/admin";
  static String baseSenderURL = "${AppPreferences().apiURL}/sender";
  static String baseCommonURL = "${AppPreferences().apiURL}/admin/sdxcontact";
  static String baseAppointmentURL = "${AppPreferences().apiURL}/isd";

  static String baseURL = AppPreferences().apiURL;
  static String baseFilingURL = "${AppPreferences().apiURL}/filing";
  static String baseEventFeedURL = "${AppPreferences().apiURL}/eventfeed";
  static String tenant = AppPreferences().tenant;
  static const String loginURL = "/api/login";
  static const String getSubscription = "/subscription/subscriptions";

  static const String dynamicSearch = "/users/dynamicsearch";
  static const String dynamicGlobalSearch = "/users/dynamicglobalsearch";
  static const String dynamicMembershipSearch = "/members/dynamicsearch";
  static const String historyDynamicURL = "/history";
  static const String checkInDynamicURL = "/checkin";
  static const String wishAnniversaryURL =
      "/Anniversary/remainder/TodaysUpdateByDepartment/";
  static const String updateAnniversary = "/Anniversary/remainder/";
  static const String checkInGrpEntityDynamicURL =
      "/grpentity/temp"; //grpentity/temp
  static const String physicianURL = "/physicians";
  static const String peopleListURL = "/users";
  static const String CreateURL = "/departments/";
  static const String acknowledgedURL = "/messages/ackstatus/";
  static const String setPasswordURL = "/users/setPassword";
  static const String forgotUsernameURL = "/users/forgotUsername/";
  static const String message = "/messages/";
  static const String zipCode = "/zipcode/";
  static const String groupEntity = "/grpentity/temp";
  static const String searchPeopleListURL1 = "/users";
  static const String searchPeopleListURL2 = "/search";

  static const String checkInReminderScheduler =
      "/scheduler/schedulers/department";

  static const String addDiagnosisDependents = "/diagnosis";
  static const String getVitalSigns = "/vitalsign";
  static const String committeeURL = "/committee";

  static const String healthQuestionnaireHistoryURL =
      "/covid/symptoms-questionnaire";

  static const String getDiagnosisReport = "/diagnosis";
  static const String healthScore = "/health/score";
  static const String departments = "/departments/";
  static const String users = "/users/";
  static const departmentName = "department_name";
  static String baseNotesURL = "${AppPreferences().apiURL}/notes";

  static String environmentDataDynamic = '/environment-data/dynamic';

  /// Recording links
  static const String startRecord = "/recording/start";
  static const String stopRecord = "/recording/stop";

  static reloadEnv() {
    baseAdminURL = "${AppPreferences().apiURL}/admin";
    baseSenderURL = "${AppPreferences().apiURL}/sender";
    baseCommonURL = "${AppPreferences().apiURL}/admin/sdxcontact";
    baseAppointmentURL = "${AppPreferences().apiURL}/isd";
    baseNotesURL = "${AppPreferences().apiURL}/notes";
    baseFilingURL = "${AppPreferences().apiURL}/filing";
    baseEventFeedURL = "${AppPreferences().apiURL}/eventfeed";

    baseURL = AppPreferences().apiURL;
    tenant = AppPreferences().tenant;
  }

  static Future<Map<String, String>> createHeader({String userName}) async {
    Map<String, String> header = {};
    String username = userName ?? await AppPreferences.getUsername();
    String clientId = await AppPreferences.getClientId();
    String departmentName = await AppPreferences.getDeptName();
    String jwtToken = await AppPreferences.getJWTToken();
    String tenant = await AppPreferences.getTenant();
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    header.putIfAbsent(WebserviceConstants.clientId, () => clientId);
    header.putIfAbsent(WebserviceConstants.tenant, () => tenant);
    header.putIfAbsent(
        WebserviceConstants.departmentName, () => departmentName);
    if (jwtToken != null) {
      header.putIfAbsent(
          WebserviceConstants.authorization, () => "Bearer " + jwtToken);
    }
    return header;
  }
}
