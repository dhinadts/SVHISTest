import 'dart:convert';

import '../model/base_response.dart';
import '../model/globalConfigurationDecodeErrorResponse.dart';
import '../model/global_config_reg_request.dart';
import '../model/global_configuration_decode_response.dart';
import '../repo/common_repository.dart';
import '../utils/app_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class GlobalConfigurationRepository {
  GlobalConfigurationRepository();

  WebserviceHelper helper = WebserviceHelper();

  Future<dynamic> decodeGlobalConfigurationUsingToken(String token,
      {bool isPromoCode}) async {
    Map<String, String> header = {};
    String username = await AppPreferences.getUsername();
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    header.putIfAbsent(WebserviceConstants.clientId,()=>AppPreferences().clientId);
    String url;
    if (isPromoCode) {
      url =
          'https://qa.servicedx.com/global/globalservice/token/decode/promo?promocode=$token';
    } else {
      url =
          'https://qa.servicedx.com/global/globalservice/token/decode?token=$token';
    }
    // debugPrint("URL - $url");
    final http.Response response = await http.post(
      url,
    );
    Map<String, dynamic> jsonData;
    //debugPrint("Response token --> ${response.body}");
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      jsonData = jsonDecode(response.body);
      return GlobalConfigurationDecodeResponse.fromJson(jsonData);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      jsonData = jsonDecode(response.body);

      return GlobalConfigurationDecodeErrorResponse.fromJson(jsonData);
    }
  }

  Future<dynamic> createGlobalConfiguration(
      GlobalConfigRegRequest request) async {
    Map<String, String> header = {};
    WebserviceHelper helper = WebserviceHelper();
    String username = await AppPreferences.getUsername();
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    header.putIfAbsent(WebserviceConstants.clientId,()=>AppPreferences().clientId);
    String url = 'https://qa.servicedx.com/global/globalservice/register';
    debugPrint("URL - $url");
    final http.Response response =
        await http.post(url, body: json.encode(request), headers: header);
    Map<String, dynamic> jsonData;
    print("Response body ${response.body}");
    GlobalConfigRegRequest finalResponse = GlobalConfigRegRequest();
    finalResponse.statusCode = response.statusCode;
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      jsonData = jsonDecode(response.body);
      finalResponse = GlobalConfigRegRequest.fromJson(jsonData);
      return finalResponse;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      jsonData = jsonDecode(response.body);
      finalResponse = GlobalConfigRegRequest.fromJson(jsonData);
      return finalResponse;
    }
  }

  BaseResponse onMultiTimeOut() {
    BaseResponse appBaseResponse = BaseResponse(status: 500);
    return appBaseResponse;
  }
}
