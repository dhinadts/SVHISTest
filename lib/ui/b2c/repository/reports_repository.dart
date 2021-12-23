import 'dart:convert';
import '../../../login/preferences/user_preference.dart';
import '../model/base_response.dart';
import '../model/countrywiseHealthcareProviders_model.dart';
import '../model/providersAndSuppliersActiveStatus_model.dart';
import '../model/requestCompleteVsIncomplete_model.dart';
import '../../../utils/app_preferences.dart';
import 'nmb2b_repository.dart';

class ReportsRepository {
  ReportsRepository();

  WebserviceHelper helper = WebserviceHelper();

  Future<dynamic> fetchCountrywiseHealthcareProvidersList(
      {String reportType, String dateFilter, String userGroup}) async {
    Map<String, String> header = {};
    header.putIfAbsent(
        "Authorization", () => "Token ${AppPreferences().token}");
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);

    String url;
    if (dateFilter != null && dateFilter.isNotEmpty) {
      url =
          "${WebserviceConstants.baseURL}${WebserviceConstants.reportsURL}?${WebserviceConstants.reportTypeParam}$reportType&${WebserviceConstants.userGroupParam}$userGroup&${WebserviceConstants.dateFilterParam}$dateFilter";
    } else {
      url =
          "${WebserviceConstants.baseURL}${WebserviceConstants.reportsURL}?${WebserviceConstants.reportTypeParam}$reportType&${WebserviceConstants.userGroupParam}$userGroup";
    }

    final response =
        await helper.get(url, headers: header, isOAuthTokenNeeded: false);

    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
//      print("Value of Response body${response.body}");
//      print("Value of Response body data ${response.body}");
      Map<String, dynamic> jsonMapData = new Map();
      List<CountrywiseHealthcareProvidersModel>
          countrywiseHealthcareProvidersList = [];

      // var listData = response.body.

      // List<dynamic> jsonData;
      try {
        jsonMapData = json.decode(response.body);
        //jsonData = jsonDecode(response.body[0]);
        //  print("Pranay jsonMapData ${jsonMapData["data"]}");

      } catch (e) {
        print("" + e.toString());
      }

      if (jsonMapData != null) {
        jsonMapData["data"].forEach((data) {
          CountrywiseHealthcareProvidersModel tempData =
              CountrywiseHealthcareProvidersModel.fromJson(data);
          countrywiseHealthcareProvidersList.add(tempData);
        });
        //print("countrywiseHealthcareProvidersList ${countrywiseHealthcareProvidersList[0].name}");
        return countrywiseHealthcareProvidersList;
      }
    }

    return BaseResponse().markAsErrorResponse();
  }

  Future<dynamic> fetchProvidersAndSuppliersActiveStatusList(
      {String reportType, String dateFilter, String userGroup}) async {
    Map<String, String> header = {};
    header.putIfAbsent(
        "Authorization", () => "Token ${AppPreferences().token}");
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);

    String url;
    if (dateFilter != null && dateFilter.isNotEmpty) {
      url =
          "${WebserviceConstants.baseURL}${WebserviceConstants.reportsURL}?${WebserviceConstants.reportTypeParam}$reportType&${WebserviceConstants.userGroupParam}$userGroup&${WebserviceConstants.dateFilterParam}$dateFilter";
    } else {
      url =
          "${WebserviceConstants.baseURL}${WebserviceConstants.reportsURL}?${WebserviceConstants.reportTypeParam}$reportType&${WebserviceConstants.userGroupParam}$userGroup";
    }

    final response =
        await helper.get(url, headers: header, isOAuthTokenNeeded: false);

    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      //   print("Value of Response body Active Status${response.body}");
      //  print("Value of Response body data ${response.body}");
      Map<String, dynamic> jsonMapData = new Map();
      ProvidersAndSuppliersActiveStatusModel
          providersAndSuppliersActiveStatusData =
          new ProvidersAndSuppliersActiveStatusModel();

      // var listData = response.body.

      // List<dynamic> jsonData;
      try {
        jsonMapData = json.decode(response.body);
        //jsonData = jsonDecode(response.body[0]);
        // print("Pranay jsonMapData ${jsonMapData["data"]}");
      } catch (e) {
        print("" + e.toString());
      }

      if (jsonMapData != null) {
        providersAndSuppliersActiveStatusData =
            ProvidersAndSuppliersActiveStatusModel.fromJson(
                jsonMapData["data"]);

        // print(
        //     "providersAndSuppliersActiveStatusData  ${providersAndSuppliersActiveStatusData.activeProvider}");
        return providersAndSuppliersActiveStatusData;
      }
    }

    return BaseResponse().markAsErrorResponse();
  }

  Future<dynamic> fetchRequestCompleteVsIncompleteList(
      {String reportType, String dateFilter, String userGroup}) async {
    Map<String, String> header = {};
    header.putIfAbsent(
        "Authorization", () => "Token ${AppPreferences().token}");
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);

    String url;
    if (dateFilter != null && dateFilter.isNotEmpty) {
      url =
          "${WebserviceConstants.baseURL}${WebserviceConstants.reportsURL}?${WebserviceConstants.reportTypeParam}$reportType&${WebserviceConstants.userGroupParam}$userGroup&${WebserviceConstants.dateFilterParam}$dateFilter";
    } else {
      url =
          "${WebserviceConstants.baseURL}${WebserviceConstants.reportsURL}?${WebserviceConstants.reportTypeParam}$reportType&${WebserviceConstants.userGroupParam}$userGroup";
    }

    final response =
        await helper.get(url, headers: header, isOAuthTokenNeeded: false);

    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      print(
          "Value of Response body fetchRequestCompleteVsIncompleteList${response.body}");
      print("Value of Response body data ${response.body}");
      Map<String, dynamic> jsonMapData = new Map();
      RequestCompleteVsIncompleteModel requestCompleteVsIncompleteData =
          new RequestCompleteVsIncompleteModel();

      // var listData = response.body.

      // List<dynamic> jsonData;
      try {
        jsonMapData = json.decode(response.body);
        //jsonData = jsonDecode(response.body[0]);
        // print(
        //     "fetchRequestCompleteVsIncompleteList jsonMapData ${jsonMapData["data"]}");
      } catch (e) {
        print("" + e.toString());
      }

      if (jsonMapData != null) {
        requestCompleteVsIncompleteData =
            RequestCompleteVsIncompleteModel.fromJson(jsonMapData["data"]);

        // print(
        //     "providersAndSuppliersActiveStatusData  ${requestCompleteVsIncompleteData.complete}");
        return requestCompleteVsIncompleteData;
      }
    }

    return BaseResponse().markAsErrorResponse();
  }
}
