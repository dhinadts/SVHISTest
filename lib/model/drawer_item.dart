import 'package:json_annotation/json_annotation.dart';

part 'drawer_item.g.dart';

@JsonSerializable()
class DrawerItem {
  @JsonKey(name: "assetUrl")
  String assetUrl;
  @JsonKey(name: "title")
  String title;
  @JsonKey(name: "pageId")
  int pageId;

  DrawerItem({this.title, this.assetUrl, this.pageId});

  factory DrawerItem.fromJson(Map<String, dynamic> json) =>
      _$DrawerItemFromJson(json);

  Map<String, dynamic> toJson() => _$DrawerItemToJson(this);
}
