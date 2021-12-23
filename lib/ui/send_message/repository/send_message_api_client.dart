import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../repo/common_repository.dart';
import '../../../utils/app_preferences.dart';
import '../../../utils/constants.dart';
import '../model/committee_info.dart';
import '../model/contact_info.dart';
import '../model/contact_search_request.dart';
import '../model/group_info.dart';
import '../model/group_search_request.dart';

class SendMessageApiClient {
  final http.Client httpClient;

  SendMessageApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<ContactInfo>> getContactsList() async {
    String deptName = await AppPreferences.getDeptName();
    String userName = await AppPreferences.getUsername();
    List<ContactInfo> contactList;
    final url = WebserviceConstants.baseSenderURL +
        "/contacts?department_name=" +
        "$deptName";
    Map<String, String> header = await createHeader(
      userName: userName,
      departmentName: deptName,
    );
    http.Response response = await this.httpClient.get(url, headers: header);
    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      List<dynamic> data = jsonDecode(response.body);
      contactList = data.map((data) => ContactInfo.fromJson(data)).toList();
      return contactList;
    } else {
      return [];
    }
  }

  Future<List<CommitteeInfo>> getCommitteeList() async {
    String deptName = await AppPreferences.getDeptName();
    String userName = await AppPreferences.getUsername();
    List<CommitteeInfo> committeeList;
    String url;
    if (AppPreferences().role == Constants.supervisorRole) {
      url = WebserviceConstants.baseAdminURL +
          "/committee?department_name=" +
          "$deptName";
    } else {
      url = WebserviceConstants.baseAdminURL +
          "/committee/members?department_name=" +
          "$deptName" +
          "&user_name=" +
          "${userName}";
    }

    Map<String, String> header = await createHeader(
      userName: userName,
      departmentName: deptName,
    );
    http.Response response = await this.httpClient.get(url, headers: header);
    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      List<dynamic> data = jsonDecode(response.body);
      // print(data);
      committeeList = data.map((data) => CommitteeInfo.fromJson(data)).toList();
      return committeeList;
    } else {
      return [];
    }
  }

  Future<List<ContactInfo>> getSearchContactsList(String searchStr) async {
    List<ContactInfo> contactList;
    ContactSearchRequest request = ContactSearchRequest();
    request.filterData = [];
    request.entity = "Contact";

    Map<String, String> header = {};
    String username = await AppPreferences.getUsername();
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);

    if (searchStr != null && searchStr.trim().isNotEmpty) {
      request.filterData.add(ContactsFilterData(
          columnName: "contactName",
          columnType: "STRING",
          columnValue: ['%$searchStr%'],
          filterType: Constants.LIKE_OPERATOR));
    }

    request.filterData.add(
      ContactsFilterData(
          columnName: "departmentName",
          columnType: "STRING",
          columnValue: [AppPreferences().deptmentName],
          filterType: "EQUAL"),
    );

    debugPrint("request body --> ${request.toJson()}");

    final url = WebserviceConstants.baseSenderURL + "/contacts/dynamicsearch";
    http.Response response = await this
        .httpClient
        .post(url, headers: header, body: json.encode(request));
    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      List<dynamic> data = jsonDecode(response.body);
      contactList = data.map((data) => ContactInfo.fromJson(data)).toList();
      return contactList;
    } else {
      return [];
    }
  }

  Future<List<GroupInfo>> getGroupList() async {
    String deptName = await AppPreferences.getDeptName();
    String userName = await AppPreferences.getUsername();
    List<GroupInfo> groupList;
    final url = WebserviceConstants.baseSenderURL +
        "/groups?department_name=" +
        "$deptName";
    Map<String, String> header = await createHeader(
      userName: userName,
      departmentName: deptName,
    );
    http.Response response = await this.httpClient.get(url, headers: header);
    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      List<dynamic> data = jsonDecode(response.body);
      groupList = data.map((data) => GroupInfo.fromJson(data)).toList();
      return groupList;
    } else {
      return [];
    }
  }

  Future<List<GroupInfo>> getSearchGroupList(String searchStr) async {
    List<GroupInfo> groupList;
    GroupSearchRequest request = GroupSearchRequest();
    request.filterData = [];
    request.entity = "Group";

    Map<String, String> header = {};
    String username = await AppPreferences.getUsername();
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);

    if (searchStr != null && searchStr.trim().isNotEmpty) {
      request.filterData.add(GroupFilterData(
          columnName: "groupName",
          columnType: "STRING",
          columnValue: ['%$searchStr%'],
          filterType: Constants.LIKE_OPERATOR));
    }

    request.filterData.add(
      GroupFilterData(
          columnName: "departmentName",
          columnType: "STRING",
          columnValue: [AppPreferences().deptmentName],
          filterType: "EQUAL"),
    );

    final url = WebserviceConstants.baseSenderURL + "/group/dynamicsearch";
    http.Response response = await this
        .httpClient
        .post(url, headers: header, body: json.encode(request));
    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      List<dynamic> data = jsonDecode(response.body);
      groupList = data.map((data) => GroupInfo.fromJson(data)).toList();
      return groupList;
    } else {
      return [];
    }
  }

  Future<List<CommitteeInfo>> getCommitteeSearchList(String searchStr) async {
    List<CommitteeInfo> committeeList;
    CommitteeSearchRequest request = CommitteeSearchRequest();
    request.filterData = [];
    request.entity = "Committee";
    Map<String, String> header = {};
    String username = await AppPreferences.getUsername();

    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);

    if (searchStr != null && searchStr.trim().isNotEmpty) {
      request.filterData.add(CommitteeFilterData(
          columnName: "committeeName",
          columnType: "STRING",
          columnValue: ['%$searchStr%'],
          filterType: Constants.LIKE_OPERATOR));
    }

    request.filterData.add(
      CommitteeFilterData(
          columnName: "departmentName",
          columnType: "STRING",
          columnValue: [AppPreferences().deptmentName],
          filterType: "EQUAL"),
    );

    final url = WebserviceConstants.baseAdminURL + "/committee/dynamicsearch";
    http.Response response =
        await http.post(url, headers: header, body: json.encode(request));
    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      List<dynamic> data = jsonDecode(response.body);
      // print("================================> ${response.body}");
      committeeList = data.map((data) => CommitteeInfo.fromJson(data)).toList();
      return committeeList;
    } else {
      // print(response.body);
      return [];
    }
  }

  Future<dynamic> sendMessage({@required Map messageData}) async {
    String deptName = await AppPreferences.getDeptName();
    String userName = await AppPreferences.getUsername();

    final url = WebserviceConstants.baseSenderURL + "/messages/sendMessage";
    Map<String, String> header = await createHeader(
      userName: userName,
      departmentName: deptName,
    );
    http.Response response = await this
        .httpClient
        .post(url, headers: header, body: json.encode(messageData));
    debugPrint("response --> ${response.body}");
    return response;
  }

  Future<dynamic> sendMessageWithAttachments(
      {@required Map messageData,
      @required List<PlatformFile> attachments}) async {
    final url = WebserviceConstants.baseSenderURL + "/messages/attachments";

    final messageWithUploadRequest =
        http.MultipartRequest('POST', Uri.parse(url));
    print('VVV : ${url}');
    messageWithUploadRequest.headers.putIfAbsent(
        WebserviceConstants.contentType,
        () => WebserviceConstants.multipartForm);
    messageWithUploadRequest.headers.putIfAbsent(
        WebserviceConstants.username, () => AppPreferences().username);
    messageWithUploadRequest.headers.putIfAbsent(
        WebserviceConstants.departmentName,
        () => AppPreferences().deptmentName);

    // print(messageWithUploadRequest.headers.toString());
    messageWithUploadRequest.fields['messageFormBean '] =
        jsonEncode(messageData);

    for (int i = 0; i < attachments.length; i++) {
      File fileObj = File(attachments[i].path);
      String fileName = attachments[i].name;
      var multipartFile = new http.MultipartFile(
        'attachments',
        http.ByteStream(fileObj.openRead()).cast(),
        await fileObj.length(),
        filename: fileName,
      );
      messageWithUploadRequest.files.add(multipartFile);
    }

    try {
      final streamedResponse = await messageWithUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      debugPrint("response --> ${response.body}");
      return response;
    } catch (e) {
      print("DDE  :" + e.toString());
    }
  }

  Future<Map<String, String>> createHeader(
      {String userName, String departmentName}) async {
    Map<String, String> header = {};
    String username = userName ?? await AppPreferences.getUsername();
    if (departmentName != null) {
      header.putIfAbsent(
          WebserviceConstants.departmentName, () => departmentName);
    }
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    return header;
  }
}
