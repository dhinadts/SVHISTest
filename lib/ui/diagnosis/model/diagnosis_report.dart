import 'package:json_annotation/json_annotation.dart';

part 'diagnosis_report.g.dart';

@JsonSerializable(explicitToJson: true)
class DiagnosisReport {
  bool active;
  double column1;
  double column10;
  double column11;
  double column12;
  double column13;
  double column14;
  double column15;
  double column16;
  double column17;
  double column18;
  double column19;
  double column2;
  double column20;
  double column21;
  double column22;
  double column23;
  double column24;
  double column25;
  double column26;
  double column27;
  double column28;
  double column29;
  double column3;
  double column30;
  double column4;
  double column5;
  double column6;
  double column7;
  double column8;
  double column9;
  String comments;
  String createdBy;
  String createdOn;
  int days;
  String departmentName;
  String fastinghrs;
  String firstName;
  String id;
  String lastName;
  String modifiedBy;
  String modifiedOn;
  int months;
  bool patientInFasting;
  String reportName;
  String status;
  String userName;
  int years;

  DiagnosisReport({
    this.active,
    this.column1,
    this.column10,
    this.column11,
    this.column12,
    this.column13,
    this.column14,
    this.column15,
    this.column16,
    this.column17,
    this.column18,
    this.column19,
    this.column2,
    this.column20,
    this.column21,
    this.column22,
    this.column23,
    this.column24,
    this.column25,
    this.column26,
    this.column27,
    this.column28,
    this.column29,
    this.column3,
    this.column30,
    this.column4,
    this.column5,
    this.column6,
    this.column7,
    this.column8,
    this.column9,
    this.comments,
    this.createdBy,
    this.createdOn,
    this.days,
    this.departmentName,
    this.fastinghrs,
    this.firstName,
    this.id,
    this.lastName,
    this.modifiedBy,
    this.modifiedOn,
    this.months,
    this.patientInFasting,
    this.reportName,
    this.status,
    this.userName,
    this.years,
  });

  factory DiagnosisReport.fromJson(Map<String, dynamic> data) =>
      _$DiagnosisReportFromJson(data);

  Map<String, dynamic> toJson() => _$DiagnosisReportToJson(this);
}
