// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_form_field_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MembershipFormFieldInfo _$MembershipFormFieldInfoFromJson(
    Map<String, dynamic> json) {
  return MembershipFormFieldInfo(
    active: json['active'] as bool,
    clientId: json['clientId'] as String,
    comments: json['comments'] as String,
    createdBy: json['createdBy'] as String,
    createdOn: json['createdOn'] as String,
    fieldDisplayName: json['fieldDisplayName'] as String,
    fieldId: json['fieldId'] as String,
    fieldName: json['fieldName'] as String,
    fieldType: json['fieldType'] as String,
    isMandatory: json['isMandatory'] as bool,
    modifiedOn: json['modifiedOn'] as String,
    modifiedBy: json['modifiedBy'] as String,
  );
}

Map<String, dynamic> _$MembershipFormFieldInfoToJson(
        MembershipFormFieldInfo instance) =>
    <String, dynamic>{
      'active': instance.active,
      'clientId': instance.clientId,
      'comments': instance.comments,
      'createdBy': instance.createdBy,
      'createdOn': instance.createdOn,
      'fieldDisplayName': instance.fieldDisplayName,
      'fieldId': instance.fieldId,
      'fieldName': instance.fieldName,
      'fieldType': instance.fieldType,
      'isMandatory': instance.isMandatory,
      'modifiedBy': instance.modifiedBy,
      'modifiedOn': instance.modifiedOn,
    };
