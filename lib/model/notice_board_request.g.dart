// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_board_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoticeBoardRequest _$NoticeBoardRequestFromJson(Map<String, dynamic> json) {
  return NoticeBoardRequest()
    ..dateFilter = json['dateFilter'] as String
    ..currentPage = json['currentPage'] as int
    ..pageSize = json['pageSize'] as int
    ..filterData = (json['filterData'] as List)
        ?.map((e) =>
            e == null ? null : FilterData.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$NoticeBoardRequestToJson(NoticeBoardRequest instance) =>
    <String, dynamic>{
      'dateFilter': instance.dateFilter,
      'currentPage': instance.currentPage,
      'pageSize': instance.pageSize,
      'filterData': instance.filterData,
    };
