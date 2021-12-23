import '../model/base_response.dart';
import '../model/notification_item.dart';
import '../model/notification_response.dart';
import '../repo/notification_repository.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class NotificationBloc extends Bloc {
  NotificationResponse allResponse;
  NotificationResponse ackResponse;
  NotificationResponse nAckResponse;
  BaseResponse updateResponse;

  final _repository = NotificationRepository();

  final updateMsgFetcher = PublishSubject<BaseResponse>();
  final allListFetcher = PublishSubject<NotificationResponse>();
  final ackListFetcher = PublishSubject<NotificationResponse>();
  final nAckListFetcher = PublishSubject<NotificationResponse>();

  NotificationBloc(BuildContext context) : super(context);

  Stream<BaseResponse> get baseResponseStream => updateMsgFetcher.stream;

  @override
  void init() {}
  List<NotificationItem> listNotification = [];

  bool isAllPagesLoaded;

  Future<void> updateAckStatus(String msgStatus, String msgId) async {
    updateResponse =
        await _repository.updateAcknowledgeStatus(msgId, msgStatus);
    updateMsgFetcher.sink.add(updateResponse);
  }

  Future<void> fetchNotificationList({bool refresh: false}) async {
    if (refresh) {
      allListFetcher.sink.add(null);
    }
    allResponse = await _repository.fetchNotificationList();
    listNotification = allResponse?.notificationList ?? List();
    allResponse?.notificationList = listNotification.reversed.toList();
    splitList(allResponse);
  }

  splitList(NotificationResponse response) {
    assert(response != null);
    nAckResponse = NotificationResponse();
    nAckResponse.notificationList = List();

    ackResponse = NotificationResponse();
    ackResponse.notificationList = List();
    for (NotificationItem item in response?.notificationList) {
      if (item.messageStatus == "NotAcknowledged") {
        nAckResponse.notificationList.add(item);
      } else if (item.messageStatus == "Acknowledged") {
        ackResponse.notificationList.add(item);
      }
    }

    allListFetcher.sink.add(allResponse);
    ackListFetcher.sink.add(ackResponse);
    nAckListFetcher.sink.add(nAckResponse);
  }

  @override
  void dispose() {
    allListFetcher.close();
    updateMsgFetcher.close();
    ackListFetcher.close();
    nAckListFetcher.close();
  }
}
