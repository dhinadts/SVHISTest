import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert' show json, jsonDecode, jsonEncode;
import '../event_schedul//eventmodel.dart';

class CreateEvent {

  static const _createeventUrl = 'https://qa.servicedx.com/subscription/applications/Covid19Test/events/';
  static final _headers = {'username': 'SuperAdmin','Content-Type': 'application/json'};

  Future<event> create(event create) async {
    try {
      String json = _toJson(create);
      final response = await http.post(_createeventUrl, headers: _headers, body: json);
      // print(response.body);
      var c = _fromJson(response.body);
      // print("Success" + c.eventName );
      return c;
    } catch (e) {
      return null;
    }
  }

    event _fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    // print(map['eventName']);
    var register = new event();
    //register.active = map['active'] as String;
    register.applicationName = map['applicationName'] as String;
    register.comments = map['comments'] as String;
    register.eventName = map['eventName'] as String;
    register.eventType = map['eventType'] as String;
    // print('fromjson : $register.toString()!');
    return register;
  }


  String _toJson(event register) {
    var mapData = new Map();
    mapData["active"] = register.active;
    mapData["applicationName"] = register.applicationName;
    mapData["comments"] = register.comments;
    mapData["eventName"] = register.eventName;
    mapData["eventType"] = register.eventType;
    String json = jsonEncode(mapData);
    // print(json);
    return json;
  }

}

