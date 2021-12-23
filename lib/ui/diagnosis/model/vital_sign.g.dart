// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vital_sign.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VitalSign _$VitalSignFromJson(Map<String, dynamic> json) {
  return VitalSign(
    createdBy: json['createdBy'] as String,
    createdOn: json['createdOn'] as String,
    modifiedBy: json['modifiedBy'] as String,
    modifiedOn: json['modifiedOn'] as String,
    comments: json['comments'] as String,
    id: json['id'] as String,
    vitalsign: json['vitalsign'] as String,
    vitalunit: json['vitalunit'] as String,
    displayName: json['displayName'] as String,
    category: json['category'] as String,
    mappedDBColumn: json['mappedDBColumn'] as String,
    active: json['active'] as bool,
    bounded: json['bounded'] as bool,
    bounds: (json['bounds'] as List)
        ?.map((e) =>
            e == null ? null : Bounds.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    lcl: (json['lcl'] as num)?.toDouble(),
    ucl: (json['ucl'] as num)?.toDouble(),
    domain: (json['domain'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$VitalSignToJson(VitalSign instance) => <String, dynamic>{
      'createdBy': instance.createdBy,
      'createdOn': instance.createdOn,
      'modifiedBy': instance.modifiedBy,
      'modifiedOn': instance.modifiedOn,
      'comments': instance.comments,
      'id': instance.id,
      'vitalsign': instance.vitalsign,
      'vitalunit': instance.vitalunit,
      'displayName': instance.displayName,
      'category': instance.category,
      'mappedDBColumn': instance.mappedDBColumn,
      'active': instance.active,
      'bounded': instance.bounded,
      'bounds': instance.bounds?.map((e) => e?.toJson())?.toList(),
      'lcl': instance.lcl,
      'ucl': instance.ucl,
      'domain': instance.domain,
    };
