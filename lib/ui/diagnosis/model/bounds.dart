import 'package:json_annotation/json_annotation.dart';

part 'bounds.g.dart';

@JsonSerializable()
class Bounds {
  double lowerCut, upperCut;
  String boundInfo,
      infoMessage,
      boundClassification,
      colorCode,
      foregroundColor;

  Bounds(
      {this.lowerCut,
      this.upperCut,
      this.boundInfo,
      this.infoMessage,
      this.colorCode,
      this.foregroundColor,
      this.boundClassification});

  factory Bounds.fromJson(Map<String, dynamic> data) => _$BoundsFromJson(data);

  Map<String, dynamic> toJson() => _$BoundsToJson(this);
}
