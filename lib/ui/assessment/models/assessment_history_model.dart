class AssessmentHistoryModel {
	bool active;
	String activePhaseId;
	String adminFormJson;
	String campaignName;
	String comments;
	String couponCode;
	String createdBy;
	String createdOn;
	String departmentName;
	String emailId;
	String formJson;
	String formid;
	String formorigin;
	String id;
	String modifiedBy;
	String modifiedOn;
	String prospectId;
	int score;
	String status;
	String user;

	AssessmentHistoryModel({this.active, this.activePhaseId, this.adminFormJson, this.campaignName, this.comments, this.couponCode, this.createdBy, this.createdOn, this.departmentName, this.emailId, this.formJson, this.formid, this.formorigin, this.id, this.modifiedBy, this.modifiedOn, this.prospectId, this.score, this.status, this.user});

	AssessmentHistoryModel.fromJson(Map<String, dynamic> json) {
		active = json['active'];
		activePhaseId = json['activePhaseId'];
		adminFormJson = json['adminFormJson'];
		campaignName = json['campaignName'];
		comments = json['comments'];
		couponCode = json['couponCode'];
		createdBy = json['createdBy'];
		createdOn = json['createdOn'];
		departmentName = json['departmentName'];
		emailId = json['emailId'];
		formJson = json['formJson'];
		formid = json['formid'];
		formorigin = json['formorigin'];
		id = json['id'];
		modifiedBy = json['modifiedBy'];
		modifiedOn = json['modifiedOn'];
		prospectId = json['prospectId'];
		score = json['score'];
		status = json['status'];
		user = json['user'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['active'] = this.active;
		data['activePhaseId'] = this.activePhaseId;
		data['adminFormJson'] = this.adminFormJson;
		data['campaignName'] = this.campaignName;
		data['comments'] = this.comments;
		data['couponCode'] = this.couponCode;
		data['createdBy'] = this.createdBy;
		data['createdOn'] = this.createdOn;
		data['departmentName'] = this.departmentName;
		data['emailId'] = this.emailId;
		data['formJson'] = this.formJson;
		data['formid'] = this.formid;
		data['formorigin'] = this.formorigin;
		data['id'] = this.id;
		data['modifiedBy'] = this.modifiedBy;
		data['modifiedOn'] = this.modifiedOn;
		data['prospectId'] = this.prospectId;
		data['score'] = this.score;
		data['status'] = this.status;
		data['user'] = this.user;
		return data;
	}
}
