import 'dart:convert';

import '../../../repo/common_repository.dart';
import '../../../ui/campaign/model/campaign_model.dart';
import '../../../utils/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CampaignApiClient {
  final http.Client httpClient;

  CampaignApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<CampaignModel>> getCampaignList(
      {String department, String userName}) async {
    String departmentName = department ?? await AppPreferences.getDeptName();
    final url = WebserviceConstants.baseFilingURL +
        "/formlist/department/$departmentName/user/$userName";
    Map<String, String> header = await createHeader();
    debugPrint("getCampaignList url --> $url");
    final response = await this.httpClient.get(url, headers: header);
    debugPrint("getCampaignList response body --> ${response.body}");
    debugPrint("response code --> ${response.statusCode}");
    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      List<dynamic> data = jsonDecode(response.body);

      List<CampaignModel> campaignList =
          data.map((data) => CampaignModel.fromJson(data)).toList();
      return campaignList;
    } else
      return List<CampaignModel>();
  }

  Future<Map<String, String>> createHeader({String userName}) async {
    Map<String, String> header = {};
    String username = userName ?? await AppPreferences.getUsername();
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    header.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);
    return header;
  }
}
