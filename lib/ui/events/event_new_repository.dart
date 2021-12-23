import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../model/base_response.dart';
import '../../repo/common_repository.dart';
import '../../utils/app_preferences.dart';
import 'event_new_feed.dart';
import 'user_event.dart';

class EventNewRepository {
  EventNewRepository();

  Future<List<UserEvent>> getUserEvents() async {
    String url =
        '${WebserviceConstants.baseEventFeedURL}/invitee?department_name=${AppPreferences().deptmentName}&user_name=${AppPreferences().username}';
    final headers = {
      "tenant": AppPreferences().tenant,
      "username": AppPreferences().username,
    };
    final response = await http.get(url, headers: headers);
    // debugPrint("body --> ${jsonDecode(response.body)}");
    if (response.statusCode == 200) {
      List jsonList = jsonDecode(response.body);
      List<UserEvent> userEvents = [];
      for (var json in jsonList) {
        userEvents.add(UserEvent.fromJson(json));
      }
      return userEvents;
    }
    return null;
  }

  Future<List<EventFeed>> getEventItems() async {
    String url = '${WebserviceConstants.baseEventFeedURL}/event';
    // print("url >> $url");

    final http.Response response = await http.get(
      url,
    );
    //print("Response >> ${response.body}");
    List<dynamic> jsonData;
    List<EventFeed> eventList = [];
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      if (jsonData != null && jsonData.length > 0) {
        // debugPrint("received Data lenth >> ${jsonData.length}");
        for (var eventJson in jsonData)
          eventList.add(EventFeed.fromJson(eventJson));
        return eventList;
      } else {
        // debugPrint("Server version and current app version are different");
        return null;
      }
    }
    return null;
  }

  Future<bool> registerEvent(UserEvent event) async {
    final url =
        '${WebserviceConstants.baseEventFeedURL}/invitee/${event.departmentName}/${AppPreferences().username}/${event.eventId}/${event.sessionName}';
    // print("url >> $url");

    final headers = {
      "tenant": AppPreferences().tenant,
      "username": AppPreferences().username,
      'Content-Type': 'application/json',
    };

    final body = {
      "status": "REGISTERED",
    };

    final response =
        await http.post(url, headers: headers, body: jsonEncode(body));
    return response.statusCode == 200;
  }

  Future<bool> acceptEvent(UserEvent event) async {
    final url =
        '${WebserviceConstants.baseEventFeedURL}/invitee/${event.departmentName}/${AppPreferences().username}/${event.eventId}/${event.sessionName}';
    // print("url >> $url");

    final headers = {
      "tenant": AppPreferences().tenant,
      "username": AppPreferences().username,
      'Content-Type': 'application/json',
    };

    final body = {
      "status": "REGISTERED",
    };

    final response =
        await http.post(url, headers: headers, body: jsonEncode(body));
    // print("================> ${response.body}");
    return response.statusCode == 200;
  }

  Future<bool> declineEvent(UserEvent event) async {
    final url =
        '${WebserviceConstants.baseEventFeedURL}/invitee/${event.departmentName}/${AppPreferences().username}/${event.eventId}/${event.sessionName}';
    // print("url >> $url");

    final headers = {
      "tenant": AppPreferences().tenant,
      "username": AppPreferences().username,
      'Content-Type': 'application/json',
    };

    final body = {
      "status": "DECLINED",
    };

    final response =
        await http.post(url, headers: headers, body: jsonEncode(body));
    // print("================> ${response.body}");
    return response.statusCode == 200;
  }

  http.Response _onTimeOut() {
    BaseResponse appBaseResponse = BaseResponse(
        status: 500, message: AppPreferences().getApisErrorMessage);
    http.Response response = http.Response(jsonEncode(appBaseResponse), 500);
    return response;
  }
}
