import 'dart:convert';

import '../../model/base_response.dart';
import '../../model/people_response.dart';
import '../../repo/common_repository.dart';
import '../../ui/diagnosis/model/diagnosis_report.dart';
import '../../ui/diagnosis/model/vital_sign.dart';
import '../../utils/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DiagnosisApiClient {
  final http.Client httpClient;

  DiagnosisApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<dynamic> fetchPeopleListImp() async {
    String username = await AppPreferences.getUsername();
    String deptName = await AppPreferences.getDeptName();
    Map<String, String> header = {};

    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);

    final url =
        '${WebserviceConstants.baseAdminURL}${WebserviceConstants.peopleListURL}?${WebserviceConstants.departmentNameParam}$deptName';
    final response = await this.httpClient.get(url, headers: header);

    if (response.statusCode != 200) {
      throw new Exception('error getting people list');
    }

    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      Map<String, dynamic> jsonMapData = new Map();
      List<dynamic> jsonData;
      try {
        jsonData = jsonDecode(response.body);
        jsonMapData.putIfAbsent("peopleResponse", () => jsonData);
      } catch (_) {
        // print("" + _);
      }

      if (jsonData != null) {
        PeopleResponse ailmentList = PeopleResponse.fromJson(jsonMapData);
        return ailmentList;
      }
    }
    return BaseResponse().markAsErrorResponse();
  }

  Future<dynamic> addDiagnosisReportImp(Map jsonMap) async {
    final url = WebserviceConstants.baseAdminURL +
        WebserviceConstants.addDiagnosisDependents;
    Map<String, String> header = await createHeader();
    final response = await this
        .httpClient
        .post(url, headers: header, body: json.encode(jsonMap));
    return response;
  }

  Future<List<VitalSign>> getVitalSignsListImp({String userName}) async {
    final url =
        WebserviceConstants.baseAdminURL + WebserviceConstants.getVitalSigns;
    Map<String, String> header = await createHeader(userName: userName);
    final response = await this.httpClient.get(url, headers: header);

    if (response.statusCode != 200) {
      throw new Exception('error getting vital sign list');
    }

    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      List<dynamic> data = jsonDecode(response.body);
      List<VitalSign> vitalSigns =
          data.map((data) => VitalSign.fromJson(data)).toList();
      return vitalSigns;
    } else {
      return List<VitalSign>();
    }
  }

  Future<List<DiagnosisReport>> getDiagnosisReportList() async {
    String deptName = await AppPreferences.getDeptName();
    final url = WebserviceConstants.baseAdminURL +
        WebserviceConstants.CreateURL +
        deptName +
        WebserviceConstants.getDiagnosisReport;
    Map<String, String> header = await createHeader();
    final response = await this.httpClient.get(url, headers: header);

    if (response.statusCode != 200) {
      throw new Exception('error getting diagnosis list');
    }

    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      List<dynamic> data = jsonDecode(response.body);
      List<DiagnosisReport> diagnosisReports =
          data.map((data) => DiagnosisReport.fromJson(data)).toList();
      return diagnosisReports;
    } else {
      return List<DiagnosisReport>();
    }
  }

  Future<Map<String, dynamic>> fetchDependantsData({String userName}) async {
    String deptName = await AppPreferences.getDeptName();
    final url = WebserviceConstants.baseAdminURL +
        WebserviceConstants.addDiagnosisDependents +
        "?${WebserviceConstants.departmentNameParam}$deptName&${WebserviceConstants.usernameParam}$userName";
    Map<String, String> header = await createHeader();
    final response = await this.httpClient.get(url, headers: header);

//    if (response.statusCode != 200) {
//      throw new Exception('error getting diagnosis dependents');
//    }

//    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
//      Map<String, dynamic> data = jsonDecode(response.body);
//      return data;
//    } else {
    return jsonDecode(response.body);
//    }
  }

  Future<Map<String, String>> createHeader({String userName}) async {
    Map<String, String> header = {};
    String username = userName ?? await AppPreferences.getUsername();
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    return header;
  }
}
