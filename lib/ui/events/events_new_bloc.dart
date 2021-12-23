import '../../ui_utils/icon_utils.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../bloc/bloc.dart';
import 'event_new_feed.dart';
import 'event_new_repository.dart';
import 'user_event.dart';

class EventsBloc extends Bloc {
  List<UserEvent> eventsList;
  EventFeed feed;
  final _repository = EventNewRepository();
  final eventListFetcher = PublishSubject<List<UserEvent>>();
  final _searchSubject = PublishSubject<String>();
  final _filterSubject = PublishSubject<String>();
  final _dateFilterSubject = PublishSubject<String>();

  EventsBloc(BuildContext context) : super(context);

  @override
  void init() {
    _searchSubject
        .debounceTime(Duration(milliseconds: 500))
        .forEach((searchString) {
      eventListFetcher.sink.add(eventsList
          .where(
            (event) =>
                event.eventName
                    .toLowerCase()
                    .contains(searchString.toLowerCase()) ||
                event.sessionName
                    .toLowerCase()
                    .contains(searchString.toLowerCase()),
          )
          .toList());
    });
    _filterSubject
        .debounceTime(Duration(milliseconds: 500))
        .forEach((statusStrig) {
      eventListFetcher.sink.add(eventsList
          .where(
            (event) =>
                event.status.toLowerCase().contains(statusStrig.toLowerCase()),
          )
          .toList());
    });

    _dateFilterSubject
        .debounceTime(Duration(milliseconds: 500))
        .forEach((dateStrig) {
      eventListFetcher.sink.add(eventsList
          .where(
            (event) => DateUtils.convertUTCToLocalTime(event.startDate)
                .toLowerCase()
                .contains(dateStrig.toLowerCase()),
          )
          .toList());
    });
  }

  getEvenItems() async {
    eventsList = await _repository.getUserEvents();
    eventListFetcher.sink.add(eventsList);
  }

  searchEventByName(String searchString) =>
      _searchSubject.sink.add(searchString);

  searchEventByStatus(String statusStrig) =>
      _filterSubject.sink.add(statusStrig);

  searchEventByDate(String dateStrig) => _dateFilterSubject.sink.add(dateStrig);

  Future<bool> registerEvent(UserEvent event) =>
      _repository.registerEvent(event);

  Future<bool> declinedEvent(UserEvent event) =>
      _repository.declineEvent(event);

  Future<bool> acceptEvent(UserEvent event) => _repository.acceptEvent(event);

  @override
  void dispose() {
    eventListFetcher.close();
    _searchSubject.close();
    _filterSubject.close();
    _dateFilterSubject.close();
  }
}
