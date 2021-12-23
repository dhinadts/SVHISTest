class AppEnvProps {
  bool modernizedHomePage;
  bool modernizehomepageNewsfeed;
  bool modernizehomepageReminders;
  String propertyName;
  bool active;
  String propertyDataType;
  String propertyValue;
  String uiDisplayName;
  bool departmentOverridable;
  String propertyCategory;
  String mimeType;
  String module;
  bool confidential;
  int position;
  dynamic additionalInfo;
  dynamic sourceData;
  String icon;
  bool isDepartmentOverrided;
  List<String> platformScheduleExposeRoleTypes;
  String subdeptSupervisorUsermodAccessEnabled;

  AppEnvProps({
    this.modernizedHomePage,
    this.modernizehomepageNewsfeed,
    this.modernizehomepageReminders,
    this.propertyName,
    this.active,
    this.propertyDataType,
    this.propertyValue,
    this.uiDisplayName,
    this.departmentOverridable,
    this.propertyCategory,
    this.mimeType,
    this.module,
    this.confidential,
    this.position,
    this.additionalInfo,
    this.sourceData,
    this.icon,
    this.isDepartmentOverrided,
    this.platformScheduleExposeRoleTypes,
    this.subdeptSupervisorUsermodAccessEnabled,
  });

  AppEnvProps.fromJson(Map<String, dynamic> json) {
    modernizedHomePage = json["com.sdx.mobile.home.modernization.enabled"];
    modernizehomepageNewsfeed = json["com.sdx.mobile.module.newsfeed.enabled"];
    modernizehomepageReminders =
        json["com.sdx.mobile.module.reminders.enabled"];
    propertyName = json['propertyName'];
    active = json['active'];
    propertyDataType = json['propertyDataType'];
    propertyValue = json['propertyValue'];
    uiDisplayName = json['uiDisplayName'];
    departmentOverridable = json['departmentOverridable'];
    propertyCategory = json['propertyCategory'];
    mimeType = json['mimeType'];
    module = json['module'];
    confidential = json['confidential'];
    position = json['position'];
    additionalInfo = json['additionalInfo'];
    sourceData = json['sourceData'];
    icon = json['icon'];
    isDepartmentOverrided = json['isDepartmentOverrided'];
    platformScheduleExposeRoleTypes =
        json['com.sdx.platform.schedule.expose.role.types'];
    subdeptSupervisorUsermodAccessEnabled = json[
        'com.sdx.platform.rights.subdept.supervisor.usermod.access.enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['com.sdx.mobile.home.modernization.enabled'] = this.modernizedHomePage;
    data['com.sdx.mobile.module.newsfeed.enabled'] =
        this.modernizehomepageNewsfeed;
    data['com.sdx.mobile.module.reminders.enabled'] =
        this.modernizehomepageReminders;
    data['propertyName'] = this.propertyName;
    data['active'] = this.active;
    data['propertyDataType'] = this.propertyDataType;
    data['propertyValue'] = this.propertyValue;
    data['uiDisplayName'] = this.uiDisplayName;
    data['departmentOverridable'] = this.departmentOverridable;
    data['propertyCategory'] = this.propertyCategory;
    data['mimeType'] = this.mimeType;
    data['module'] = this.module;
    data['confidential'] = this.confidential;
    data['position'] = this.position;
    data['additionalInfo'] = this.additionalInfo;
    data['sourceData'] = this.sourceData;
    data['icon'] = this.icon;
    data['isDepartmentOverrided'] = this.isDepartmentOverrided;
    data['com.sdx.platform.schedule.expose.role.types'] =
        this.platformScheduleExposeRoleTypes;
    data['com.sdx.platform.rights.subdept.supervisor.usermod.access.enabled'] =
        this.subdeptSupervisorUsermodAccessEnabled;
    return data;
  }
}
