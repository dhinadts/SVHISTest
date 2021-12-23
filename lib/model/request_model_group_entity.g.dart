// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_model_group_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestModelGroupEntity _$RequestModelGroupEntityFromJson(
    Map<String, dynamic> json) {
  return RequestModelGroupEntity()
    ..message = json['message'] as String
    ..status = json['status']
    ..timestamp = json['timestamp'] as String
    ..error = json['error'] as String
    ..path = json['path'] as String
    ..active = json['active'] as bool
    ..column42 = json['column42'] as String
    ..column43 = json['column43'] as String
    ..departmentName = json['departmentName'] as String
    ..userName = json['userName'] as String
    ..workForceTasks = (json['workForceTasks'] as List)
        ?.map((e) => e == null
            ? null
            : WorkForceTaskModel.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$RequestModelGroupEntityToJson(
        RequestModelGroupEntity instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
      'timestamp': instance.timestamp,
      'error': instance.error,
      'path': instance.path,
      'active': instance.active,
      'column42': instance.column42,
      'column43': instance.column43,
      'departmentName': instance.departmentName,
      'userName': instance.userName,
      'workForceTasks': instance.workForceTasks,
    };
