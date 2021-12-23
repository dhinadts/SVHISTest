import 'dart:convert';

import '../../event_schedul/doctor_schedule_info.dart';
import '../../login/api/api_calling.dart';
import '../../login/utils/custom_progress_dialog.dart';

import '../../login/colors/color_info.dart';
import '../../login/utils.dart';
import '../../repo/common_repository.dart';
import '../../ui/advertise/adWidget.dart';
import '../../ui/booking_appointment/models/doctor_info.dart';
import '../../ui_utils/app_colors.dart';
import '../../utils/app_preferences.dart';
import '../../widgets/coupon_code_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'appointment_continue_payment.dart';
import 'models/doctor_availability.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'models/appointment.dart';

class BookingAppointmentScreen extends StatefulWidget {
  final UserAsDoctorInfo doctor;
  final Map patientDetails;

  const BookingAppointmentScreen({Key key, this.doctor, this.patientDetails})
      : super(key: key);

  @override
  _BookingAppointmentScreenState createState() =>
      _BookingAppointmentScreenState();
}

enum Days { Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday }

class _BookingAppointmentScreenState extends State<BookingAppointmentScreen> {
  List<DoctorAvailability> doctorAvailableDates = [];
  List<DoctorAvailability> doctorAvailableDatesTemp = [];
  List<String> availableDays = List();
  int selectedDateIndex = 0;
  int selectedTimeIndex;
  String doctorAvailableDays = "";
  String couponCode = '';
  String STATUS_BLOCKED = "BLOCKED";
  String STATUS_AVAILABLE = "AVAILABLE";
  String STATUS_BOOKED = "BOOKED";

// bool _isAvailableLoad = true;
  bool _isLoading = false;
  String date;
  // var selectedDate;
  String headerText = "";
  Map<String, dynamic> jsonMapData = new Map();
  final _controller = ScrollController();
  String currencySymbol = "";
  String currencySuffix = "";
  DoctorAvailabilitySlot blockedSlot;
  DoctorAvailabilitySlot selectedSlot;

  String videoConsultFee = "";

  @override
  void initState() {
    super.initState();
    currencySymbol = AppPreferences().defaultCurrencySymbol;
    currencySuffix = AppPreferences().defaultCurrencySuffix;

    videoConsultFee = currencySymbol +
        (widget.doctor?.dInfo?.videoConsultationFee == null ||
                widget.doctor.dInfo.videoConsultationFee.toString().isEmpty
            ? '50'
            : widget.doctor.dInfo.videoConsultationFee.toString()) +
        " " +
        currencySuffix;

    // if (widget.doctor.availableDays.length > 0) {
    //   availableDays = widget.doctor.availableDays;
    if (widget.doctor?.dInfo?.availableDays != null) {
      widget.doctor.dInfo.availableDays.forEach((availableDay) {
        if (doctorAvailableDays == "") {
          doctorAvailableDays = availableDay;
        } else {
          doctorAvailableDays = doctorAvailableDays + "," + availableDay;
        }
      });
    }

    setState(() {
      _isLoading = true;
    });
    getDoctorsAvailabilityList();

    initializeAd();
  }

  getDoctorsAvailabilityList() async {
    WebserviceHelper helper = WebserviceHelper();
    String loggedInUserName = await AppPreferences.getUsername();
    String departmentName = await AppPreferences.getDeptName();
//https://qa.servicedx.com/isd/v2/doctor_availability/department/ISDHealth/doctor/SCDC10055
    String dName = widget.doctor.userName;

    Map<String, String> header = {};
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => loggedInUserName);
    header.putIfAbsent("tenant", () => WebserviceConstants.tenant);
    DateFormat format = DateFormat("MM/dd/yyyy");
    var startDate = format.format(DateTime.now());
    // print(startDate);
    String url = WebserviceConstants.baseAppointmentURL +
        "/v2/doctor_availability/department/$departmentName/doctor/$dName/consolidated?start_date=${startDate}";
    final response =
        await helper.get(url, headers: header, isOAuthTokenNeeded: false);

    debugPrint("response - ${response.body}");
    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      // checkForFreeConsultaion();
      List<dynamic> jsonData;
      print(jsonData);
      try {
        jsonData = jsonDecode(response.body);

        jsonMapData.putIfAbsent("doctorAvailabilityList", () => jsonData);
      } catch (_) {
        // print("" + _);
      }

      if (jsonData != null) {
// doctorFilteredList = doctorList;
        setState(() {
          _isLoading = false;
        });
        setState(() {
          setDoctorDate();
        });
      }
    }
