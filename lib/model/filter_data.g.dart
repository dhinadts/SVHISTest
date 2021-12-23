// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterData _$FilterDataFromJson(Map<String, dynamic> json) {
  return FilterData()
    ..columnName = json['columnName'] as String
    ..columnValue =
        (json['columnValue'] as List)?.map((e) => e as String)?.toList()
    ..filterType = json['filterType'] as String
    ..columnType = json['columnType'] as String;
}

Map<String, dynamic> _$FilterDataToJson(FilterData instance) =>
    <String, dynamic>{
      'columnName': instance.columnName,
      'columnValue': instance.columnValue,
      'filterType': instance.filterType,
      'columnType': instance.columnType,
    };
