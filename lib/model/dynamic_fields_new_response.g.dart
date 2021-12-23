// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dynamic_fields_new_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DynamicFieldsNewResponse _$DynamicFieldsNewResponseFromJson(
    Map<String, dynamic> json) {
  return DynamicFieldsNewResponse()
    ..message = json['message'] as String
    ..status = json['status']
    ..timestamp = json['timestamp'] as String
    ..error = json['error'] as String
    ..path = json['path'] as String
    ..WorkForce = (json['WorkForce'] as List)
        ?.map((e) =>
    e == null
        ? null
        : DynamicFieldsResponse.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..DATTApp = (json['DATTApp'] as List)
        ?.map((e) =>
    e == null
        ? null
        : DynamicFieldsResponse.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..HealthCare = (json['HealthCare'] as List)
        ?.map((e) =>
    e == null
        ? null
        : DynamicFieldsResponse.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$DynamicFieldsNewResponseToJson(
        DynamicFieldsNewResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
      'timestamp': instance.timestamp,
      'error': instance.error,
      'path': instance.path,
      'WorkForce': instance.WorkForce,
      'HealthCare': instance.HealthCare,
      'DATTApp': instance.DATTApp,
    };
