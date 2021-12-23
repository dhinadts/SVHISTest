class NonMemberSearchRequestModel {
  List<String> columnList;
  String entity;
  List<NonMemberFilterData> filterData;

  NonMemberSearchRequestModel({this.columnList, this.entity, this.filterData}) {
    this.columnList = [
      "active",
      "addressLine1",
      "addressLine2",
      "addressLine3",
      "cityName",
      "comments",
      "countryName",
      "createdBy",
      "createdOn",
      "departmentName",
      "firstName",
      "hasMembership",
      "lastName",
      "membershipStatus",
      "modifiedBy",
      "modifiedOn",
      "stateName",
      "userFullName",
      "userName",
      "zipCode",
      "roleName",
      "emailId",
      "mobileNo"
    ];
  }

  NonMemberSearchRequestModel.fromJson(Map<String, dynamic> json) {
    columnList = json['columnList'].cast<String>();
    entity = json['entity'];
    if (json['filterData'] != null) {
      filterData = new List<NonMemberFilterData>();
      json['filterData'].forEach((v) {
        filterData.add(new NonMemberFilterData.fromJson(v));
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

class NonMemberFilterData {
  String columnName;
  String columnType;
  List<String> columnValue;
  String filterType;

  NonMemberFilterData(
      {this.columnName, this.columnType, this.columnValue, this.filterType});

  NonMemberFilterData.fromJson(Map<String, dynamic> json) {
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
