class Condition {
  int conditionId;
  String conditionKey;
  int keyId;
  String conditionOperator;
  String conditionValue;
  String conditionType;
  String conditionValueDataType;
  String conditionConnector;
  String departmentName;
  String subscriptionName;
  Null applicationName;

  Condition(
      {this.conditionId,
      this.conditionKey,
      this.keyId,
      this.conditionOperator,
      this.conditionValue,
      this.conditionType,
      this.conditionValueDataType,
      this.conditionConnector,
      this.departmentName,
      this.subscriptionName,
      this.applicationName});

  Condition.fromJson(Map<String, dynamic> json) {
    conditionId = json['conditionId'];
    conditionKey = json['conditionKey'];
    keyId = json['keyId'];
    conditionOperator = json['conditionOperator'];
    conditionValue = json['conditionValue'];
    conditionType = json['conditionType'];
    conditionValueDataType = json['conditionValueDataType'];
    conditionConnector = json['conditionConnector'];
    departmentName = json['departmentName'];
    subscriptionName = json['subscriptionName'];
    applicationName = json['applicationName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['conditionId'] = this.conditionId;
    data['conditionKey'] = this.conditionKey;
    data['keyId'] = this.keyId;
    data['conditionOperator'] = this.conditionOperator;
    data['conditionValue'] = this.conditionValue;
    data['conditionType'] = this.conditionType;
    data['conditionValueDataType'] = this.conditionValueDataType;
    data['conditionConnector'] = this.conditionConnector;
    data['departmentName'] = this.departmentName;
    data['subscriptionName'] = this.subscriptionName;
    data['applicationName'] = this.applicationName;
    return data;
  }
}
