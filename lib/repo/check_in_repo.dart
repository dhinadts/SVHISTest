import 'dart:convert';
import 'dart:io';

import '../model/base_response.dart';
import '../model/user_info.dart';
import '../repo/common_repository.dart';
import '../utils/app_preferences.dart';
import 'package:http/http.dart' as http;

class CheckInRepository {
  CheckInRepository();

  //Post API helper
  Future<BaseResponse> submitSignUpMultipartRequest(UserInfo userInfo) async {
    BaseResponse respUser = UserInfo();
    try {
      var request = new http.MultipartRequest(
          "POST",
          Uri.parse(WebserviceConstants.baseCommonURL +
              WebserviceConstants.CreateURL +
              userInfo.departmentName +
              "/users"));

      request.fields['user'] = jsonEncode(userInfo.toJson());
      request.headers.putIfAbsent(WebserviceConstants.contentType,
          () => WebserviceConstants.multipartForm);
      request.headers.putIfAbsent(WebserviceConstants.username, () => "admin");
      request.headers.putIfAbsent(
          WebserviceConstants.clientId, () => AppPreferences().clientId);
      http.StreamedResponse response;
      response = await request.send();
      final responseString = await response.stream.bytesToString();
      Map<String, dynamic> obj = json.decode(responseString);
      respUser = BaseResponse.fromJson(obj);
      respUser.status = response.statusCode;
    } catch (e) {
      respUser = onMultiTimeOut();
    }

    return respUser;
  }

  //Post API helper
  Future<BaseResponse> submitUserInfoMultipartRequest(
      UserInfo userInfo, addressProofImage) async {
    var request = new http.MultipartRequest(
        "POST",
        Uri.parse(WebserviceConstants.baseCommonURL +
            WebserviceConstants.CreateURL +
            userInfo.departmentName +
            "/users"));

    request.fields['user'] = jsonEncode(userInfo.toJson());
    if (addressProofImage != null) {
      String fileNameAddressProof =
          "address_" + addressProofImage.path.split('/').last;
      final addressImage = http.MultipartFile(
          'attachments',
          http.ByteStream(addressProofImage.openRead()).cast(),
          await addressProofImage.length(),
          filename: fileNameAddressProof);
      request.files.add(addressImage);
    }
    request.headers.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.multipartForm);
    request.headers.putIfAbsent(
        WebserviceConstants.username, () => AppPreferences().username);

    request.headers.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);
    http.StreamedResponse response;
    BaseResponse respUser = UserInfo();
    print(
        "URL ${WebserviceConstants.baseCommonURL + WebserviceConstants.CreateURL + userInfo.departmentName + "/users"}");
    try {
      response = await request.send();
      final responseString = await response.stream.bytesToString();
      Map<String, dynamic> obj = json.decode(responseString);
      respUser = BaseResponse.fromJson(obj);
      respUser.status = response.statusCode;
      print("Response Body $responseString");
    } catch (e) {
      respUser = onMultiTimeOut();
      respUser.status = response.statusCode;
      print("Response Exception : $e");
      print("Response responseCode : ${response.statusCode}");
      print("Response Body respUser ${respUser.toJson()}");
    }

    return respUser;
  }

  //Post API helper
  Future<BaseResponse> updateUserInfoMultipartRequest(
      UserInfo userInfo, File addressProofImage,
      {String sourceDepartment = null}) async {
    String _departmentName;
    if (sourceDepartment == null) {
      _departmentName = userInfo.departmentName;
    } else {
      _departmentName = sourceDepartment;
    }
    if (_departmentName == null || _departmentName.isEmpty) {
      _departmentName = await AppPreferences.getDeptName();
    }

    String username = await AppPreferences.getUsername();
    print("inside the multipart $username");
    print(WebserviceConstants.baseCommonURL +
        WebserviceConstants.CreateURL +
        _departmentName +
        "/users/" +
        username);
    var request = new http.MultipartRequest(
        "PUT",
        Uri.parse(WebserviceConstants.baseCommonURL +
            WebserviceConstants.CreateURL +
            _departmentName +
            "/users/" +
            username));
    request.fields['user'] = jsonEncode(userInfo.toJson());
    if (addressProofImage != null) {
      String fileNameAddressProof =
          "address_" + addressProofImage.path.split('/').last;
      final addressImage = http.MultipartFile(
          'attachments',
          http.ByteStream(addressProofImage.openRead()).cast(),
          await addressProofImage.length(),
          filename: fileNameAddressProof);
      request.files.add(addressImage);
    }
    request.headers.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.multipartForm);
    request.headers.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);
    request.headers.putIfAbsent(WebserviceConstants.username, () => username);
    http.StreamedResponse response;
    BaseResponse respUser = UserInfo();
    try {
      response = await request.send();
      final responseString = await response.stream.bytesToString();
      Map<String, dynamic> obj = json.decode(responseString);
      respUser = BaseResponse.fromJson(obj);
      respUser.status = response.statusCode;
      print(respUser);
    } catch (e) {
      respUser = onMultiTimeOut();
    }

    return respUser;
  }

  // ignore: missing_return
  Future<bool> updateUserDepartmentMultipartRequest(UserInfo userInfo,
      File addressProofImage, String sourceDepartment) async {
    String _departmentName = sourceDepartment;

    print(WebserviceConstants.baseAdminURL +
        WebserviceConstants.CreateURL +
        _departmentName +
        "/users/" +
        userInfo.userName);
    var request = new http.MultipartRequest(
        "PUT",
        Uri.parse(WebserviceConstants.baseAdminURL +
            WebserviceConstants.CreateURL +
            _departmentName +
            "/users/" +
            userInfo.userName));
    request.fields['user'] = jsonEncode(userInfo.toJson());
    request.headers.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.multipartForm);
    request.headers.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);
    http.StreamedResponse response;
    BaseResponse respUser = UserInfo();
    try {
      response = await request.send();
      final responseString = await response.stream.bytesToString();
      Map<String, dynamic> obj = json.decode(responseString);
      respUser = BaseResponse.fromJson(obj);
      respUser.status = response.statusCode;
      print(responseString);
      if (response.statusCode > 199 && response.statusCode < 300) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      respUser = onMultiTimeOut();
      return false;
    }
  }

  http.Response _onTimeOut() {
    BaseResponse appBaseResponse = BaseResponse(
        status: 500, message: AppPreferences().getApisErrorMessage);
    http.Response response = http.Response(jsonEncode(appBaseResponse), 500);
    return response;
  }

  BaseResponse onMultiTimeOut() {
    BaseResponse appBaseResponse = BaseResponse(
        status: 500, message: AppPreferences().getApisErrorMessage);
    //BaseResponse response = BaseResponse(jsonEncode(appBaseResponse), 500);
    return appBaseResponse;
  }
}
