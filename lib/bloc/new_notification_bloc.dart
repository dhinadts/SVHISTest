import '../model/notice_board_response.dart';
import '../repo/notification_repository.dart';
import '../utils/app_preferences.dart';
import '../utils/validation_utils.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class NewNotificationBloc extends Bloc {
  NoticeBoardResponse response;

  final _repository = NotificationRepository();

  final notificationFetcher = PublishSubject<NoticeBoardResponse>();

  NewNotificationBloc(BuildContext context) : super(context);

  @override
  void init() {}
  List<NewNotification> notificationList = [];
  bool isAllPagesLoaded;

  Future<void> fetchNotifications(int pageNo,
      {bool refresh: false, String filterType}) async {
    if (pageNo == 1) {
      notificationFetcher.sink.add(null);
      await AppPreferences.setPageData("");
      response = NoticeBoardResponse();
      notificationList = [];
    }
    isAllPagesLoaded = false;
    response = await _repository.fetchNewNotificationList(pageNo,
        filterType: filterType);
    if (ValidationUtils.isSuccessResponse(response.status)) {
      notificationList.addAll(response?.results ?? []);
      isAllPagesLoaded = response?.results?.isEmpty ?? true;
      response?.results = notificationList;
    }
    notificationFetcher.sink.add(response);
  }

  @override
  void dispose() {
    notificationFetcher.close();
  }
}
