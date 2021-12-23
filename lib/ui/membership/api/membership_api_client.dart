import 'dart:convert';
import 'dart:io';

import '../../../model/base_response.dart';
import '../../../model/non_member_search_request_model.dart';
import '../../../model/people_response.dart';
import '../../../model/user_info.dart';
import '../../../repo/common_repository.dart';
import '../../../ui/membership/bloc/membership_event.dart';
import '../../../ui/membership/model/membership_info.dart';
import '../../../ui/membership/model/membership_search_request_model.dart';
import '../../../ui/membership/model/payment_info.dart';
import '../../../utils/app_preferences.dart';
import '../../../utils/constants.dart';
import '../../../utils/validation_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MembershipApiClient {
  final http.Client httpClient;

  MembershipApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<http.Response> getMembershipPageReferenceData(
      {String clientId}) async {
    final url = WebserviceConstants.baseAdminURL +
        "/page/reference-data/MEMBERSHIP_FORM";
    Map<String, String> header = await createHeader();

    final response = await this.httpClient.get(url, headers: header);

    return response;
  }

  Future<http.Response> getMembershipFormFields({String clientId}) async {
    final url =
        WebserviceConstants.baseFilingURL + "/dynamic/membership/$clientId";
    Map<String, String> header = await createHeader();
    final response = await this.httpClient.get(url, headers: header);
    // debugPrint("response --> ${response.body}");
    return response;
  }

  Future<List<MembershipInfo>> getMembershipList({String department}) async {
    String departmentName = department ?? await AppPreferences.getDeptName();
    final url = WebserviceConstants.baseFilingURL +
        "/membership/form/departments/$departmentName";
    Map<String, String> header = await createHeader();

    final response = await this.httpClient.get(url, headers: header);
    // debugPrint("response --> ${response.body}");
    // debugPrint("response code --> ${response.statusCode}");
    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      List<dynamic> data = jsonDecode(response.body);

      List<MembershipInfo> membershipList =
          data.map((data) => MembershipInfo.fromJson(data)).toList();
      return membershipList;
    } else
      return List<MembershipInfo>();
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

    final response = await httpClient.get(url, headers: header);
    // print("Membership API Body : ${response.body}");
    if (ValidationUtils.isSuccessResponse(response.statusCode)) {
      Map<String, dynamic> main = jsonDecode(response.body);
      List<dynamic> data = main["supervisors"] ?? List();
      data.addAll(main["members"]);
      List<MembershipInfo> membershipList =
          data.map((data) => MembershipInfo.fromJson(data)).toList();
      return membershipList;
    }

    return List<MembershipInfo>();
  }

  Future<List<PaymentInfo>> getMembershipTransactionDetails(
      {String requestId, String transactionType}) async {
    final url = WebserviceConstants.baseFilingURL +
        "/payment?request_id=$requestId&transaction_type=[$transactionType]";
    Map<String, String> header = await createHeader();

    final response = await this.httpClient.get(url, headers: header);
    debugPrint("response transaction detials --> ${response.body}");
    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      List<dynamic> data = jsonDecode(response.body);
      List<PaymentInfo> paymentInfoList =
          data.map((data) => PaymentInfo.fromJson(data)).toList();
      return paymentInfoList;
    } else
      return List<PaymentInfo>();
  }

  Future<http.Response> getMembershipTransactionDetailsByRequestId(
      {String requestId, String transactionType}) async {
    final url = WebserviceConstants.baseFilingURL +
        "/payment?request_id=$requestId&transaction_type=[$transactionType]";
    Map<String, String> header = await createHeader();
    print('URL PAY COMPLETE : $url');
    final response = await this.httpClient.get(url, headers: header);
    debugPrint("response transaction detials by requestId--> ${response.body}");
    return response;
  }

  Future<List<MembershipInfo>> searchMembershipList(
      SEARCH_MEMERSHIP searchBy, String searchStr, bool isApprovedStatus,
      {String departmentName}) async {
    MembershipSearchRequestModel request = MembershipSearchRequestModel();
    request.filterData = [];
    request.entity = "Membership";

    Map<String, String> header = {};
    String username = await AppPreferences.getUsername();
    String clientId = await AppPreferences.getClientId();
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    header.putIfAbsent("clientid", () => clientId);

    if (searchStr != null && searchStr.trim().isNotEmpty) {
      request.filterData.add(MembershipFilterData(
          columnName: (searchBy == SEARCH_MEMERSHIP.Name)
              ? "userFullName"
              : "membershipId",
          columnType: "STRING",
          columnValue: ['%$searchStr%'],
          filterType: Constants.LIKE_OPERATOR));
      if (isApprovedStatus) {
        request.filterData.add(MembershipFilterData(
            columnName: "membershipStatus",
            columnType: "STRING",
            columnValue: ['Approved'],
            filterType: Constants.EQUAL_OPERATOR));
      }
    }
    if (departmentName != null && departmentName.isNotEmpty) {
      request.filterData.add(MembershipFilterData(
          columnName: "departmentName",
          columnType: "STRING",
          columnValue: ['$departmentName'],
          filterType: Constants.EQUAL_OPERATOR));
    }
    debugPrint("request is --> ${request.toJson()}");

    final http.Response response = await http.post(
        "${WebserviceConstants.baseFilingURL}" +
            "/membership/form/dynamicsearch",
        body: json.encode(request),
        headers: header);

    debugPrint("response is --> ${response.body}");
    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      List<dynamic> data = jsonDecode(response.body);
      List<MembershipInfo> membershipList =
          data.map((data) => MembershipInfo.fromJson(data)).toList();
      return membershipList;
    } else
      return List<MembershipInfo>();
  }

  Future<http.Response> cashPaymentInitiate(
      {String email,
      String name,
      String phone,
      String total,
      String departmentName,
      String paymentDescription,
      String receiptNo}) async {
    MembershipSearchRequestModel request = MembershipSearchRequestModel();
    request.filterData = [];
    request.entity = "Membership";

    Map<String, String> header = {};
    String username = await AppPreferences.getUsername();
    UserInfo userInfo = await AppPreferences.getUserInfo();
    String userFullName = userInfo.userFullName;
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    header.putIfAbsent("clientid", () => AppPreferences().clientId);

    debugPrint("TESTING --->>>>");
    debugPrint("request is --> ${request.toJson()}");
    debugPrint("${WebserviceConstants.baseFilingURL}" +
        "/payment/cash/initiate?${WebserviceConstants.emailParam}$email&${WebserviceConstants.nameParam}$name&${WebserviceConstants.phoneParam}$phone&${WebserviceConstants.totalParam}$total&${WebserviceConstants.departmentNameParam}$departmentName&${WebserviceConstants.paymentDescriptionParam}$paymentDescription&${WebserviceConstants.userFullNameParam}$userFullName&receiptNo=$receiptNo");
    final http.Response response = await http.post(
        "${WebserviceConstants.baseFilingURL}" +
            "/payment/cash/initiate?${WebserviceConstants.emailParam}$email&${WebserviceConstants.nameParam}$name&${WebserviceConstants.phoneParam}$phone&${WebserviceConstants.totalParam}$total&${WebserviceConstants.departmentNameParam}$departmentName&${WebserviceConstants.paymentDescriptionParam}$paymentDescription&${WebserviceConstants.userFullNameParam}$userFullName&receiptNo=$receiptNo",
        body: json.encode(request),
        headers: header);

    // debugPrint("${WebserviceConstants.baseFilingURL}" +
    //     "/payment/cash/initiate?${WebserviceConstants.emailParam}$email&${WebserviceConstants.nameParam}$name&${WebserviceConstants.phoneParam}$phone&${WebserviceConstants.totalParam}$total&${WebserviceConstants.departmentNameParam}$departmentName&${WebserviceConstants.paymentDescriptionParam}$paymentDescription");

    debugPrint("response is --> ${response.body}");
    debugPrint("response code is --> ${response.statusCode}");
    return response;
  }

  Future<List<MembershipInfo>> filterMembershipList(String filterBy,
      {String departmentName}) async {
    MembershipSearchRequestModel request = MembershipSearchRequestModel();
    request.filterData = [];
    request.entity = "Membership";

    Map<String, String> header = {};
    String username = await AppPreferences.getUsername();
    String clientId = await AppPreferences.getClientId();
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    header.putIfAbsent("clientid", () => clientId);

    // String columnValueStr = "";
    // if (filterBy == FILTER_MEMBERSHIP.Approved) {
    //   columnValueStr = "Approved";
    // } else if (filterBy == FILTER_MEMBERSHIP.PendingApproval) {
    //   columnValueStr = "Pending Approval";
    // } else if (filterBy == FILTER_MEMBERSHIP.PendingPayment) {
    //   columnValueStr = "Pending Payment";
    // } else if (filterBy == FILTER_MEMBERSHIP.UnderReview) {
    //   columnValueStr = "Under Review";
    // } else if (filterBy == FILTER_MEMBERSHIP.Rejected) {
    //   columnValueStr = "Rejected";
    // }

    request.filterData.add(
      MembershipFilterData(
          columnName: "departmentName",
          columnType: "STRING",
          columnValue: [departmentName ?? AppPreferences().deptmentName],
          filterType: "EQUAL"),
    );

    request.filterData.add(MembershipFilterData(
        columnName: "membershipStatus",
        columnType: "STRING",
        columnValue: ['$filterBy'],
        filterType: Constants.EQUAL_OPERATOR));

    debugPrint("request is --> ${request.toJson()}");

    final http.Response response = await http.post(
        "${WebserviceConstants.baseFilingURL}" +
            "/membership/form/dynamicsearch",
        body: json.encode(request),
        headers: header);

    debugPrint("response is --> ${response.body} ${json.encode(request)}");
    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      List<dynamic> data = jsonDecode(response.body);
      List<MembershipInfo> membershipList =
          data.map((data) => MembershipInfo.fromJson(data)).toList();
      return membershipList;
    } else
      return List<MembershipInfo>();
  }

  Future<MembershipInfo> getMembershipInfoById(String membershipId) async {
    final url = WebserviceConstants.baseFilingURL +
        "/membership/form/membership_id/$membershipId";
    Map<String, String> header = await createHeader();
    // print(url);
    final response = await this.httpClient.get(url, headers: header);

    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      if (response.body.isNotEmpty) {
        List<dynamic> data = jsonDecode(response.body);
        List<MembershipInfo> membershipList =
            data.map((data) => MembershipInfo.fromJson(data)).toList();
        if (membershipList.length > 0)
          return membershipList.first;
        else
          return null;
      } else {
        return null;
      }
    } else
      return null;
  }

  Future<MembershipInfo> getMembershipInfoByUserName(String userName) async {
    String departmentName = await AppPreferences.getDeptName();
    final url = WebserviceConstants.baseFilingURL +
        "/membership/form/departments/$departmentName/users/$userName";
    Map<String, String> header = await createHeader();
    // print(url);
    final response = await this.httpClient.get(url, headers: header);
    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      if (response.body.isNotEmpty) {
        return MembershipInfo.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } else
      return null;
  }

  Future<List<String>> getMembershipFormBranches() async {
    // final url = WebserviceConstants.baseURL +
    //     "/subscription/references/values/MEMBERSHIP_FORM_BRANCH?sort=true";
    String departmentName = await AppPreferences.getDeptName();
    final url = WebserviceConstants.baseAdminURL +
        "/departments/$departmentName/subdepartments";
    Map<String, String> header = await createHeader();

    final response = await this.httpClient.get(url, headers: header);

    //debugPrint("response body --> ${response.body}");
    List<String> branchList = [];
    branchList.add(departmentName);
    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      List<dynamic> data = jsonDecode(response.body);
      //debugPrint("response body data --> ${data}");
      if (data.isNotEmpty) {
        for (Map<String, dynamic> responseData in data) {
          //debugPrint("responseData --> ${responseData["departmentName"]}");
          //List<String> branchList = List<String>.from(data);
          if (responseData.containsKey("departmentName")) {
            branchList.add(responseData["departmentName"]);
          }
        }
        //debugPrint("response body --> ${response.body}");
        return branchList;
      } else {
        return branchList;
      }
    } else
      return branchList;
  }

  Future<dynamic> fetchNonMembersListImp(
      NonMemberSearchRequestModel request) async {
    Map<String, String> header = {};
    String username = await AppPreferences.getUsername();
    String clientId = await AppPreferences.getClientId();
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    header.putIfAbsent("clientid", () => clientId);
    if (request.filterData == null) request.filterData = [];
    request.filterData.add(
      NonMemberFilterData(
          columnName: "departmentName",
          columnType: "STRING",
          columnValue: [AppPreferences().deptmentName],
          filterType: "EQUAL"),
    );

    request.filterData.add(
      NonMemberFilterData(
          columnName: "membershipStatus",
          columnType: "STRING",
          columnValue: [""],
          filterType: "EQUAL"),
    );

    request.filterData.add(NonMemberFilterData(
        columnName: "roleName",
        columnType: "STRING",
        columnValue: ['User'],
        filterType: Constants.EQUAL_OPERATOR));

    request.filterData.add(
      NonMemberFilterData(
          columnName: "hasMembership",
          columnType: "BOOLEAN",
          columnValue: ["false"],
          filterType: "EQUAL"),
    );

    final http.Response response = await http.post(
        "${WebserviceConstants.baseFilingURL}${WebserviceConstants.dynamicMembershipSearch}",
        body: json.encode(request),
        headers: header);
    debugPrint("nonmembers request --> ${request.toJson()}");
    debugPrint("nonmembers response --> ${response.body}");
    if (ValidationUtils.isSuccessResponse(response.statusCode)) {
      Map<String, dynamic> jsonMapData = new Map();
      List<dynamic> jsonData;
      try {
        jsonData = jsonDecode(response.body);
        jsonMapData.putIfAbsent("peopleResponse", () => jsonData);
      } catch (_) {
        // print("" + _);
      }

      if (jsonData != null) {
        PeopleResponse peopleList = PeopleResponse.fromJson(jsonMapData);
        return peopleList;
      }
    }
    return BaseResponse().markAsErrorResponse();
  }

  Future<dynamic> createMembership(
      Map jsonMap,
      File documentFrontImage,
      File documentBackImage,
      File addressProofImage,
      File rnRmImageFile,
      File recentImageFile) async {
    final url = WebserviceConstants.baseURL + "/filing/membership/form";
    // print("membership create payment url --->");
    // print(url);

    final membershipFormUploadRequest =
        http.MultipartRequest('POST', Uri.parse(url));
    membershipFormUploadRequest.headers.putIfAbsent(
        WebserviceConstants.contentType,
        () => WebserviceConstants.multipartForm);
    membershipFormUploadRequest.headers.putIfAbsent(
        WebserviceConstants.username, () => AppPreferences().username);
    membershipFormUploadRequest.headers
        .putIfAbsent("clientid", () => AppPreferences().clientId);

    if (documentFrontImage != null) {
      String fileNameFront = "front_" + documentFrontImage.path.split('/').last;
      final frontImage = http.MultipartFile(
          'files',
          http.ByteStream(documentFrontImage.openRead()).cast(),
          await documentFrontImage.length(),
          filename: fileNameFront);
      membershipFormUploadRequest.files.add(frontImage);
    }
    if (documentBackImage != null) {
      String fileNameBack = "back_" + documentBackImage.path.split('/').last;
      final backImage = http.MultipartFile(
          'files',
          http.ByteStream(documentBackImage.openRead()).cast(),
          await documentBackImage.length(),
          filename: fileNameBack);
      membershipFormUploadRequest.files.add(backImage);
    }

    if (addressProofImage != null) {
      String fileNameAddressProof =
          "address_" + addressProofImage.path.split('/').last;
      final addressImage = http.MultipartFile(
          'files',
          http.ByteStream(addressProofImage.openRead()).cast(),
          await addressProofImage.length(),
          filename: fileNameAddressProof);
      membershipFormUploadRequest.files.add(addressImage);
    }

    if (rnRmImageFile != null) {
      String rnRMImageName = "registered_" + rnRmImageFile.path.split('/').last;
      final rnRmImage = http.MultipartFile(
          'files',
          http.ByteStream(rnRmImageFile.openRead()).cast(),
          await rnRmImageFile.length(),
          filename: rnRMImageName);
      membershipFormUploadRequest.files.add(rnRmImage);
    }

    if (recentImageFile != null) {
      String recentImageName =
          "picture_" + recentImageFile.path.split('/').last;
      final recentImage = http.MultipartFile(
          'files',
          http.ByteStream(recentImageFile.openRead()).cast(),
          await recentImageFile.length(),
          filename: recentImageName);
      membershipFormUploadRequest.files.add(recentImage);
    }

    // debugPrint("jsonMap referredByValue --> ${jsonMap["referredByValue"]}");
    // debugPrint("jsonMap referredByValue --> ${jsonMap["referredBy"]}");

    String membershipDetailsJson = jsonEncode(jsonMap);
    membershipFormUploadRequest.fields["membershipDetails"] =
        membershipDetailsJson;

    try {
      final streamedResponse = await membershipFormUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      debugPrint(
          "createMembership header ----> " + response.headers.toString());
      //debugPrint("response --> ${response.body}");
      return response;
    } catch (e) {
      // print(e);
      return null;
    }
  }

  Future<dynamic> updateMembership(
      Map jsonMap,
      String membershipId,
      File documentFrontImage,
      File documentBackImage,
      File addressProofImage,
      File rnRmImageFile,
      File recentImageFile) async {
    final url =
        WebserviceConstants.baseURL + "/filing/membership/form/$membershipId";
    debugPrint("membership update payment url --->");
    debugPrint(url);
    final membershipFormUploadRequest =
        http.MultipartRequest('PUT', Uri.parse(url));
    membershipFormUploadRequest.headers.putIfAbsent(
        WebserviceConstants.contentType,
        () => WebserviceConstants.multipartForm);
    membershipFormUploadRequest.headers.putIfAbsent(
        WebserviceConstants.username, () => AppPreferences().username);
    membershipFormUploadRequest.headers
        .putIfAbsent("clientid", () => AppPreferences().clientId);

    if (documentFrontImage != null) {
      String fileNameFront = "front_" + documentFrontImage.path.split('/').last;
      final frontImage = http.MultipartFile(
          'files',
          http.ByteStream(documentFrontImage.openRead()).cast(),
          await documentFrontImage.length(),
          filename: fileNameFront);
      membershipFormUploadRequest.files.add(frontImage);
    }

    if (documentBackImage != null) {
      String fileNameBack = "back_" + documentBackImage.path.split('/').last;
      final backImage = http.MultipartFile(
          'files',
          http.ByteStream(documentBackImage.openRead()).cast(),
          await documentBackImage.length(),
          filename: fileNameBack);
      membershipFormUploadRequest.files.add(backImage);
    }

    if (addressProofImage != null) {
      String fileNameAddressProof =
          "address_" + addressProofImage.path.split('/').last;
      final addressImage = http.MultipartFile(
          'files',
          http.ByteStream(addressProofImage.openRead()).cast(),
          await addressProofImage.length(),
          filename: fileNameAddressProof);
      membershipFormUploadRequest.files.add(addressImage);
    }

    if (rnRmImageFile != null) {
      String rnRMImageName = "registered_" + rnRmImageFile.path.split('/').last;
      final rnRmImage = http.MultipartFile(
          'files',
          http.ByteStream(rnRmImageFile.openRead()).cast(),
          await rnRmImageFile.length(),
          filename: rnRMImageName);
      membershipFormUploadRequest.files.add(rnRmImage);
    }

    if (recentImageFile != null) {
      String recentImageName =
          "picture_" + recentImageFile.path.split('/').last;
      final recentImage = http.MultipartFile(
          'files',
          http.ByteStream(recentImageFile.openRead()).cast(),
          await recentImageFile.length(),
          filename: recentImageName);
      membershipFormUploadRequest.files.add(recentImage);
    }

    String membershipDetailsJson = jsonEncode(jsonMap);
    membershipFormUploadRequest.fields["membershipDetails"] =
        membershipDetailsJson;

    try {
      final streamedResponse = await membershipFormUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint(
          "updateMembership header ----> " + response.headers.toString());
      debugPrint(url);
      debugPrint(membershipDetailsJson);
      return response;
    } catch (e) {
      debugPrint(e);
      return null;
    }
  }

  Future<Map<String, String>> createHeader({String userName}) async {
    Map<String, String> header = {};
    String username = userName ?? await AppPreferences.getUsername();
    String clientId = await AppPreferences.getClientId();
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    header.putIfAbsent("clientid", () => clientId);
    return header;
  }
}
