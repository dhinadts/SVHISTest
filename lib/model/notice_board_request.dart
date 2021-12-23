import '../model/filter_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notice_board_request.g.dart';

@JsonSerializable()
class NoticeBoardRequest {
  @JsonKey(name: "dateFilter")
  String dateFilter;
  @JsonKey(name: "currentPage")
  int currentPage;
  @JsonKey(name: "pageSize")
  int pageSize;
  @JsonKey(name: "filterData")
  List<FilterData> filterData;

  NoticeBoardRequest();

  factory NoticeBoardRequest.fromJson(Map<String, dynamic> json) =>
      _$NoticeBoardRequestFromJson(json);

  Map<String, dynamic> toJson() => _$NoticeBoardRequestToJson(this);
}
