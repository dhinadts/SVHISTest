import 'package:json_annotation/json_annotation.dart';

part 'answers_data.g.dart';

@JsonSerializable()
class AnswersData {
  String age;
  String gender;
  String ethnicBackground;
  String familyDiabetes;
  String waistRange;
  String bmiRange;
  String bloodPressure;

  AnswersData({
    this.age,
    this.gender,
    this.ethnicBackground,
    this.familyDiabetes,
    this.waistRange,
    this.bmiRange,
    this.bloodPressure,
  });

  factory AnswersData.fromJson(Map<String, dynamic> data) =>
      _$AnswersDataFromJson(data);

  Map<String, dynamic> toJson() => _$AnswersDataToJson(this);
}
