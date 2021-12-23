// To parse this JSON data, do
//
//     final modelAppointment = modelAppointmentFromJson(jsonString);

import 'dart:convert';

ModelAppointment modelAppointmentFromJson(String str) =>
    ModelAppointment.fromJson(json.decode(str));

String modelAppointmentToJson(ModelAppointment data) =>
    json.encode(data.toJson());

class ModelAppointment {
  ModelAppointment({
    this.createdBy,
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
    this.returnSms,
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
    this.couponCode,
    this.referenceId,
    this.uid,
    this.resourceId,
    this.sid,
    this.recordedFiles,
    this.isRecording,
    this.isScreensharing,
    this.generatedToken,
    this.appointmentTiming,
  });

  String createdBy;
  DateTime createdOn;
  String modifiedBy;
  DateTime modifiedOn;
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
  bool returnSms;
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
  dynamic couponCode;
  dynamic referenceId;
  int uid;
  String resourceId;
  String sid;
  List<String> recordedFiles;
  dynamic isRecording;
  dynamic isScreensharing;
  String generatedToken;
  DateTime appointmentTiming;

  factory ModelAppointment.fromJson(Map<String, dynamic> json) =>
      ModelAppointment(
        createdBy: json["createdBy"],
        createdOn: DateTime.parse(json["createdOn"]),
        modifiedBy: json["modifiedBy"],
        modifiedOn: DateTime.parse(json["modifiedOn"]),
        active: json["active"],
        comments: json["comments"],
        requestDate: json["requestDate"],
        patientName: json["patientName"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        patientFullName: json["patientFullName"],
        doctorId: json["doctorId"],
        doctorName: json["doctorName"],
        doctorDepartmentName: json["doctorDepartmentName"],
        location: json["location"],
        departmentName: json["departmentName"],
        returnSms: json["returnSMS"],
        smsReturnTime: json["smsReturnTime"],
        appointmentStartTime: json["appointmentStartTime"],
        appointmentEndTime: json["appointmentEndTime"],
        appointmentStatus: json["appointmentStatus"],
        confirmedBy: json["confirmedBy"],
        confirmedOn: json["confirmedOn"],
        declinedBy: json["declinedBy"],
        declinedOn: json["declinedOn"],
        doctorNotes: json["doctorNotes"],
        medicalPrescription: json["medicalPrescription"],
        review: json["review"],
        freeConsultation: json["freeConsultation"],
        appointmentType: json["appointmentType"],
        appointmentFee: json["appointmentFee"],
        paymentDetail: PaymentDetail.fromJson(json["paymentDetail"]),
        refundDetail: json["refundDetail"],
        rating: json["rating"],
        reportTime: json["reportTime"],
        complete: json["complete"],
        smsDesc: json["smsDesc"],
        valid: json["valid"],
        bookingId: json["bookingId"],
        sex: json["sex"],
        age: json["age"],
        emailReturnTime: json["emailReturnTime"],
        emailDesc: json["emailDesc"],
        cancellationReason: json["cancellationReason"],
        rescheduleReason: json["rescheduleReason"],
        appointmentLink: json["appointmentLink"],
        doctorFullName: json["doctorFullName"],
        couponCode: json["couponCode"],
        referenceId: json["referenceId"],
        uid: json["uid"],
        resourceId: json["resourceId"],
        sid: json["sid"],
        recordedFiles: List<String>.from(json["recordedFiles"].map((x) => x)),
        isRecording: json["isRecording"],
        isScreensharing: json["isScreensharing"],
        generatedToken: json["generatedToken"],
        appointmentTiming: DateTime.parse(json["appointmentTiming"]),
      );

  Map<String, dynamic> toJson() => {
        "createdBy": createdBy,
        "createdOn": createdOn.toIso8601String(),
        "modifiedBy": modifiedBy,
        "modifiedOn": modifiedOn.toIso8601String(),
        "active": active,
        "comments": comments,
        "requestDate": requestDate,
        "patientName": patientName,
        "firstName": firstName,
        "lastName": lastName,
        "patientFullName": patientFullName,
        "doctorId": doctorId,
        "doctorName": doctorName,
        "doctorDepartmentName": doctorDepartmentName,
        "location": location,
        "departmentName": departmentName,
        "returnSMS": returnSms,
        "smsReturnTime": smsReturnTime,
        "appointmentStartTime": appointmentStartTime,
        "appointmentEndTime": appointmentEndTime,
        "appointmentStatus": appointmentStatus,
        "confirmedBy": confirmedBy,
        "confirmedOn": confirmedOn,
        "declinedBy": declinedBy,
        "declinedOn": declinedOn,
        "doctorNotes": doctorNotes,
        "medicalPrescription": medicalPrescription,
        "review": review,
        "freeConsultation": freeConsultation,
        "appointmentType": appointmentType,
        "appointmentFee": appointmentFee,
        "paymentDetail": paymentDetail.toJson(),
        "refundDetail": refundDetail,
        "rating": rating,
        "reportTime": reportTime,
        "complete": complete,
        "smsDesc": smsDesc,
        "valid": valid,
        "bookingId": bookingId,
        "sex": sex,
        "age": age,
        "emailReturnTime": emailReturnTime,
        "emailDesc": emailDesc,
        "cancellationReason": cancellationReason,
        "rescheduleReason": rescheduleReason,
        "appointmentLink": appointmentLink,
        "doctorFullName": doctorFullName,
        "couponCode": couponCode,
        "referenceId": referenceId,
        "uid": uid,
        "resourceId": resourceId,
        "sid": sid,
        "recordedFiles": List<dynamic>.from(recordedFiles.map((x) => x)),
        "isRecording": isRecording,
        "isScreensharing": isScreensharing,
        "generatedToken": generatedToken,
        "appointmentTiming":
            "${appointmentTiming.year.toString().padLeft(4, '0')}-${appointmentTiming.month.toString().padLeft(2, '0')}-${appointmentTiming.day.toString().padLeft(2, '0')}",
      };
}

class PaymentDetail {
  PaymentDetail({
    this.transactionId,
    this.paymentStatus,
  });

  String transactionId;
  String paymentStatus;

  factory PaymentDetail.fromJson(Map<String, dynamic> json) => PaymentDetail(
        transactionId: json["transactionId"],
        paymentStatus: json["paymentStatus"],
      );

  Map<String, dynamic> toJson() => {
        "transactionId": transactionId,
        "paymentStatus": paymentStatus,
      };
}
