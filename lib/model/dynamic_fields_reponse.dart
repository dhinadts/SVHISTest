import '../model/work_force_task_model.dart';

class DynamicFieldsResponse {
  String createdBy;
  String createdOn;
  String modifiedBy;
  String modifiedOn;
  bool active;
  String comments;
  String id;
  String fieldCategory;
  int position;
  String fieldName;
  String fieldDisplayName;
  String fieldClassification;
  String fieldUnit;
  List<Map<String, dynamic>> bounds;
  double lcl;
  double ucl;
  bool bounded;
  bool hasExpression;
  bool hasPrandiable;
  bool postPrandiable;
  bool prePrandiable;
  List<String> domain;
  String mappedDBColumn;
  String fieldDataType;
  String errorMessage;
  String conversionExpression;
  String icon;
  List<String> possibleValues;
  dynamic defaultValue;
  String fieldCaptureType;
  dynamic actualValue;
  List<WorkForceTaskModel> workForceTasks;

  DynamicFieldsResponse(
      {this.createdBy,
      this.createdOn,
      this.modifiedBy,
      this.modifiedOn,
      this.active,
      this.comments,
      this.id,
      this.fieldCategory,
      this.position,
    this.fieldName,
    this.fieldDisplayName,
    this.fieldClassification,
    this.fieldUnit,
    this.bounds,
    this.lcl,
    this.ucl,
    this.bounded,
    this.domain,
    this.mappedDBColumn,
    this.fieldDataType,
    this.errorMessage,
    this.icon,
    this.possibleValues,
    this.defaultValue,
    this.fieldCaptureType,
    this.conversionExpression,
    this.hasPrandiable,
    this.actualValue,
    this.workForceTasks,
    this.hasExpression
  });

  DynamicFieldsResponse.fromJson(Map<String, dynamic> json) {
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    modifiedBy = json['modifiedBy'];
    modifiedOn = json['modifiedOn'];
    active = json['active'];
    comments = json['comments'];
    id = json['id'];
    fieldCategory = json['fieldCategory'];
    position = json['position'];
    fieldName = json['fieldName'];
    fieldDisplayName = json['fieldDisplayName'];
    fieldClassification = json['fieldClassification'];
    fieldUnit = json['fieldUnit'];
    bounds = json['bounds'].cast<Map<String, dynamic>>();
    lcl = json['lcl'];
    ucl = json['ucl'];
    bounded = json['bounded'];
    domain = json['domain'].cast<String>();
    mappedDBColumn = json['mappedDBColumn'];
    fieldDataType = json['fieldDataType'];
    errorMessage = json['errorMessage'];
    icon = json['icon'];
    possibleValues = json['possibleValues']?.cast<String>();
    defaultValue = json['defaultValue'];
    fieldCaptureType = json['fieldCaptureType'];
    conversionExpression = json['conversionExpression'];
    hasPrandiable = json['hasPrandiable'] ?? false;
    actualValue = json['actualValue'];
    hasExpression = json['hasExpression'] ?? false;
    postPrandiable = json['postPrandiable'] ?? false;
    prePrandiable = json['prePrandiable'] ?? false;
    if (json['workForceTasks'] != null) {
      workForceTasks = new List<WorkForceTaskModel>();
      json['workForceTasks'].forEach((v) {
        workForceTasks.add(new WorkForceTaskModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['modifiedBy'] = this.modifiedBy;
    data['modifiedOn'] = this.modifiedOn;
    data['active'] = this.active;
    data['comments'] = this.comments;
    data['id'] = this.id;
    data['fieldCategory'] = this.fieldCategory;
    data['position'] = this.position;
    data['fieldName'] = this.fieldName;
    data['fieldDisplayName'] = this.fieldDisplayName;
    data['fieldClassification'] = this.fieldClassification;
    data['fieldUnit'] = this.fieldUnit;
    data['bounds'] = this.bounds;
    data['lcl'] = this.lcl;
    data['ucl'] = this.ucl;
    data['bounded'] = this.bounded;
    data['domain'] = this.domain;
    data['mappedDBColumn'] = this.mappedDBColumn;
    data['fieldDataType'] = this.fieldDataType;
    data['errorMessage'] = this.errorMessage;
    data['icon'] = this.icon;
    data['possibleValues'] = this.possibleValues;
    data['defaultValue'] = this.defaultValue;
    data['fieldCaptureType'] = this.fieldCaptureType;
    data['conversionExpression'] = this.conversionExpression;
    data['hasPrandiable'] = this.hasPrandiable;
    data['actualValue'] = this.actualValue;
    data['hasExpression'] = this.hasExpression;
    data['postPrandiable'] = this.postPrandiable;
    data['prePrandiable'] = this.prePrandiable;
    //    data['workForceTasks'] = this.workForceTasks;
    if (this.workForceTasks != null) {
      data['workForceTasks'] =
          this.workForceTasks.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
