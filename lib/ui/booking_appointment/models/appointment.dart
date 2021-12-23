class Appointment {
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
  String doctorId;
  String doctorName;
  String location;
  String departmentName;
  bool returnSMS;
  String smsReturnTime;
  String appointmentTime;
  String reportTime;
  String review;
  dynamic rating;
  String cancellationReason;
  bool complete;
  String smsDesc;
  bool valid;
  String bookingId;
  String sex;
  bool freeConsultation;
  int appointmentFee;
  int age;
  String emailReturnTime;
  String emailDesc;
  String doctorImage;
  String appointmentStartTime;
  String appointmentEndTime;
  String appointmentStatus;
  String appointmentTiming;
  String doctorFullName;
  String downloadProfileURL;
  String doctorCategory;
  String referenceId;
  bool isScreenSharing = false;
  bool isRecording = false;
  List recordedFiles;
  PaymentDetail paymentDetail;
    String generatedToken;

  Appointment(
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
      this.location,
      this.departmentName,
      this.returnSMS,
      this.smsReturnTime,
      this.appointmentTime,
      this.reportTime,
      this.complete,
      this.doctorCategory,
      this.smsDesc,
      this.valid,
      this.recordedFiles,
      this.bookingId,
      this.cancellationReason,
      this.sex,
      this.appointmentFee,
      this.freeConsultation,
      this.review,
      this.rating,
      this.age,
      this.emailReturnTime,
      this.emailDesc,
      this.downloadProfileURL,
      this.doctorImage,
      this.appointmentStartTime,
      this.appointmentEndTime,
      this.appointmentStatus,
      this.appointmentTiming,
      this.doctorFullName,
      this.referenceId,
      this.isScreenSharing,
      this.isRecording,
      this.paymentDetail,
      this.generatedToken
      });

  Appointment.fromJson(Map<String, dynamic> data) {
    appointmentStartTime = data['appointmentStartTime'] ?? "";
    appointmentEndTime = data['appointmentEndTime'] ?? "";
    appointmentStatus = data['appointmentStatus'] ?? "";
    appointmentTiming = data['appointmentTiming'] ?? "";
    createdBy = data['createdBy'] ?? "";
    createdOn = data['createdOn'] ?? "";
    modifiedBy = data['modifiedBy'] ?? "";
    modifiedOn = data['modifiedOn'] ?? "";
    active = data['active'] ?? false;
    doctorCategory = data['doctorCategory'] ?? "";
    comments = data['comments'] ?? "";
    requestDate = data['requestDate'] ?? "";
    patientName = data['patientName'] ?? "";
    rating = data['rating'] ?? 0.0;
    review = data['review'] ?? "";
    firstName = data['firstName'] ?? "";
    lastName = data['lastName'] ?? "";
    patientFullName = data['patientFullName'] ?? "";
    doctorId = data['doctorId'] ?? "";
    downloadProfileURL = data['downloadProfileURL'] ?? "";
    cancellationReason = data['cancellationReason'] ?? "";
    recordedFiles = data['recordedFiles'] as List;
    doctorName = data['doctorName'] ?? "";
    location = data['location'] ?? "";
    freeConsultation = data['freeConsultation'];
    appointmentFee = data['appointmentFee'];
    departmentName = data['departmentName'] ?? "";
    returnSMS = data['returnSMS'] ?? false;
    smsReturnTime = data['smsReturnTime'] ?? "";
    appointmentTime = data['appointmentTime'] ?? "";
    reportTime = data['reportTime'] ?? "";
    complete = data['complete'] ?? true;
    smsDesc = data['smsDesc'] ?? "";
    valid = data['valid'] ?? false;
    bookingId = data['bookingId'] ?? "";
    sex = data['sex'] ?? "";
    age = data['age'] ?? 0;
    emailReturnTime = data['emailReturnTime'] ?? "";
    emailDesc = data['emailDesc'] ?? "";
    doctorImage = data['doctorImage'] ?? "";
    doctorFullName = data['doctorFullName'] ?? "";
    referenceId = data['referenceId'] ?? "";
    isScreenSharing = data['isScreensharing'] ?? false;
    isRecording = data['isRecording'] ?? false;
    paymentDetail = PaymentDetail.fromJson(data['paymentDetail']) ?? null;
    generatedToken = data['generatedToken'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['active'] = this.active;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['modifiedBy'] = this.modifiedBy;
    data['modifiedOn'] = this.modifiedOn;
    data['active'] = this.active;
    data['comments'] = this.comments;
    data['requestDate'] = this.requestDate;
    data['doctorCategory'] = this.doctorCategory;
    data['patientName'] = this.patientName;
    data['appointmentFee'] = this.appointmentFee;
    data['freeConsultation'] = this.freeConsultation;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['patientFullName'] = this.patientFullName;
    data['doctorId'] = this.doctorId;
    data['doctorName'] = this.doctorName;
    data['cancellationReason'] = this.cancellationReason;
    data['location'] = this.location;
    data['departmentName'] = this.departmentName;
    data['returnSMS'] = this.returnSMS;
    data['smsReturnTime'] = this.smsReturnTime;
    data['recordedFiles'] = this.recordedFiles;
    data['appointmentTime'] = this.appointmentTime;
    data['reportTime'] = this.reportTime;
    data['downloadProfileURL'] = this.downloadProfileURL;
    data['complete'] = this.complete;
    data['smsDesc'] = this.smsDesc;
    data['review'] = this.review;
    data['rating'] = this.rating;
    data['valid'] = this.valid;
    data['bookingId'] = this.bookingId;
    data['sex'] = this.sex;
    data['age'] = this.age;
    data['emailReturnTime'] = this.emailReturnTime;
    data['emailDesc'] = this.emailDesc;
    data['doctorImage'] = this.doctorImage;
    data['appointmentStartTime'] = this.appointmentStartTime;
    data['appointmentEndTime'] = this.appointmentEndTime;
    data['appointmentStatus'] = this.appointmentStatus;
    data['appointmentTiming'] = this.appointmentTiming;
    data['doctorFullName'] = this.doctorFullName;
    data['referenceId'] = this.referenceId;
    data['isScreensharing'] = this.isScreenSharing;
    data['isRecording'] = this.isRecording;
    data['paymentDetail'] = this.paymentDetail;
data['generatedToken'] = this.generatedToken;
    return data;
  }
}

class PaymentDetail {
  String transactionId;
  String paymentStatus;

  PaymentDetail({this.transactionId, this.paymentStatus});
  PaymentDetail.fromJson(Map<String, dynamic> data) {
    transactionId = data['transactionId'] ?? "";
    paymentStatus = data['paymentStatus'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['transactionId'] = this.transactionId;
    data['paymentStatus'] = this.paymentStatus;
    return data;
  }
}
