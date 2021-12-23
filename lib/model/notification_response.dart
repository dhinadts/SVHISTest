import '../model/base_response.dart';
import '../model/notification_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_response.g.dart';

@JsonSerializable()
class NotificationResponse extends BaseResponse {
  @JsonKey(name: "notificationList")
  List<NotificationItem> notificationList;

  NotificationResponse();

  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationResponseToJson(this);
}
