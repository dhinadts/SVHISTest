class MenuItems {
  String menuFormId;
  String appMinVersion;
  String appMaxVersion;
  String departmentName;
  MenuInfo menuInfo;

  MenuItems(
      {this.menuFormId,
      this.appMinVersion,
      this.appMaxVersion,
      this.departmentName,
      this.menuInfo});

  MenuItems.fromJson(Map<String, dynamic> json) {
    menuFormId = json['menu_form_id'];
    appMinVersion = json['app_min_version'];
    appMaxVersion = json['app_max_version'];
    departmentName = json['department_name'];
    menuInfo = json['menu_info'] != null
        ? new MenuInfo.fromJson(json['menu_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['menu_form_id'] = this.menuFormId;
    data['app_min_version'] = this.appMinVersion;
    data['app_max_version'] = this.appMaxVersion;
    data['department_name'] = this.departmentName;
    if (this.menuInfo != null) {
      data['menu_info'] = this.menuInfo.toJson();
    }
    return data;
  }
}

class MenuInfo {
  List<SUPERVISOR> sUPERVISOR;
  List<USER> uSER;

  MenuInfo({this.sUPERVISOR, this.uSER});

  MenuInfo.fromJson(Map<String, dynamic> json) {
    if (json['SUPERVISOR'] != null) {
      sUPERVISOR = new List<SUPERVISOR>();
      json['SUPERVISOR'].forEach((v) {
        sUPERVISOR.add(new SUPERVISOR.fromJson(v));
      });
    }
    if (json['USER'] != null) {
      uSER = new List<USER>();
      json['USER'].forEach((v) {
        uSER.add(new USER.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sUPERVISOR != null) {
      data['SUPERVISOR'] = this.sUPERVISOR.map((v) => v.toJson()).toList();
    }
    if (this.uSER != null) {
      data['USER'] = this.uSER.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SUPERVISOR {
  String module;
  String label;
  String icon;
  bool textonly;
  int pageId;
  String country;
  String status;
  String externalUrl;
  String internalUrl;

  SUPERVISOR({
    this.module,
    this.label,
    this.icon,
    this.textonly,
    this.pageId,
    this.country,
    this.status,
    this.externalUrl,
    this.internalUrl,
  });

  SUPERVISOR.fromJson(Map<String, dynamic> json) {
    module = json['module'];
    label = json['label'];
    icon = json['icon'];
    textonly = json['textonly'];
    pageId = json['position'];
    country = json['country'];
    status = json['status'];
    externalUrl = json['external'];
    internalUrl = json['internal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['module'] = this.module;
    data['label'] = this.label;
    data['icon'] = this.icon;
    data['textonly'] = this.textonly;
    data['position'] = this.pageId;
    data['status'] = this.status;
    data['country'] = this.country;
    data['external'] = this.externalUrl;
    data['internal'] = this.internalUrl;
    return data;
  }
}

class USER {
  String module;
  String label;
  String icon;
  bool textonly;
  int pageId;
  String country;
  String status;
  String externalUrl;
  String internalUrl;

  USER({
    this.module,
    this.label,
    this.icon,
    this.textonly,
    this.pageId,
    this.country,
    this.status,
    this.externalUrl,
    this.internalUrl,
  });

  USER.fromJson(Map<String, dynamic> json) {
    module = json['module'];
    label = json['label'];
    icon = json['icon'];
    textonly = json['textonly'];
    pageId = json['position'];
    country = json['country'];
    externalUrl = json['external'];
    status = json['status'];
    internalUrl = json['internal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['module'] = this.module;
    data['label'] = this.label;
    data['icon'] = this.icon;
    data['textonly'] = this.textonly;
    data['position'] = this.pageId;
    data['country'] = this.country;
    data['external'] = this.externalUrl;
    data['internal'] = this.internalUrl;
    data['status'] = this.status;
    return data;
  }
}
