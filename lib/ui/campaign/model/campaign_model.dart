class CampaignModel {
  String formid;
  String moduleName;
  String formName;
  String form;
  String campaignName;
  String campaignType;
  String pollDescription;
  String userGrp;
  List<String> users;
  String departmentName;
  String createdOn;
  String modifiedOn;
  String startDate;
  String endDate;
  String publishingMode;
  String message;
  String campaignStartDate;
  String campaignEndDate;
  String notificationType;

  CampaignModel(
      {this.formid,
      this.moduleName,
      this.formName,
      this.form,
      this.campaignName,
      this.campaignType,
      this.pollDescription,
      this.userGrp,
      this.users,
      this.departmentName,
      this.createdOn,
      this.modifiedOn,
      this.startDate,
      this.endDate,
      this.publishingMode,
      this.message,
      this.campaignStartDate,
      this.campaignEndDate,
      this.notificationType});

  CampaignModel.fromJson(Map<String, dynamic> json) {
    formid = json['formid'];
    moduleName = json['moduleName'];
    formName = json['formName'];
    form = json['form'];
    campaignName = json['campaignName'];
    campaignType = json['campaignType'];
    pollDescription = json['pollDescription'];
    userGrp = json['userGrp'];
    users = json['users'].cast<String>();
    departmentName = json['departmentName'];
    createdOn = json['createdOn'];
    modifiedOn = json['modifiedOn'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    publishingMode = json['publishingMode'];
    message = json['message'];
    campaignStartDate = json['campaignStartDate'];
    campaignEndDate = json['campaignEndDate'];
    notificationType = json['notificationType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['formid'] = this.formid;
    data['moduleName'] = this.moduleName;
    data['formName'] = this.formName;
    data['form'] = this.form;
    data['campaignName'] = this.campaignName;
    data['campaignType'] = this.campaignType;
    data['pollDescription'] = this.pollDescription;
    data['userGrp'] = this.userGrp;
    data['users'] = this.users;
    data['departmentName'] = this.departmentName;
    data['createdOn'] = this.createdOn;
    data['modifiedOn'] = this.modifiedOn;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['publishingMode'] = this.publishingMode;
    data['message'] = this.message;
    data['campaignStartDate'] = this.campaignStartDate;
    data['campaignEndDate'] = this.campaignEndDate;
    data['notificationType'] = this.notificationType;
    return data;
  }
}
