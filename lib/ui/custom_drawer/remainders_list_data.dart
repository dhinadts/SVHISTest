import '../../bloc/bloc.dart';
import '../../repo/common_repository.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class RemaindersListData {
  RemaindersListData(
    Map<String, Object> map, {
    this.imagePath,
    this.bgPath,
    this.wishType,
    this.titleTxt,
    this.startColor,
    this.endColor,
    this.meals,
    this.kacl,
    this.userName,
    this.firstName,
    this.lastName,
    this.departmentName,
    this.messageInfo,
    this.profilePic,
    this.emailId,
    this.occasionalType,
    this.phoneNo,
    this.occasionalDate,
    this.createdBy,
    this.modifiedBy,
    this.createdOn,
    this.modifiedOn,
    this.active,
    this.anniversaryRemaindersId,
  });
  String anniversaryRemaindersId;
  String userName;
  String firstName;
  String lastName;
  String departmentName;
  var messageInfo;
  String profilePic;
  String emailId;
  String occasionalType;
  String phoneNo;
  String occasionalDate;
  String createdBy;
  String modifiedBy;
  String createdOn;
  String modifiedOn;
  bool active;

  String imagePath;
  String bgPath;
  String wishType;
  String titleTxt;
  String startColor;
  String endColor;
  List<String> meals;
  int kacl;

  RemaindersListData.fromJson(Map<String, dynamic> json) {
    //print("Member of userList ${json['members']}");
    anniversaryRemaindersId = json['anniversaryRemaindersId'];
    userName = json['userName'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    departmentName = json['departmentName'];
    messageInfo = json['messageInfo'];
    profilePic = json['profilePic'];
    emailId = json['emailId'];
    occasionalType = json['occasionalType'];
    phoneNo = json['phoneNo'];
    occasionalDate = json['occasionalDate'];
    createdBy = json['createdBy'];
    modifiedBy = json['modifiedBy'];
    createdOn = json['createdOn'];
    modifiedOn = json['modifiedOn'];
    active = json['active'];
    messageInfo = json['messageInfo'];
    imagePath = json['imagePath'];
    bgPath = json['bgPath'];
    wishType = json['wishType'];
    titleTxt = json['titleTxt'];
    startColor = json['startColor'];
    endColor = json['endColor'];
    meals = json['meals'];
    kacl = json['kacl'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['anniversaryRemaindersId'] = this.anniversaryRemaindersId;
    data['userName'] = this.userName;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['departmentName'] = this.departmentName;

    data['messageInfo'] = this.messageInfo;
    data['profilePic'] = this.profilePic;
    data['emailId'] = this.emailId;
    data['occasionalType'] = this.occasionalType;

    data['phoneNo'] = this.phoneNo;
    data['occasionalDate'] = this.occasionalDate;
    data['createdBy'] = this.createdBy;
    data['modifiedBy'] = this.modifiedBy;
    data['createdOn'] = this.createdOn;
    data['modifiedOn'] = this.modifiedOn;
    data['active'] = this.active;

    data['imagePath'] = this.imagePath;
    data['bgPath'] = this.bgPath;
    data['wishType'] = this.wishType;
    data['titleTxt'] = this.titleTxt;
    data['startColor'] = this.startColor;
    data['endColor'] = this.endColor;
    data['meals'] = this.meals;

    data['kacl'] = this.kacl;
    return data;
  }
}

List<RemaindersListData> remaindersListData;

class CheckRemainders extends Bloc {
  dynamic response;

  final _repository = CommonRepository();
  final checkRemaindersListFetcher = PublishSubject<dynamic>();
  CheckRemainders(BuildContext context) : super(context);
  Stream<CheckRemainders> get list => checkRemaindersListFetcher.stream;

  Future<void> getWishesList1() async {
    List<RemaindersListData> response = await _repository.getWishesList();

    checkRemaindersListFetcher.sink.add(response);
  }

  @override
  void dispose() {
    checkRemaindersListFetcher.close();
  }

  @override
  void init() {
    // TODO: implement init
  }
}
