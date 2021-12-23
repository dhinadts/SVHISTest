import 'dart:convert';

import '../model/base_response.dart';
import '../model/filter_data.dart';
import '../model/notice_board_request.dart';
import '../model/notice_board_response.dart';
import '../model/notification_response.dart';
import '../repo/common_repository.dart';
import '../utils/app_preferences.dart';
import '../utils/validation_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class NotificationRepository {
  NotificationRepository();

  WebserviceHelper helper = WebserviceHelper();

  Future<dynamic> fetchNotificationList() async {
    Map<String, String> header = {};
    String username = await AppPreferences.getUsername();
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    header.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);
    final response = await helper.get(
        WebserviceConstants.baseSenderURL + WebserviceConstants.message,
        headers: header,
        isOAuthTokenNeeded: false);

    // debugPrint("status code -- ${response.statusCode}");

    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE ||
        response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE_2) {
      Map<String, dynamic> jsonMapData = new Map();
      List<dynamic> jsonData;
      try {
        jsonData = jsonDecode(response.body);
        jsonMapData.putIfAbsent("notificationList", () => jsonData);
      } catch (_) {
//        print("" + _);
      }

      if (jsonData != null) {
        NotificationResponse historyList =
            NotificationResponse.fromJson(jsonMapData);
        return historyList;
      }
    }

    return BaseResponse().markAsErrorResponse();
  }

  Future<BaseResponse> updateAcknowledgeStatus(
      String msgId, String msgStatus) async {
    var request = new http.MultipartRequest(
        "PUT",
        Uri.parse(WebserviceConstants.baseSenderURL +
            WebserviceConstants.acknowledgedURL +
            msgId));
    request.headers["username"] = AppPreferences().username;
    request.fields["message_status"] = msgStatus;
    http.StreamedResponse response;
    String responseString = "";
    BaseResponse respUser = BaseResponse();
    try {
      response = await request.send();
      responseString = await response.stream.bytesToString();
      Map<String, dynamic> obj = json.decode(responseString);
      respUser = BaseResponse.fromJson(obj);
      respUser.status = response.statusCode;
      respUser.message = responseString;
    } catch (e) {
      respUser = onMultiTimeOut();
      respUser.message = responseString;
      respUser.status = response.statusCode;
    }

    return respUser;
  }

  BaseResponse onMultiTimeOut() {
    BaseResponse appBaseResponse = BaseResponse(status: 500);
    //BaseResponse response = BaseResponse(jsonEncode(appBaseResponse), 500);
    return appBaseResponse;
  }

  /*
  *
  * API Call for notification get
  * */
  Future<dynamic> fetchNewNotificationList(int pageNo,
      {String filterType}) async {
    Map<String, String> header = {};
    String username = await AppPreferences.getUsername();
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    header.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);
    NoticeBoardRequest request = NoticeBoardRequest();
    request.dateFilter = "LAST_ONE_WEEK";
    request.currentPage = pageNo;
    request.pageSize = 20;
    FilterData data = FilterData();
    data.columnName = "departmentName";
    data.columnValue = [AppPreferences().deptmentName];
    data.columnType = "STRING";
    data.filterType = "EQUAL";
    if (request.filterData == null) {
      request.filterData = List();
    }
    request.filterData.add(data);

//If role is user add one more filter data to request
    if (AppPreferences().role != "Supervisor") {
      FilterData data = FilterData();
      data.columnName = 'userName';
      data.columnValue = [AppPreferences().username];
      data.columnType = "STRING";
      data.filterType = "EQUAL";
      if (request.filterData == null) {
        request.filterData = List();
      }
      request.filterData.add(data);
    }
    if (filterType != null && filterType != "All") {
      FilterData data1 = FilterData();
      data1.columnName = "type";
      data1.columnValue = [filterType];
      data1.columnType = "STRING";
      data1.filterType = "EQUAL";
      request.filterData.add(data1);
    }
    Map<String, dynamic> jsonBody = request.toJson();
    String pageDataStr = await AppPreferences.getPageData();

    if (pageDataStr != null && pageDataStr != "") {
      jsonBody.putIfAbsent("pageData", () => json.decode("$pageDataStr"));
    }
    NoticeBoardResponse notificationList = NoticeBoardResponse();
    notificationList.status = 500;
    final response = await http.post(
        WebserviceConstants.baseSenderURL +
            WebserviceConstants.message +
            "page",
        headers: header,
        body: jsonEncode(jsonBody));

    if (ValidationUtils.isSuccessResponse(response.statusCode)) {
      Map<String, dynamic> jsonData = new Map();
//      List<dynamic> jsonData;
      try {
        jsonData = jsonDecode(response.body);
        // print("response.body ${response.body}");
        // jsonMapData.putIfAbsent("notificationList", () => jsonData);
        String pageData = json.encode(jsonData["pageData"]);
        await AppPreferences.setPageData(pageData);
      } catch (_) {
//        print("" + _);
      }

      if (jsonData != null) {
        notificationList = NoticeBoardResponse.fromJson(jsonData);
        // print("${notificationList.toJson()}");
        notificationList.status = response.statusCode;
        return notificationList;
      }
    }

    return notificationList;
  }
}
