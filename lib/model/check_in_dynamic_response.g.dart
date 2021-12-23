// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_in_dynamic_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckInDynamicResponse _$CheckInDynamicResponseFromJson(
    Map<String, dynamic> json) {
  return CheckInDynamicResponse()
    ..message = json['message'] as String
    ..status = json['status']
    ..timestamp = json['timestamp'] as String
    ..error = json['error'] as String
    ..path = json['path'] as String
    ..checkInDynamicList = (json['checkInList'] as List)
        ?.map((e) => e == null
            ? null
            : CheckInDynamic.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$CheckInDynamicResponseToJson(
        CheckInDynamicResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
      'timestamp': instance.timestamp,
      'error': instance.error,
      'path': instance.path,
      'checkInList': instance.checkInDynamicList,
    };
