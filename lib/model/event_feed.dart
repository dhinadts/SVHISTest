class EventFeed {
  bool active;
  String audienceDepartment;
  String bookingForm;
  String comments;
  String createdBy;
  String createdOn;
  int dayOfMonth;
  String description;
  String endDate;
  String eventDepartment;
  String eventId;
  String eventName;
  String eventPattern;
  String eventType;
  bool feedBackRequired;
  int maximumAttendees;
  String modifiedBy;
  String modifiedOn;
  bool multipleSession;
  int noOfDaysBeforeRegistration;
  int noOfHoursBeforeRegistration;
  String occurenceType;
  bool openEvent;
  bool paidEvent;
  String rating;
  String registrationEndDate;
  RegistrationImage registrationImage;
  String registrationRequired;
  String registrationType;
  String registrationUrl;
  List<Sessions> sessions;
  String startDate;
  String status;
  List<TargetAudience> targetAudience;
  String timezone;

  EventFeed(
      {this.active,
      this.audienceDepartment,
      this.bookingForm,
      this.comments,
      this.createdBy,
      this.createdOn,
      this.dayOfMonth,
      this.description,
      this.endDate,
      this.eventDepartment,
      this.eventId,
      this.eventName,
      this.eventPattern,
      this.eventType,
      this.feedBackRequired,
      this.maximumAttendees,
      this.modifiedBy,
      this.modifiedOn,
      this.multipleSession,
      this.noOfDaysBeforeRegistration,
      this.noOfHoursBeforeRegistration,
      this.occurenceType,
      this.openEvent,
      this.paidEvent,
      this.rating,
      this.registrationEndDate,
      this.registrationImage,
      this.registrationRequired,
      this.registrationType,
      this.registrationUrl,
      this.sessions,
      this.startDate,
      this.status,
      this.targetAudience,
      this.timezone});

  EventFeed.fromJson(Map<String, dynamic> json) {
    active = json['active'];
    audienceDepartment = json['audienceDepartment'];
    bookingForm = json['bookingForm'];
    comments = json['comments'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    dayOfMonth = json['dayOfMonth'];
    description = json['description'];
    endDate = json['endDate'];
    eventDepartment = json['eventDepartment'];
    eventId = json['eventId'];
    eventName = json['eventName'];
    eventPattern = json['eventPattern'];
    eventType = json['eventType'];
    feedBackRequired = json['feedBackRequired'];
    maximumAttendees = json['maximumAttendees'];
    modifiedBy = json['modifiedBy'];
    modifiedOn = json['modifiedOn'];
    multipleSession = json['multipleSession'];
    noOfDaysBeforeRegistration = json['noOfDaysBeforeRegistration'];
    noOfHoursBeforeRegistration = json['noOfHoursBeforeRegistration'];
    occurenceType = json['occurenceType'];
    openEvent = json['openEvent'];
    paidEvent = json['paidEvent'];
    rating = json['rating'];
    registrationEndDate = json['registrationEndDate'];
    registrationImage = json['registrationImage'] != null
        ? new RegistrationImage.fromJson(json['registrationImage'])
        : null;
    registrationRequired = json['registrationRequired'];
    registrationType = json['registrationType'];
    registrationUrl = json['registrationUrl'];
    if (json['sessions'] != null) {
      sessions = new List<Sessions>();
      json['sessions'].forEach((v) {
        sessions.add(new Sessions.fromJson(v));
      });
    }
    startDate = json['startDate'];
    status = json['status'];
    if (json['targetAudience'] != null) {
      targetAudience = new List<TargetAudience>();
      json['targetAudience'].forEach((v) {
        targetAudience.add(new TargetAudience.fromJson(v));
      });
    }
    timezone = json['timezone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['active'] = this.active;
    data['audienceDepartment'] = this.audienceDepartment;
    data['bookingForm'] = this.bookingForm;
    data['comments'] = this.comments;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['dayOfMonth'] = this.dayOfMonth;
    data['description'] = this.description;
    data['endDate'] = this.endDate;
    data['eventDepartment'] = this.eventDepartment;
    data['eventId'] = this.eventId;
    data['eventName'] = this.eventName;
    data['eventPattern'] = this.eventPattern;
    data['eventType'] = this.eventType;
    data['feedBackRequired'] = this.feedBackRequired;
    data['maximumAttendees'] = this.maximumAttendees;
    data['modifiedBy'] = this.modifiedBy;
    data['modifiedOn'] = this.modifiedOn;
    data['multipleSession'] = this.multipleSession;
    data['noOfDaysBeforeRegistration'] = this.noOfDaysBeforeRegistration;
    data['noOfHoursBeforeRegistration'] = this.noOfHoursBeforeRegistration;
    data['occurenceType'] = this.occurenceType;
    data['openEvent'] = this.openEvent;
    data['paidEvent'] = this.paidEvent;
    data['rating'] = this.rating;
    data['registrationEndDate'] = this.registrationEndDate;
    if (this.registrationImage != null) {
      data['registrationImage'] = this.registrationImage.toJson();
    }
    data['registrationRequired'] = this.registrationRequired;
    data['registrationType'] = this.registrationType;
    data['registrationUrl'] = this.registrationUrl;
    if (this.sessions != null) {
      data['sessions'] = this.sessions.map((v) => v.toJson()).toList();
    }
    data['startDate'] = this.startDate;
    data['status'] = this.status;
    if (this.targetAudience != null) {
      data['targetAudience'] =
          this.targetAudience.map((v) => v.toJson()).toList();
    }
    data['timezone'] = this.timezone;
    return data;
  }
}

class RegistrationImage {
  String attachmentId;
  String attachmentUrl;
  String fileName;
  String fileType;

  RegistrationImage(
      {this.attachmentId, this.attachmentUrl, this.fileName, this.fileType});

  RegistrationImage.fromJson(Map<String, dynamic> json) {
    attachmentId = json['attachmentId'];
    attachmentUrl = json['attachmentUrl'];
    fileName = json['fileName'];
    fileType = json['fileType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['attachmentId'] = this.attachmentId;
    data['attachmentUrl'] = this.attachmentUrl;
    data['fileName'] = this.fileName;
    data['fileType'] = this.fileType;
    return data;
  }
}

class Sessions {
  bool active;
  String comments;
  String createdBy;
  String createdOn;
  String endDate;
  String eventId;
  String location;
  String modifiedBy;
  String modifiedOn;
  int noOfRegistration;
  String previousEndDate;
  String previousLocation;
  String previousRoomName;
  String previousStartDate;
  String roomName;
  String sessionName;
  String speaker;
  String sponsor;
  String startDate;
  String timeZone;

  Sessions(
      {this.active,
      this.comments,
      this.createdBy,
      this.createdOn,
      this.endDate,
      this.eventId,
      this.location,
      this.modifiedBy,
      this.modifiedOn,
      this.noOfRegistration,
      this.previousEndDate,
      this.previousLocation,
      this.previousRoomName,
      this.previousStartDate,
      this.roomName,
      this.sessionName,
      this.speaker,
      this.sponsor,
      this.startDate,
      this.timeZone});

  Sessions.fromJson(Map<String, dynamic> json) {
    active = json['active'];
    comments = json['comments'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    endDate = json['endDate'];
    eventId = json['eventId'];
    location = json['location'];
    modifiedBy = json['modifiedBy'];
    modifiedOn = json['modifiedOn'];
    noOfRegistration = json['noOfRegistration'];
    previousEndDate = json['previousEndDate'];
    previousLocation = json['previousLocation'];
    previousRoomName = json['previousRoomName'];
    previousStartDate = json['previousStartDate'];
    roomName = json['roomName'];
    sessionName = json['sessionName'];
    speaker = json['speaker'];
    sponsor = json['sponsor'];
    startDate = json['startDate'];
    timeZone = json['timeZone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['active'] = this.active;
    data['comments'] = this.comments;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['endDate'] = this.endDate;
    data['eventId'] = this.eventId;
    data['location'] = this.location;
    data['modifiedBy'] = this.modifiedBy;
    data['modifiedOn'] = this.modifiedOn;
    data['noOfRegistration'] = this.noOfRegistration;
    data['previousEndDate'] = this.previousEndDate;
    data['previousLocation'] = this.previousLocation;
    data['previousRoomName'] = this.previousRoomName;
    data['previousStartDate'] = this.previousStartDate;
    data['roomName'] = this.roomName;
    data['sessionName'] = this.sessionName;
    data['speaker'] = this.speaker;
    data['sponsor'] = this.sponsor;
    data['startDate'] = this.startDate;
    data['timeZone'] = this.timeZone;
    return data;
  }
}

class TargetAudience {
  String departmentName;
  String notificationName;
  String notificationType;
  String userName;

  TargetAudience(
      {this.departmentName,
      this.notificationName,
      this.notificationType,
      this.userName});

  TargetAudience.fromJson(Map<String, dynamic> json) {
    departmentName = json['departmentName'];
    notificationName = json['notificationName'];
    notificationType = json['notificationType'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['departmentName'] = this.departmentName;
    data['notificationName'] = this.notificationName;
    data['notificationType'] = this.notificationType;
    data['userName'] = this.userName;
    return data;
  }
}
