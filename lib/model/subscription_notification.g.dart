// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionNotification _$SubscriptionNotificationFromJson(
    Map<String, dynamic> json) {
  return SubscriptionNotification()
    ..notificationName = json['notificationName'] as String
    ..notificationType = json['notificationType'] as String
    ..userName = json['userName'] as String
    ..departmentName = json['departmentName'] as String;
}

Map<String, dynamic> _$SubscriptionNotificationToJson(
        SubscriptionNotification instance) =>
    <String, dynamic>{
      'notificationName': instance.notificationName,
      'notificationType': instance.notificationType,
      'userName': instance.userName,
      'departmentName': instance.departmentName,
    };
