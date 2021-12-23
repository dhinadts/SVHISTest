import '../model/base_response.dart';
import '../model/subscriptions_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subscription_response.g.dart';

@JsonSerializable()
class SubscriptionResponse extends BaseResponse {
  @JsonKey(name: "subscriptionList")
  List<SubscriptionsModel> subscriptionList;

  SubscriptionResponse();

  factory SubscriptionResponse.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionResponseToJson(this);
}
