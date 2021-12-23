import 'dart:convert';

import '../../api/membership_api_client.dart';
import '../../login/colors/color_info.dart';
import '../../login/utils.dart';
import '../../login/utils/custom_progress_dialog.dart';
import '../../model/payment_info.dart';
import '../../repo/common_repository.dart';
import '../../repo/membership_repo.dart';
import '../../ui/booking_appointment/models/doctor_info.dart';
import '../../ui/custom_drawer/custom_app_bar.dart';
import '../../ui/membership/widgets/payment_cancel_dialog.dart';
import '../../ui/membership/widgets/payments_widget.dart';
import '../../ui_utils/app_colors.dart';
import '../../ui_utils/icon_utils.dart';
import '../../utils/app_preferences.dart';
import '../../utils/validation_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'booking_corfirmation_screen.dart';
import 'models/appointment.dart';
import 'models/doctor_availability.dart';

class AppointmentContinuePayment extends StatefulWidget {
  final UserAsDoctorInfo doctor;
  final String date;
  final DoctorAvailabilitySlot slot;
  final bool isFreeConsultation;
  final String couponCode;
  final Map patientDetails;

  const AppointmentContinuePayment(
      {Key key,
      this.doctor,
      this.date,
      this.slot,
      this.isFreeConsultation,
      this.patientDetails,
      this.couponCode})
      : super(key: key);

  @override
  _AppointmentContinuePaymentState createState() =>
      _AppointmentContinuePaymentState();
}

class _AppointmentContinuePaymentState
    extends State<AppointmentContinuePayment> {
  bool showPaymentStatusView = false;
  bool paymentStatusLoading = false;
  String userName = "";
  String firstName = "";
  String lastname = "";
  String email = "";
  String phNumber = "";
  bool clicked = true;
  bool isLoading = false;
  bool autoConfirm = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PaymentInfo paymentInfoObj;
  MembershipRepository _membershipRepository;
  int videoConsultationFee = 50;
  _getUserName() async {
    firstName = await AppPreferences.getFullName();
    lastname = await AppPreferences.getSecondFullName();
    userName = await AppPreferences.getUsername();
    email = await AppPreferences.getEmail();
    phNumber = await AppPreferences.getPhone();
  }

  void initState() {
    super.initState();
    if (widget.doctor.dInfo == null) {
      videoConsultationFee = 50;
    } else {
      videoConsultationFee = widget.doctor.dInfo.videoConsultationFee;
    }
    _membershipRepository = MembershipRepository(
        membershipApiClient: MembershipApiClient(httpClient: http.Client()));

    _getUserName();
    dateConvertion();
  }

  String bookingDate = "";
  dateConvertion() {
//  2021-03-06T12:24:54.156
    bookingDate = widget.date;
    bookingDate = bookingDate.split("/")[2] +
        "-" +
        bookingDate.split("/")[0] +
        "-" +
        bookingDate.split("/")[1] +
        "T" +
        "00:00:00";
    // print(bookingDate);
    // print(DateUtils.convertUTCToLocalTime(bookingDate).split(" ")[0]);
    setState(() {
      bookingDate = DateUtils.convertUTCToLocalTime(bookingDate).split(" ")[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
            title:
                widget.doctor.userFullName != null ? "Appointment Details" : "",
            pageId: 0),
        body: isLoading
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
            : showPaymentStatusView
                ? appointmentPaymentWidget()
                : doctorAppointmentDetailsWidget());
  }

  Widget doctorDetails() {
    String consultFee = "";
    if (widget.isFreeConsultation) {
      consultFee = "Fee : FREE";
    } else {
      consultFee = "Fee : " + '\$' + "  $videoConsultationFee";
    }
    return Container(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        children: <Widget>[
          widget.doctor.downloadProfileURL.length == 0
              ? Image.asset(
                  'assets/images/doctor_image.png',
                  width: 130.0,
                  height: 130.0,
                )
              : CircleAvatar(
                  radius: 80.0,
                  backgroundColor: Colors.grey,
                  backgroundImage:
                      NetworkImage(widget.doctor.downloadProfileURL),
                ),
          SizedBox(
            width: 8.0,
          ),
          Text(
            "${widget.doctor.userFullName}",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text("${widget.doctor.specialities.join(', ')}"),
          SizedBox(
            height: 10.0,
          ),
          Text(consultFee),
          SizedBox(
            height: 10.0,
          ),
          Container(
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width / 7,
                  0,
                  MediaQuery.of(context).size.width / 5,
                  0),
              width: MediaQuery.of(context).size.width * .80,
              // Center(
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.date_range,
                    color: Colors.blue,
                    size: 35.0,
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    "$bookingDate" + '\n' + "${slotFromObject(widget.slot)}",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                ],
              )),
          // ),
        ],
      ),
    );
  }

  // String slotFromObject(DoctorAvailabilitySlot slot) {
  //   return slot.startTime + " - " + slot.endTime;
  // }

  String slotFromObject(DoctorAvailabilitySlot slot) {
    DateFormat formatTime = DateFormat("HH:mm");
    DateTime start = formatTime.parse(slot.startTime);
    DateTime end = formatTime.parse(slot.endTime);
    String value = DateFormat('h:mm a').format(start) +
        " - " +
        DateFormat('h:mm a').format(end);
    return value;
  }

  Widget doctorAppointmentDetailsWidget() {
    return Center(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                // color: Colors.red,
                // height: 440,
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              doctorDetails(),
              SizedBox(
                height: MediaQuery.of(context).size.height * .10,
              ),
              InkWell(
                onTap: clicked
                    ? () {
                        if (widget.isFreeConsultation == true) {
                          // apiCall();
                          checkAutoConfirm();
                          setState(() {
                            clicked = false;
                          });
                        } else {
                          setState(() {
                            showPaymentStatusView = true;
                          });
                        }
                      }
                    : (){},
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.height * .08,
                      0,
                      MediaQuery.of(context).size.height * .08,
                      0),
                  color: Color(ColorInfo.APP_BLUE),
                  // width: MediaQuery.of(context).size.width * .5,
                  height: MediaQuery.of(context).size.height * .08,
                  child: Center(
                      child: Text(
                    widget.isFreeConsultation
                        ? "Continue Free Appointment"
                        : "Continue Payment",
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              ),
            ]))));
  }

