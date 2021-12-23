import '../model/people_response.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class UserInfoValidationBloc extends Bloc {
  PeopleResponse response;

  final actionTrigger = PublishSubject<bool>();
  final validationTrigger = PublishSubject<bool>();
  final returnResponse = PublishSubject<bool>();
  final usernameStream = PublishSubject<String>();

  UserInfoValidationBloc(BuildContext context) : super(context);

  Stream<bool> get stream => actionTrigger.stream;

  @override
  void init() {}
  bool isAllPagesLoaded;

  Future<void> actionCallAPI() async {
    actionTrigger.sink.add(true);
  }

  Future<void> returnResponseCallBack(bool readOnly) async {
    returnResponse.sink.add(readOnly);
  }

  Future<void> actionPeopleListCallAPI(
      {bool isCameFromAddUserFamily: false}) async {
    actionTrigger.sink.add(isCameFromAddUserFamily);
  }

  Future<void> actionUsernameSent(String username) async {
    usernameStream.sink.add(username);
  }

  Future<void> actionPeopleListCallAPISupervisor({bool action: false}) async {
    actionTrigger.sink.add(action);
  }

  Future<void> validationStateChange() async {
    validationTrigger.sink.add(true);
  }

  @override
  void dispose() {
    actionTrigger.close();
    returnResponse.close();
    validationTrigger.close();
    usernameStream.close();
  }
}