// doctorFilteredList = doctorList;
    setState(() {
      _isLoading = false;
    });
  }

  _checkIfSelectedSlotIsAvailable() async {
    var exist = await checkAppointmentAlreadyExitsforSameTime();
    if (exist) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Alert"),
              content: Text(
                  // "You have another appointment for the same day and the same time. Is this appointment for you or someone else?"
                 "You have another appointment for the same day and the same time." ),
              actions: [
                // FlatButton(
                //   child: Text("Self"),
                //   onPressed: () {
                //     Fluttertoast.showToast(
                //         msg:
                //             "Cannot book another appointment for the same date and time until they cancel the other appointment.");
                //     Navigator.pop(context);
                //   },
                // ),
                // FlatButton(
                //   child: Text("For Another Person"),
                //   onPressed: () {
                //     Fluttertoast.showToast(
                //         msg: "Reference appointments are not allowed");
                //     Navigator.pop(context);
                //   },
                // )
                FlatButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    } else {
      List<DoctorAvailability> doctorAvailDates = [];
      List<DoctorAvailability> doctorAvailTempDates = [];
      CustomProgressLoader.showLoader(context);

      WebserviceHelper helper = WebserviceHelper();
      String loggedInUserName = await AppPreferences.getUsername();
      String departmentName = await AppPreferences.getDeptName();
//https://qa.servicedx.com/isd/v2/doctor_availability/department/ISDHealth/doctor/SCDC10055
      String dName = widget.doctor.userName;

      Map<String, String> header = {};
      header.putIfAbsent(WebserviceConstants.contentType,
          () => WebserviceConstants.applicationJson);
      header.putIfAbsent(WebserviceConstants.username, () => loggedInUserName);
      header.putIfAbsent("tenant", () => WebserviceConstants.tenant);
      DateFormat format = DateFormat("MM/dd/yyyy");
      var startDate = format.format(DateTime.now());
      // print(startDate);
      String url = WebserviceConstants.baseAppointmentURL +
          "/v2/doctor_availability/department/$departmentName/doctor/$dName/consolidated?start_date=$startDate";
      final response =
          await helper.get(url, headers: header, isOAuthTokenNeeded: false);

      debugPrint("response - ${response.body}");
      if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
        // checkForFreeConsultaion();
        Map<String, dynamic> jsonMapData1 = new Map();

        List<dynamic> jsonData;
        print(jsonData);
        try {
          jsonData = jsonDecode(response.body);

          jsonMapData1.putIfAbsent("doctorAvailabilityList1", () => jsonData);
        } catch (_) {
          // print("" + _);
        }
        doctorAvailDates = jsonMapData1["doctorAvailabilityList1"]
            .map<DoctorAvailability>((x) => DoctorAvailability.fromJson(x))
            .toList();

        for (var _selectedDateIndex = 0;
            _selectedDateIndex < doctorAvailDates.length;
            _selectedDateIndex++) {
          String date = doctorAvailDates[_selectedDateIndex].availableDate;
          DateFormat format = DateFormat("MM/dd/yyyy");
          DateTime dateNow = format.parse(format.format(DateTime.now()));
          DateTime dateCheck = format.parse(date);
          if (dateCheck.difference(dateNow).inDays == 0 ||
              dateCheck.isAfter(dateNow)) {
            DoctorAvailability obj = doctorAvailDates[_selectedDateIndex];
            doctorAvailTempDates.add(obj);
          }
        }
        if (doctorAvailTempDates.length > 0) {
          doctorAvailDates.removeRange(0, doctorAvailDates.length);
          doctorAvailDates = doctorAvailTempDates;
        }
        //check if selected slot is available or not.
        // if available , call set status as BOOKED else show popup
        DoctorAvailabilitySlot s =
            doctorAvailDates[selectedDateIndex].slots[selectedTimeIndex];

        CustomProgressLoader.cancelLoader(context);

        if (selectedSlot.id == s.id) {
          if (s.availabilityStatus.toUpperCase() == STATUS_AVAILABLE) {
            setSlotAsBookedAPICall(s, STATUS_BLOCKED);
          } else {
            //show Popup that  already booked
            Utils.toasterMessage("Slot is booked");
          }
        }
      } //
    }
  }

  setSlotAsBookedAPICall(DoctorAvailabilitySlot slot, String status) async {
    CustomProgressLoader.showLoader(context);
    String slotId = slot.id;
    var response;
    String url = WebserviceConstants.baseAppointmentURL +
        "/v2/doctor_availability/id/$slotId";

    String departmentName = await AppPreferences.getDeptName();

    DoctorScheduleInfo doctorScheduleInfo = new DoctorScheduleInfo();
    doctorScheduleInfo.active = "true";
    doctorScheduleInfo.availabilityStatus = "AVAILABLE";
    doctorScheduleInfo.availableDate =
        doctorAvailableDates[selectedDateIndex].availableDate;
    doctorScheduleInfo.departmentName = departmentName;
    doctorScheduleInfo.doctorName = widget.doctor.userName;
    doctorScheduleInfo.type = "VIDEO";
    doctorScheduleInfo.startTime = slot.startTime;
    doctorScheduleInfo.endTime = slot.endTime;
    doctorScheduleInfo.id = slot.id;
    doctorScheduleInfo.slotStatus = status;
    response = await APICalling.apiPut(url, json.encode(doctorScheduleInfo));
//id:"07b21b2d-45ba-4457-8ca6-49af8dea8c4a"

    CustomProgressLoader.cancelLoader(context);
    if (response == 204 || response == 200 || response == 201) {
      // Utils.toasterMessage(UPDATE_SUCCESS_MESSAGE);
      if (status != STATUS_AVAILABLE) {
        blockedSlot = slot;
        _navigateToContinuePaymentScreen();
      } else {
        Navigator.of(context).pop();
      }
    } else {
      if (response == 500) {
        // Utils.toasterMessage(UPDATE_FAILED_MESSAGE);
      }
    }
  }
