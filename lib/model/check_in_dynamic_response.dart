import '../model/base_response.dart';
import '../model/check_in_dynamic.dart';
import 'package:json_annotation/json_annotation.dart';

part 'check_in_dynamic_response.g.dart';

@JsonSerializable()
class CheckInDynamicResponse extends BaseResponse {
  @JsonKey(name: "checkInList")
  List<CheckInDynamic> checkInDynamicList;

  CheckInDynamicResponse();

  factory CheckInDynamicResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckInDynamicResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CheckInDynamicResponseToJson(this);
}
