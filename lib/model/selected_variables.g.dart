// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_variables.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelectedVariables _$SelectedVariablesFromJson(Map<String, dynamic> json) {
  return SelectedVariables()
    ..applicationName = json['applicationName'] as String
    ..eventName = json['eventName'] as String
    ..variableId = json['variableId'] as int
    ..variableName = json['variableName'] as String
    ..variableType = json['variableType'] as String;
}

Map<String, dynamic> _$SelectedVariablesToJson(SelectedVariables instance) =>
    <String, dynamic>{
      'applicationName': instance.applicationName,
      'eventName': instance.eventName,
      'variableId': instance.variableId,
      'variableName': instance.variableName,
      'variableType': instance.variableType,
    };
