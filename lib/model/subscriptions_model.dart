//import '../model/Event.dart';
import '../model/condition.dart';
import '../model/selected_variables.dart';
import '../model/subscription_notification.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subscriptions_model.g.dart';

@JsonSerializable()
class SubscriptionsModel {
  @JsonKey(name: "createdBy")
  String createdBy;
  @JsonKey(name: "createdOn")
  String createdOn;
  @JsonKey(name: "modifiedBy")
  String modifiedBy;
  @JsonKey(name: "comments")
  String comments;
  @JsonKey(name: "departmentName")
  String departmentName;
  @JsonKey(name: "subscriptionName")
  String subscriptionName;
  @JsonKey(name: "applicationName")
  String applicationName;
  @JsonKey(name: "ruleExpression")
  String ruleExpression;
  @JsonKey(name: "subscriptionSubject")
  String subscriptionSubject;
  @JsonKey(name: "subscriptionContent")
  String subscriptionContent;
  @JsonKey(name: "notifications")
  List<SubscriptionNotification> notifications;

  @JsonKey(name: "selectedVariables")
  List<SelectedVariables> selectedVariables;
  @JsonKey(name: "events")
  List<dynamic> events;
  @JsonKey(name: "conditions")
  List<Condition> conditions;
  @JsonKey(name: "status")
  String status;
  @JsonKey(name: "priority")
  String priority;
  @JsonKey(name: "users")
  List<String> users;

  /* @JsonKey(name: "groups")
  String groups;*/
  @JsonKey(name: "active")
  bool active;

  SubscriptionsModel();

  factory SubscriptionsModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionsModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionsModelToJson(this);
}
