import 'package:json_annotation/json_annotation.dart';
part 'group_info.g.dart';

@JsonSerializable()
class GroupInfo {
  bool active;
  String comments;
  String createdBy;
  String createdOn;
  String departmentName;
  int escalationInterval;
  String formattedCreatedDate;
  String groupName;
  String groupType;
  String modifiedOn;
  String modifiedBy;
  String type;

  GroupInfo({
    this.active,
    this.comments,
    this.createdBy,
    this.createdOn,
    this.departmentName,
    this.escalationInterval,
    this.formattedCreatedDate,
    this.groupName,
    this.groupType,
    this.modifiedBy,
    this.modifiedOn,
    this.type,
  });
  factory GroupInfo.fromJson(Map<String, dynamic> data) =>
      _$GroupInfoFromJson(data);

  Map<String, dynamic> toJson() => _$GroupInfoToJson(this);
}
