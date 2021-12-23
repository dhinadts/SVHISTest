import '../model/app_version.dart';
import '../model/check_in_dynamic.dart';
import '../model/people.dart';
import '../model/smart_notes_model.dart';
import '../ui/payment/model/payment_detail.dart';

class Args {
  final String arg;
  final String username;
  final String userFullName;
  final People people;
  final CheckInDynamic checkInDynamic;
  final bool isCameFromEditFamily;
  final PaymentDetail paymentDetail;
  final String from;
  final String token;
  final String contactTracingUsername;
  final int drawerIndex;
  final AppVersion appVersion;
  final String portMonitoringId;
  final String portMonitoringDepName;
  final String portMonitoringIdentificationNumber;
  final FileDetails smartNoteAttachment;
  final String smartNoteFileType;
  final String gender;
  String departmentName;

  Args(
      {this.arg,
      this.people,
      this.isCameFromEditFamily,
      this.checkInDynamic,
      this.username,
      this.userFullName,
      this.from,
      this.contactTracingUsername,
      this.drawerIndex,
      this.appVersion,
      this.token,
      this.portMonitoringId,
      this.portMonitoringDepName,
      this.paymentDetail,
      this.portMonitoringIdentificationNumber,
      this.smartNoteFileType,
      this.smartNoteAttachment,
      this.gender,
      this.departmentName});
}

class SmartNoteTextArg {
  final String noteTitle;
  final String noteComments;

  SmartNoteTextArg({
    this.noteTitle,
    this.noteComments,
  });
}

class ScreenNameArg {
  String title;
  ScreenNameArg(String s) {
    this.title = s;
  }
}
