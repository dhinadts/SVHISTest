// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResponse _$BaseResponseFromJson(Map<String, dynamic> json) {
  return BaseResponse(
    message: json['message'] as String,
    status: json['status'] as int,
    error: json['error'],
    timestamp: json['timestamp'] as String,
    path: json['path'] as String,
  );
}

Map<String, dynamic> _$BaseResponseToJson(BaseResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
      'timestamp': instance.timestamp,
      'error': instance.error,
      'path': instance.path,
    };
