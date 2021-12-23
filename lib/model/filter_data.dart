import 'package:json_annotation/json_annotation.dart';

part 'filter_data.g.dart';

@JsonSerializable()
class FilterData {
  @JsonKey(name: "columnName")
  String columnName;
  @JsonKey(name: "columnValue")
  List<String> columnValue;
  @JsonKey(name: "filterType")
  String filterType;
  @JsonKey(name: "columnType")
  String columnType;

  FilterData();

  factory FilterData.fromJson(Map<String, dynamic> json) =>
      _$FilterDataFromJson(json);

  Map<String, dynamic> toJson() => _$FilterDataToJson(this);
}