/*   checkForFreeConsultaion() async {
    //Consultation is free for consultants, need to check if its a doctor
    if (widget.doctor.isConsultant == true) {
      videoConsultFee = "FREE";
      return;
    }
//     WebserviceHelper helper = WebserviceHelper();
//     String loggedInUserName = await AppPreferences.getUsername();
//     String departmentName = await AppPreferences.getDeptName();
// //https://qa.servicedx.com/isd/v2/doctor_availability/department/ISDHealth/doctor/SCDC10055

//     Map<String, String> header = {};
//     header.putIfAbsent(WebserviceConstants.contentType,
//         () => WebserviceConstants.applicationJson);
//     header.putIfAbsent(WebserviceConstants.username, () => loggedInUserName);
//     header.putIfAbsent("tenant", () => WebserviceConstants.tenant);
//     String url = WebserviceConstants.baseAppointmentURL +
//         "/v2/patient_appointment/" +
//         departmentName +
//         "/" +
//         loggedInUserName +
//         "/status";
//     // "/v2/doctor_availability/department/$departmentName/doctor/$dName/consolidated";
//     final response =
//         await helper.get(url, headers: header, isOAuthTokenNeeded: false);

//     // debugPrint("response - ${response.toString()}");
//     if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
//       dynamic jsonData;
//       try {
//         jsonData = jsonDecode(response.body);
//         if (jsonData == true) {
//           videoConsultFee = "FREE";
//         }
//       } catch (_) {
//         // print("" + _);
//       }

//       if (jsonData != null) {
// // doctorFilteredList = doctorList;
//         setState(() {
//           _isLoading = false;
//         });
//         setState(() {
//           setDoctorDate();
//         });
//       }
//     }
// doctorFilteredList = doctorList;
    setState(() {
      _isLoading = false;
    });
  } */

  DateTime convertUTCToLocalDate(String serverTime) {
    var dateTimeArray = serverTime.split("T");
    var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss")
        .parse(dateTimeArray[0] + " " + dateTimeArray[1], true);
    var dateLocal = dateTime.toLocal();
    var finalString = DateFormat("yyyy-MM-dd hh:mm:ss")
        .format(DateTime.parse(dateLocal.toString().replaceFirst(".000", "")));
    DateTime finalDate =
        new DateFormat("yyyy-MM-dd hh:mm:ss").parse(finalString.toString());
    return finalDate;
  }

// getDateListBetweenTwoDates() {
// if (doctorAvailabilityDetails.fromDate.length > 0 &&
// doctorAvailabilityDetails.toDate.length > 0) {
// DateTime startDate =
// convertUTCToLocalDate(doctorAvailabilityDetails.fromDate);
// DateTime endDate =
// convertUTCToLocalDate(doctorAvailabilityDetails.toDate);

// dates = getDaysInBeteween(startDate, endDate);
// print(dates);
// }
// }

// List<String> getDaysInBeteween(DateTime startDate, DateTime endDate) {
// List<String> days = [];
// var formatter = new DateFormat('EEE, d MMM');
// var formatter2 = new DateFormat('yyyy-MM-dd');

// for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
// String day = formatter.format(DateTime(
// startDate.year,
// startDate.month,
// // In Dart you can set more than. 30 days, DateTime will do the trick
// startDate.day + i));
// String dateStr = formatter2.format(DateTime(
// startDate.year,
// startDate.month,
// // In Dart you can set more than. 30 days, DateTime will do the trick
// startDate.day + i));
// //add those days in which doctor is available
// if (doctorAvailableDays
// .toLowerCase()
// .contains(day.split(',')[0].toLowerCase())) {
// days.add(day);
// dateTimeList.add(dateStr);
// }
// }
// return days;
// }

