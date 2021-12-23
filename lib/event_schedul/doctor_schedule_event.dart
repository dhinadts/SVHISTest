// import 'package:http/http.dart' as http;
// import 'dart:async';
// import 'dart:convert' show json, jsonDecode, jsonEncode;
// import '../event_schedul//doctor_schedule_info.dart';

// class DoctorScheduleEvent {

//   static const _createeventUrl = 'https://qa.servicedx.com/isd/doctor_availability';
//   static final _headers = {'Content-Type': 'application/json'};

//   Future<DoctorScheduleInfo> create(DoctorScheduleInfo create) async {
//     try {
//       Map<String, dynamic>  json = _toJson(create);
//       print("jso" + json.toString());
//       final response = await http.post(_createeventUrl, headers: _headers, body: json);
//       print(response.body);
//       print("jsores" + json.toString());
//       var c = _fromJson(response.body);
//       if (c.toJson().isNotEmpty) {
//         print("Doctor scheduled Success" + response.body.toString());
//       }else{
//         print("Doctor scheduled not Success"+ response.body.toString());
//       }

//       return c;
//     } catch (e) {
//       return null;
//     }
//   }

//   DoctorScheduleInfo _fromJson(String json) {
//     Map<String, dynamic> map = jsonDecode(json);
//     var register = new DoctorScheduleInfo();
//     register.active = map['active'] as String;
//     register.availableDate = map['availableDate'] as String;
//     register.comments = map['comments'] as String;
//     register.doctorId = map['doctorId'] as String;
//     register.doctorName = map['doctorName'] as String;
//     register.endTime = map['endTime'] as String;
//     register.startTime = map['startTime'] as String;
//     register.type = map['type'] as String;
//     print('fromjson : $register.toString()!');
//     return register;
//   }

//   Map<String, dynamic> _toJson(DoctorScheduleInfo register) {
//     var mapData = new Map<String, dynamic>();
//     mapData["active"] = register.active;
//     mapData["availableDate"] = register.availableDate;
//     mapData["comments"] = register.comments;
//     mapData["doctorId"] = register.doctorId;
//     mapData["doctorName"] = register.doctorName;
//     mapData["endTime"] = register.endTime;
//     mapData["startTime"] = register.startTime;
//     mapData["type"] = register.type;
//    // String json = jsonEncode(mapData);
//     print(mapData);
//     return mapData;
//   }

// }
