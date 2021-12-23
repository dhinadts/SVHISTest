import 'dart:convert';
import 'dart:io';
import '../model/base_response.dart';
import 'package:http/http.dart' as http;

class NMb2bRepository {
  NMb2bRepository();

  WebserviceHelper helper = WebserviceHelper();
}

WebserviceHelper helper = WebserviceHelper();

class WebserviceHelper {
  // next three lines makes this class a Singleton
  static WebserviceHelper _instance = WebserviceHelper.internal();

  static const int WEB_SUCCESS_STATUS_CODE = 200;
  static const int WEB_SUCCESS_STATUS_CODE_2 = 201;
  static const int WEB_ERROR_STATUS_CODE = 500;

  WebserviceHelper.internal();

  factory WebserviceHelper() => _instance;

  /// Get API call
  Future<http.Response> get(String url,
      {Map<String, String> headers, bool isOAuthTokenNeeded = false}) async {
    print("\n URL $url");
    print("Header $headers");
    final http.Response response = await http
        .get(url, headers: headers)
        .timeout(
            Duration(seconds: WebserviceConstants.apiServiceTimeOutInSeconds),
            onTimeout: _onTimeOut);
    return response;
  }

  Future<http.Response> delete(String url,
      {Map<String, String> headers, bool isOAuthTokenNeeded = false}) async {
    print("\n URL $url");
    print("Header $headers");
    final http.Response response = await http
        .delete(url, headers: headers)
        .timeout(
            Duration(seconds: WebserviceConstants.apiServiceTimeOutInSeconds),
            onTimeout: _onTimeOut);
    return response;
  }

  http.Response _onTimeOut() {
    BaseResponse appBaseResponse = BaseResponse(status: 500);
    http.Response response = http.Response(jsonEncode(appBaseResponse), 500);
    return response;
  }
}

class WebserviceConstants {
  static const contentType = "Content-Type";
  // static const applicationJson = "application/json; charset=utf-8"
  static const applicationJson = "application/json";
  static const multipartForm = "multipart/form-data";
  static const webServerError = "error";
  static const success = "success";
  static const username = "username";
  static const password = "password";
  static const formDataUrlEncoded = "application/x-www-form-urlencoded";
  static const authorization = "Authorization";
  static const bearer = "Bearer ";
  static const name = "name";
  static const departmentNameParam = "department_name=";
  static const contactDate = "contact_date=";
  static const usernameParam = "user_name=";
  static const cityParam = "city=";
  static const stateParam = "state=";
  static const zipCodeParam = "zipcode=";
  static const createdDateParam = "created_date=";
  static const userRelationParam = "user_relation=";
  static const lastReportedDate = "last_reported_date=";
  static const parentUserNameParam = "parent_user_name=";
  static const xAuthToken = "x-auth-token";

  static const int apiServiceTimeOutInSeconds = 60;

/*  static const String baseAdminURL = "https://qa.servicedx.com/admin";
  static const String baseSenderURL = "https://qa.servicedx.com/sender";*/

  static const reportTypeParam = "report_type=";
  static const dateFilterParam = "date_filter=";
  static const userGroupParam = "user_group=";
  static const itemIdParam = "item_id_delete=";
  static const itemNameParam = "item=";
  static const categoryTypeParam = "category=";
  static const profileCategoryTypeParam = "category_type=";
  static const profileSubcategoryTypeParam = "subcategory_type=";

  static const String activateAccountURL = "/useraccount/active";
  static const String loginURL = "/login";
  static const String registerURL = "/register";
  static const String addFcmTokenURL = "/devicetoken/add";
  static const String forgetPasswordURL = "/forgotpassword";
  static const String changePasswordURL = "/reset-password";
  static const String resetPasswordURL = "/reset-new-password";
  static const String reportsURL = "/reports";
  static const String userDetailsURL = "/profile";
  static const String requestedItemsListURL = "/addnewrequest";
  static const String supplierItemsListURL = "/addnewsupply";
  static const String itemsListURL = "/items";
  static const String countyListURL = "/county";
  static const String stateListURL = "/state";
  static const String categoryListURL = "/category";
  static const String subCategoryListURL = "/subcategory";
  static const String matchedRequestURL = "/matchedrequest";
  static const String matchedSupplyURL = "/supplier_matched_requester";
  static const String inProcessRequestURL = "/inprocess";
  static const String acceptRejectOrderURL = "/order-accept-reject";
  static const String connectSupplierURL = "/connect";
  static const String orderStatusCompleteURL = "/order-complete";
  static const String itemRelatedTagsURL = "/recommended-tags";
  //static const String baseURL = "https://nmb2b.qa.servicedx.com/api/1.0";
  //static const String baseURL = "https://nmb2b.servicedx.com/api/1.0";

  static const String baseURL = "https://nmb2b.servicedx.com/api/1.0";
}
