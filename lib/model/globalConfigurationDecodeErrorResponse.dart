class GlobalConfigurationDecodeErrorResponse {
  String timestamp;
  int status;
  String error;
  String message;

  GlobalConfigurationDecodeErrorResponse({
    this.timestamp,
    this.status,
    this.error,
    this.message,
  });

  GlobalConfigurationDecodeErrorResponse.fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'];
    status = json['status'];
    error = json['error'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['timestamp'] = this.timestamp;
    data['status'] = this.status;
    data['error'] = this.error;
    data['message'] = this.message;
    return data;
  }
}
