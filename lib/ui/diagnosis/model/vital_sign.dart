import '../../../ui/diagnosis/model/bounds.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vital_sign.g.dart';

@JsonSerializable(explicitToJson: true)
class VitalSign {
  String createdBy,
      createdOn,
      modifiedBy,
      modifiedOn,
      comments,
      id,
      vitalsign,
      vitalunit,
      displayName,
      category,
      mappedDBColumn;
  bool active, bounded;
  List<Bounds> bounds;
  double lcl, ucl;
  List<String> domain;

  VitalSign({
    this.createdBy,
    this.createdOn,
    this.modifiedBy,
    this.modifiedOn,
    this.comments,
    this.id,
    this.vitalsign,
    this.vitalunit,
    this.displayName,
    this.category,
    this.mappedDBColumn,
    this.active,
    this.bounded,
    this.bounds,
    this.lcl,
    this.ucl,
    this.domain,
  });

  factory VitalSign.fromJson(Map<String, dynamic> data) =>
      _$VitalSignFromJson(data);

  Map<String, dynamic> toJson() => _$VitalSignToJson(this);
}
