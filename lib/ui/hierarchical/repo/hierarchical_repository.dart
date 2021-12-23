import 'dart:convert';

import '../../../repo/common_repository.dart';
import '../../../ui/hierarchical/model/department_model.dart';
import '../../../utils/app_preferences.dart';
import '../../../utils/validation_utils.dart';
import 'package:flutter/material.dart';

class HierarchicalRepository {
  WebserviceHelper helper;

  HierarchicalRepository() {
    helper = WebserviceHelper();
  }

//GetAPI department
  Future<dynamic> getDepartment() async {
    Map<String, String> header = {};
    header.putIfAbsent('tenant', () => WebserviceConstants.tenant);
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);

    String url =
        '${WebserviceConstants.baseAdminURL}/departments/${AppPreferences().deptmentName}/hierarchy';

    final response =
        await helper.get(url, headers: header, isOAuthTokenNeeded: false);
    DepartmentModel departmentModel = DepartmentModel();
    departmentModel.status = response.statusCode;
    //debugPrint("getDepartment --> ${response.body}");
    if (ValidationUtils.isSuccessResponse(response.statusCode)) {
      Map<String, dynamic> jsonMapData = new Map();
      List<dynamic> jsonData;
      try {
        jsonMapData = jsonDecode(response.body);
      } catch (_) {
        // print("" + _);
      }

      if (jsonMapData != null) {
        departmentModel = DepartmentModel.fromJson(jsonMapData);
        departmentModel.status = response.statusCode;
        return departmentModel;
      }
    }

    return departmentModel;
  }

  Future<dynamic> getMembersBaseOnDepartment({String department}) async {
    Map<String, String> header = {};
    header.putIfAbsent('tenant', () => WebserviceConstants.tenant);
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(
        WebserviceConstants.username, () => AppPreferences().username);

    String url =
        '${WebserviceConstants.baseAdminURL}/departments/$department?membership=true';
    // debugPrint("getMembersBaseOnDepartment url --> $url");
    final response =
        await helper.get(url, headers: header, isOAuthTokenNeeded: false);
    DepartmentModel departmentModel = DepartmentModel();
    departmentModel.status = response.statusCode;
    // print("Body : ${response.body}");
    if (ValidationUtils.isSuccessResponse(response.statusCode)) {
      Map<String, dynamic> jsonMapData = new Map();
      try {
        jsonMapData = jsonDecode(response.body);
      } catch (_) {
        // print("" + _);
      }

      if (jsonMapData != null) {
        departmentModel = DepartmentModel.fromJson(jsonMapData);
        departmentModel.status = response.statusCode;
        return departmentModel;
      }
    }

    return departmentModel;
  }
}
