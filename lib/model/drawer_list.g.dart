// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drawer_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DrawerListResponse _$DrawerListResponseFromJson(Map<String, dynamic> json) {
  return DrawerListResponse()
    ..message = json['message'] as String
    ..status = json['status']
    ..timestamp = json['timestamp'] as String
    ..error = json['error'] as String
    ..path = json['path'] as String
    ..userDrawers = (json['user'] as List)
        ?.map((e) =>
            e == null ? null : DrawerItem.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..supervisorDrawers = (json['supervisor'] as List)
        ?.map((e) =>
            e == null ? null : DrawerItem.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$DrawerListResponseToJson(DrawerListResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
      'timestamp': instance.timestamp,
      'error': instance.error,
      'path': instance.path,
      'user': instance.userDrawers,
      'supervisor': instance.supervisorDrawers,
    };
