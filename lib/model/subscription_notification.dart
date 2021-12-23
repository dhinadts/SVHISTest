import 'package:json_annotation/json_annotation.dart';

part 'subscription_notification.g.dart';

@JsonSerializable()
class SubscriptionNotification {
  @JsonKey(name: "notificationName")
  String notificationName;
  @JsonKey(name: "notificationType")
  String notificationType;
  @JsonKey(name: "userName")
  String userName;
  @JsonKey(name: "departmentName")
  String departmentName;

  SubscriptionNotification();

  factory SubscriptionNotification.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionNotificationToJson(this);
}
