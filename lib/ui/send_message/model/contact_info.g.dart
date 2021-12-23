// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactInfo _$ContactInfoFromJson(Map<String, dynamic> json) {
  return ContactInfo(
    active: json['active'] as bool,
    comments: json['comments'] as String,
    contactName: json['contactName'] as String,
    countryCode: json['countryCode'] as int,
    countryCodeValue: json['countryCodeValue'] as String,
    createdBy: json['createdBy'] as String,
    createdOn: json['createdOn'] as String,
    defaultContact: json['defaultContact'] as bool,
    departmentName: json['departmentName'] as String,
    firstName: json['firstName'] as String,
    formattedCreatedDate: json['formattedCreatedDate'] as String,
    hold: json['hold'] as bool,
    lastName: json['lastName'] as String,
    modifiedBy: json['modifiedBy'] as String,
    modifiedOn: json['modifiedOn'] as String,
    toMailId: json['toMailId'] as String,
    toNumber: json['toNumber'] as String,
    type: json['type'] as String,
    userFullName: json['userFullName'] as String,
    userName: json['userName'] as String,
  );
}

Map<String, dynamic> _$ContactInfoToJson(ContactInfo instance) =>
    <String, dynamic>{
      'active': instance.active,
      'comments': instance.comments,
      'contactName': instance.contactName,
      'countryCode': instance.countryCode,
      'countryCodeValue': instance.countryCodeValue,
      'createdBy': instance.createdBy,
      'createdOn': instance.createdOn,
      'defaultContact': instance.defaultContact,
      'departmentName': instance.departmentName,
      'firstName': instance.firstName,
      'formattedCreatedDate': instance.formattedCreatedDate,
      'hold': instance.hold,
      'lastName': instance.lastName,
      'modifiedBy': instance.modifiedBy,
      'modifiedOn': instance.modifiedOn,
      'toMailId': instance.toMailId,
      'toNumber': instance.toNumber,
      'type': instance.type,
      'userFullName': instance.userFullName,
      'userName': instance.userName,
    };
