// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionResponse _$SubscriptionResponseFromJson(Map<String, dynamic> json) {
  return SubscriptionResponse()
    ..message = json['message'] as String
    ..status = json['status']
    ..timestamp = json['timestamp'] as String
    ..error = json['error'] as String
    ..path = json['path'] as String
    ..subscriptionList = (json['subscriptionList'] as List)
        ?.map((e) => e == null
            ? null
            : SubscriptionsModel.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$SubscriptionResponseToJson(
        SubscriptionResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
      'timestamp': instance.timestamp,
      'error': instance.error,
      'path': instance.path,
      'subscriptionList': instance.subscriptionList,
    };
