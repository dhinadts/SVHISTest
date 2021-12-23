import 'package:json_annotation/json_annotation.dart';

part 'membership_form_field_info.g.dart';

@JsonSerializable()
class MembershipFormFieldInfo {
  bool active;
  String clientId;
  String comments;
  String createdBy;
  String createdOn;
  String fieldDisplayName;
  String fieldId;
  String fieldName;
  String fieldType;
  bool isMandatory;
  String modifiedBy;
  String modifiedOn;

  MembershipFormFieldInfo({
    this.active,
    this.clientId,
    this.comments,
    this.createdBy,
    this.createdOn,
    this.fieldDisplayName,
    this.fieldId,
    this.fieldName,
    this.fieldType,
    this.isMandatory,
    this.modifiedOn,
    this.modifiedBy,
  });

  factory MembershipFormFieldInfo.fromJson(Map<String, dynamic> data) =>
      _$MembershipFormFieldInfoFromJson(data);

  Map<String, dynamic> toJson() => _$MembershipFormFieldInfoToJson(this);
}
