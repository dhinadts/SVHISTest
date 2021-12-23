class MembershipSearchRequestModel {
  List<String> columnList;
  String entity;
  List<MembershipFilterData> filterData;

  MembershipSearchRequestModel(
      {this.columnList, this.entity, this.filterData}) {
    this.columnList = [
      "userName",
      "membershipId",
      "membershipStatus",
      "membershipType",
      "departmentName",
      "firstName",
      "lastName",
      "userFullName",
      "address1",
      "address2",
      "age",
      "birthDate",
      "city",
      "modifiedOn",
      "approvedDate",
    ];
  }

  MembershipSearchRequestModel.fromJson(Map<String, dynamic> json) {
    columnList = json['columnList'].cast<String>();
    entity = json['entity'];
    if (json['filterData'] != null) {
      filterData = new List<MembershipFilterData>();
      json['filterData'].forEach((v) {
        filterData.add(new MembershipFilterData.fromJson(v));
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

class MembershipFilterData {
  String columnName;
  String columnType;
  List<String> columnValue;
  String filterType;

  MembershipFilterData(
      {this.columnName, this.columnType, this.columnValue, this.filterType});

  MembershipFilterData.fromJson(Map<String, dynamic> json) {
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
