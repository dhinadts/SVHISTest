class CommitteeInfo {
  String createdBy;
  String createdOn;
  String modifiedBy;
  String modifiedOn;
  bool active;
  String comments;
  String departmentName;
  String committeeName;
  String committeeType;
  String location;
  String committeeStrength;
  String otherMemberType;
  List<dynamic> groups;
  List<dynamic> customMemberTypes;
  List<dynamic> committeeDepartment;
  List<dynamic> memberTypes;
  List<dynamic> members;
  dynamic uploads;

  CommitteeInfo(
      {this.createdBy,
      this.createdOn,
      this.modifiedBy,
      this.modifiedOn,
      this.active,
      this.comments,
      this.departmentName,
      this.committeeName,
      this.committeeType,
      this.location,
      this.committeeStrength,
      this.otherMemberType,
      this.groups,
      this.customMemberTypes,
      this.committeeDepartment,
      this.memberTypes,
      this.members,
      this.uploads});

  CommitteeInfo.fromJson(Map<String, dynamic> json) {
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    modifiedBy = json['modifiedBy'];
    modifiedOn = json['modifiedOn'];
    active = json['active'];
    comments = json['comments'];
    departmentName = json['departmentName'];
    committeeName = json['committeeName'];
    committeeType = json['committeeType'];
    location = json['location'];
    committeeStrength = json['committeeStrength'] as String;
    otherMemberType = json['otherMemberType'];
    groups = json['groups'] as List<dynamic>;
    customMemberTypes = json['customMemberTypes'];
    committeeDepartment = json['committeeDepartment'];
    memberTypes = json['memberTypes'] as List<dynamic>;
    if (json['members'] != null) {
      members = new List<String>();
      json['members'].forEach((v) {
        members.add(v);
      });
    }
    uploads = json['uploads'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['modifiedBy'] = this.modifiedBy;
    data['modifiedOn'] = this.modifiedOn;
    data['active'] = this.active;
    data['comments'] = this.comments;
    data['departmentName'] = this.departmentName;
    data['committeeName'] = this.committeeName;
    data['committeeType'] = this.committeeType;
    data['location'] = this.location;
    data['committeeStrength'] = this.committeeStrength;
    data['otherMemberType'] = this.otherMemberType;
    data['groups'] = this.groups;
    data['customMemberTypes'] = this.customMemberTypes;
    data['committeeDepartment'] = this.committeeDepartment;
    data['memberTypes'] = this.memberTypes;
    if (this.members != null) {
      data['members'] = this.members.map((v) => v.toJson()).toList();
    }
    data['uploads'] = this.uploads;
    return data;
  }
}


class CommitteeSearchRequest {
  List<String> columnList;
  String entity;
  List<CommitteeFilterData> filterData;
  bool sortRequired;
  CommitteeSearchRequest({this.columnList, this.entity, this.filterData}) {
    this.columnList = [
      "active",
      "committeeName",
      "departmentName",
      "createdBy",
      "memberTypes",
      "modifiedOn"
    ];
    this.sortRequired = true;
  }

  CommitteeSearchRequest.fromJson(Map<String, dynamic> json) {
    columnList = json['columnList'].cast<String>();
    entity = json['entity'];
    sortRequired = json['sortRequired'];
    if (json['filterData'] != null) {
      filterData = new List<CommitteeFilterData>();
      json['filterData'].forEach((v) {
        filterData.add(new CommitteeFilterData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['columnList'] = this.columnList;
    data['entity'] = this.entity;
    data['sortRequired'] = this.sortRequired;
    if (this.filterData != null) {
      data['filterData'] = this.filterData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommitteeFilterData {
  String columnName;
  String columnType;
  List<String> columnValue;
  String filterType;

  CommitteeFilterData(
      {this.columnName, this.columnType, this.columnValue, this.filterType});

  CommitteeFilterData.fromJson(Map<String, dynamic> json) {
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
