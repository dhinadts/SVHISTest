// To parse this JSON data, do
//
//     final startRecordRes = startRecordResFromJson(jsonString);

import 'dart:convert';

RecordRes recordingResFromJson(String str) =>
    RecordRes.fromJson(json.decode(str));

String recordingResToJson(RecordRes data) => json.encode(data.toJson());

class RecordRes {
  RecordRes({
    this.timestamp,
    this.status,
    this.error,
    this.message,
    this.path,
  });

  DateTime timestamp;
  int status;
  String error;
  String message;
  String path;

  factory RecordRes.fromJson(Map<String, dynamic> json) => RecordRes(
        timestamp: DateTime.parse(json["timestamp"]),
        status: json["status"],
        error: json["error"],
        message: json["message"],
        path: json["path"],
      );

  Map<String, dynamic> toJson() => {
        "timestamp": timestamp.toIso8601String(),
        "status": status,
        "error": error,
        "message": message,
        "path": path,
      };
}
