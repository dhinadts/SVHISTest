class AnnotateModel {
  String event;
  Data data;

  AnnotateModel({this.event, this.data});

  AnnotateModel.fromJson(Map<String, dynamic> json) {
    event = json['event'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event'] = this.event;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String action;
  List<Offset> offset;

  Data({this.action, this.offset});

  Data.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    if (json['offset'] != null) {
      offset = new List<Offset>();
      json['offset'].forEach((v) {
        if (v != null) offset.add(new Offset.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['action'] = this.action;
    if (this.offset != null) {
      data['offset'] = this.offset.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Offset {
  String dx;
  String dy;

  Offset({this.dx, this.dy});

  Offset.fromJson(Map<String, dynamic> json) {
    dx = json['dx'];
    dy = json['dy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dx'] = this.dx;
    data['dy'] = this.dy;
    return data;
  }
}
