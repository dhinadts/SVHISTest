import 'dart:convert';

import '../../../ui/committees/add_edit_committee_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../model/base_response.dart';
import '../../../model/user_info.dart';
import '../../../repo/common_repository.dart';
import '../../../utils/app_preferences.dart';
import '../model/committee_data.dart';
import '../../../utils/constants.dart';

class CommitteesRepository {
  Future<List<dynamic>> getCommitteesList() async {
    Map<String, String> header = {};
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);
    String departmentName = await AppPreferences.getDeptName();
    String url =
        '${WebserviceConstants.baseAdminURL}/committee?${WebserviceConstants.departmentName}=$departmentName';
    // print("url >> getCommitteesList $url");

    final http.Response response = await http.get(url, headers: header);
    // print("Response >> getCommitteesList ${response.body}");
    List<dynamic> jsonData;
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body).cast<dynamic>();
      if (jsonData != null && jsonData.length > 0) {
        // debugPrint(
        //     "received Data lenth >> getCommitteesList ${jsonData.length}");
        jsonData = jsonDecode(response.body);
        return jsonData;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<CommitteeData> getCommitteeData(
      String committeeName, String departmentName) async {
    Map<String, String> header = {};
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);
    //String departmentName = await AppPreferences.getDeptName();
    String url =
        '${WebserviceConstants.baseAdminURL}/committee/$departmentName/$committeeName';
    // print("url >> getCommitteeData $url");

    final http.Response response = await http.get(url, headers: header);
    // print("Response >> getCommitteeMembersList ${response.body}");
    //List<dynamic> jsonData;

    //print("getCommitteeData --> ${response.body}");

    if (response.statusCode == 200) {
      //jsonData = json.decode(response.body).cast<dynamic>();
      if (response.body != null) {
        // debugPrint(
        //     "received Data lenth >> getCommitteeMembersList ${jsonData.length}");
        CommitteeData committeeData =
            CommitteeData.fromJson(jsonDecode(response.body));
        waiting = false;
        return committeeData;
      } else {
        waiting = false;
        return null;
      }
    } else {
      waiting = false;
      return null;
    }
  }

  Future<List<String>> getCommitteeRoleDefinitionList() async {
    String username = await AppPreferences.getUsername();
    String departmentName = await AppPreferences.getDeptName();

    Map<String, String> header = {};
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    // header.putIfAbsent(
    //     WebserviceConstants.departmentName, () => departmentName);
    header.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);
    String url =
        '${WebserviceConstants.baseURL}/subscription/references/values/COMMITTEE_MEMBER_TYPE?department_name=$departmentName&sort=true';

    print("url >> getCommitteeRoleDefinitionList $url");

    final http.Response response = await http.get(url, headers: header);
    // print("Response >> getCommitteeMembersList ${response.body}");
    List<dynamic> jsonData;
    List<String> committeeMembersList = new List();
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body).cast<dynamic>();
      if (jsonData != null && jsonData.length > 0) {
        // debugPrint(
        //     "received Data lenth >> getCommitteeMembersList ${jsonData.length}");
        jsonData = jsonDecode(response.body);
        jsonData.forEach((element) {
          committeeMembersList.add(element);
        });
        waiting = false;
        return committeeMembersList;
      } else {
        waiting = false;
        return null;
      }
    } else {
      waiting = false;
      return null;
    }
  }

  Future<List<String>> getDepartmentList() async {
    String url = '${WebserviceConstants.baseAdminURL}/departments';
    // https://qa.servicedx.com/admin/departments/GNAT/hierarchy
    // '${WebserviceConstants.baseAdminURL}/departments/${AppPreferences().deptmentName}/hierarchy';

    // print("url >> getDepartmentList $url");

    final http.Response response = await http.get(
      url,
    );
    //print("Response >> getDepartmentList ${response.body}");
    List<dynamic> jsonData;
    List<String> departmentList = new List();
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body).cast<dynamic>();
      if (jsonData != null && jsonData.length > 0) {
        // debugPrint(
        //     "received Data lenth >> getDepartmentList ${jsonData.length}");
        jsonData = jsonDecode(response.body);

        jsonData.forEach((element) {
          if (element['departmentName'] != null && element['active']) {
            departmentList.add(element['departmentName']);
          }
        });
        waiting = false;
        return departmentList;
      } else {
        waiting = false;
        return null;
      }
    } else {
      waiting = false;
      return null;
    }
  }

  deleteCommittee(String committeeName) async {
    Map<String, String> header = {};
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    http.Response response = await http.delete(
        Uri.parse(WebserviceConstants.baseAdminURL +
            "/committee/" +
            AppPreferences().deptmentName +
            '/' +
            committeeName),
        headers: header);
    return response.statusCode;
  }

  Future<List<CommitteeData>> getCommitteeSearchList(
      String searchStr, int selectedSearchOption) async {
    List<CommitteeData> committeeList;
    CommitteeSearchRequest request = CommitteeSearchRequest();
    request.filterData = [];
    request.entity = "Committee";
    Map<String, String> header = {};
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);
    // Map<String, String> header = {};
    // String username = await AppPreferences.getUsername();

    // header.putIfAbsent(WebserviceConstants.contentType,
    //     () => WebserviceConstants.applicationJson);
    // header.putIfAbsent(WebserviceConstants.username, () => username);

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
      print("=SEARCH===============================> ${response.body}");
      committeeList = data.map((data) => CommitteeData.fromJson(data)).toList();

      var dataList = List<CommitteeData>();
      if (selectedSearchOption == 3) {
        for (int i = 0; i < committeeList.length; i++) {
          var model = committeeList[i];
          if (model.active) {
            dataList.add(model);
          }
        }
      }
      if (selectedSearchOption == 4) {
        for (int i = 0; i < committeeList.length; i++) {
          var model = committeeList[i];
          if (!model.active) {
            dataList.add(model);
          }
        }
      }

      if (selectedSearchOption == 2) {
        dataList.addAll(committeeList);
      }
      return dataList;
    } else {
      // print(response.body);
      return [];
    }
  }

  Future<List<UserInfo>> getDepartmentUserList(
      List<String> departmentNames) async {
    // String url =
    //     '${WebserviceConstants.baseAdminURL}/departments/$departmentName/users/media';
    // print("url >> getDepartmentUserList $url");

    // final http.Response response = await http.get(
    //   url,
    // );
    // print("Response >> getDepartmentUserList ${response.body}");
    // List<dynamic> jsonData;
    // List<UserInfo> departmentUserList = new List();
    // if (response.statusCode == 200) {
    //   jsonData = json.decode(response.body).cast<dynamic>();
    //   if (jsonData != null && jsonData.length > 0) {
    //     debugPrint(
    //         "received Data lenth >> getDepartmentUserList ${jsonData.length}");
    //     jsonData = jsonDecode(response.body);
    //     jsonData.forEach((element) {
    //       UserInfo userInfo = UserInfo.fromJson(element);
    //       departmentUserList.add(userInfo);
    //     });
    //     return departmentUserList;
    //   } else {

    //     return null;
    //   }
    // } else {
    //   return null;
    // }
    Map<String, String> header = {};
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);

    String url = '${WebserviceConstants.baseAdminURL}/users?';