// List<String> getDaysInBeteweenForAPIInUTC(
// DateTime startDate, DateTime endDate) {
// List<String> days = [];
// var formatter = new DateFormat('yyyy-MM-dd');
// for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
// String day = formatter.format(DateTime(
// startDate.year,
// startDate.month,
// // In Dart you can set more than. 30 days, DateTime will do the trick
// startDate.day + i));
// days.add(day);
// }
// return days;
// }
  Future<bool> _willPopCallback() async {
    //check if any slot is marked as blocked, mark as available
    if (blockedSlot == null) {
    } else {
      setSlotAsBookedAPICall(blockedSlot, STATUS_AVAILABLE);
    }

    return true; // return true if the route to be popped
  }

  @override
  Widget build(BuildContext context) {
    //print("===================>  ${widget.patientName}");
    return WillPopScope(
        onWillPop: _willPopCallback,
        child: Scaffold(
            appBar: AppBar(
              brightness: Brightness.light,
              backgroundColor: AppColors.primaryColor,
              title: Text(
                "Appointment Schedule",
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
            ),
            body: _isLoading
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: 60,
                          width: 60,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width * .95,
                                  height:
                                      MediaQuery.of(context).size.height * .17,
                                  child: doctorDetails(),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * .95,
                                  height:
                                      MediaQuery.of(context).size.height * .54,
                                  child: doctorAvailableDates.length > 0
                                      ? doctorTimeSlot()
                                      : Center(child: Text('No Slots')),
                                ),
                                // buildPromoCodeText(),
                                InkWell(
                                  onTap: () async {
                                    if (selectedTimeIndex == null) {
                                      return Utils.toasterMessage(
                                          "Please select a Slot");
                                    } else {
                                      _checkIfSelectedSlotIsAvailable();
                                      // selectedSlot =
                                    }
                                  },
                                  child: Container(
                                    color: doctorAvailableDates.length == 0
                                        ? Colors.grey
                                        : Color(ColorInfo.APP_BLUE),
                                    width:
                                        MediaQuery.of(context).size.width * .95,
                                    height: MediaQuery.of(context).size.height *
                                        .08,
                                    child: Center(
                                        child: widget.doctor.userCategory
                                                    .toLowerCase() ==
                                                "Consultant".toLowerCase()
                                            ? Text(
                                                "SCHEDULE AN APPOINTMENT" +
                                                    "\n (" +
                                                    "Consultation Fee:  " +
                                                    "FREE" +
                                                    ")",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            : Text(
                                                "SCHEDULE AN APPOINTMENT" +
                                                    "\n (" +
                                                    "Consultation Fee:  " +
                                                    videoConsultFee +
                                                    ")",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                      ),

                      /// Show Banner Ad
                      getSivisoftAdWidget(),
                    ],
                  )));
  }

  _scheduleAppointmentBtnTapped() {
    setState(() {
      _isLoading = false;
    });
    if (selectedTimeIndex == null) {
      return Utils.toasterMessage("Please select a Slot");
    }

    _checkIfSelectedSlotIsAvailable();

    // if (doctorAvailableDates.length == 0) {
    //   Utils.toasterMessage("No Slots");
    // } else if (slotFromObject(
    //         doctorAvailableDates[selectedDateIndex].slots[selectedTimeIndex],
    //         selectedDateIndex) ==
    //     "Not Available") {
    //   Utils.toasterMessage("Slot booked");
    // } else {
    //   if (doctorAvailableDates[selectedDateIndex]
    //           .slots[selectedTimeIndex]
    //           .availabilityStatus
    //           .toLowerCase() ==
    //       "booked") {
    //     Utils.toasterMessage("Slot booked");
    //   } else {
    // ZZ
    // }
    // }
  }

  checkAppointmentAlreadyExitsforSameTime() async {
    bool appointmentexits = false;
    var startDate = doctorAvailableDates[selectedDateIndex].availableDate;
    var startTime = doctorAvailableDates[selectedDateIndex]
        .slots[selectedTimeIndex]
        .startTime;
    var response = await http.get(WebserviceConstants.baseAppointmentURL +
        "/v2/patient_appointment/${AppPreferences().deptmentName}/${AppPreferences().username}?start_date=${startDate}&end_date=${startDate}");
    // List json.decode(response.body));
    if (response.statusCode > 199 && response.statusCode < 300) {
      List res = json.decode(response.body);
      List<Appointment> appointmentList =
          res.map((e) => Appointment.fromJson(e)).toList();
      appointmentList = appointmentList
          .where((element) => element.requestDate.contains(startDate))
          .toList();
      appointmentList.forEach((element) {
        List date = startDate.split("/");
        startDate =
            date[2] + "-" + date[0] + "-" + date[1] + "T" + startTime;
        var endDate = date[2] +
            "-" +
            date[0] +
            "-" +
            date[1] +
            " " +
            doctorAvailableDates[selectedDateIndex]
                .slots[selectedTimeIndex]
                .endTime;
        var apptStartTime = DateTime.parse(startDate).microsecondsSinceEpoch;
        var apptEndTime = DateTime.parse(endDate).microsecondsSinceEpoch;
        var appointmentElementStartTime = DateTime.parse(
                element.appointmentTiming + " " + element.appointmentStartTime)
            .microsecondsSinceEpoch;
        var appointmentElementEndTime = DateTime.parse(
                element.appointmentTiming + " " + element.appointmentEndTime)
            .microsecondsSinceEpoch;

        if ((apptStartTime <= appointmentElementStartTime &&
                apptEndTime <= appointmentElementEndTime &&
                (apptEndTime - apptStartTime) + apptStartTime >
                    appointmentElementStartTime) ||
            (apptStartTime >= appointmentElementStartTime &&
                apptEndTime <= appointmentElementEndTime) ||
            (apptStartTime <= appointmentElementStartTime &&
                apptEndTime >= appointmentElementEndTime) ||
            (apptStartTime >= appointmentElementStartTime &&
                apptEndTime >= appointmentElementEndTime &&
                (apptStartTime < appointmentElementEndTime))) {
          appointmentexits = true;
        }
      });

      return appointmentexits;
    } else {
      return appointmentexits;
    }
  }

  _navigateToContinuePaymentScreen() async {
    if (widget.doctor.userCategory.toLowerCase() ==
        "Consultant".toLowerCase()) {
      setState(() {
        videoConsultFee = "FREE";
      });

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => AppointmentContinuePayment(
            doctor: widget.doctor,
            patientDetails: widget.patientDetails,
            date: doctorAvailableDates[selectedDateIndex].availableDate,
            slot: doctorAvailableDates[selectedDateIndex]
                .slots[selectedTimeIndex],
            isFreeConsultation: videoConsultFee == "FREE" ? true : false,
            couponCode: couponCode,
          ),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => AppointmentContinuePayment(
            doctor: widget.doctor,
            date: doctorAvailableDates[selectedDateIndex].availableDate,
            patientDetails: widget.patientDetails,
            slot: doctorAvailableDates[selectedDateIndex]
                .slots[selectedTimeIndex],
            isFreeConsultation: videoConsultFee == "FREE" ? true : false,
            couponCode: couponCode,
          ),
        ),
      );
    }
  }

  Widget doctorDetails() {
    return Card(
//backgroundColor: Colors.transparent,
//elevation: 8.0,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * .25,
// height: MediaQuery.of(context).size.height * .25,
//color: Colors.red,
                child: widget.doctor.downloadProfileURL.length == 0
                    ? Image.asset(
                        'assets/images/doctor_image.png',
                        width: 100.0,
                        height: 100.0,
                      )
                    : Center(
                        child: CircleAvatar(
                          radius: 60.0,
                          backgroundColor: Colors.grey,
                          //backgroundImage: MemoryImage(base64.decode(widget.doctor.profileImage)
                          backgroundImage:
                              NetworkImage(widget.doctor.downloadProfileURL),
                        ),
                      )),
            SizedBox(
              width: 8.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width * .60,
//color: Colors.blue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
// "${widget.doctor.doctorName}",
                          widget.doctor.userFullName,
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16.0),
                        ),
                      ),
