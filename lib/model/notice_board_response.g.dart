// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_board_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoticeBoardResponse _$NoticeBoardResponseFromJson(Map<String, dynamic> json) {
  return NoticeBoardResponse()
    ..message = json['message'] as String
    ..status = json['status']
    ..timestamp = json['timestamp'] as String
    ..error = json['error'] as String
    ..path = json['path'] as String
    ..dateFilter = json['dateFilter'] as String
    ..currentPage = json['previousPage'] as bool
    ..pageSize = json['pageSize'] as int
    ..results = (json['results'] as List)
        ?.map((e) => e == null
            ? null
            : NewNotification.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$NoticeBoardResponseToJson(
        NoticeBoardResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
      'timestamp': instance.timestamp,
      'error': instance.error,
      'path': instance.path,
      'dateFilter': instance.dateFilter,
      'previousPage': instance.currentPage,
      'pageSize': instance.pageSize,
      'results': instance.results,
    };
