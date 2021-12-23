
import 'base_response.dart';

class UserLoginModel extends BaseResponse {
  String token;
  String statusCode;
  dynamic error;
  String userGroup;
  bool isProfile;


  UserLoginModel(
      {this.token,
        this.error,
      this.statusCode,
        this.userGroup,
        this.isProfile

      });

  UserLoginModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    statusCode = json['status'];
    error = json['error'];
    userGroup = json['group'];
    isProfile = json['is_profile'];
  }
}
