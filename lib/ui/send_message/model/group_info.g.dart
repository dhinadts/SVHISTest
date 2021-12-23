// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupInfo _$GroupInfoFromJson(Map<String, dynamic> json) {
  return GroupInfo(
    active: json['active'] as bool,
    comments: json['comments'] as String,
    createdBy: json['createdBy'] as String,
    createdOn: json['createdOn'] as String,
    departmentName: json['departmentName'] as String,
    escalationInterval: json['escalationInterval'] as int,
    formattedCreatedDate: json['formattedCreatedDate'] as String,
    groupName: json['groupName'] as String,
    groupType: json['groupType'] as String,
    modifiedBy: json['modifiedBy'] as String,
    modifiedOn: json['modifiedOn'] as String,
    type: json['type'] as String,
  );
}

Map<String, dynamic> _$GroupInfoToJson(GroupInfo instance) => <String, dynamic>{
      'active': instance.active,
      'comments': instance.comments,
      'createdBy': instance.createdBy,
      'createdOn': instance.createdOn,
      'departmentName': instance.departmentName,
      'escalationInterval': instance.escalationInterval,
      'formattedCreatedDate': instance.formattedCreatedDate,
      'groupName': instance.groupName,
      'groupType': instance.groupType,
      'modifiedOn': instance.modifiedOn,
      'modifiedBy': instance.modifiedBy,
      'type': instance.type,
    };
