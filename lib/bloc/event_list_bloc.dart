import '../model/event_feed.dart';
import '../model/user_event.dart';
import '../repo/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class EventListBloc extends Bloc {
  List<UserEvent> eventsList;
  EventFeed feed;
  final _repository = EventRepository();
  final eventListFetcher = PublishSubject<List<UserEvent>>();
  final _searchSubject = PublishSubject<String>();

  EventListBloc(BuildContext context) : super(context);

  @override
  void init() {
    _searchSubject
        .debounceTime(Duration(milliseconds: 500))
        .forEach((searchString) {
      eventListFetcher.sink.add(eventsList
          .where(
            (event) => event.eventName
                .toLowerCase()
                .contains(searchString.toLowerCase()),
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

  
  Future<bool> registerEvent(UserEvent event) =>
      _repository.registerEvent(event);

  Future<bool> declinedEvent(UserEvent event) =>
      _repository.declineEvent(event);

  @override
  void dispose() {
    eventListFetcher.close();
    _searchSubject.close();
  }
}
