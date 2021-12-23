import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class DoctorScheduleInfo {
  String active;
  String availableDate;
  String comments;
  String departmentName;
  String doctorName;
  String endTime;
  String startTime;
  String type;
  String availabilityStatus;
  String id;
    String slotStatus;

  DoctorScheduleInfo(
      {this.active,
      this.availableDate,
      this.comments,
      this.departmentName,
      this.doctorName,
      this.endTime,
      this.startTime,
      this.type,
      this.availabilityStatus,
      this.id,
      this.slotStatus});

  DoctorScheduleInfo.fromJson(Map<String, dynamic> json) {
    active = json['active'] ?? false;
    availableDate = json['availableDate'] ?? "";
    comments = json['comments'] ?? "";
    departmentName = json['departmentName'] ?? "";
    doctorName = json['doctorName'] ?? "";
    endTime = json['endTime'] ?? "";
    startTime = json['startTime'] ?? "";
    type = json['type'] ?? "";
    availabilityStatus = json['availabilityStatus'] ?? "";
    id = json['id'] ?? "";
    slotStatus = json['slotStatus'] ?? "";
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['active'] = this.active;
    data['availableDate'] = this.availableDate;
    data['comments'] = this.comments;
    data['departmentName'] = this.departmentName;
    data['doctorName'] = this.doctorName;
    data['endTime'] = this.endTime;
    data['startTime'] = this.startTime;
    data['type'] = this.type;
    data['availabilityStatus'] = this.availabilityStatus;
    data['id'] = this.id;
    data['slotStatus'] = this.slotStatus;
    return data;
  }
}
