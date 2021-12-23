class WorkForceTaskModel {
  String comments;
  String description;
  String endTime;
  String groupRefId;
  String startTime;
  String status;
  String taskId;
  String taskName;

  WorkForceTaskModel(
      {this.comments,
      this.description,
      this.endTime,
      this.groupRefId,
      this.startTime,
      this.status,
      this.taskId,
      this.taskName});

  WorkForceTaskModel.fromJson(Map<String, dynamic> json) {
    comments = json['comments'];
    description = json['description'];
    endTime = json['endTime'];
    groupRefId = json['groupRefId'];
    startTime = json['startTime'];
    status = json['status'];
    taskId = json['taskId'];
    taskName = json['taskName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comments'] = this.comments;
    data['description'] = this.description;
    data['endTime'] = this.endTime;
    data['groupRefId'] = this.groupRefId;
    data['startTime'] = this.startTime;
    data['status'] = this.status;
    data['taskId'] = this.taskId;
    data['taskName'] = this.taskName;
    return data;
  }
}