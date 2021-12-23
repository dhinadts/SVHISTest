import 'package:json_annotation/json_annotation.dart';

part 'additional_history_dynamic.g.dart';

@JsonSerializable()
class AdditionalHistoryDynamic {
  bool active;
  dynamic column1,
      column2,
      column3,
      column4,
      column5,
      column6,
      column7,
      column8,
      column9,
      column10,
      column11,
      column12,
      column13,
      column14,
      column15,
      column16,
      column17,
      column18,
      column19,
      column20,
      column21,
      column22,
      column23,
      column24,
      column25,
      column26,
      column27,
      column28,
      column29,
      column30,
      column31,
      column32,
      column33,
      column34,
      column35,
      column36,
      column37,
      column38,
      column39,
      column40;
  String comments,
      createdBy,
      createdOn,
      departmentName,
      firstName,
      id,
      lastName,
      modifiedBy,
      modifiedOn,
      userName;

  AdditionalHistoryDynamic({
    this.active,
    this.column1,
    this.column2,
    this.column3,
    this.column4,
    this.column5,
    this.column6,
    this.column7,
    this.column8,
    this.column9,
    this.column10,
    this.column11,
    this.column12,
    this.column13,
    this.column14,
    this.column15,
    this.column16,
    this.column17,
    this.column18,
    this.column19,
    this.column20,
    this.column21,
    this.column22,
    this.column23,
    this.column24,
    this.column25,
    this.column26,
    this.column27,
    this.column28,
    this.column29,
    this.column30,
    this.column31,
    this.column32,
    this.column33,
    this.column34,
    this.column35,
    this.column36,
    this.column37,
    this.column38,
    this.column39,
    this.column40,
    this.comments,
    this.departmentName,
    this.firstName,
    this.id,
    this.lastName,
    this.createdBy,
    this.createdOn,
    this.modifiedBy,
    this.modifiedOn,
    this.userName,
  });

  factory AdditionalHistoryDynamic.fromJson(Map<String, dynamic> data) =>
      _$AdditionalHistoryDynamicFromJson(data);

  Map<String, dynamic> toJson() => _$AdditionalHistoryDynamicToJson(this);
}