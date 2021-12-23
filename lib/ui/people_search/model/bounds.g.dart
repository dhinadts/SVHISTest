// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bounds.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bounds _$BoundsFromJson(Map<String, dynamic> json) {
  return Bounds(
    lowerCut: (json['lowerCut'] as num)?.toDouble(),
    upperCut: (json['upperCut'] as num)?.toDouble(),
    boundInfo: json['boundInfo'] as String,
    infoMessage: json['infoMessage'] as String,
    colorCode: json['colorCode'] as String,
    foregroundColor: json['foregroundColor'] as String,
    boundClassification: json['boundClassification'] as String,
  );
}

Map<String, dynamic> _$BoundsToJson(Bounds instance) => <String, dynamic>{
      'lowerCut': instance.lowerCut,
      'upperCut': instance.upperCut,
      'boundInfo': instance.boundInfo,
      'infoMessage': instance.infoMessage,
      'boundClassification': instance.boundClassification,
      'colorCode': instance.colorCode,
      'foregroundColor': instance.foregroundColor,
    };
