import '../model/base_response.dart';

class UserLoginModel extends BaseResponse {
  String accessToken;
  String tokenType;
  String refreshToken;
  String scope;
  String userFullName;
  String userDepartment;
  String userName;
  String userRole;
  String statusCode;
  String error_description;
  String jti;

  UserLoginModel(
      {this.accessToken,
      this.tokenType,
      this.refreshToken,
      this.scope,
      this.userFullName,
      this.userDepartment,
      this.userName,
      this.userRole,
      this.statusCode,
      this.jti});

  UserLoginModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    refreshToken = json['refresh_token'];
    scope = json['scope'];
    userFullName = json['userFullName'];
    userDepartment = json['userDepartment'];
    userName = json['userName'];
    userRole = json['userRole'];
    statusCode = json['status'];
    jti = json['jti'];
    error_description = json['error_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['token_type'] = this.tokenType;
    data['refresh_token'] = this.refreshToken;
    data['scope'] = this.scope;
    data['userFullName'] = this.userFullName;
    data['userDepartment'] = this.userDepartment;
    data['userName'] = this.userName;
    data['userRole'] = this.userRole;
    data['status'] = this.statusCode;
    data['jti'] = this.jti;
    data['error_description'] = this.error_description;
    return data;
  }
}
