class UserEvent {
  String createdBy;
  String createdOn;
  String modifiedBy;
  String modifiedOn;
  bool active;
  String comments;
  String departmentName;
  String userName;
  String eventDepartmentName;
  String eventName;
  String eventId;
  String sessionName;
  String status;
  String startDate;
  String endDate;
  String timezone;
  String location;
  String bookingDetails;
  String sessionRating;
  String sessionAttendance;
  String feedBack;
  Map<String, dynamic> registrationImage;

  UserEvent(
      {this.createdBy,
      this.createdOn,
      this.modifiedBy,
      this.modifiedOn,
      this.active,
      this.comments,
      this.departmentName,
      this.userName,
      this.eventDepartmentName,
      this.eventName,
      this.eventId,
      this.sessionName,
      this.status,
      this.startDate,
      this.endDate,
      this.timezone,
      this.location,
      this.bookingDetails,
      this.sessionRating,
      this.sessionAttendance,
      this.feedBack,
      this.registrationImage});

  UserEvent.fromJson(Map<String, dynamic> json) {
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    modifiedBy = json['modifiedBy'];
    modifiedOn = json['modifiedOn'];
    active = json['active'];
    comments = json['comments'];
    departmentName = json['departmentName'];
    userName = json['userName'];
    eventDepartmentName = json['eventDepartmentName'];
    eventName = json['eventName'];
    eventId = json['eventId'];
    sessionName = json['sessionName'];
    status = json['status'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    timezone = json['timezone'];
    location = json['location'];
    bookingDetails = json['bookingDetails'];
    sessionRating = json['sessionRating'];
    sessionAttendance = json['sessionAttendance'];
    feedBack = json['feedBack'];
    registrationImage = json['registrationImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['modifiedBy'] = this.modifiedBy;
    data['modifiedOn'] = this.modifiedOn;
    data['active'] = this.active;
    data['comments'] = this.comments;
    data['departmentName'] = this.departmentName;
    data['userName'] = this.userName;
    data['eventDepartmentName'] = this.eventDepartmentName;
    data['eventName'] = this.eventName;
    data['eventId'] = this.eventId;
    data['sessionName'] = this.sessionName;
    data['status'] = this.status;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['timezone'] = this.timezone;
    data['location'] = this.location;
    data['bookingDetails'] = this.bookingDetails;
    data['sessionRating'] = this.sessionRating;
    data['sessionAttendance'] = this.sessionAttendance;
    data['feedBack'] = this.feedBack;
    data['registrationImage'] = this.registrationImage;
    return data;
  }
}
