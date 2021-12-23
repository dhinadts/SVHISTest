// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DepartmentModel _$DepartmentModelFromJson(Map<String, dynamic> json) {
  return DepartmentModel(
    createdBy: json['createdBy'] as String,
    createdOn: json['createdOn'] as String,
    modifiedBy: json['modifiedBy'] as String,
    modifiedOn: json['modifiedOn'] as String,
    active: json['active'] as bool,
    comments: json['comments'] as String,
    departmentName: json['departmentName'] as String,
    supervisorName: json['supervisorName'] as String,
    supervisorToken: json['supervisorToken'] as String,
    userToken: json['userToken'] as String,
    expiryDate: json['expiryDate'] as String,
    supervisorPromoCode: json['supervisorPromoCode'] as String,
    userPromoCode: json['userPromoCode'] as String,
    userCount: json['userCount'] as int,
    domains: (json['domains'] as List)?.map((e) => e as String)?.toList(),
    supervisors: (json['supervisors'] as List)
        ?.map((e) => e == null
            ? null
            : MembershipInfo.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    users: (json['users'] as List)
        ?.map((e) => e == null
            ? null
            : MembershipInfo.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    members: (json['members'] as List)
        ?.map((e) => e == null
            ? null
            : MembershipInfo.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    parentDepartmentName: json['parentDepartmentName'] as String,
  )
    ..message = json['message'] as String
    ..status = json['status']
    ..timestamp = json['timestamp'] as String
    ..error = json['error'] as String
    ..path = json['path'] as String
    ..subDepartments = (json['subDepartments'] as List)
        ?.map((e) => e == null
            ? null
            : SubDepartmentModel.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..allMembers = (json['allMembers'] as List)
        ?.map((e) => e == null
            ? null
            : MembershipInfo.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$DepartmentModelToJson(DepartmentModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
      'timestamp': instance.timestamp,
      'error': instance.error,
      'path': instance.path,
      'createdBy': instance.createdBy,
      'createdOn': instance.createdOn,
      'modifiedBy': instance.modifiedBy,
      'modifiedOn': instance.modifiedOn,
      'active': instance.active,
      'comments': instance.comments,
      'departmentName': instance.departmentName,
      'supervisorName': instance.supervisorName,
      'supervisorToken': instance.supervisorToken,
      'userToken': instance.userToken,
      'expiryDate': instance.expiryDate,
      'supervisorPromoCode': instance.supervisorPromoCode,
      'userPromoCode': instance.userPromoCode,
      'userCount': instance.userCount,
      'domains': instance.domains,
      'parentDepartmentName': instance.parentDepartmentName,
      'subDepartments': instance.subDepartments,
      'users': instance.users,
      'members': instance.members,
      'supervisors': instance.supervisors,
      'allMembers': instance.allMembers,
    };
