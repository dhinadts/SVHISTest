// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drawer_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DrawerItem _$DrawerItemFromJson(Map<String, dynamic> json) {
  return DrawerItem(
    title: json['title'] as String,
    assetUrl: json['assetUrl'] as String,
    pageId: json['pageId'] as int,
  );
}

Map<String, dynamic> _$DrawerItemToJson(DrawerItem instance) =>
    <String, dynamic>{
      'assetUrl': instance.assetUrl,
      'title': instance.title,
      'pageId': instance.pageId,
    };
