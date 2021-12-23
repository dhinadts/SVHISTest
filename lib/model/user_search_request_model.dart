class UserSearchRequestModel {
  List<String> columnList;
  String entity;
  List<FilterData> filterData;

  UserSearchRequestModel({this.columnList, this.entity, this.filterData}) {
    this.columnList = [
      "userName",
      "departmentName",
      "firstName",
      "lastName",
      "addressLine1",
      "addressLine2",
      "addressLine3",
      "city",
      "cityName",
      "stateName",
      "zipCode",
      "mobileNo",
      "emailId",
      "roleName",
      "modifiedOn",
      "lastReportedDate",
      "userRelation",
      "profileImage",
      "downloadProfileURL",
      "membershipType",
      "membershipStatus",
      "hasMembership",
      "membershipEntitlements",
      "invalidLoginCount"
    ];
  }

  UserSearchRequestModel.fromJson(Map<String, dynamic> json) {
    columnList = json['columnList'].cast<String>();
    entity = json['entity'];
    if (json['filterData'] != null) {
      filterData = new List<FilterData>();
      json['filterData'].forEach((v) {
        filterData.add(new FilterData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['columnList'] = this.columnList;
    data['entity'] = this.entity;
    if (this.filterData != null) {
      data['filterData'] = this.filterData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FilterData {
  String columnName;
  String columnType;
  List<String> columnValue;
  String filterType;

  FilterData(
      {this.columnName, this.columnType, this.columnValue, this.filterType});

  FilterData.fromJson(Map<String, dynamic> json) {
    columnName = json['columnName'];
    columnType = json['columnType'];
    columnValue = json['columnValue'].cast<String>();
    filterType = json['filterType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['columnName'] = this.columnName;
    data['columnType'] = this.columnType;
    data['columnValue'] = this.columnValue;
    data['filterType'] = this.filterType;
    return data;
  }
}
