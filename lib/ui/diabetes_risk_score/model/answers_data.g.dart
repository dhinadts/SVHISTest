// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answers_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnswersData _$AnswersDataFromJson(Map<String, dynamic> json) {
  return AnswersData(
    age: json['age'] as String,
    gender: json['gender'] as String,
    ethnicBackground: json['ethnicBackground'] as String,
    familyDiabetes: json['familyDiabetes'] as String,
    waistRange: json['waistRange'] as String,
    bmiRange: json['bmiRange'] as String,
    bloodPressure: json['bloodPressure'] as String,
  );
}

Map<String, dynamic> _$AnswersDataToJson(AnswersData instance) =>
    <String, dynamic>{
      'age': instance.age,
      'gender': instance.gender,
      'ethnicBackground': instance.ethnicBackground,
      'familyDiabetes': instance.familyDiabetes,
      'waistRange': instance.waistRange,
      'bmiRange': instance.bmiRange,
      'bloodPressure': instance.bloodPressure,
    };
