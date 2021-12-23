class ResetPasswordResponse {
  String timestamp;
  int status;
  String error;
  String message;
  String path;

  ResetPasswordResponse(
      {this.timestamp, this.status, this.error, this.message, this.path});

  ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'];
    status = json['status'];
    error = json['error'];
    message = json['message'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['timestamp'] = this.timestamp;
    data['status'] = this.status;
    data['error'] = this.error;
    data['message'] = this.message;
    data['path'] = this.path;
    return data;
  }
}
