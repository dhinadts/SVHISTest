import 'dart:convert';
import '../../ui/agora/repository/recordingRepository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../repo/common_repository.dart';
import '../../ui/advertise/adWidget.dart';
import '../../ui/agora/pages/call.dart';
import '../../ui/agora/pages/video_call_screen.dart';
import '../../ui/booking_appointment/models/doctor_info.dart';
import '../../ui/campaign/campaign_inappwebview_screen.dart';
import '../../ui/custom_drawer/custom_app_bar.dart';
import '../../ui_utils/icon_utils.dart';
import '../../utils/app_preferences.dart';
import '../../utils/constants.dart';
import '../../widgets/ratting_widget.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:avatar_letter/avatar_letter.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'booking_appointment_screen.dart';
import 'models/appointment.dart';
import 'models/doctor.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'repo/appointments_repo.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:io';
import 'review_appointment_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../assessment/assessment_history.dart';

class AppointmentDetails extends StatefulWidget {
  final Appointment appointmentDetails;
  final bool willShowConnect;
  final bool willTestConnect;
  final bool isUpcoming;
  final bool enableFeedback;
  final MaterialColor color;
  const AppointmentDetails(
      {Key key,
      this.appointmentDetails,
      this.willShowConnect,
      this.willTestConnect,
      this.isUpcoming,
      this.enableFeedback,
      this.color})
      : super(key: key);

  @override
  _AppointmentDetailsState createState() => _AppointmentDetailsState();
}

class _AppointmentDetailsState extends State<AppointmentDetails> {
  Doctor doctorData = new Doctor();
  String userCategory;
  String supervisor;
  String s3BucketName = "sdx-agora-cloud-recording";
  TextEditingController cancelReasonController = TextEditingController();
  UserAsDoctorInfo userDoctorInfo = null;
  UserAsDoctorInfo userPatientInfo = null;
  static var httpClient = new HttpClient();
  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  bool isCallStatusCompleted = false;
  String cancelledBy = "";
  RecordingRepository _repository;

  @override
  void initState() {
    super.initState();
    doctorData.doctorId = widget.appointmentDetails.doctorId;
    // doctorData.speciality = widget.appointmentDetails.doctorSpeciality.splitMapJoin(", ");//TODO
    doctorData.image = widget.appointmentDetails.doctorImage;
    doctorData.doctorName = widget.appointmentDetails.doctorName;
    getUserCategory();
    getUserInfo();
    getUserInfo(doctorName: widget.appointmentDetails.modifiedBy);
    getCancelledByPersonDetails();
    getPatientUserInfo();
    print(widget.appointmentDetails.toJson());
    initializeAd();
    // _getAppointmentStatusFromFireStore();
    _repository = RecordingRepository();
    isCallStatusCompleted =
        widget.appointmentDetails.appointmentStatus == "COMPLETED"
            ? true
            : false;
    //Do this only for real time data not for test
    if (widget.appointmentDetails.appointmentStatus != "COMPLETED" &&
        widget.willTestConnect == false) {
      _updateAppointmentStatusFromAPI();
    }
  }

  // _getAppointmentStatusFromFireStore() {
  //   Firestore.instance
  //       .collection('AgoraCallStatus')
  //       .where("BookingID", isEqualTo: widget.appointmentDetails.bookingId)
  //       .getDocuments()
  //       .then((value) {
  //     value.documents.forEach((element) {
  //       print(element.data["CallStatus"]);
  //       isCallStatusCompleted =
  //           element.data["CallStatus"] == "DisConnected" ? true : false;
  //       setState(() {});
  //     });
  //   });
  // }

  _updateAppointmentStatusFromAPI() async {
    widget.appointmentDetails.isRecording = false;
    widget.appointmentDetails.appointmentStatus = "COMPLETED";
    Map map = {
      'isScreensharing': false,
      'isRecording': false,
      'appointmentStatus': "COMPLETED"
    };

    var obj = await _repository.updateAppointmentStatus(
      widget.appointmentDetails.bookingId,
      widget.appointmentDetails.departmentName,
      widget.appointmentDetails.patientName,
      map,
    );

    if (obj.error == null) {}
  }

  getUserCategory() async {
    userCategory = await AppPreferences.getUserCategory();
    supervisor = AppPreferences().role;

    setState(() {});
  }

