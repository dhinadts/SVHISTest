import '../model/base_response.dart';
import '../model/drawer_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'drawer_list.g.dart';

@JsonSerializable()
class DrawerListResponse extends BaseResponse {
  @JsonKey(name: "user")
  List<DrawerItem> userDrawers;
  @JsonKey(name: "supervisor")
  List<DrawerItem> supervisorDrawers;

  DrawerListResponse();

  factory DrawerListResponse.fromJson(Map<String, dynamic> json) =>
      _$DrawerListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DrawerListResponseToJson(this);
}
