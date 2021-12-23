import 'package:json_annotation/json_annotation.dart';

part 'selected_variables.g.dart';

@JsonSerializable()
class SelectedVariables {
  @JsonKey(name: "applicationName")
  String applicationName;
  @JsonKey(name: "eventName")
  String eventName;
  @JsonKey(name: "variableId")
  int variableId;
  @JsonKey(name: "variableName")
  String variableName;
  @JsonKey(name: "variableType")
  String variableType;

  SelectedVariables();

  factory SelectedVariables.fromJson(Map<String, dynamic> json) =>
      _$SelectedVariablesFromJson(json);

  Map<String, dynamic> toJson() => _$SelectedVariablesToJson(this);
}
