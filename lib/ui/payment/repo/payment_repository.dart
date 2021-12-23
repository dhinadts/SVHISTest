import 'dart:convert';

import '../../../model/base_response.dart';
import '../../../repo/common_repository.dart';
import '../../../ui/payment/model/payment_detail_response.dart';
import '../../../utils/app_preferences.dart';
import '../../../utils/constants.dart';
import '../../../utils/validation_utils.dart';
import 'package:http/http.dart' as http;

class PaymentRepository {
  WebserviceHelper helper;

  PaymentRepository() {
    helper = WebserviceHelper();
  }

//GetAPI department
  Future<dynamic> getPayment() async {
    Map<String, String> header = {};
    String departmentName = AppPreferences().deptmentName;
    header.putIfAbsent('tenant', () => WebserviceConstants.tenant);
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(
        WebserviceConstants.username, () => AppPreferences().username);
    header.putIfAbsent("clientid", () => AppPreferences().clientId);

    String url =
        '${WebserviceConstants.baseFilingURL}/payment?${WebserviceConstants.departmentNameParam}$departmentName';
    if (AppPreferences().role != Constants.supervisorRole) {
      url =
          '${WebserviceConstants.baseFilingURL}/payment?${WebserviceConstants.departmentNameParam}$departmentName&${WebserviceConstants.usernameParam}${AppPreferences().username}';
    }

    final response =
        await helper.get(url, headers: header, isOAuthTokenNeeded: false);

    if (ValidationUtils.isSuccessResponse(response.statusCode)) {
      Map<String, dynamic> jsonMapData = new Map();
      List<dynamic> jsonData;
      try {
        jsonData = jsonDecode(response.body);
        jsonMapData.putIfAbsent("paymentDetailList", () => jsonData);
      } catch (_) {
        // print("" + _);
      }

      if (jsonData != null) {
        PaymentDetailResponse paymentDetails =
            PaymentDetailResponse.fromJson(jsonMapData);
        return paymentDetails;
      }
    }

    return PaymentDetailResponse();
  }

  http.Response _onTimeOut() {
    BaseResponse appBaseResponse = BaseResponse(status: 500);
    http.Response response = http.Response(jsonEncode(appBaseResponse), 500);
    return response;
  }

  BaseResponse onMultiTimeOut() {
    BaseResponse appBaseResponse = BaseResponse(status: 500);
    //BaseResponse response = BaseResponse(jsonEncode(appBaseResponse), 500);
    return appBaseResponse;
  }

  BaseResponse onMultiTimeOutLogin() {
    BaseResponse appBaseResponse = BaseResponse(status: 500);
    //BaseResponse response = BaseResponse(jsonEncode(appBaseResponse), 500);
    return appBaseResponse;
  }
}
