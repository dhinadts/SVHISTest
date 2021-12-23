import 'dart:convert';

import '../../model/base_response.dart';
import '../../model/people_response.dart';
import '../../repo/common_repository.dart';
import '../../utils/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PeopleSearchApiClient {
  final http.Client httpClient;

  PeopleSearchApiClient({
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
        PeopleResponse historyList = PeopleResponse.fromJson(jsonMapData);
        return historyList;
      }
    }
    return BaseResponse().markAsErrorResponse();
  }
}
