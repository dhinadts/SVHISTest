import 'dart:convert';

import '../../repo/common_repository.dart';
import '../../ui/advertise/adWidget.dart';
import '../../ui/campaign/campaign_inappwebview_screen.dart';
import '../../ui/custom_drawer/navigation_home_screen.dart';
import '../../ui_utils/app_colors.dart';
import '../../utils/app_preferences.dart';
import '../../utils/routes.dart';
import 'models/doctor_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../ui_utils/icon_utils.dart';
import 'models/appointment.dart';

class AppointmentConfirmationScreen extends StatefulWidget {
  final Appointment appointment;

  const AppointmentConfirmationScreen({Key key, this.appointment})
      : super(key: key);

  @override
  _AppointmentConfirmationScreenState createState() =>
      _AppointmentConfirmationScreenState();
}

class _AppointmentConfirmationScreenState
    extends State<AppointmentConfirmationScreen> {
  TextEditingController commentsController = new TextEditingController();
  String userCategory = "";
  UserAsDoctorInfo userDoctorInfo = null;
  @override
  void initState() {
    super.initState();
    usercategor();
    getUserInfo();

    /// Initialize Admob
    initializeAd();
  }

  usercategor() async {
    userCategory = await AppPreferences.getUserCategory();
  }

  Future<void> showProgress(String status) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CupertinoActivityIndicator(radius: 20),
          );
        });
    setAppointmentStatus(status);
  }

  setAppointmentStatus(String status) async {
    String reason = commentsController.text;
    final reqBody = jsonEncode({"cancellationReason": reason});

    String loggedInUserName = await AppPreferences.getUsername();
    Map<String, String> header = {};
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => loggedInUserName);
    header.putIfAbsent("tenant", () => WebserviceConstants.tenant);

    final response = await http.post(
        WebserviceConstants.baseAppointmentURL +
            "/v2/patient_appointment/${widget.appointment.departmentName}/${widget.appointment.patientName}/${widget.appointment.bookingId}/status?appointment_status=$status",
        headers: header,
        body: reqBody);
    // debugPrint("request - ${response.request}");
    // debugPrint("response - ${response.body}");
    Navigator.pop(context);
    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    String sTime = widget.appointment.appointmentTiming +
        " " +
        widget.appointment.appointmentStartTime;
    String eTime = widget.appointment.appointmentTiming +
        " " +
        widget.appointment.appointmentEndTime;

    var sTime1 = DateFormat("h:mm a").format(DateTime.parse(sTime));
    var eTime1 = DateFormat("hh:mm a").format(DateTime.parse(eTime));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          "Appointment Confirmation",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                //replaceHome();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NavigationHomeScreen()),
                    ModalRoute.withName(Routes.dashBoard));
              })
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          widget.appointment.patientFullName,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        AppPreferences().userCategory.toUpperCase() ==
                                    "DOCTOR" &&
                                userDoctorInfo?.sourceReferenceId != null &&
                                userDoctorInfo.sourceReferenceId.isNotEmpty
                            ? GestureDetector(
                                child: Image.asset("assets/images/feedback.png",
                                    height: 30),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CampaignInAppWebViewScreen(
                                                userName: widget
                                                    .appointment.patientName,
                                                departmentName: widget
                                                    .appointment.departmentName,
                                                referenceID: userDoctorInfo
                                                    .sourceReferenceId,
                                              )));
                                })
                            : Container()
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Appointment Date : ${DateFormat(DateUtils.defaultDateFormat).format(DateTime.parse(widget.appointment.appointmentTiming + " " + widget.appointment.appointmentStartTime))}",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Appointment Time : $sTime1 - $eTime1",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Status : ${widget.appointment.appointmentStatus}",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Booking ID : ${widget.appointment.bookingId}",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Comments :",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      maxLines: 3,
                      enabled: widget.appointment.appointmentStatus ==
                                  "CONFIRMED" ||
                              widget.appointment.appointmentStatus == "DECLINED"
                          ? false
                          : true,
                      controller: commentsController,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    isAppointmentConfimredOrDeclined()
                        ? Container(
                            child: Text(
                                '${widget.appointment.appointmentStatus.toUpperCase()}',
                                style: TextStyle(color: Colors.black38)))
                        : Row(
                            children: [
                              Expanded(
                                child: RaisedButton(
                                  onPressed: () {
                                    showProgress("CONFIRMED");
                                  },
                                  child: Text("Confirm"),
                                  color: AppColors.darkGrassGreen,
                                  textColor: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: RaisedButton(
                                  onPressed: () {
                                    if (commentsController.text.length == 0) {
                                      Fluttertoast.showToast(
                                          timeInSecForIosWeb: 5,
                                          msg:
                                              "Cancellation Reason cannot be Empty",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.TOP);
                                    } else {
                                      showProgress("DECLINED");
                                    }
                                  },
                                  child: Text("Decline"),
                                  color: AppColors.brick,
                                  textColor: Colors.white,
                                ),
                              )
                            ],
                          )
                  ],
                ),
              ),
            ),
          ),

          /// Show Banner Ad
          getSivisoftAdWidget(),
        ],
      ),
    );
  }

  getUserInfo({bool navigate = false}) async {
    Map<String, String> header = {};
    String deptName = await AppPreferences.getDeptName();
    String username = await AppPreferences.getUsername();

    //for QA tenant servicedx_qa
    //for Jamaica tenant servicedx
    header.putIfAbsent(
        WebserviceConstants.tenant, () => WebserviceConstants.tenant);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    header.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);
    WebserviceHelper helper = WebserviceHelper();

    String url = WebserviceConstants.baseAdminURL +
        "/departments/" +
        deptName +
        "/users/" +
        widget.appointment.patientName +
        "/lightWeight";

    try {
      final response =
          await helper.get(url, headers: header, isOAuthTokenNeeded: false);
      Map<String, dynamic> jsonData;
      if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
        print('User Info Response...........${response.body.toString()}');
        jsonData = jsonDecode(response.body);

        setState(() {
          userDoctorInfo = UserAsDoctorInfo.fromJson(jsonData);
          print(
              "================> Source Reference ${userDoctorInfo.sourceReferenceId}");
        });
      }
    } catch (e) {}
  }

  bool isAppointmentConfimredOrDeclined() {
    if (widget.appointment.appointmentStatus.toLowerCase() == "confirmed" ||
        widget.appointment.appointmentStatus.toLowerCase() == "declined") {
      return true;
    }
    return false;
  }
}
