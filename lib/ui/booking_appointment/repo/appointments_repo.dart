import 'package:http/http.dart' as http;
import '../../../repo/common_repository.dart';
import '../../../utils/app_preferences.dart';
import 'dart:convert';
import '../models/appointment_token_details.dart';

class AppointmentsRepo {
  Future<String> getAppointmentsToken(
      String bookingId, String patientName) async {
    String departmentName = AppPreferences().deptmentName;
    http.Response response = await http.get(
        WebserviceConstants.baseAppointmentURL +
            "/v2/patient_appointment/" +
            departmentName +
            '/' +
            patientName +
            '/' +
            bookingId +
            '/token');
    print(WebserviceConstants.baseAppointmentURL +
        "/v2/patient_appointment/" +
        departmentName +
        '/' +
        patientName +
        '/' +
        bookingId +
        '/token');
    return AppointmentTokenDetails.fromJson(json.decode(response.body))
        .generatedToken;
  }
}
