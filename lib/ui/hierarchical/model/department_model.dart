import '../../../model/base_response.dart';
import '../../../ui/hierarchical/model/sub_department_model.dart';
import '../../../ui/membership/model/membership_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'department_model.g.dart';

@JsonSerializable()
class DepartmentModel extends BaseResponse {
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
  List<SubDepartmentModel> subDepartments;
  List<MembershipInfo> users;
  List<MembershipInfo> members;
  List<MembershipInfo> supervisors;
  List<MembershipInfo> allMembers;

  DepartmentModel(
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
      this.supervisors,
      this.users,
      this.members,
      this.parentDepartmentName});

  factory DepartmentModel.fromJson(Map<String, dynamic> json) =>
      _$DepartmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$DepartmentModelToJson(this);
}