///// SHOW PAYMNET WIDGET////
  Widget appointmentPaymentWidget() {
    debugPrint("==========>  videoConsultationFee $videoConsultationFee");
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 380,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0)),
                  child: Container(
                    //color: AppColors.primaryColor,
                    color: Color(0xFF1A237E),
                    padding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Payment Method",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                            IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) =>
                                          PaymentCancellationDialog(
                                            onTap: () {
                                              // debugPrint(
                                              // "PaymentCancellationDialog on tap...");
                                              setState(() {});
                                            },
                                          ));
                                },
                                color: Colors.white),
                          ],
                        ),
                      ],
                    ),
                  )),
              Expanded(
                child: Container(
                  color: AppColors.primaryColor,
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(16.0),
                    height: MediaQuery.of(context).size.height * 1 / 1.6,
                    child: PaymentsWidget(
                      totalAmount: videoConsultationFee.toDouble(),
                      name: userName,
                      isOnlyCard: true,
                      email: email,
                      departmentName: AppPreferences().deptmentName,
                      phoneNumber: phNumber,
                      paymentDescription: "Consultation by $firstName",
                      paymentStatus: (bool payStatus, String paymentMode,
                          String requestId) async {
                        /*  debugPrint("payStatus --> $payStatus");
                        debugPrint("paymentMode --> $paymentMode");
                        debugPrint("requestId --> $requestId"); */
                        setState(() {
                          paymentStatusLoading = true;
                        });
//Tapping on back from payment ,loading is shoing on the screen
                        // isLoading = true;

                        if (paymentMode == "Card") {
                          // print('++++++++++++payStatus++++++');

                          if (payStatus) {
                            List<PaymentInfo> paymentInfoList =
                                await _membershipRepository
                                    .getMembershipTransactionDetails(
                                        requestId: requestId,
                                        transactionType: "CONSULTATION");
                            if (paymentInfoList.isNotEmpty &&
                                paymentInfoList[0].transactionStatus ==
                                    "success") {
                              Utils.toasterMessage(" Payment Success");

                              paymentInfoObj = paymentInfoList[0];
                              setState(() {
                                isLoading = true;
                                paymentStatusLoading = false;
                              });
                              Future.delayed(const Duration(milliseconds: 5),
                                  () {
                                // apiCall();
                                checkAutoConfirm();
                              });
                            } else {
                              Utils.toasterMessage(" transaction failed");
                              setState(() {
                                paymentStatusLoading = false;
                              });
                            }

                            ///
                          } else {
                            setState(() {
                              paymentStatusLoading = false;
                            });
                          }
                        } else {
                          // print('++++++++++++payStatus Failed++++++');

                          Utils.toasterMessage(" Payment failed");
                          setState(() {
                            paymentStatusLoading = false;
                          });
                        }
                      },
                      globalKey: _scaffoldKey,
                      transactionType: TransactionType.CONSULTATION,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  checkAutoConfirm() async {
    Map<String, String> header = {};
    header.putIfAbsent('tenant', () => WebserviceConstants.tenant);
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(
        WebserviceConstants.username, () => AppPreferences().username);

    String url =
        '${WebserviceConstants.baseAdminURL}/departments/${AppPreferences().promoDeparmentName}?membership=false';

    final response = await http.get(url, headers: header);
    // print(" API URL : $url");
    // print(" API Body : ${response.body}");
    if (ValidationUtils.isSuccessResponse(response.statusCode)) {
      var environmentProperties =
          json.decode(response.body)['environmentProperties'];
      if (environmentProperties != null) {
        var autoconfirmation = environmentProperties[
            'com.sdx.platform.appointment.autoconfirmation.enable'];
        if (autoconfirmation != null) {
          var autoconfirmationProperty = autoconfirmation['propertyValue'];
          if (autoconfirmationProperty.toString() == "true") {
            autoConfirm = true;
          }
        }
      }
      apiCall();
    }
  }

  apiCall() async {
    CustomProgressLoader.showLoader(context);
    String patientFullName =
        widget.patientDetails != null && widget.patientDetails['userName'] != ''
            ? widget.patientDetails['fullName']
            : await AppPreferences.getFullName();

    // debugPrint("patientFullName in payment api calling");
    // debugPrint(patientFullName);
    // debugPrint("testing patient details");
    // debugPrint(widget.patientDetails.toString());
    String patientName =
        widget.patientDetails != null && widget.patientDetails['userName'] != ''
            ? widget.patientDetails['userName']
            : await AppPreferences.getUsername();
    String patientFirstName;
    String patientLastName;
    if (widget.patientDetails != null) {
      patientFirstName = widget.patientDetails['firstName'];
      patientLastName = widget.patientDetails['lastName'];
    }
    if (patientFirstName == '' || patientFirstName == null) {
      await AppPreferences.getUserInfo().then((value) {
        patientFirstName = value.firstName;
        patientLastName = value.lastName;
      });
    }
    String startTime = widget.slot.startTime;
    String endTime = widget.slot.endTime;
    String patientDeptName = await AppPreferences.getDeptName();
    // debugPrint("patientDeptName====>$patientDeptName");

    Map paymentDetail = {
      'paymentStatus': "success",
      'transactionId':
          widget.isFreeConsultation ? "" : paymentInfoObj.transactionId
    };
    // Map refundDetail = {
    //   "paymentStatus": "success",
    //   "transactionId": paymentInfoObj.transactionId
    // };
    // String url = WebserviceConstants.baseAppointmentURL +
    //     "/v2/patient_appointment/$patientDeptName/$patientName/status";
    // http.Response res = await http.get(
    //   url,
    //   headers: {
    //     "username": AppPreferences().username,
    //     "tenant": WebserviceConstants.tenant,
    //     'content-type': 'application/json',
    //   },
    // );
    bool freeConsultancy =
        widget.doctor.userCategory.toLowerCase() == "Consultant".toLowerCase()
            ? true
            : false;
    // if (res.statusCode == 200) {
    //   freeConsultancy = res.body.toString().trim() == "true" ? true : false;
    // }
    Map data = widget.couponCode.isEmpty || widget.couponCode == null
        ? {
            "active": true,
            "age": 0,
            "appointmentEndTime": endTime,
            "appointmentFee":
                widget.isFreeConsultation ? 0 : videoConsultationFee,
            "appointmentStartTime": startTime,
            "appointmentType": "VIDEO",
            "comments": "",
            "freeConsultation": freeConsultancy,
            "complete": true,
            "createdBy": patientFullName,
            "createdOn": "",
            "departmentName": patientDeptName,
            "doctorDepartmentName": patientDeptName, //widget.doctor.doctorId,
            "doctorName": widget.doctor.userName,
            "doctorFullName": widget.doctor.userFullName,
            "emailDesc": email,
            "paymentDetail": paymentDetail,
            // "refundDetail": refundDetail,
            "emailReturnTime": "",
            "firstName": patientFirstName,
            "lastName": patientLastName,
            // "location": widget.doctor.location,
            "modifiedOn": "",
            "patientFullName": patientFullName,
            "patientName": patientName,
            "reportTime": "",
            "requestDate": widget.date,
            "returnSMS": true,
            "sex": "",
            "smsDesc": "",
            "smsReturnTime": "",
            "valid": true,
            // "couponCode": widget.couponCode
          }
        : {
            "active": true,
            "age": 0,
            "appointmentEndTime": endTime,
            "appointmentFee":
                widget.isFreeConsultation ? 0 : videoConsultationFee,
            "appointmentStartTime": startTime,
            "appointmentType": "VIDEO",
            "comments": "",
            "freeConsultation": freeConsultancy,
            "complete": true,
            "createdBy": patientFullName,
            "createdOn": "",
            "departmentName": patientDeptName,
            "doctorDepartmentName": patientDeptName, //widget.doctor.doctorId,
            "doctorName": widget.doctor.userName,
            "doctorFullName": widget.doctor.userFullName,
            "emailDesc": email,
            "paymentDetail": paymentDetail,
            // "refundDetail": refundDetail,
            "emailReturnTime": "",
            "firstName": patientFirstName,
            "lastName": patientLastName,
            // "location": widget.doctor.location,
            "modifiedOn": "",
            "patientFullName": patientFullName,
            "patientName": patientName,
            "reportTime": "",
            "requestDate": widget.date,
            "returnSMS": true,
            "sex": "",
            "smsDesc": "",
            "smsReturnTime": "",
            "valid": true,
            "couponCode": widget.couponCode
          };
    // debugPrint(data.toString());
    String body = json.encode(data);
    // print(patientName);
    // print("Here is the Response-------" + body);
    var url = WebserviceConstants.baseAppointmentURL +
        "/v2/patient_appointment/$patientDeptName/$patientName";
    // print("Here is the url-------" + url);
    // "/v2/patient_appointment/$patientDeptName/$patientFullName";
    // print("Here is the url-------" + url);
    var headers = {
      "username": AppPreferences().username,
      "tenant": WebserviceConstants.tenant,
      'content-type': 'application/json',
    };
    http.Response response = await http.post(
      '$url',
      headers: headers,
      body: body,
    );

    CustomProgressLoader.cancelLoader(context);
    print(response.body.toString());
    print(response.statusCode.toString());

    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE ||
        response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE_2) {
      Map<String, dynamic> jsonMapData = new Map();

      try {
        jsonMapData = jsonDecode(response.body);
      } catch (_) {
        // print("" + _);
      }

      if (jsonMapData != null) {
        var appoint = Appointment.fromJson(jsonMapData);
        if (autoConfirm) {
          http.Response res = await http.post(
              WebserviceConstants.baseAppointmentURL +
                  "/v2/patient_appointment/$patientDeptName/$patientName/${appoint.bookingId}/status?appointment_status=CONFIRMED",
              headers: headers);
          appoint = Appointment.fromJson(json.decode(res.body));
        }
        setState(() {
          // print(appoint.toString());
          // _latestBookingId = appoint.bookingId;

          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => BookingConfirmationScreen(
                    doctor: widget.doctor,
                    date: bookingDate,
                    time: slotFromObject(widget.slot),
                    latestBookingId: appoint.bookingId,
                  )));
        });
      } else {}
    } else {
      Utils.toasterMessage(" Error in booking the appointment");
    }
  }
}
/*


 [{"createdBy":"SuperAdmin","createdOn":"2021-02-08T19:19:19.876","modifiedBy":"NonAuthUser","modifiedOn":"2021-02-08T19:19:56.304","active":false,"comments":null,"paymentId":"01c5f878-0c9f-48f4-a638-bfe06bd099bf","payeeName":"Patient01","payeeEmail":"918807872537","orderId":"ORD-2565","transactionId":"31-1-ORD-2565-20210208031925","reasonCode":"1","reasonDescription":"Transaction is approved.","totalAmount":50.0,"currency":null,"fxRate":null,"payeePhoneNumber":"918807872537","returnURL":"https://qa.servicedx.com/payment","developerId":"1","merchantId":"127","transactionDate":"2021-02-08T09:49:54","transactionStatus":"success","transactionSource":"MOBILE","transactionGateway":"WIP","requestId":"1f22a9e5-c870-40ad-bc55-1fffe62f8472","paymentMode":"CARD","paymentDescription":"Consultation by Samuel, George","transactionType":"CONSULTATION","category":null,"departmentName":"null","userName":"Patient01","userFullName":"George Samuel","gatewayExecutionURL":null}]

 */
