class ContactSearchRequest {
  List<String> columnList;
  String entity;
  List<ContactsFilterData> filterData;

  ContactSearchRequest({this.columnList, this.entity, this.filterData}) {
    this.columnList = [
      "active",
      "comments",
      "contactName",
      "countryCode",
      "countryCodeValue",
      "createdBy",
      "createdOn",
      "defaultContact",
      "departmentName",
      "firstName",
      // "formattedCreatedDate",
      "hold",
      "lastName",
      "modifiedBy",
      "modifiedOn",
      "toMailId",
      "toNumber",
      "type",
      "userFullName",
      "userName"
    ];
  }

  ContactSearchRequest.fromJson(Map<String, dynamic> json) {
    columnList = json['columnList'].cast<String>();
    entity = json['entity'];
    if (json['filterData'] != null) {
      filterData = new List<ContactsFilterData>();
      json['filterData'].forEach((v) {
        filterData.add(new ContactsFilterData.fromJson(v));
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

class ContactsFilterData {
  String columnName;
  String columnType;
  List<String> columnValue;
  String filterType;

  ContactsFilterData(
      {this.columnName, this.columnType, this.columnValue, this.filterType});

  ContactsFilterData.fromJson(Map<String, dynamic> json) {
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
