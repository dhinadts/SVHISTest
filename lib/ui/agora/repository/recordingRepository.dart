import 'dart:convert';
import '../../../repo/common_repository.dart';
import '../../../ui/agora/repository/modelAppointment.dart';
import '../../../ui/agora/repository/recordingRes.dart';
import '../../../ui/b2c/model/base_response.dart';
import '../../../ui/b2c/model/user_login_model.dart';
import '../../../ui/booking_appointment/models/appointment.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class RecordingRepository {
  WebserviceHelper helper;
  var client;

  RecordingRepository() {
    helper = WebserviceHelper();
    client = new http.Client();
  }

  /// Start recording web service call
  Future<Map<String, dynamic>> startRecording(
      String bookingId, String departmentName, String patientName) async {
    var url =
        '${WebserviceConstants.baseURL}/isd/v2/patient_appointment/$departmentName/$patientName/$bookingId${WebserviceConstants.startRecord}';
    http.Response response = await client.get(url);
    print("REQ URL: $url");
    if (response.statusCode == 200) {
      var obj = json.decode(response.body);
      // responseModel = recordingResFromJson(obj.toString());
      return obj;
    } else {
      print("Start recording Error string:  ${response.statusCode}");
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  /// Stop recording web service call
  Future<RecordRes> stopRecording(
      String bookingId, String departmentName, String patientName) async {
    var url =
        '${WebserviceConstants.baseURL}/isd/v2/patient_appointment/$departmentName/$patientName/$bookingId${WebserviceConstants.stopRecord}';
    http.Response response = await client.get(url);
    print("REQ URL: $url");
    if (response.statusCode == 200) {
      var obj = json.decode(response.body);
      // responseModel = recordingResFromJson(obj.toString());
      return obj;
    } else {
      print("Stop recording Error string:  ${response.statusCode}");
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  /// get appointment API
  Future<ModelAppointment> getAppointment(
      String departmentName, String patientName, String bookingId) async {
    var url =
        '${WebserviceConstants.baseURL}/isd/v2/patient_appointment/$departmentName/$patientName';
    http.Response response = await client.get(url);
    print("REQ URL: $url");
    if (response.statusCode == 200) {
      var obj = json.decode(response.body);
      // responseModel = recordingResFromJson(obj.toString());
      for (var item in obj) {
        if (item['bookingId'] == bookingId) {
          print("Condition validated");
          var dd = jsonEncode(item);
          return modelAppointmentFromJson(dd.toString());
        }
      }
      return null;
    } else {
      print("Get Appointment error string:  ${response.statusCode}");
      return Future.error(response.reasonPhrase);
    }
  }

Future<RecordRes> updateAppointment(String bookingId, String departmentName,
      String patientName, ModelAppointment data) async {
    var url =
        // '${WebserviceConstants.baseURL}/isd/v2/patient_appointment/$departmentName/$patientName/$bookingId';
        '${WebserviceConstants.baseURL}/isd/v2/patient_appointment/$departmentName/$patientName/$bookingId/dynamicUpdate';

    var map = modelAppointmentToJson(data);
    developer.log("PARAMS: $map");

    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "isScreensharing": data.isScreensharing,
        "isRecording": data.isRecording
      }),
    );

    if (response.statusCode == 200) {
      print("UPDATE RES: ${response.body}");
      var obj = json.decode(response.body);
      //print("UPDATE RES: $obj");
      // responseModel = recordingResFromJson(obj.toString());
      return obj;
    } else {
      print("Update appointment Error string:  ${response.statusCode}");
      return Future.error(response.reasonPhrase);
    }
  }
  
  /// update appointment API
  Future<RecordRes> updateAppointmentStatus(String bookingId, String departmentName,
      String patientName, Map data) async {
    var url =
        // '${WebserviceConstants.baseURL}/isd/v2/patient_appointment/$departmentName/$patientName/$bookingId';
        '${WebserviceConstants.baseURL}/isd/v2/patient_appointment/$departmentName/$patientName/$bookingId/dynamicUpdate';

    // var map = modelAppointmentToJson(data);
    // developer.log("PARAMS: $map");

    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "isScreensharing": data['isScreensharing'],
        "isRecording": data['isRecording'],
        "appointmentStatus":data['appointmentStatus']
      }),
    );

    if (response.statusCode == 200) {
      print("UPDATE RES: ${response.body}");
      var obj = json.decode(response.body);
      //print("UPDATE RES: $obj");
      // responseModel = recordingResFromJson(obj.toString());
      return obj;
    } else {
      print("Update appointment Error string:  ${response.statusCode}");
      return Future.error(response.reasonPhrase);
    }
  }

  /// Invite link API API
  Future<String> getInviteLink(
      String departmentName, String patientName, String bookingId) async {
    var url =
        '${WebserviceConstants.baseURL}/isd/v2/patient_appointment/$departmentName/$patientName/$bookingId/invite/link';
    http.Response response = await client.get(url);
    print("REQ URL : $url");
    if (response.statusCode == 200) {
      // var obj = json.decode(response.body);
      print("RES GET LINK : ${response.body}");
      // responseModel = recordingResFromJson(obj.toString());
      return response.body.toString();
    } else {
      print("Get link error string:  ${response.statusCode}");
      return Future.error(response.reasonPhrase);
    }
  }

  BaseResponse onMultiTimeOut() {
    BaseResponse appBaseResponse = BaseResponse(status: 500);
    //BaseResponse response = BaseResponse(jsonEncode(appBaseResponse), 500);
    return appBaseResponse;
  }

  BaseResponse onMultiTimeOutLogin() {
    BaseResponse appBaseResponse = BaseResponse(status: 500);
    //BaseResponse response = BaseResponse(jsonEncode(appBaseResponse), 500);
    return appBaseResponse;
  }
}