//
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.doctor.specialities.join(', '),
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 12.0),
                          )),
                      Container(
                          alignment: Alignment.centerLeft,
                          child: RatingBarIndicator(
                            rating: widget.doctor.rating,
                            itemCount: 5,
                            itemSize: 10.0,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                          )),
                    ],
                  ),
                  // Container(
                  //     child: Row(
                  //   children: <Widget>[
                  //     // Container(child: Text("Available : ")),
                  //     // Container(
                  //     //   child: Flexible(
                  //     //     child: Text(
                  //     //       "$doctorAvailableDays",
                  //     //       style: TextStyle(
                  //     //           color: Colors.green,
                  //     //           fontWeight: FontWeight.w700,
                  //     //           fontSize: 12.0),
                  //     //     ),
                  //     //   ),
                  //     // )
                  //   ],
                  // )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPromoCodeText() {
    return TextButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (_) {
              return CouponCodeDialog(couponCode: couponCode);
            }).then((value) {
          if (value != null) {
            couponCode = value;
          }
        });
      },
      child: Text(
        couponCode.length > 0
            ? "Show applied coupon"
            : "Do you have a coupon code?",
        style: new TextStyle(
            color: Colors.blue, decoration: TextDecoration.underline),
      ),
    );
// return InkWell(
// onTap: () {},
// child: Text(
// "Do you have a coupon code?",
// style: new TextStyle(
// color: Colors.blue, decoration: TextDecoration.underline),
// ),
// );
  }

  void _goToElement() {
    _controller.animateTo(
        (MediaQuery.of(context).size.width * .95 * selectedDateIndex),
        // 100 is the height of container and index of 6th element is 5
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn);
  }

  Widget doctorTimeSlot() {
    // doctorAvailableDates[0].slots[0]
    return Card(
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(15.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Container(
          //   alignment: Alignment.centerLeft,
          //   height: 40.0,
          //   child: Padding(
          //     padding: const EdgeInsets.all(1.0),
          //     child: Text(
          //       "SCHEDULE",
          //       style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
          //     ),
          //   ),
          // ),
          doctorAvailableDates.length < 1
              ? Container()
              : Container(
                  height: MediaQuery.of(context).size.height * .08,
                  child: ListView.builder(
                    //controller: _controller,
                    scrollDirection: Axis.horizontal,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: availableDatesArr().length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
// if (_isAvailableLoad) {
                            selectedDateIndex = index;
// }
// _isAvailableLoad = false;
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * .95,
                          height: MediaQuery.of(context).size.height * .08,
                          decoration: BoxDecoration(
                            color: selectedDateIndex == index
                                ? Colors.blue[800]
                                : Colors.blue[300],
                            border: Border.all(
                              color: Colors.grey[300],
                            ),
                          ),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                  margin: const EdgeInsets.only(
                                      left: 1.0, right: 1.0),
                                  child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (selectedDateIndex != 0 &&
                                              selectedDateIndex <
                                                  doctorAvailableDates.length) {
                                            selectedDateIndex =
                                                selectedDateIndex - 1;
                                            setHeaderText(selectedDateIndex);
                                            selectedTimeIndex = null;
                                          }
                                          // _goToElement();
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: Center(
                                          child: IconButton(
                                              icon: Icon(
                                                  Icons.keyboard_arrow_left,
                                                  size: 25.0,
                                                  color: Color(
                                                      ColorInfo.APP_BLUE))),
                                        ),
                                      )

                                      // Image.asset(
                                      //   "assets/images/left_arrow.png",
                                      //   width: 13,
                                      //   height: 20,
                                      // )
                                      )),
                              Center(
                                child: Container(
                                  child: new Text(
// availableDatesArr()[index]
                                    headerText,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Montserrat'),
                                  ),
                                ),
                              ),
                              Container(
                                  child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (selectedDateIndex !=
                                                  doctorAvailableDates.length -
                                                      1 &&
                                              selectedDateIndex <
                                                  doctorAvailableDates.length) {
                                            selectedDateIndex =
                                                selectedDateIndex + 1;
                                            setHeaderText(selectedDateIndex);
                                            selectedTimeIndex = null;
                                          }
                                          //_goToElement();
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: Center(
                                          child: IconButton(
                                              icon: Icon(
                                                  Icons.keyboard_arrow_right,
                                                  size: 25.0,
                                                  color: Color(
                                                      ColorInfo.APP_BLUE))),
                                        ),
                                      )
                                      // Image.asset(
                                      //     "assets/images/right_arrow.png",
                                      //     width: 13,
                                      //     height: 20)
                                      )),
                            ],
                          ),
// ),
                        ),
                      );
                    },
                  ),
                ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            height: MediaQuery.of(context).size.height * .40,
            color: Colors.white,

// height: MediaQuery.of(context).size.height * .08,

            child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: doctorAvailableDates[selectedDateIndex].slots.length == 0
                    //     ||
                    // !doctorAvailableDays.contains(getDay(selectedDateIndex))
                    ? Text('No slot available')
                    : doctorTimeSlotByDay()),
          ),
        ],
      ),
    );
  }

  bool isSlotAvailable(int index) {
    if (doctorAvailableDates[selectedDateIndex]
                .slots[index]
                .availabilityStatus
                .toUpperCase() ==
            STATUS_AVAILABLE &&
        (doctorAvailableDates[selectedDateIndex]
                    .slots[index]
                    .slotStatus
                    .toUpperCase() !=
                STATUS_BLOCKED ||
            doctorAvailableDates[selectedDateIndex]
                    .slots[index]
                    .slotStatus
                    .toUpperCase() !=
                STATUS_BOOKED)) {
      return true;
    }
    return false;
  }

