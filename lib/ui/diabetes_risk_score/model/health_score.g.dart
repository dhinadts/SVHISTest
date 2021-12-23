// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_score.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealthScore _$HealthScoreFromJson(Map<String, dynamic> json) {
  return HealthScore(
    active: json['active'] as bool,
    answers: json['answers'] == null
        ? null
        : AnswersData.fromJson(json['answers'] as Map<String, dynamic>),
    comments: json['comments'] as String,
    countryCode: json['countryCode'] as String,
    countryCodeValue: json['countryCodeValue'] as String,
    createdBy: json['createdBy'] as String,
    createdOn: json['createdOn'] as String,
    departmentName: json['departmentName'] as String,
    emailId: json['emailId'] as String,
    firstName: json['firstName'] as String,
    id: json['id'] as String,
    isProspect: json['isProspect'] as bool,
    lastName: json['lastName'] as String,
    mobileNo: json['mobileNo'] as String,
    modifiedBy: json['modifiedBy'] as String,
    modifiedOn: json['modifiedOn'] as String,
    recommendedBy: json['recommendedBy'] as String,
    riskLevel: json['riskLevel'] as String,
    scorePoints: (json['scorePoints'] as num)?.toDouble(),
    userFullName: json['userFullName'] as String,
    userName: json['userName'] as String,
  );
}

Map<String, dynamic> _$HealthScoreToJson(HealthScore instance) =>
    <String, dynamic>{
      'active': instance.active,
      'answers': instance.answers?.toJson(),
      'comments': instance.comments,
      'countryCode': instance.countryCode,
      'countryCodeValue': instance.countryCodeValue,
      'createdBy': instance.createdBy,
      'createdOn': instance.createdOn,
      'departmentName': instance.departmentName,
      'emailId': instance.emailId,
      'firstName': instance.firstName,
      'id': instance.id,
      'isProspect': instance.isProspect,
      'lastName': instance.lastName,
      'mobileNo': instance.mobileNo,
      'modifiedBy': instance.modifiedBy,
      'modifiedOn': instance.modifiedOn,
      'recommendedBy': instance.recommendedBy,
      'riskLevel': instance.riskLevel,
      'scorePoints': instance.scorePoints,
      'userFullName': instance.userFullName,
      'userName': instance.userName,
    };