  getTimeAMandPM(Appointment appointment) {
    String sTime =
        appointment.appointmentTiming + " " + appointment.appointmentStartTime;
    String eTime =
        appointment.appointmentTiming + " " + appointment.appointmentEndTime;
    var sTime1 = DateFormat("hh:mm a").format(DateTime.parse(sTime));
    var eTime1 = DateFormat("hh:mm a").format(DateTime.parse(eTime));
    return sTime1 + " - " + eTime1;
  }

  getCancelledByPersonDetails() async {
    if (widget.appointmentDetails.modifiedBy.length > 0) {
      var userInfo =
          await getCancelledUserInfo(widget.appointmentDetails.modifiedBy);
      cancelledBy = userInfo.userFullName;

      setState(() {});
    }
  }

  Future<UserAsDoctorInfo> getCancelledUserInfo(userName) async {
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
        userName +
        "/lightWeight";

    try {
      final response =
          await helper.get(url, headers: header, isOAuthTokenNeeded: false);
      Map<String, dynamic> jsonData;
      if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
        print('User Info Response...........${response.body.toString()}');
        jsonData = jsonDecode(response.body);
        userDoctorInfo = UserAsDoctorInfo.fromJson(jsonData);
        return userDoctorInfo;
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Appointment Details", pageId: 0),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .9,
                    width: MediaQuery.of(context).size.width * .95,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              child: Text(
                                  "Booking ID : ${widget.appointmentDetails.bookingId}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black)),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Container(
                              child: Text(
                                "Appointment Details",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Container(
                                child:
                                    doctorDetails(widget.appointmentDetails)),
                            SizedBox(
                              height: 25,
                            ),
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              direction: Axis.horizontal,
                              children: [
                                widget.willTestConnect
                                    ? InkWell(
                                        onTap: () {
                                          onJoin(
                                            widget.appointmentDetails.doctorId,
                                            widget.appointmentDetails.bookingId,
                                            widget
                                                .appointmentDetails.patientName,
                                            widget.appointmentDetails,
                                            false,
                                          );
                                        },
                                        child: Chip(
                                            elevation: 4.0,
                                            backgroundColor: Colors.green,
                                            label: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.phone,
                                                  color: Colors.white,
                                                  size: 25.0,
                                                ),
                                                SizedBox(
                                                  width: 5.0,
                                                ),
                                                Text(
                                                  userCategory == "DOCTOR"
                                                      ? "Test Launch"
                                                      : supervisor ==
                                                              Constants
                                                                  .supervisorRole
                                                          ? "Test Launch"
                                                          : "Test Connect",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ],
                                            )),
                                      )
                                    : Container(),
                                widget.willShowConnect
                                    ? InkWell(
                                        onTap: () {
                                          onJoin(
                                            widget.appointmentDetails.doctorId,
                                            widget.appointmentDetails.bookingId,
                                            widget
                                                .appointmentDetails.patientName,
                                            widget.appointmentDetails,
                                            true,
                                          );
                                        },
                                        child: Chip(
                                            elevation: 4.0,
                                            backgroundColor: Colors.green,
                                            label: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.phone,
                                                  color: Colors.white,
                                                  size: 25.0,
                                                ),
                                                SizedBox(
                                                  width: 5.0,
                                                ),
                                                Text(
                                                  userCategory == "DOCTOR"
                                                      ? "Launch"
                                                      : supervisor ==
                                                              Constants
                                                                  .supervisorRole
                                                          ? "Launch"
                                                          : "Connect",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ],
                                            )),
                                      )
                                    : widget.isUpcoming &&
                                            isCallStatusCompleted == false
                                        ? InkWell(
                                            onTap: () async {
                                              showRescheduleAlert();
                                            },
                                            child: Chip(
                                                elevation: 4.0,
                                                backgroundColor:
                                                    Colors.indigo[800],
                                                label: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.date_range,
                                                      color: Colors.white,
                                                      size: 25.0,
                                                    ),
                                                    SizedBox(
                                                      width: 5.0,
                                                    ),
                                                    Text(
                                                      "Reschedule",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ],
                                                )),
                                          )
                                        : Container(),
                                widget.isUpcoming &&
                                        widget.appointmentDetails
                                                .appointmentStatus !=
                                            "CANCELLED" &&
                                        !widget.willShowConnect &&
                                        isCallStatusCompleted == false
                                    /*AppPreferences().role !=
                                        Constants.supervisorRole &&*/

                                    ? InkWell(
                                        onTap: () async {
                                          await cancelAppointmentAlert(widget
                                              .appointmentDetails.bookingId);
                                        },
                                        child: Chip(
                                            elevation: 4.0,
                                            backgroundColor: Colors.red,
                                            label: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.cancel,
                                                  color: Colors.white,
                                                  size: 25.0,
                                                ),
                                                SizedBox(
                                                  width: 5.0,
                                                ),
                                                Text(
                                                  "Cancel Appointment",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ],
                                            )),
                                      )
                                    : Container(),
                                AppPreferences().userCategory == "DOCTOR" ||
                                        AppPreferences().userCategory ==
                                            "CONSULTANT"
                                    ? InkWell(
                                        onTap: () async {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AssessmentHistory(
                                                        "Patient History",
                                                        username:
                                                            userPatientInfo
                                                                .userName,
                                                        departmentName:
                                                            AppPreferences()
                                                                .deptmentName,
                                                        showFab: false,
                                                        email: userPatientInfo
                                                            .emailId,
                                                        phoneNo: userPatientInfo
                                                            .mobileNo,
                                                      )));
                                        },
                                        child: Chip(
                                            elevation: 4.0,
                                            backgroundColor: Colors.blue,
                                            label: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.history,
                                                  color: Colors.white,
                                                  size: 25.0,
                                                ),
                                                SizedBox(
                                                  width: 5.0,
                                                ),
                                                Text(
                                                  "Patient History",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ],
                                            )),
                                      )
                                    : Container(),
                                !widget.isUpcoming &&
                                        widget.appointmentDetails
                                                .appointmentStatus !=
                                            "CANCELLED" &&
                                        AppPreferences().role !=
                                            Constants.supervisorRole &&
                                        userCategory != "DOCTOR"
                                    ? InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ReviewAppointment(widget
                                                          .appointmentDetails)));
                                        },
                                        child: Chip(
                                            elevation: 4.0,
                                            backgroundColor: Colors.green,
                                            label: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.rate_review,
                                                  color: Colors.white,
                                                  size: 25.0,
                                                ),
                                                SizedBox(
                                                  width: 5.0,
                                                ),
                                                Text(
                                                  "Write Review",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ],
                                            )),
                                      )
                                    : Container(),
                                !widget.isUpcoming &&
                                        widget.appointmentDetails
                                                .appointmentStatus !=
                                            "CANCELLED" &&
                                        (AppPreferences().role ==
                                                Constants.supervisorRole ||
                                            userCategory == "DOCTOR") &&
                                        (widget.appointmentDetails
                                                    .rating !=
                                                null &&
                                            widget.appointmentDetails.review
                                                .isNotEmpty &&
                                            widget.appointmentDetails.review !=
                                                null)
                                    ? InkWell(
                                        onTap: () {
                                          double rating =
                                              widget.appointmentDetails.rating +
                                                  0.0;
                                          String review =
                                              widget.appointmentDetails.review;
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text(
                                                      "Appointment Review"),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child:
                                                                Text("Rating")),
                                                      ),
                                                      Container(
                                                          child: StarRating(
                                                              rating: rating,
                                                              color: Colors
                                                                  .yellow)),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              "Review",
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                            )),
                                                      ),
                                                      TextFormField(
                                                          enabled: true,
                                                          readOnly: true,
                                                          maxLines: 5,
                                                          decoration:
                                                              InputDecoration(
                                                                  border:
                                                                      OutlineInputBorder()),
                                                          controller:
                                                              TextEditingController(
                                                                  text:
                                                                      "$review"),
                                                          style: TextStyle(
                                                              fontSize: 14))
                                                    ],
                                                  ),
                                                  actions: [
                                                    FlatButton(
                                                      child: Text("Ok"),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    )
                                                  ],
                                                );
                                              });
                                        },
                                        child: Chip(
                                            elevation: 4.0,
                                            backgroundColor: Colors.green,
                                            label: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.rate_review,
                                                  color: Colors.white,
                                                  size: 25.0,
                                                ),
                                                SizedBox(
                                                  width: 5.0,
                                                ),
                                                Text(
                                                  "View Review",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ],
                                            )),
                                      )
                                    : Container(),
                                widget.appointmentDetails.recordedFiles !=
                                            null &&
                                        widget.appointmentDetails.recordedFiles
                                                .length >
                                            0 &&
                                        widget.appointmentDetails
                                                .appointmentStatus !=
                                            "DECLINED" &&
                                        widget.appointmentDetails
                                                .appointmentStatus !=
                                            "CANCELLED"
                                    ? Center(
                                        child: InkWell(
                                          onTap: () {
                                            _downloadFile();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Chip(
                                                elevation: 4.0,
                                                backgroundColor: Colors.green,
                                                label: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.download_rounded,
                                                      color: Colors.white,
                                                      size: 25.0,
                                                    ),
                                                    SizedBox(
                                                      width: 5.0,
                                                    ),
                                                    Text(
                                                      "Download Recording",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ],
                                                )),
                                          ),
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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

  Widget doctorDetails(Appointment appointmentHistoryData) {
    String bookingDate = appointmentHistoryData.requestDate;
    String bookingTime = getTimeAMandPM(appointmentHistoryData);
    print(appointmentHistoryData.doctorFullName);
//  2021-03-06T12:24:54.156
    // if (bookingDate.split("/")[2].length < 4 ||
    //     int.parse(bookingDate.split("/")[1]) > 12)
    bookingDate = bookingDate.split("/")[2] +
        "-" +
        bookingDate.split("/")[0] +
        "-" +
        bookingDate.split("/")[1] +
        "T" +
        "00:00:00";
    // print(bookingDate);
    // print(DateUtils.convertUTCToLocalTime(bookingDate).split(" ")[0]);
    bookingDate = DateUtils.convertUTCToLocalTime(bookingDate).split(" ")[0];

    return Card(
      elevation: 6.0,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Container(
                  // width: MediaQuery.of(context).size.width * .30,
                  //color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: appointmentHistoryData.doctorImage.length == 0
                        ?
                        // Image.asset(
                        //     'assets/images/doctor_image.png',
                        //     width: 100.0,
                        //     height: 100.0,
                        //   )
                        Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: widget.color, width: 2.0),
                                  borderRadius: BorderRadius.circular(50)),
                              child: AvatarLetter(
                                backgroundColor: Colors.transparent,
                                textColor: widget.color,
                                fontSize: 20,
                                upperCase: true,
                                numberLetters: 2,
                                letterType: LetterType.Circular,
                                text: appointmentHistoryData.doctorFullName,
                                textColorHex: null,
                                backgroundColorHex: null,
                              ),
                            ),
                          )
                        : CircleAvatar(
                            radius: 55.0,
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(
                                appointmentHistoryData.doctorImage),
                          ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        appointmentHistoryData.doctorName ==
                                    AppPreferences().username &&
                                AppPreferences().userCategory == "CONSULTANT"
                            ? "Self"
                            : appointmentHistoryData.doctorFullName.length == 0
                                ? appointmentHistoryData.doctorName
                                : appointmentHistoryData.doctorFullName,
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 18.0),
                      ),
                    ),
                    /* SizedBox(
                      height: 10.0,
                    ), */
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Text(appointmentHistoryData.doctorCategory ==
                                null
                            ? appointmentHistoryData.doctorCategory +
                                "," +
                                appointmentHistoryData.departmentName
                            : "${userDoctorInfo == null ? "" : userDoctorInfo.userCategory == "CONSULTANT" ? "Consultant," : "Doctor,"} ${appointmentHistoryData.departmentName}")),
                  ],
                ),
              ],
            ),
            SizedBox(
              width: 8.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 1.0,
              //color: Colors.blue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.date_range,
                          color: Colors.red,
                          size: 35.0,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              bookingDate,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              bookingTime,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 2, top: 3.0),
                          child: Text(
                            "Created At : ${DateUtils.convertUTCToLocalTime(appointmentHistoryData.createdOn)}",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 2, top: 3.0),
                          child: Row(
                            children: [
                              Container(
                                child: Text(
                                  "Patient Name: ${appointmentHistoryData.firstName} ${appointmentHistoryData.lastName}",
                                  softWrap: true,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              widget.isUpcoming == true &&
                                      userPatientInfo?.sourceReferenceId !=
                                          null &&
                                      userPatientInfo
                                          .sourceReferenceId.isNotEmpty
                                  ? GestureDetector(
                                      child: Image.asset(
                                          "assets/images/feedback.png",
                                          height: 25),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CampaignInAppWebViewScreen(
                                                        userName: appointmentHistoryData
                                                            .patientName,
                                                        departmentName:
                                                            appointmentHistoryData
                                                                .departmentName,
                                                        referenceID: userPatientInfo
                                                            .sourceReferenceId,
                                                        enableFeedback: widget
                                                            .enableFeedback)));
                                      })
                                  : Container()
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 2, top: 5.0),
                          child: Text(
                            "Appointment Status : ${appointmentHistoryData.appointmentStatus}",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 2, top: 5.0),
                          child: Text(
                            "Appointment Fee : ${appointmentHistoryData.freeConsultation == true ? "Free" : AppPreferences().defaultCurrencySymbol + "" + appointmentHistoryData.appointmentFee.toString() + " " + AppPreferences().defaultCurrencySuffix}\n",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        appointmentHistoryData.appointmentStatus ==
                                    "DECLINED" ||
                                appointmentHistoryData.appointmentStatus ==
                                    "CANCELLED"
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 2, top: 2.0),
                                child: Text(
                                  "Cancelled By : " + cancelledBy,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            : Container(),
                        appointmentHistoryData.appointmentStatus ==
                                    "DECLINED" ||
                                appointmentHistoryData.appointmentStatus ==
                                    "CANCELLED"
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 2, top: 2.0),
                                child: Text(
                                  "Reason : ${appointmentHistoryData.cancellationReason}\n",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            : Container(),

                        // Padding(
                        //   padding: const EdgeInsets.only(left: 8, top: 5.0),
                        //   child: Text(
                        //     "Appointment Cancellation Reason : ${appointmentHistoryData.comments}",
                        //     style: TextStyle(
                        //         color: Colors.black, fontWeight: FontWeight.w500),
                        //   ),
                        // ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // downloadRecordedFile() async {
  //   await http.get(
  //       "https://qa.servicedx.com/document/files/download?filePath=${widget.appointmentDetails.recordedFiles[0]}&bucketName=${s3BucketName}");
  // }

  Future<File> _downloadFile() async {
    Fluttertoast.showToast(msg: "Downloading the recorded video");
    var _response = await http.Client().send(http.Request(
        'GET',
        Uri.parse(
            "https://api-stvincent.servicedx.com/document/files/download?filePath=${widget.appointmentDetails.recordedFiles[0]}&bucketName=${s3BucketName}")));
    // print("");
    List<int> _bytes = [];
    var _received = 0;
    var total = _response.contentLength;
    if (_response.statusCode > 199 && _response.statusCode < 300) {
      _response.stream.listen((value) {
        setState(() {
          _bytes.addAll(value);
          _received += value.length;
          // if (((_received / total) * 100).toInt()>=100){
          _showNotification(true,
              percentage: ((_received / total) * 100).toInt());
          // }
          // Fluttertoast.showToast(
          //     msg:
          //         "Download percentage ${((_received / total) * 100).toInt()}%");
        });
      }).onDone(() async {
        var directory = await getApplicationDocumentsDirectory();
        var path = directory.path;
        final file = File(
            "${path + widget.appointmentDetails.bookingId + "-" + widget.appointmentDetails.appointmentTiming}.mp4");
        await file.writeAsBytes(_bytes);
        final result = await ImageGallerySaver.saveFile(file.path);
      });
    } else {
      _showNotification(false);
    }
  }

  Future<void> _showNotification(bool isSuccess, {int percentage}) async {
    final android = AndroidNotificationDetails(
        'channel id', 'channel name', 'channel description',
        enableVibration: false,
        ongoing: true,
        onlyAlertOnce: true,
        channelShowBadge: true,
        priority: Priority.max,
        importance: Importance.min);
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android: android, iOS: iOS);

    await flutterLocalNotificationsPlugin.show(
      0, // notification id
      isSuccess
          ? percentage < 100
              ? "Downloading"
              : 'Success'
          : 'Failure',
      isSuccess
          ? percentage < 100
              ? "Download percentage ${percentage}"
              : 'File has been downloaded successfully'
          : 'There was an error while downloading the file.',
      platform,
    );
  }

  Future<void> onJoin(String channelId, String bookingId, String patientName,
      Appointment appointment, bool isLaunch) async {
    // update input validation

    // await for camera and mic permissions before pushing video page
    if (userCategory != "DOCTOR" && supervisor != Constants.supervisorRole) {
      if (appointment.generatedToken.length == 0) {
        showCallAlert();
      } else {
        AppointmentsRepo repo = AppointmentsRepo();
        String token = await repo.getAppointmentsToken(bookingId, patientName);

        await _handleCameraAndMic();
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Constants.VIDEO_CALLING_MODERN
                ? VideoCallScreen(
                    channelName: bookingId, //"abc", //channelId,
                    token: token,
                    role: ClientRole.Broadcaster,
                    sessionRole: SessionRole.doctor,
                    appointment: appointment,
                    isLaunch: isLaunch,
                    referenceId: userPatientInfo.sourceReferenceId)
                : CallPage(
                    channelName: bookingId, //"abc", //channelId,
                    token: token,
                    role: ClientRole.Broadcaster,
                  ),
          ),
        );
      }
    } else {
      AppointmentsRepo repo = AppointmentsRepo();
      String token = await repo.getAppointmentsToken(bookingId, patientName);

      await _handleCameraAndMic();
      // push video page with given channel name
      print(
          "==============>  referrence id " + userDoctorInfo.sourceReferenceId);
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Constants.VIDEO_CALLING_MODERN
              ? VideoCallScreen(
                  channelName: bookingId, //"abc", //channelId,
                  token: token,
                  role: ClientRole.Broadcaster,
                  sessionRole: SessionRole.patient,
                  appointment: appointment,
                  isLaunch: isLaunch,
                  referenceId: userPatientInfo.sourceReferenceId,
                )
              : CallPage(
                  channelName: bookingId, //"abc", //channelId,
                  token: token,
                  role: ClientRole.Broadcaster,
                ),
        ),
      );
    }
  }

  showCallAlert() {
    showDialog(
        builder: (context) {
          return AlertDialog(
            title: Text("Alert"),
            content: Text("Please wait for the host to start this appointment"),
            actions: [
              FlatButton(
                child: Text("ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
        context: context);
  }

  showRescheduleAlert() {
    showDialog(
        builder: (context) {
          return AlertDialog(
            title: Text("Alert"),
            content: Text("Are you sure you want reschedule the appointment?"),
            actions: [
              FlatButton(
                child: Text("Yes"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await cancelAppointmentApiCall(
                      widget.appointmentDetails.bookingId, false);
                  await getUserInfo(navigate: true);
                },
              ),
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
        context: context);
  }

  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }

  getUserInfo({bool navigate = false, String doctorName}) async {
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
                doctorName ==
            null
        ? doctorData.doctorName
        : doctorName + "/lightWeight";

    try {
      final response =
          await helper.get(url, headers: header, isOAuthTokenNeeded: false);
      Map<String, dynamic> jsonData;
      if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
        print('User Info Response...........${response.body.toString()}');
        jsonData = jsonDecode(response.body);

        if (navigate != null && navigate == true) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => BookingAppointmentScreen(
                doctor: userDoctorInfo,
              ),
            ),
          );
        } else if (doctorName == null) {
          userDoctorInfo = UserAsDoctorInfo.fromJson(jsonData);

          print("=============> UserInfo  data  true or false " +
              userDoctorInfo.isConsultant.toString());
          setState(() {});
          // return userDoctorInfo;
        } else {
          setState(() {
            cancelledBy = UserAsDoctorInfo.fromJson(jsonData).userFullName;
          });
        }
      }
    } catch (e) {}
  }

  getPatientUserInfo() async {
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
        widget.appointmentDetails.patientName +
        "/lightWeight";

    try {
      final response =
          await helper.get(url, headers: header, isOAuthTokenNeeded: false);
      Map<String, dynamic> jsonData;
      if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
        print('User Info Response...........${response.body.toString()}');
        jsonData = jsonDecode(response.body);
        setState(() {
          userPatientInfo = UserAsDoctorInfo.fromJson(jsonData);
        });

        // return userPatientInfo;
      }
    } catch (e) {}
  }

  cancelAppointmentAlert(bookingId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Alert"),
          content: Text("Are you sure. You want to cancel the appointment?"),
          actions: [
            FlatButton(
              child: Text("Yes"),
              onPressed: () async {
                Navigator.pop(context);
                cancelAppointmentAlertForReason(bookingId);
              },
            ),
            FlatButton(
              child: Text("No"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  cancelAppointmentAlertForReason(bookingId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Please Enter Reason For Cancellation"),
          content: Container(
            width: MediaQuery.of(context).size.height * 0.8,
            child: TextFormField(
              maxLines: 4,
              controller: cancelReasonController,
              decoration: InputDecoration(
                  hintText: "Reason", border: OutlineInputBorder()),
            ),
          ),
          actions: [
            FlatButton(
              child: Text("Okay"),
              onPressed: () async {
                if (cancelReasonController.text.trim().length > 3) {
                  Navigator.pop(context);
                  cancelAppointmentApiCall(bookingId, true);
                } else {
                  Fluttertoast.showToast(
                    msg: "Reason must be at least 3 characters long",
                  );
                }
              },
            ),
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  cancelAppointmentApiCall(bookingId, navigateToHomeScreen) async {
    String loggedInUserName = await AppPreferences.getUsername();

    Map<String, String> header = {};
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => loggedInUserName);
    header.putIfAbsent("tenant", () => WebserviceConstants.tenant);
    var body = jsonEncode({
      "cancellationReason": cancelReasonController.text.isEmpty ||
              cancelReasonController.text == null
          ? "Rescheduled"
          : cancelReasonController.text
    });
    print(WebserviceConstants.baseAppointmentURL +
        "/v2/patient_appointment/${AppPreferences().deptmentName}/${userCategory == 'CONSULTANT' || userCategory == 'DOCTOR' ? widget.appointmentDetails.patientName : AppPreferences().username}/$bookingId/status?appointment_status=CANCELLED");
    http.Response res = await http.post(
        WebserviceConstants.baseAppointmentURL +
            "/v2/patient_appointment/${AppPreferences().deptmentName}/${userCategory == 'CONSULTANT' || userCategory == 'DOCTOR' ? widget.appointmentDetails.patientName : AppPreferences().username}/$bookingId/status?appointment_status=CANCELLED",
        headers: header,
        body: body);

    debugPrint("Cancellation URL ====> " + res.request.toString());
    debugPrint("Cancellation REQUEST BODY ====> " + body);
    debugPrint("Cancellation booking ID ====> " + bookingId);
    debugPrint("Cancellation response ====> " + res.body);
    cancelReasonController.clear();
    if (res.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Appointment cancelled successfully",
        gravity: ToastGravity.TOP,
      );
      if (widget.appointmentDetails.paymentDetail != null) {
        if (widget.appointmentDetails.paymentDetail.transactionId.length > 0) {
          refundCanceledAppointmentApiCall();
        }
      } else {
        Navigator.pop(context, true);
      }
    } else {
      Fluttertoast.showToast(
        msg: "Appointment cancellation failed",
        gravity: ToastGravity.TOP,
      );
    }
  }

  refundCanceledAppointmentApiCall() async {
    String loggedInUserName = await AppPreferences.getUsername();

    Map<String, String> header = {};
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => loggedInUserName);
    header.putIfAbsent("tenant", () => WebserviceConstants.tenant);
    print(AppPreferences().clientId);
    print(widget.appointmentDetails.departmentName);

    print(WebserviceConstants.baseURL +
        "/payments/refund?department_name=${widget.appointmentDetails.departmentName}&payment_id=${widget.appointmentDetails.paymentDetail.transactionId}&user_name=$loggedInUserName");
    http.Response res = await http.post(
        WebserviceConstants.baseURL +
            "/payments/refund?department_name=${widget.appointmentDetails.departmentName}&payment_id=${widget.appointmentDetails.paymentDetail.transactionId}&user_name=$loggedInUserName",
        headers: header);

    debugPrint("refund URL ====> " + res.request.toString());
    if (res.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Refund successful",
        gravity: ToastGravity.TOP,
      );
      Navigator.pop(context, true);
    } else {
      Fluttertoast.showToast(
        msg: "Refund failed",
        gravity: ToastGravity.TOP,
      );
    }
  }
}
