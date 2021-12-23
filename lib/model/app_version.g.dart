// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppVersion _$AppVersionFromJson(Map<String, dynamic> json) {
  return AppVersion(
    appName: json['appName'] as String,
    createdBy: json['createdBy'] as String,
    createdOn: json['createdOn'] as String,
    downloadUrl: json['downloadUrl'] as String,
    guid: json['guid'] as String,
    launchDate: json['launchDate'] as String,
    modifiedBy: json['modifiedBy'] as String,
    modifiedOn: json['modifiedOn'] as String,
    nextVersion: json['nextVersion'] as String,
    platform: json['platform'] as String,
    priority: json['priority'] as String,
    status: json['status'] as String,
    version: json['version'] as String,
  );
}

Map<String, dynamic> _$AppVersionToJson(AppVersion instance) =>
    <String, dynamic>{
      'appName': instance.appName,
      'createdBy': instance.createdBy,
      'createdOn': instance.createdOn,
      'downloadUrl': instance.downloadUrl,
      'guid': instance.guid,
      'launchDate': instance.launchDate,
      'modifiedBy': instance.modifiedBy,
      'modifiedOn': instance.modifiedOn,
      'nextVersion': instance.nextVersion,
      'platform': instance.platform,
      'priority': instance.priority,
      'status': instance.status,
      'version': instance.version,
    };
