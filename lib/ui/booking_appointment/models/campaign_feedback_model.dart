class FeedbackList {
  dynamic createdBy;
  String createdOn;
  dynamic modifiedBy;
  dynamic modifiedOn;
  bool active;
  dynamic comments;
  String id;
  String user;
  String formJson;
  String formid;
  String departmentName;
  String formorigin;
  int score;
  dynamic adminFormJson;
  String status;
  String promoCode;
  dynamic emailId;
  dynamic activePhaseId;
  dynamic prospectId;
  dynamic forminfo;
  String campaignName;

  FeedbackList(
      {this.createdBy,
      this.createdOn,
      this.modifiedBy,
      this.modifiedOn,
      this.active,
      this.comments,
      this.id,
      this.user,
      this.formJson,
      this.formid,
      this.departmentName,
      this.formorigin,
      this.score,
      this.adminFormJson,
      this.status,
      this.promoCode,
      this.emailId,
      this.activePhaseId,
      this.prospectId,
      this.forminfo,
      this.campaignName});

  FeedbackList.fromJson(Map<String, dynamic> json) {
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    modifiedBy = json['modifiedBy'];
    modifiedOn = json['modifiedOn'];
    active = json['active'];
    comments = json['comments'];
    id = json['id'];
    user = json['user'];
    formJson = json['formJson'];
    formid = json['formid'];
    departmentName = json['departmentName'];
    formorigin = json['formorigin'];
    score = json['score'];
    adminFormJson = json['adminFormJson'];
    status = json['status'];
    promoCode = json['promoCode'];
    emailId = json['emailId'];
    activePhaseId = json['activePhaseId'];
    prospectId = json['prospectId'];
    forminfo = json['forminfo'];
    campaignName = json['campaignName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['modifiedBy'] = this.modifiedBy;
    data['modifiedOn'] = this.modifiedOn;
    data['active'] = this.active;
    data['comments'] = this.comments;
    data['id'] = this.id;
    data['user'] = this.user;
    data['formJson'] = this.formJson;
    data['formid'] = this.formid;
    data['departmentName'] = this.departmentName;
    data['formorigin'] = this.formorigin;
    data['score'] = this.score;
    data['adminFormJson'] = this.adminFormJson;
    data['status'] = this.status;
    data['promoCode'] = this.promoCode;
    data['emailId'] = this.emailId;
    data['activePhaseId'] = this.activePhaseId;
    data['prospectId'] = this.prospectId;
    data['forminfo'] = this.forminfo;
    data['campaignName'] = this.campaignName;
    return data;
  }
}