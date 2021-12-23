import 'dart:convert';

import '../../../repo/common_repository.dart';
import '../../../ui/diabetes_risk_score/model/health_score.dart';
import '../../../ui/diabetes_risk_score/model/health_score_request_model.dart';
import '../../../utils/app_preferences.dart';
import '../../../utils/constants.dart';
import '../../../utils/validation_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DiabetesRiskScoreApiClient {
  final http.Client httpClient;

  DiabetesRiskScoreApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<dynamic> createHealthScore(Map jsonMap) async {
    final url =
        WebserviceConstants.baseFilingURL + WebserviceConstants.healthScore;
    Map<String, String> header = await createHeader();
    final response = await this
        .httpClient
        .post(url, headers: header, body: json.encode(jsonMap));
    // debugPrint("createHealthScore response --> ${response.body}");
    // debugPrint(
    // "createHealthScore response statuscode--> ${response.statusCode}");
    return response;
  }

  Future<List<HealthScore>> getHealthScoreHistoryList({String userName}) async {
    String deptName = await AppPreferences.getDeptName();
    List<HealthScore> healthScoreList;
    final url = WebserviceConstants.baseFilingURL +
        WebserviceConstants.healthScore +
        "${WebserviceConstants.departments}$deptName${WebserviceConstants.users}$userName";
    Map<String, String> header = await createHeader(
      userName: userName,
      departmentName: deptName,
    );
    // debugPrint("getHealthScoreHistoryList url --> $url");
    // debugPrint("getHealthScoreHistoryList header --> $header");

    http.Response response = await this.httpClient.get(url, headers: header);
    // debugPrint("getHealthScoreHistoryList response --> ${response.body}");
    // debugPrint(
    //     "getHealthScoreHistoryList response statuscode--> ${response.statusCode}");
    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      List<dynamic> data = jsonDecode(response.body);
      healthScoreList = data.map((data) => HealthScore.fromJson(data)).toList();
      return healthScoreList;
    } else {
      return [];
    }
  }

  Future<List<HealthScore>> getHealthScoreHistoryListForProspects(
      String searchStr) async {
    List<HealthScore> healthScoreList;
    HealthScoreRequestModel request = HealthScoreRequestModel();
    request.filterData = [];
    request.entity = "HealthScoreInfo";

    Map<String, String> header = {};
    String username = await AppPreferences.getUsername();
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    if (searchStr != null && searchStr.trim().isNotEmpty) {
      request.filterData.add(HealthScoreFilterData(
          columnName: "userFullName",
          columnType: "STRING",
          columnValue: ['%$searchStr%'],
          filterType: Constants.LIKE_OPERATOR));
    }

    request.filterData.add(
      HealthScoreFilterData(
          columnName: "departmentName",
          columnType: "STRING",
          columnValue: [AppPreferences().deptmentName],
          filterType: "EQUAL"),
    );

    request.filterData.add(
      HealthScoreFilterData(
          columnName: "isProspect",
          columnType: "BOOLEAN",
          columnValue: ["true"],
          filterType: "EQUAL"),
    );

    final http.Response response = await http.post(
        "${WebserviceConstants.baseFilingURL}" + "/health/score/dynamicsearch",
        body: json.encode(request),
        headers: header);

    //debugPrint("Search response --> ${response.body}");

    if (ValidationUtils.isSuccessResponse(response.statusCode)) {
      List<dynamic> jsonData;
      try {
        jsonData = jsonDecode(response.body);
      } catch (_) {
        // print("" + _);
      }

      if (jsonData != null) {
        healthScoreList =
            jsonData.map((data) => HealthScore.fromJson(data)).toList();
        return healthScoreList;
      } else {
        return [];
      }
    } else {
      return [];
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
