import '../model/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notice_board_response.g.dart';

@JsonSerializable()
class NoticeBoardResponse extends BaseResponse {
  @JsonKey(name: "dateFilter")
  String dateFilter;
  @JsonKey(name: "previousPage")
  bool currentPage;
  @JsonKey(name: "pageSize")
  int pageSize;
  @JsonKey(name: "results")
  List<NewNotification> results;

  NoticeBoardResponse();

  factory NoticeBoardResponse.fromJson(Map<String, dynamic> json) =>
      _$NoticeBoardResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NoticeBoardResponseToJson(this);
}

class NewNotification {
  String createdBy;
  String createdOn;
  String modifiedBy;
  String modifiedOn;
  bool active;
  String comments;
  String configurationName;
  String emailId;
  String groupName;
  String groupType;
  String message;
  int messageId;
  String messageStatus;
  String mobileNumber;
  String subject;
  String type;
  String userName;
  String contactName;
  String userFullName;
  String departmentName;
  int year;
  String formattedCreatedDate;

  NewNotification(
      {this.createdBy,
      this.createdOn,
      this.modifiedBy,
      this.modifiedOn,
      this.active,
      this.comments,
      this.configurationName,
      this.emailId,
      this.groupName,
      this.groupType,
      this.message,
      this.messageId,
      this.messageStatus,
      this.mobileNumber,
      this.subject,
      this.type,
      this.userName,
      this.contactName,
      this.userFullName,
      this.departmentName,
      this.year,
      this.formattedCreatedDate});

  NewNotification.fromJson(Map<String, dynamic> json) {
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    modifiedBy = json['modifiedBy'];
    modifiedOn = json['modifiedOn'];
    active = json['active'];
    comments = json['comments'];
    configurationName = json['configurationName'];
    emailId = json['emailId'];
    groupName = json['groupName'];
    groupType = json['groupType'];
    message = json['message'];
    messageId = json['messageId'];
    messageStatus = json['messageStatus'];
    mobileNumber = json['mobileNumber'];
    subject = json['subject'];
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
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['modifiedBy'] = this.modifiedBy;
    data['modifiedOn'] = this.modifiedOn;
    data['active'] = this.active;
    data['comments'] = this.comments;
    data['configurationName'] = this.configurationName;
    data['emailId'] = this.emailId;
    data['groupName'] = this.groupName;
    data['groupType'] = this.groupType;
    data['message'] = this.message;
    data['messageId'] = this.messageId;
    data['messageStatus'] = this.messageStatus;
    data['mobileNumber'] = this.mobileNumber;
    data['subject'] = this.subject;
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
