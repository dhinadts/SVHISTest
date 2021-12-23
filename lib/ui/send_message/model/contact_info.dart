import 'package:json_annotation/json_annotation.dart';
part 'contact_info.g.dart';

@JsonSerializable()
class ContactInfo {
  bool active;
  String comments;
  String contactName;
  int countryCode;
  String countryCodeValue;
  String createdBy;
  String createdOn;
  bool defaultContact;
  String departmentName;
  String firstName;
  String formattedCreatedDate;
  bool hold;
  String lastName;
  String modifiedBy;
  String modifiedOn;
  String toMailId;
  String toNumber;
  String type;
  String userFullName;
  String userName;

  ContactInfo({
    this.active,
    this.comments,
    this.contactName,
    this.countryCode,
    this.countryCodeValue,
    this.createdBy,
    this.createdOn,
    this.defaultContact,
    this.departmentName,
    this.firstName,
    this.formattedCreatedDate,
    this.hold,
    this.lastName,
    this.modifiedBy,
    this.modifiedOn,
    this.toMailId,
    this.toNumber,
    this.type,
    this.userFullName,
    this.userName,
  });
  factory ContactInfo.fromJson(Map<String, dynamic> data) =>
      _$ContactInfoFromJson(data);

  Map<String, dynamic> toJson() => _$ContactInfoToJson(this);
}
