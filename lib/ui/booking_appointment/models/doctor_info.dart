class UserAsDoctorInfo {
  String userName;
  String firstName;
  String lastName;
  String userFullName;
  String emailId;
  String mobileNo;
  String registrationNumber;
  List<String> specialities;
  double rating;
  String experience;
  DoctorInfo dInfo;
  String profileImage;
  String downloadProfileURL;
  bool isConsultant;
  String userCategory;
  String gender;
  String sourceReferenceId;
  String language;
  UserAsDoctorInfo(
      {this.userName,
      this.firstName,
      this.lastName,
      this.userFullName,
      this.emailId,
      this.mobileNo,
      this.registrationNumber,
      this.specialities,
      this.experience,
      this.rating,
      this.downloadProfileURL,
      this.dInfo,
      this.profileImage,
      this.isConsultant,
      this.sourceReferenceId,
      this.userCategory,
      this.gender,
      this.language});
  UserAsDoctorInfo.fromJson(Map<String, dynamic> json) {
    userName = json['userName'] ?? "";
    firstName = json['firstName'] ?? "";
    lastName = json['lastName'] ?? "";
    userFullName = json['userFullName'] ?? "";
    emailId = json['emailId'] ?? "";
    downloadProfileURL = json['downloadProfileURL'] ?? "";
    sourceReferenceId = json['sourceReferenceId'] ?? "";
    mobileNo = json['mobileNo'] ?? "";
    registrationNumber = json['registrationNumber'] ?? "";
    experience = json['experience'] ?? "";
    rating = json['rating'] ?? 0.0;
    specialities = json["specialities"] == null
        ? []
        : List<String>.from(json["specialities"].map((x) => x));
    dInfo = json['doctorInfo'] == null
        ? null
        : DoctorInfo.fromJson(json['doctorInfo']);
    profileImage = json['profileImage'] ?? "";
    isConsultant = false;
    userCategory = json['userCategory'] ?? "";
    gender = json['gender'] ?? "";
    language = json['language'] ?? "";
    //  (data['doctorInfo'] as List)
    //   ?.map((e) => e == null
    //       ? null
    //       : DoctorAvailabilitySlot.fromJson(e as Map<String, dynamic>))
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['userName'] = this.userName;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['userFullName'] = this.userFullName;
    data['emailId'] = this.emailId;
    data['mobileNo'] = this.mobileNo;
    data['registrationNumber'] = this.registrationNumber;
    data['specialities'] = this.specialities;
    data['experience'] = this.experience;
    data['rating'] = this.rating;
    data['profileImage'] = this.profileImage;
    data['sourceReferenceId'] = this.sourceReferenceId;
    data['downloadProfileURL'] = this.downloadProfileURL;
    data['userCategory'] = this.userCategory;
    data['language'] = this.language;
    data['gender'] = this.gender;
  }
}

class DoctorInfo {
  String createdBy;
  String createdOn;
  String modifiedBy;
  String modifiedOn;
  bool active;
  String comments;
  String departmentName;
  String doctorName;
  String experience;
  String startedWorkingOn;
  List<String> workingHours;
  int smsConsultationFee;
  int voiceConsultationFee;
  int videoConsultationFee;
  int inPersonConsultationFee;
  List<String> availableDays;
  DoctorInfo({
    this.createdBy,
    this.createdOn,
    this.modifiedBy,
    this.modifiedOn,
    this.active,
    this.comments,
    this.departmentName,
    this.doctorName,
    this.experience,
    this.startedWorkingOn,
    this.workingHours,
    this.smsConsultationFee,
    this.voiceConsultationFee,
    this.videoConsultationFee,
    this.inPersonConsultationFee,
    this.availableDays,
  });
  DoctorInfo.fromJson(Map<String, dynamic> json) {
    createdBy = json['createdBy'] ?? "";
    createdOn = json['createdOn'] ?? "";
    modifiedBy = json['modifiedBy'] ?? "";
    modifiedOn = json['modifiedOn'] ?? "";
    active = json['active'] ?? false;
    comments = json['comments'] ?? "";
    departmentName = json['departmentName'] ?? "";
    doctorName = json['doctorName'] ?? "";
    experience = json['experience'] ?? "";
    startedWorkingOn = json['startedWorkingOn'] ?? "";
    smsConsultationFee = json['smsConsultationFee'] ?? 0;
    voiceConsultationFee = json['voiceConsultationFee'] ?? 0;
    videoConsultationFee = json['videoConsultationFee'] ?? 0;
    inPersonConsultationFee = json['inPersonConsultationFee'] ?? 0;
    availableDays = json["availableDays"] == null
        ? []
        : List<String>.from(json["availableDays"].map((x) => x));

    workingHours = json["workingHours"] == null
        ? []
        : List<String>.from(json["workingHours"].map((x) => x));
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
    data['startedWorkingOn'] = this.startedWorkingOn;
    data['workingHours'] = this.workingHours;
    data['smsConsultationFee'] = this.smsConsultationFee;
    data['voiceConsultationFee'] = this.voiceConsultationFee;
    data['videoConsultationFee'] = this.videoConsultationFee;
    data['inPersonConsultationFee'] = this.inPersonConsultationFee;
    data['availableDays'] = this.availableDays;
  }
}
