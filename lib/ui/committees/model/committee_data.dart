class CommitteeData {
  String modifiedOn;
  bool active;
  String comments;
  String departmentName;
  String committeeName;
  String committeeType;
  String committeeStrength;
  String location;
  // List<String> committeeDepartment;
  List<String> groups;
  List<String> memberTypes;
  List<dynamic> members;
  dynamic uploads;

  CommitteeData({
    this.modifiedOn,
    this.active,
    this.comments,
    this.departmentName,
    this.committeeName,
    this.committeeType,
    this.committeeStrength,
    this.location,
    // this.committeeDepartment,
    this.groups,
    this.memberTypes,
    this.members,
    this.uploads,
  });

  CommitteeData.fromJson(Map<String, dynamic> json) {
    //print("Member of userList ${json['members']}");
    modifiedOn = json['modifiedOn'];
    active = json['active'] as bool;
    comments = json['comments'];
    departmentName = json['departmentName'];
    committeeName = json['committeeName'];
    committeeType = json['committeeType'];
    committeeStrength = json['committeeStrength'];
    location = json['location'];
    // committeeDepartment = json['committeeDepartment']?.cast<String>();
    groups = json['groups']?.cast<String>();
    memberTypes = json['memberTypes']?.cast<String>();
    members = json['members'];
    uploads = json['uploads'];
  }
}
