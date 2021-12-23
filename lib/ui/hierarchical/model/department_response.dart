import '../../../model/base_response.dart';
import '../../../ui/hierarchical/model/department_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'department_response.g.dart';

@JsonSerializable()
class DepartmentResponse extends BaseResponse {
  List<DepartmentModel> departmentList;

  DepartmentResponse({
    this.departmentList,
  });

  factory DepartmentResponse.fromJson(Map<String, dynamic> json) =>
      _$DepartmentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DepartmentResponseToJson(this);
}
