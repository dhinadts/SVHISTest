import '../model/base_response.dart';
import '../model/dynamic_fields_reponse.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dynamic_fields_new_response.g.dart';

@JsonSerializable()
class DynamicFieldsNewResponse extends BaseResponse {
  @JsonKey(name: "WorkForce")
  List<DynamicFieldsResponse> WorkForce;

  @JsonKey(name: "HealthCare")
  List<DynamicFieldsResponse> HealthCare;

  @JsonKey(name: "DATTApp")
  List<DynamicFieldsResponse> DATTApp;

  DynamicFieldsNewResponse();

  factory DynamicFieldsNewResponse.fromJson(Map<String, dynamic> json) =>
      _$DynamicFieldsNewResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DynamicFieldsNewResponseToJson(this);
}
