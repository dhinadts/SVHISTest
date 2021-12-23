import '../model/base_response.dart';
import '../model/people.dart';
import 'package:json_annotation/json_annotation.dart';

part 'people_response.g.dart';

@JsonSerializable()
class PeopleResponse extends BaseResponse {
  @JsonKey(name: "peopleResponse")
  List<People> peopleResponse;

  PeopleResponse();

  factory PeopleResponse.fromJson(Map<String, dynamic> json) =>
      _$PeopleResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PeopleResponseToJson(this);
}
