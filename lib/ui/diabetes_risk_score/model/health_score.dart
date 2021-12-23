import '../../../ui/diabetes_risk_score/model/answers_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'health_score.g.dart';

@JsonSerializable(explicitToJson: true)
class HealthScore {
  bool active;
  AnswersData answers;
  String comments;
  String countryCode;
  String countryCodeValue;
  String createdBy;
  String createdOn;
  String departmentName;
  String emailId;
  String firstName;
  String id;
  bool isProspect;
  String lastName;
  String mobileNo;
  String modifiedBy;
  String modifiedOn;
  String recommendedBy;
  String riskLevel;
  double scorePoints;
  String userFullName;
  String userName;

  HealthScore({
    this.active,
    this.answers,
    this.comments,
    this.countryCode,
    this.countryCodeValue,
    this.createdBy,
    this.createdOn,
    this.departmentName,
    this.emailId,
    this.firstName,
    this.id,
    this.isProspect,
    this.lastName,
    this.mobileNo,
    this.modifiedBy,
    this.modifiedOn,
    this.recommendedBy,
    this.riskLevel,
    this.scorePoints,
    this.userFullName,
    this.userName,
  });

  factory HealthScore.fromJson(Map<String, dynamic> data) =>
      _$HealthScoreFromJson(data);

  Map<String, dynamic> toJson() => _$HealthScoreToJson(this);
}
