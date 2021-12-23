class GroupSearchRequest {
  List<String> columnList;
  String entity;
  List<GroupFilterData> filterData;

  GroupSearchRequest({this.columnList, this.entity, this.filterData}) {
    this.columnList = [
      "active",
      "comments",
      "createdBy",
      "createdOn",
      "departmentName",
      "escalationInterval",
      "groupName",
      "groupType",
      "modifiedBy",
      "modifiedOn",
      "type"
    ];
  }

  GroupSearchRequest.fromJson(Map<String, dynamic> json) {
    columnList = json['columnList'].cast<String>();
    entity = json['entity'];
    if (json['filterData'] != null) {
      filterData = new List<GroupFilterData>();
      json['filterData'].forEach((v) {
        filterData.add(new GroupFilterData.fromJson(v));
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

class GroupFilterData {
  String columnName;
  String columnType;
  List<String> columnValue;
  String filterType;

  GroupFilterData(
      {this.columnName, this.columnType, this.columnValue, this.filterType});

  GroupFilterData.fromJson(Map<String, dynamic> json) {
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
