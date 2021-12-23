class PatientModel {
  String userName;
  String firstName;
  String lastName;
  String emailId;
  String mobileNo;
  String userId;
  String formId;
  String submittedOn;
  String couponCode;
  int score;

  PatientModel(
      {this.userName,
      this.firstName,
      this.lastName,
      this.emailId,
      this.mobileNo,
      this.userId,
      this.formId,
      this.submittedOn,
      this.couponCode,
      this.score});

  PatientModel.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    emailId = json['emailId'];
    mobileNo = json['mobileNo'];
    userId = json['userId'];
    formId = json['formId'];
    submittedOn = json['submittedOn'];
    couponCode = json['couponCode'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userName'] = this.userName;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['emailId'] = this.emailId;
    data['mobileNo'] = this.mobileNo;
    data['userId'] = this.userId;
    data['formId'] = this.formId;
    data['submittedOn'] = this.submittedOn;
    data['couponCode'] = this.couponCode;
    data['score'] = this.score;
    return data;
  }
}
