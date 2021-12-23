import 'package:json_annotation/json_annotation.dart';

part 'app_version.g.dart';

@JsonSerializable()
class AppVersion {
  String appName,
      createdBy,
      createdOn,
      downloadUrl,
      guid,
      launchDate,
      modifiedBy,
      modifiedOn,
      nextVersion,
      platform,
      priority,
      status,
      version;
  AppVersion(
      {this.appName,
      this.createdBy,
      this.createdOn,
      this.downloadUrl,
      this.guid,
      this.launchDate,
      this.modifiedBy,
      this.modifiedOn,
      this.nextVersion,
      this.platform,
      this.priority,
      this.status,
      this.version});
  factory AppVersion.fromJson(Map<String, dynamic> data) =>
      _$AppVersionFromJson(data);
  Map<String, dynamic> toJson() => _$AppVersionToJson(this);
}
