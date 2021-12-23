class RequestResetPassword {
  String newPassword;
  String oldPassword;
  String userName;

  RequestResetPassword({this.newPassword, this.oldPassword, this.userName});

  RequestResetPassword.fromJson(Map<String, dynamic> json) {
    newPassword = json['newPassword'];
    oldPassword = json['oldPassword'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['newPassword'] = this.newPassword;
    data['oldPassword'] = this.oldPassword;
    data['userName'] = this.userName;
    return data;
  }
}
