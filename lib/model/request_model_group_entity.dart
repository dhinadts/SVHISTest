import '../model/base_response.dart';
import '../model/work_force_task_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'request_model_group_entity.g.dart';

@JsonSerializable()
class RequestModelGroupEntity extends BaseResponse {
  @JsonKey(name: "active")
  bool active;
  @JsonKey(name: "column42")
  String column42;
  @JsonKey(name: "column43")
  String column43;
  @JsonKey(name: "departmentName")
  String departmentName;
  @JsonKey(name: "userName")
  String userName;
  @JsonKey(name: "workForceTasks")
  List<WorkForceTaskModel> workForceTasks;

  RequestModelGroupEntity();

  factory RequestModelGroupEntity.fromJson(Map<String, dynamic> json) =>
      _$RequestModelGroupEntityFromJson(json);

  Map<String, dynamic> toJson() => _$RequestModelGroupEntityToJson(this);
}
