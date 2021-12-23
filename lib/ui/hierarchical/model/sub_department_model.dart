import '../../../ui/membership/model/membership_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sub_department_model.g.dart';

@JsonSerializable()
class SubDepartmentModel {
  String createdBy;
  String createdOn;
  String modifiedBy;
  String modifiedOn;
  bool active;
  String comments;
  String departmentName;
  String supervisorName;
  String supervisorToken;
  String userToken;
  String expiryDate;
  String supervisorPromoCode;
  String userPromoCode;
  int userCount;
  List<String> domains;
  String parentDepartmentName;
  List<MembershipInfo> users;
  List<MembershipInfo> supervisors;
  List<MembershipInfo> allMembers;

  SubDepartmentModel(
      {this.createdBy,
      this.createdOn,
      this.modifiedBy,
      this.modifiedOn,
      this.active,
      this.comments,
      this.departmentName,
      this.supervisorName,
      this.supervisorToken,
      this.userToken,
      this.expiryDate,
      this.supervisorPromoCode,
      this.userPromoCode,
      this.userCount,
      this.domains,
      this.users,
      this.supervisors,
      this.parentDepartmentName});

  factory SubDepartmentModel.fromJson(Map<String, dynamic> json) =>
      _$SubDepartmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubDepartmentModelToJson(this);
}