// https://qa.servicedx.com/admin/users?parent_department_name=Diabetes%20Assoc
    int count = 0;
    departmentNames.forEach((element) {
      if (count == 0)
        url = url + "department_list=" + element;
      else
        url = url + "&department_list=" + element;

      count += 1;
    });
    // print("url >> getDepartmentUserList $url");

    final http.Response response = await http.get(url, headers: header);
    //print("Response >> getDepartmentUserList ${response.body}");
    List<dynamic> jsonData;
    List<UserInfo> departmentUserList = new List();
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body).cast<dynamic>();
      if (jsonData != null && jsonData.length > 0) {
        debugPrint(
            "received Data lenth >> getDepartmentUserList ${jsonData.length}");
        jsonData = jsonDecode(response.body);
        jsonData.forEach((element) {
          UserInfo userInfo = UserInfo.fromJson(element);
          departmentUserList.add(userInfo);
        });
        waiting = true;
        return departmentUserList;
      } else {
        return [];
      }
    } else {
      return null;
    }
  }

  Future<BaseResponse> addCommitteeTitle(Map committeeData) async {
    String username = await AppPreferences.getUsername();
    //String departmentName = await AppPreferences.getDeptName();
    /* Map<String, String> header = {};
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username); */
    Map<String, String> header = {};
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    // header.putIfAbsent(
    //     WebserviceConstants.departmentName, () => departmentName);

    http.Response response;
    String url = WebserviceConstants.baseURL + "/subscription/references";
    BaseResponse respBase;

    try {
      response = await http
          .post(url, headers: header, body: jsonEncode(committeeData))
          .timeout(
              Duration(seconds: WebserviceConstants.apiServiceTimeOutInSeconds),
              onTimeout: _onTimeOut);
      respBase = BaseResponse.fromJson(jsonDecode(response.body));
      respBase.status = response.statusCode;
    } catch (e) {
      respBase = onMultiTimeOut();
    }

    return respBase;
  }

  Future<BaseResponse> createOrUpdateCommittee(
      CommitteeData committeeData, FilePickerResult companyPoliciesFile,
      {bool isUpdate = false}) async {
    //Map<String, dynamic> data = committeeData.toJson();
    String username = await AppPreferences.getUsername();
    Map<String, String> header = {};
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    // print("=====================>Create Committtee API Header $header");
    http.Response response;
    String url =
        WebserviceConstants.baseAdminURL + WebserviceConstants.committeeURL;
    BaseResponse respBase;
    // print(isUpdate);
    // print("committeeData post URL: $url");
    // print("committeeData : ${jsonEncode(committeeData.toJson())}");
    final Map<String, dynamic> data = new Map<String, dynamic>();

    List<Map<String, dynamic>> membersData = new List();
    if (companyPoliciesFile != null) {
      Map<String, List<dynamic>> uploadData = new Map<String, List<dynamic>>();

      PlatformFile file = companyPoliciesFile.files.first;

      // print("Company policies file.name ${file.name}");
      // print("Company policies file.bytes ${file.bytes}");
      // print("Company policies file.size ${file.size}");
      // print("Company policies file.extension ${file.extension}");
      // print("Company policies file.path in repository ${file.path}");
      uploadData["additionalProp1"] = [
        {
          "attachmentId": "Company policies",
          "fileName": file.name,
          "fileType": file.extension
        }
      ];
      uploadData["additionalProp2"] = [
        {
          "attachmentId": "memberDos policies",
          "fileName": file.name,
          "fileType": file.extension
        }
      ];

      data['uploads'] = uploadData;
      // print("uploads in repository: ${jsonEncode(data['uploads'])}");
    }

    // print(
    //     "member list in model data username ${committeeData.members[0].username}");
    committeeData.members.forEach((element) {
      if (element.checkboxValue) {
        Map<String, dynamic> mapData = new Map();

        mapData["memberDepartment"] = element.departmentName;
        mapData["userName"] = element.username;
        mapData["memberType"] = element.memberType;
        mapData["firstName"] = element.firstName;
        mapData["lastName"] = element.lastName;
        mapData["roleName"] = element.role;

        membersData.add(mapData);
      }
    });
    // print("member list in model data ${committeeData.members}");
    data['modifiedOn'] = committeeData.modifiedOn;
    data['active'] = committeeData.active;
    data['comments'] = committeeData.comments;
    data['departmentName'] = committeeData.departmentName;
    data['committeeName'] = committeeData.committeeName;
    data['committeeType'] = committeeData.committeeType;
    data['committeeStrength'] = committeeData.committeeStrength;
    data['location'] = committeeData.location;
    // data['committeeDepartment'] = committeeData.committeeDepartment;
    data['groups'] = committeeData.groups;
    data['memberTypes'] = committeeData.memberTypes;
    data['members'] = membersData;

    // print("committeeData in repository data: ${jsonEncode(data)}");
    try {
      if (isUpdate) {
        url =
            "${WebserviceConstants.baseAdminURL}${WebserviceConstants.committeeURL}/${committeeData.departmentName}/${committeeData.committeeName}";

        debugPrint("url --> $url");
        response = await http
            .put(url, headers: header, body: jsonEncode(data))
            .timeout(
                Duration(
                    seconds: WebserviceConstants.apiServiceTimeOutInSeconds),
                onTimeout: _onTimeOut);
      } else {
        response = await http
            .post(url, headers: header, body: jsonEncode(data))
            .timeout(
                Duration(
                    seconds: WebserviceConstants.apiServiceTimeOutInSeconds),
                onTimeout: _onTimeOut);
      }
      debugPrint("Response body --> ${response.body}");

      respBase = BaseResponse.fromJson(jsonDecode(response.body));
      respBase.status = response.statusCode;

      String errorMsg = jsonDecode(response.body)['message'] as String;
      respBase.error = errorMsg;
    } catch (e) {
      respBase = onMultiTimeOut();
      // print("Stack trace of response ${e.toString()}");
//      respBase.status = response.statusCode;
//      respBase.message = response.body;
    }

    return respBase;
  }

  BaseResponse onMultiTimeOut() {
    BaseResponse appBaseResponse = BaseResponse(
        status: 500, message: AppPreferences().getApisErrorMessage);
    //BaseResponse response = BaseResponse(jsonEncode(appBaseResponse), 500);
    return appBaseResponse;
  }

  http.Response _onTimeOut() {
    BaseResponse appBaseResponse = BaseResponse(
        status: 500, message: AppPreferences().getApisErrorMessage);
    http.Response response = http.Response(jsonEncode(appBaseResponse), 500);
    return response;
  }
}