//Slots Widget
  Widget doctorTimeSlotByDay() {
    List<Widget> datesList = [];
    for (var index = 0;
        index < doctorAvailableDates[selectedDateIndex].slots.length;
        index++) {
      datesList.add(
          "${slotFromObject(doctorAvailableDates[selectedDateIndex].slots[index], selectedDateIndex)}" ==
                  "Not Available"
              ? SizedBox()
              : isSlotAvailable(index)
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          selectedTimeIndex = index;
                          selectedSlot = doctorAvailableDates[selectedDateIndex]
                              .slots[index];
                          // _checkIfSelectedSlotIsAvailable();

                          // if (doctorAvailableDates[selectedDateIndex]
                          //         .slots[index]
                          //         .availabilityStatus
                          //         .toLowerCase() ==
                          //     "available") {
                          //   selectedTimeIndex = index;
                          //   selectedSlot =
                          //       doctorAvailableDates[selectedDateIndex]
                          //           .slots[index];
                          //           _checkIfSelectedSlotIsAvailable();
                          // } else {
                          //   Utils.toasterMessage("Slot booked");
                          // }
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3.5,
                        height: MediaQuery.of(context).size.height * .08,
                        margin: EdgeInsets.only(right: 8, bottom: 10),
                        decoration: BoxDecoration(
                            color: doctorAvailableDates[selectedDateIndex]
                                        .slots[index]
                                        .availabilityStatus ==
                                    "BOOKED"
                                ? Colors.blue[800]
                                //: selectedTimeIndex == index ? Colors.green
                                : Colors.white,
                            border: Border.all(
                              width: selectedTimeIndex == index
                                  ? doctorAvailableDates[selectedDateIndex]
                                              .slots[index]
                                              .availabilityStatus ==
                                          "BOOKED"
                                      ? 1
                                      : 3
                                  : 1,
                              color: selectedTimeIndex == index
                                  ? doctorAvailableDates[selectedDateIndex]
                                              .slots[index]
                                              .availabilityStatus ==
                                          "BOOKED"
                                      ? Colors.transparent
                                      : Colors.green
                                  : Colors.grey[700],
                            ),
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                            child: doctorAvailableDates[selectedDateIndex]
                                        .slots[index]
                                        .availabilityStatus ==
                                    "BOOKED"
                                ? new Text(
                                    "${slotFromObject(doctorAvailableDates[selectedDateIndex].slots[index], selectedDateIndex)}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white))
                                : new Text(
                                    "${slotFromObject(doctorAvailableDates[selectedDateIndex].slots[index], selectedDateIndex)}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            //selectedTimeIndex == index ? Colors.white :
                                            Colors.blue[600]))),
                      ))
                  : SizedBox());
    }
    var list = doctorAvailableDates[selectedDateIndex].slots.where((e) {
      return e.availabilityStatus == "BOOKED" ||
          e.availabilityStatus == "CONFIRMED" ||
          e.slotStatus == STATUS_BLOCKED ||
          slotFromObject(e, selectedDateIndex) == "Not Available";
    });
    if (list.length == doctorAvailableDates[selectedDateIndex].slots.length) {
      datesList.add(Center(child: Text("No Slot Avaliable")));
    }
    //get the number of Inkwell widget and as per that return the widgets

    var inkwellCount = datesList.map((e) => e is InkWell);
    var trueValues = inkwellCount.toList().where((i) => i == true).toList();

    return trueValues.length < 3
        ? Wrap(
            children: datesList,
            crossAxisAlignment: WrapCrossAlignment.start,
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.start,
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                Wrap(
                  children: datesList,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.start,
                ),
              ],
            ),
          );
    /*return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2,
        ),
        physics: NeverScrollableScrollPhysics(),
        itemCount: doctorAvailableDates[selectedDateIndex].slots.length,
        itemBuilder: (context, index) {
          return "${slotFromObject(doctorAvailableDates[selectedDateIndex].slots[index], selectedDateIndex)}" ==
              "Not Available"
              ? Container()
          : doctorAvailableDates[selectedDateIndex]
              .slots[index]
              .availabilityStatus ==
          "BOOKED"
          ? Container()
              : InkWell(
              onTap: () {
                setState(() {
                  if (doctorAvailableDates[selectedDateIndex]
                          .slots[index]
                          .availabilityStatus
                          .toLowerCase() ==
                      "available") {
                    selectedTimeIndex = index;
                  } else {
                    Utils.toasterMessage("Slot booked");
                  }
                });
              },
              child:
                  // Container(
                  //     height: MediaQuery.of(context).size.height * .08,
                  //     decoration: BoxDecoration(
                  //         color: Colors.grey[600],
                  //         border: Border.all(
                  //           width: 1,
                  //           color: Colors.grey[100],
                  //         ),
                  //         borderRadius: BorderRadius.circular(5)),
                  //     child: Center(
                  //         child: "${slotFromObject(doctorAvailableDates[selectedDateIndex].slots[index], selectedDateIndex)}" ==
                  //                 "Not Available"
                  //             ? new Text("Not Available",
                  //                 textAlign: TextAlign.center,
                  //                 style: TextStyle(
                  //                     fontSize: 10, color: Colors.white))
                  //             : new Text(
                  //                 "${slotFromObject(doctorAvailableDates[selectedDateIndex].slots[index], selectedDateIndex)}",
                  //                 textAlign: TextAlign.center,
                  //                 style: TextStyle(
                  //                     fontSize: 10, color: Colors.white))),
                  //   )
                   Container(
                          height: MediaQuery.of(context).size.height * .08,
                          decoration: BoxDecoration(
                              color: doctorAvailableDates[selectedDateIndex]
                                          .slots[index]
                                          .availabilityStatus ==
                                      "BOOKED"
                                  ? Colors.blue[800]
                                  : selectedTimeIndex == index ? Colors.green : Colors.white,
                              border: Border.all(
                                width: selectedTimeIndex == index
                                    ? doctorAvailableDates[selectedDateIndex]
                                                .slots[index]
                                                .availabilityStatus ==
                                            "BOOKED"
                                        ? 1
                                        : 3
                                    : 1,
                                color: selectedTimeIndex == index
                                    ? doctorAvailableDates[selectedDateIndex]
                                                .slots[index]
                                                .availabilityStatus ==
                                            "BOOKED"
                                        ? Colors.transparent
                                        : Colors.green
                                    : Colors.grey[700],
                              ),
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                              child: doctorAvailableDates[selectedDateIndex]
                                          .slots[index]
                                          .availabilityStatus ==
                                      "BOOKED"
                                  ? new Text(
                                      "${slotFromObject(doctorAvailableDates[selectedDateIndex].slots[index], selectedDateIndex)}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white))
                                  : new Text(
                                      "${slotFromObject(doctorAvailableDates[selectedDateIndex].slots[index], selectedDateIndex)}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: selectedTimeIndex == index ? Colors.white : Colors.blue[600]))),
                        ));
        });*/
  }

  String slotFromObject(DoctorAvailabilitySlot slot, int _selectedDateIndex) {
    String date = doctorAvailableDates[_selectedDateIndex].availableDate;
    DateFormat format = DateFormat("MM/dd/yyyy");
    DateTime dateNow = format.parse(format.format(DateTime.now()));
    DateTime dateCheck = format.parse(date);
    DateFormat formatTime = DateFormat("HH:mm");
    DateTime start = formatTime.parse(slot.startTime);
    DateTime end = formatTime.parse(slot.endTime);
    DateTime current = DateTime.now();
    DateTime selEndDate =
        new DateFormat("MM/dd/yyyy HH:mm").parse(date + " " + slot.endTime);

    print(selEndDate.toString());
    print(current.toString());
    if (dateCheck.difference(dateNow).inDays == 0) {
      if (selEndDate.isAfter(current)) {
        //(end.isAfter(now)) {
        String value = DateFormat('h:mm a').format(start) +
            " - " +
            DateFormat('h:mm a').format(end);
        return value;
      } else {
        return "Not Available";
      }
    } else {
      String value = DateFormat('h:mm a').format(start) +
          " - " +
          DateFormat('h:mm a').format(end);
      return value;
    }
  }

  String slotFromObject1(DoctorAvailabilitySlot slot, int _selectedDateIndex) {
    String date = doctorAvailableDates[_selectedDateIndex].availableDate;
    DateFormat format = DateFormat("MM/dd/yyyy");
    DateTime dateNow = format.parse(format.format(DateTime.now()));
    DateTime dateCheck = format.parse(date);
    DateFormat formatTime = DateFormat("HH:mm");
    DateTime now = formatTime.parse(formatTime.format(DateTime.now()));
    DateTime start = formatTime.parse(slot.startTime);
    DateTime end = formatTime.parse(slot.endTime);
    if (dateCheck.difference(dateNow).inDays == 0) {
      if (now.hour + 1 == start.hour) {
        return "Not Available";
      } else if (end.isAfter(now)) {
        String value = DateFormat('h:mm a').format(start) +
            " - " +
            DateFormat('h:mm a').format(end);
        return value;
      } else {
        return "Not Available";
      }
    } else {
      String value = DateFormat('h:mm a').format(start) +
          " - " +
          DateFormat('h:mm a').format(end);
      return value;
    }
  }

  void setDoctorDate() {
    doctorAvailableDates = jsonMapData["doctorAvailabilityList"]
        .map<DoctorAvailability>((x) => DoctorAvailability.fromJson(x))
        .toList();

    for (var _selectedDateIndex = 0;
        _selectedDateIndex < doctorAvailableDates.length;
        _selectedDateIndex++) {
      String date = doctorAvailableDates[_selectedDateIndex].availableDate;
      DateFormat format = DateFormat("MM/dd/yyyy");
      DateTime dateNow = format.parse(format.format(DateTime.now()));
      DateTime dateCheck = format.parse(date);
      if (dateCheck.difference(dateNow).inDays == 0 ||
          dateCheck.isAfter(dateNow)) {
        DoctorAvailability obj = doctorAvailableDates[_selectedDateIndex];
        doctorAvailableDatesTemp.add(obj);
      }
    }
    if (doctorAvailableDatesTemp.length > 0) {
      doctorAvailableDates.removeRange(0, doctorAvailableDates.length);

      doctorAvailableDates = doctorAvailableDatesTemp;
    }
    if (doctorAvailableDates.length > 0) {
      setHeaderText(0);
    }

/* if(doctorAvailableDatesTemp!=null && doctorAvailableDatesTemp.length == 0){
doctorAvailableDates = null;
}*/
  }

  void setHeaderText(int _selectedDateIndex) {
    String date = doctorAvailableDates[_selectedDateIndex].availableDate;
    String value = "";
    DateFormat format = DateFormat("MM/dd/yyyy");
    DateTime dateNow = format.parse(format.format(DateTime.now()));
    DateTime dateCheck = format.parse(date);
    DateFormat formatDisplay = DateFormat("EEE, MMM d, ''yy");
    String day = formatDisplay.format(dateCheck);
    if (dateCheck.difference(dateNow).inDays == 0) {
      value = "Today " + day;
    } else if (dateCheck.difference(dateNow).inDays == 1) {
      value = "Tomorrow " + day;
    } else {
      value = day;
    }
// setLocalDateFormat(date);
    setState(() {
      headerText = value;
    });
  }

  String getDay(int _selectedDateIndex) {
    String date = doctorAvailableDates[_selectedDateIndex].availableDate;
    DateFormat format = DateFormat("MM/dd/yyyy");
    DateTime dateCheck = format.parse(date);
    DateFormat formatDisplay = DateFormat("EEEE");
    String day = formatDisplay.format(dateCheck);
    return day;
  }

  List<String> availableDatesArr() {
    List<String> tempArray = [];
    for (int i = 0; i < doctorAvailableDates.length; i++) {
      String date = doctorAvailableDates[i].availableDate;
      String value = "";
      DateFormat format = DateFormat("MM/dd/yyyy");
      DateTime dateNow = format.parse(format.format(DateTime.now()));
      DateTime dateCheck = format.parse(date);
      DateFormat formatDisplay = DateFormat("EEE, MMM d, ''yy");
      String day = formatDisplay.format(dateCheck);
      if (dateCheck.difference(dateNow).inDays == 0) {
        value = "Today " + day;
      } else if (dateCheck.difference(dateNow).inDays == 1) {
        value = "Tomorrow " + day;
      } else {
        value = day;
      }
// setLocalDateFormat(date);
      tempArray.add(value);
    }

    return tempArray;
  }

  // List<String> getTimeSlotListFor() {
  //   if (dates.length == 0) {
  //     return [];
  //   }
  //   String selectedDayFromDates = dates[selectedDateIndex].split(",")[0];
  //   switch (selectedDayFromDates.toLowerCase()) {
  //     case "sun":
  //       return doctorAvailabilityDetails.availabilityCalendar.sunday;
  //     case "mon":
  //       return doctorAvailabilityDetails.availabilityCalendar.monday;
  //     case "tue":
  //       return doctorAvailabilityDetails.availabilityCalendar.tuesday;
  //     case "wed":
  //       return doctorAvailabilityDetails.availabilityCalendar.wednesday;
  //     case "thu":
  //       return doctorAvailabilityDetails.availabilityCalendar.thursday;
  //     case "fri":
  //       return doctorAvailabilityDetails.availabilityCalendar.friday;
  //     case "sat":
  //       return doctorAvailabilityDetails.availabilityCalendar.saturday;
  //     default:
  //       return [];
  //   }
  // }

  // String getAppointmentTimeInUTC() {
  //   var bookingDate = dateTimeList[selectedDateIndex];
  //   var bookingTime = getTimeSlotListFor()[selectedTimeIndex];

  //   DateTime bookingTempDate =
  //       DateFormat("yyyy-MM-dd hh:mma").parse(bookingDate + " " + bookingTime);
  //   // var dateUtc = bookingTempDate.toUtc();
  //   var strToDateTime = DateTime.parse(bookingTempDate.toString());
  //   String appoint = DateFormat("yyyy-MM-dd HH:mm:ss").format(strToDateTime);
  //   String inUTCTime =
  //       appoint.split(' ')[0] + 'T' + appoint.split(' ')[1] + '.000Z';
  //   return inUTCTime;
  // }

  // apiCall() async {
  //   if (getTimeSlotListFor().length == 0) {
  //     Utils.toasterMessage("Please select slot.");
  //     return;
  //   }
  //   CustomProgressLoader.showLoader(context);
  //   String patientFullName = await AppPreferences.getFullName();
  //   String email = await AppPreferences.getEmail();
  //   String appointmentTime = getAppointmentTimeInUTC();
  //   Map data = {
  //     "active": true,
  //     "age": 0,
  //     "appointmentTime": appointmentTime,
  //     "bookingId": "",
  //     "comments": "",
  //     "complete": true,
  //     "createdBy": patientFullName,
  //     "createdOn": getAppointmentTimeInUTC(),
  //     "departmentName": widget.doctor.speciality.join(', '),
  //     "doctorId": widget.doctor.doctorId,
  //     "doctorName": widget.doctor.doctorName,
  //     "emailDesc": email,
  //     "emailReturnTime": appointmentTime,
  //     "firstName": patientFullName,
  //     "lastName": patientFullName,
  //     "location": widget.doctor.address1 + widget.doctor.address2,
  //     "modifiedBy": widget.doctor.modifiedBy,
  //     "modifiedOn": appointmentTime,
  //     "patientFullName": patientFullName,
  //     "patientName": patientFullName,
  //     "reportTime": appointmentTime,
  //     "requestDate": appointmentTime,
  //     "returnSMS": true,
  //     "sex": "",
  //     "smsDesc": "",
  //     "smsReturnTime": appointmentTime,
  //     "valid": true
  //   };
  //   String body = json.encode(data);

  //   print("Here is the Response-------" + body.toString());
  //   String url =
  //       AppPreferences().apiURL + "/isd" + "/patient_appointment";
  //   print("Here is the url-------" + url);

  //   http.Response response = await http.post(
  //     '$url',
  //     headers: {
  //       "username": AppPreferences().username,
  //       "tenant": WebserviceConstants.tenant,
  //       'content-type': 'application/json',
  //     },
  //     body: body,
  //   );

  //   CustomProgressLoader.cancelLoader(context);
  //   print(response.toString());
  //   print(response.toString());

  //   if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE ||
  //       response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE_2) {
  //     Map<String, dynamic> jsonMapData = new Map();

  //     try {
  //       jsonMapData = jsonDecode(response.body);
  //     } catch (_) {
  //       print("" + _);
  //     }

  //     if (jsonMapData != null) {
  //       setState(() {
  //         var appoint = Appointment.fromJson(jsonMapData);
  //         print(appoint.toString());
  //         _latestBookingId = appoint.bookingId;
  //       });
  //     }
  //   }
  // }
}
