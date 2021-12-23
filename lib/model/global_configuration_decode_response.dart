import 'env_props.dart';

class GlobalConfigurationDecodeResponse {
  int id;
  String countryName;
  String apiUrl;
  String uiUrl;
  String keyspace;
  String departmentName;
  String environmentCode;
  String timestamp;
  int status;
  String error;
  String message;
  String path;
  EnvProps envProps;
  DepartmentProps departmentProps;
  String environmentShortCode;

  GlobalConfigurationDecodeResponse(
      {this.id,
      this.countryName,
      this.apiUrl,
      this.uiUrl,
      this.keyspace,
      this.departmentName,
      this.environmentCode,
      this.timestamp,
      this.status,
      this.error,
      this.message,
      this.envProps,
      this.departmentProps,
      this.path,
      this.environmentShortCode});

  GlobalConfigurationDecodeResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryName = json['countryName'];
    environmentCode = json['environmentCode'];
    apiUrl = json['apiUrl'];
    uiUrl = json['uiUrl'];
    keyspace = json['keyspace'];
    departmentName = json['departmentName'];
    timestamp = json['timestamp'];
    status = json['status'];
    error = json['error'];
    message = json['message'];
    path = json['path'];
    // print(json['environmentProperties']);
    envProps = EnvProps.fromJson(json['environmentProperties']);
    departmentProps = DepartmentProps.fromJson(json['departmentProperties']);
    environmentShortCode = json['environmentShortCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['countryName'] = this.countryName;
    data['environmentCode'] = this.environmentCode;
    data['apiUrl'] = this.apiUrl;
    data['uiUrl'] = this.uiUrl;
    data['keyspace'] = this.keyspace;
    data['departmentName'] = this.departmentName;
    data['timestamp'] = this.timestamp;
    data['status'] = this.status;
    data['error'] = this.error;
    data['message'] = this.message;
    data['path'] = this.path;
    data['environmentProperties'] = this.envProps.toJson();
    data['departmentProperties'] = this.departmentProps.toJson();
    data['environmentShortCode'] = this.environmentShortCode;
    return data;
  }
}

class DepartmentProps {
  String clientId;
  String departmentName;

  DepartmentProps({
    this.clientId,
    this.departmentName,
  });

  DepartmentProps.fromJson(Map<String, dynamic> json) {
    clientId = json['client'];
    departmentName = json['department'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['client'] = this.clientId;
    data['department'] = this.departmentName;
    return data;
  }
}