class CommitteeSearchRequest {
  List<String> columnList;
  String entity;
  List<CommitteeFilterData> filterData;
  bool sortRequired;
  CommitteeSearchRequest({this.columnList, this.entity, this.filterData}) {
    this.columnList = [
      "committeeName",
      "departmentName",
      "createdBy",
      "memberTypes",
      "modifiedOn",
      "active"
    ];
    this.sortRequired = true;
  }

  CommitteeSearchRequest.fromJson(Map<String, dynamic> json) {
    columnList = json['columnList'].cast<String>();
    entity = json['entity'];
    sortRequired = json['sortRequired'];
    if (json['filterData'] != null) {
      filterData = new List<CommitteeFilterData>();
      json['filterData'].forEach((v) {
        filterData.add(new CommitteeFilterData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['columnList'] = this.columnList;
    data['entity'] = this.entity;
    data['sortRequired'] = this.sortRequired;
    if (this.filterData != null) {
      data['filterData'] = this.filterData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommitteeFilterData {
  String columnName;
  String columnType;
  List<String> columnValue;
  String filterType;

  CommitteeFilterData(
      {this.columnName, this.columnType, this.columnValue, this.filterType});

  CommitteeFilterData.fromJson(Map<String, dynamic> json) {
    columnName = json['columnName'];
    columnType = json['columnType'];
    columnValue = json['columnValue'].cast<String>();
    filterType = json['filterType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['columnName'] = this.columnName;
    data['columnType'] = this.columnType;
    data['columnValue'] = this.columnValue;
    data['filterType'] = this.filterType;
    return data;
  }
}
