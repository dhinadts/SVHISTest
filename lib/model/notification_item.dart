class NotificationItem {
  bool active;
  String comments;
  String category;
  String configurationName;
  String emailId;
  int escalationId;
  int escalationSequence;
  int escalationInterval;
  String groupName;
  String groupType;
  String eventInstanceId;
  String message;
  int messageId;
  String messageStatus;
  String mobileNumber;
  String sendId;
  String source;
  String subject;
  String templateId;
  String templateName;
  String type;
  String userName;
  String contactName;
  String userFullName;
  String departmentName;
  int year;
  String formattedCreatedDate;

  NotificationItem(
      {this.active,
      this.comments,
      this.category,
      this.configurationName,
      this.emailId,
      this.escalationId,
      this.escalationSequence,
      this.escalationInterval,
      this.groupName,
      this.groupType,
      this.eventInstanceId,
      this.message,
      this.messageId,
      this.messageStatus,
      this.mobileNumber,
      this.sendId,
      this.source,
      this.subject,
      this.templateId,
      this.templateName,
      this.type,
      this.userName,
      this.contactName,
      this.userFullName,
      this.departmentName,
      this.year,
      this.formattedCreatedDate});

  NotificationItem.fromJson(Map<String, dynamic> json) {
    active = json['active'];
    comments = json['comments'];
    category = json['category'];
    configurationName = json['configurationName'];
    emailId = json['emailId'];
    escalationId = json['escalationId'];
    escalationSequence = json['escalationSequence'];
    escalationInterval = json['escalationInterval'];
    groupName = json['groupName'];
    groupType = json['groupType'];
    eventInstanceId = json['eventInstanceId'];
    message = json['message'];
    messageId = json['messageId'];
    messageStatus = json['messageStatus'];
    mobileNumber = json['mobileNumber'];
    sendId = json['sendId'];
    source = json['source'];
    subject = json['subject'];
    templateId = json['templateId'];
    templateName = json['templateName'];
    type = json['type'];
    userName = json['userName'];
    contactName = json['contactName'];
    userFullName = json['userFullName'];
    departmentName = json['departmentName'];
    year = json['year'];
    formattedCreatedDate = json['formattedCreatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['active'] = this.active;
    data['comments'] = this.comments;
    data['category'] = this.category;
    data['configurationName'] = this.configurationName;
    data['emailId'] = this.emailId;
    data['escalationId'] = this.escalationId;
    data['escalationSequence'] = this.escalationSequence;
    data['escalationInterval'] = this.escalationInterval;
    data['groupName'] = this.groupName;
    data['groupType'] = this.groupType;
    data['eventInstanceId'] = this.eventInstanceId;
    data['message'] = this.message;
    data['messageId'] = this.messageId;
    data['messageStatus'] = this.messageStatus;
    data['mobileNumber'] = this.mobileNumber;
    data['sendId'] = this.sendId;
    data['source'] = this.source;
    data['subject'] = this.subject;
    data['templateId'] = this.templateId;
    data['templateName'] = this.templateName;
    data['type'] = this.type;
    data['userName'] = this.userName;
    data['contactName'] = this.contactName;
    data['userFullName'] = this.userFullName;
    data['departmentName'] = this.departmentName;
    data['year'] = this.year;
    data['formattedCreatedDate'] = this.formattedCreatedDate;
    return data;
  }
}
