// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscriptions_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionsModel _$SubscriptionsModelFromJson(Map<String, dynamic> json) {
  return SubscriptionsModel()
    ..createdBy = json['createdBy'] as String
    ..createdOn = json['createdOn'] as String
    ..modifiedBy = json['modifiedBy'] as String
    ..comments = json['comments'] as String
    ..departmentName = json['departmentName'] as String
    ..subscriptionName = json['subscriptionName'] as String
    ..applicationName = json['applicationName'] as String
    ..ruleExpression = json['ruleExpression'] as String
    ..subscriptionSubject = json['subscriptionSubject'] as String
    ..subscriptionContent = json['subscriptionContent'] as String
    ..notifications = (json['notifications'] as List)
        ?.map((e) => e == null
            ? null
            : SubscriptionNotification.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..selectedVariables = (json['selectedVariables'] as List)
        ?.map((e) => e == null
            ? null
            : SelectedVariables.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..events = json['events'] as List
    ..conditions = (json['conditions'] as List)
        ?.map((e) =>
            e == null ? null : Condition.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..status = json['status'] as String
    ..priority = json['priority'] as String
    ..users = (json['users'] as List)?.map((e) => e as String)?.toList()
    ..active = json['active'] as bool;
}

Map<String, dynamic> _$SubscriptionsModelToJson(SubscriptionsModel instance) =>
    <String, dynamic>{
      'createdBy': instance.createdBy,
      'createdOn': instance.createdOn,
      'modifiedBy': instance.modifiedBy,
      'comments': instance.comments,
      'departmentName': instance.departmentName,
      'subscriptionName': instance.subscriptionName,
      'applicationName': instance.applicationName,
      'ruleExpression': instance.ruleExpression,
      'subscriptionSubject': instance.subscriptionSubject,
      'subscriptionContent': instance.subscriptionContent,
      'notifications': instance.notifications,
      'selectedVariables': instance.selectedVariables,
      'events': instance.events,
      'conditions': instance.conditions,
      'status': instance.status,
      'priority': instance.priority,
      'users': instance.users,
      'active': instance.active,
    };
