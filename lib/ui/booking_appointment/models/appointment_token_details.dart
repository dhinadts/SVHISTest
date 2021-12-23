class AppointmentTokenDetails {
  String createdBy;
  String createdOn;
  String modifiedBy;
  String modifiedOn;
  bool active;
  String comments;
  String requestDate;
  String patientName;
  String firstName;
  String lastName;
  String patientFullName;
  dynamic doctorId;
  String doctorName;
  String doctorDepartmentName;
  dynamic location;
  String departmentName;
  bool returnSMS;
  dynamic smsReturnTime;
  String appointmentStartTime;
  String appointmentEndTime;
  String appointmentStatus;
  dynamic confirmedBy;
  dynamic confirmedOn;
  dynamic declinedBy;
  dynamic declinedOn;
  dynamic doctorNotes;
  dynamic medicalPrescription;
  dynamic review;
  bool freeConsultation;
  String appointmentType;
  int appointmentFee;
  PaymentDetail paymentDetail;
  dynamic refundDetail;
  dynamic rating;
  dynamic reportTime;
  bool complete;
  String smsDesc;
  bool valid;
  String bookingId;
  String sex;
  int age;
  dynamic emailReturnTime;
  String emailDesc;
  dynamic cancellationReason;
  dynamic rescheduleReason;
  dynamic appointmentLink;
  String doctorFullName;
  String generatedToken;
  String appointmentTiming;

  AppointmentTokenDetails(
      {this.createdBy,
      this.createdOn,
      this.modifiedBy,
      this.modifiedOn,
      this.active,
      this.comments,
      this.requestDate,
      this.patientName,
      this.firstName,
      this.lastName,
      this.patientFullName,
      this.doctorId,
      this.doctorName,
      this.doctorDepartmentName,
      this.location,
      this.departmentName,
      this.returnSMS,
      this.smsReturnTime,
      this.appointmentStartTime,
      this.appointmentEndTime,
      this.appointmentStatus,
      this.confirmedBy,
      this.confirmedOn,
      this.declinedBy,
      this.declinedOn,
      this.doctorNotes,
      this.medicalPrescription,
      this.review,
      this.freeConsultation,
      this.appointmentType,
      this.appointmentFee,
      this.paymentDetail,
      this.refundDetail,
      this.rating,
      this.reportTime,
      this.complete,
      this.smsDesc,
      this.valid,
      this.bookingId,
      this.sex,
      this.age,
      this.emailReturnTime,
      this.emailDesc,
      this.cancellationReason,
      this.rescheduleReason,
      this.appointmentLink,
      this.doctorFullName,
      this.generatedToken,
      this.appointmentTiming});

  AppointmentTokenDetails.fromJson(Map<String, dynamic> json) {
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    modifiedBy = json['modifiedBy'];
    modifiedOn = json['modifiedOn'];
    active = json['active'];
    comments = json['comments'];
    requestDate = json['requestDate'];
    patientName = json['patientName'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    patientFullName = json['patientFullName'];
    doctorId = json['doctorId'];
    doctorName = json['doctorName'];
    doctorDepartmentName = json['doctorDepartmentName'];
    location = json['location'];
    departmentName = json['departmentName'];
    returnSMS = json['returnSMS'];
    smsReturnTime = json['smsReturnTime'];
    appointmentStartTime = json['appointmentStartTime'];
    appointmentEndTime = json['appointmentEndTime'];
    appointmentStatus = json['appointmentStatus'];
    confirmedBy = json['confirmedBy'];
    confirmedOn = json['confirmedOn'];
    declinedBy = json['declinedBy'];
    declinedOn = json['declinedOn'];
    doctorNotes = json['doctorNotes'];
    medicalPrescription = json['medicalPrescription'];
    review = json['review'];
    freeConsultation = json['freeConsultation'];
    appointmentType = json['appointmentType'];
    appointmentFee = json['appointmentFee'];
    paymentDetail = json['paymentDetail'] != null
        ? new PaymentDetail.fromJson(json['paymentDetail'])
        : null;
    refundDetail = json['refundDetail'];
    rating = json['rating'];
    reportTime = json['reportTime'];
    complete = json['complete'];
    smsDesc = json['smsDesc'];
    valid = json['valid'];
    bookingId = json['bookingId'];
    sex = json['sex'];
    age = json['age'];
    emailReturnTime = json['emailReturnTime'];
    emailDesc = json['emailDesc'];
    cancellationReason = json['cancellationReason'];
    rescheduleReason = json['rescheduleReason'];
    appointmentLink = json['appointmentLink'];
    doctorFullName = json['doctorFullName'];
    generatedToken = json['generatedToken'];
    appointmentTiming = json['appointmentTiming'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['modifiedBy'] = this.modifiedBy;
    data['modifiedOn'] = this.modifiedOn;
    data['active'] = this.active;
    data['comments'] = this.comments;
    data['requestDate'] = this.requestDate;
    data['patientName'] = this.patientName;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['patientFullName'] = this.patientFullName;
    data['doctorId'] = this.doctorId;
    data['doctorName'] = this.doctorName;
    data['doctorDepartmentName'] = this.doctorDepartmentName;
    data['location'] = this.location;
    data['departmentName'] = this.departmentName;
    data['returnSMS'] = this.returnSMS;
    data['smsReturnTime'] = this.smsReturnTime;
    data['appointmentStartTime'] = this.appointmentStartTime;
    data['appointmentEndTime'] = this.appointmentEndTime;
    data['appointmentStatus'] = this.appointmentStatus;
    data['confirmedBy'] = this.confirmedBy;
    data['confirmedOn'] = this.confirmedOn;
    data['declinedBy'] = this.declinedBy;
    data['declinedOn'] = this.declinedOn;
    data['doctorNotes'] = this.doctorNotes;
    data['medicalPrescription'] = this.medicalPrescription;
    data['review'] = this.review;
    data['freeConsultation'] = this.freeConsultation;
    data['appointmentType'] = this.appointmentType;
    data['appointmentFee'] = this.appointmentFee;
    if (this.paymentDetail != null) {
      data['paymentDetail'] = this.paymentDetail.toJson();
    }
    data['refundDetail'] = this.refundDetail;
    data['rating'] = this.rating;
    data['reportTime'] = this.reportTime;
    data['complete'] = this.complete;
    data['smsDesc'] = this.smsDesc;
    data['valid'] = this.valid;
    data['bookingId'] = this.bookingId;
    data['sex'] = this.sex;
    data['age'] = this.age;
    data['emailReturnTime'] = this.emailReturnTime;
    data['emailDesc'] = this.emailDesc;
    data['cancellationReason'] = this.cancellationReason;
    data['rescheduleReason'] = this.rescheduleReason;
    data['appointmentLink'] = this.appointmentLink;
    data['doctorFullName'] = this.doctorFullName;
    data['generatedToken'] = this.generatedToken;
    data['appointmentTiming'] = this.appointmentTiming;
    return data;
  }
}

class PaymentDetail {
  String transactionId;
  String paymentStatus;

  PaymentDetail({this.transactionId, this.paymentStatus});

  PaymentDetail.fromJson(Map<String, dynamic> json) {
    transactionId = json['transactionId'];
    paymentStatus = json['paymentStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transactionId'] = this.transactionId;
    data['paymentStatus'] = this.paymentStatus;
    return data;
  }
}