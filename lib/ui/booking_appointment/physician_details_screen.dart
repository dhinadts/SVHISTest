import 'dart:convert';

import '../../model/base_response.dart';
import '../../model/user_info.dart';
import '../../repo/auth_repository.dart';
import '../../repo/common_repository.dart';
import '../../ui/advertise/adWidget.dart';
import '../../ui/booking_appointment/booking_appointment_screen.dart';
import '../../ui/booking_appointment/models/doctor_info.dart';
import '../../utils/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../ui_utils/app_colors.dart';
import 'models/doctor.dart';
import 'doctor_review_page.dart';

class PhysicianDetailScreen extends StatefulWidget {
  // final String doctorUsername;
  // final String doctorFulName;
  final Doctor doctorObj;

  const PhysicianDetailScreen({Key key, @required this.doctorObj})
      : super(key: key);

  @override
  _PhysicianDetailScreenState createState() => _PhysicianDetailScreenState();
}

class _PhysicianDetailScreenState extends State<PhysicianDetailScreen> {
  bool _isLoading = true;
  UserAsDoctorInfo userDoctorInfo;
  String doctorAvailableDays = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // getDoctorInfo();
    getUserInfo();

    initializeAd();
  }

  //GetAPI department
  Future getUserInfo() async {
    Map<String, String> header = {};
    String username = widget.doctorObj.doctorUserName;
    String deptName = await AppPreferences.getDeptName();

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
        username +
        "/lightWeight";

    final response =
        await helper.get(url, headers: header, isOAuthTokenNeeded: false);
    Map<String, dynamic> jsonData;
    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      try {
        // print('User Info Response...........${response.body.toString()}');
        jsonData = jsonDecode(response.body);
        userDoctorInfo = UserAsDoctorInfo.fromJson(jsonData);
        userDoctorInfo.isConsultant = widget.doctorObj.isConsultant;
        if (userDoctorInfo.dInfo != null) {
          userDoctorInfo.dInfo.availableDays.forEach((availableDay) {
            if (doctorAvailableDays == "") {
              doctorAvailableDays = availableDay;
            } else {
              doctorAvailableDays = doctorAvailableDays + "," + availableDay;
            }
          });
        }

        setState(() {
          _isLoading = false;
        });
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: AppColors.primaryColor,
        title: Text("",
            style: TextStyle(
                fontSize: 20, fontFamily: 'Montserrat', color: Colors.white)),
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
                  child: Stack(
                    children: <Widget>[
                      ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height,
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                          color: Colors.grey[100],
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: userDoctorInfo
                                                      .downloadProfileURL
                                                      .length ==
                                                  0
                                              ? Container(
                                                  child: Image.asset(
                                                    'assets/images/doctor_image.png',
                                                    width: 100,
                                                    height: 100.0,
                                                  ),
                                                )
                                              : /*Image.memory(
                                                  base64.decode(userDoctorInfo
                                                      .profileImage),
                                                  width: double.infinity,
                                                  fit: BoxFit.contain,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.35,
                                                )*/
                                        Image.network( userDoctorInfo.downloadProfileURL,
                                          width: double.infinity,
                                          fit: BoxFit.contain,
                                          height: MediaQuery.of(context)
                                              .size
                                              .height *
                                              0.35,),
                                          // : CircleAvatar(
                                          //     radius: 80.0,
                                          //     backgroundColor: Colors.grey,
                                          //     backgroundImage: NetworkImage(
                                          //         userDoctorInfo
                                          //             .downloadProfileURL),
                                          //   ),
                                          ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top:
                                      MediaQuery.of(context).size.height * 0.30,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      // border: Border.all(color: Colors.red),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(40),
                                          topRight: Radius.circular(40)),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(4,
                                              -6), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          //width: 160.0,
                                          child: RaisedButton(
                                            elevation: 0.0,
                                            color: Colors.transparent,
                                            child: Text(
                                              userDoctorInfo.firstName +
                                                  " " +
                                                  userDoctorInfo.lastName,
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.blue),
                                            ),
                                            onPressed: () {},
                                          ),
                                        ),
                                        Center(
                                          child: SizedBox(
                                            height: 20.0,
                                            //width: 160.0,
                                            child: RaisedButton(
                                              child: Text(
                                                widget.doctorObj.speciality.join(", "),
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.white),
                                              ),
                                              shape: new RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          12.0)),
                                              color: Colors.red[500],
                                              onPressed: () {},
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 1.0,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              RatingBarIndicator(
                                                rating: userDoctorInfo.rating,
                                                itemCount: 5,
                                                itemSize: 20.0,
                                                physics:
                                                    BouncingScrollPhysics(),
                                                itemBuilder: (context, _) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                              ),
                                              FlatButton(
                                                child: Text("See all reviews",
                                                    style: TextStyle(
                                                        color: Colors.blue)),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              DoctorReview(widget
                                                                  .doctorObj
                                                                  .doctorUserName)));
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15.0, right: 15),
                                          child: Divider(
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top:
                                      MediaQuery.of(context).size.height * 0.50,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25.0, right: 25),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          // mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              child: Text(
                                                "About",
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            SizedBox(height: 15),
                                            /* Container(
                                          child: Text(
                                            "Available on:",
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        Container(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.fromLTRB(0, 10, 10, 10),
                                            child: Text(
                                              doctorAvailableDays,
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                fontFamily: 'Montserrat',
                                                //fontWeight: FontWeight.w500
                                              ),
                                            ),
                                          ),
                                        ), */
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Container(
                                                child: Text(
                                                  "Experience",
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontFamily: 'Montserrat',
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 10, 10, 10),
                                                child: Text(
                                                  "${userDoctorInfo.experience}",
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontFamily: 'Montserrat',
                                                    //fontWeight: FontWeight.w500
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.center,
                                              child: Container(
                                                alignment: Alignment.center,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                                height: 1,
                                                color: Colors.grey[300],
                                              ),
                                            ),
                                            Container(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 10, 10, 10),
                                                child: Text(
                                                  "Registration",
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontFamily: 'Montserrat',
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                "${userDoctorInfo.registrationNumber}",
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontFamily: 'Montserrat',
                                                  //fontWeight: FontWeight.w500
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.center,
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 10, 10, 10),
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                    height: 1,
                                                    color: Colors.grey[300],
                                                  )),
                                            ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Container(
                                                child: Text(
                                                  "Gender",
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontFamily: 'Montserrat',
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ),

                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Container(
                                                child: Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        0, 10, 10, 10),
                                                    child: Text(
                                                      "${userDoctorInfo.gender}",
                                                      style: TextStyle(
                                                        fontSize: 14.0,
                                                        fontFamily:
                                                            'Montserrat',
                                                        // fontWeight:
                                                        //     FontWeight.w500
                                                      ),
                                                    )),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.center,
                                              child: Container(
                                                alignment: Alignment.center,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                                height: 1,
                                                color: Colors.grey[300],
                                              ),
                                            ),
                                            userDoctorInfo.language.length > 0
                                                ? Container(
                                                    child: Text(
                                                      "Language",
                                                      style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontFamily:
                                                              'Montserrat',
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  )
                                                : Container(),
                                            Container(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Text(
                                                  "${userDoctorInfo.language}",
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontFamily: 'Montserrat',
                                                    //fontWeight: FontWeight.w500
                                                  ),
                                                ),
                                              ),
                                            ),
//                        Container(
//                          child: Text(
//                            "Awards",
//                            style: TextStyle(
//                                fontSize: 14.0,
//                                fontFamily: 'Montserrat',
//                                fontWeight: FontWeight.w500),
//                          ),
//                        ),
//                        Container(
//                          child: Padding(
//                            padding: const EdgeInsets.all(10.0),
//                            child: Text(
//                              awards,
//                              style: TextStyle(
//                                fontSize: 12.0,
//                                fontFamily: 'Montserrat',
//                                //fontWeight: FontWeight.w500
//                              ),
//                            ),
//                          ),
//                        ),
//                        Container(
//                          child: Text(
//                            "Regno",
//                            style: TextStyle(
//                                fontSize: 14.0,
//                                fontFamily: 'Montserrat',
//                                fontWeight: FontWeight.w500),
//                          ),
//                        ),
//                        Container(
//                          child: Padding(
//                            padding: const EdgeInsets.all(10.0),
//                            child: Text(
//                              widget.doctor.regno,
//                              style: TextStyle(
//                                fontSize: 12.0,
//                                fontFamily: 'Montserrat',
//                                //fontWeight: FontWeight.w500
//                              ),
//                            ),
//                          ),
//                        ),
//                        Container(
//                          child: Text(
//                            "Memberships",
//                            style: TextStyle(
//                                fontSize: 14.0,
//                                fontFamily: 'Montserrat',
//                                fontWeight: FontWeight.w500),
//                          ),
//                        ),
//                        Container(
//                          child: Padding(
//                            padding: const EdgeInsets.all(10.0),
//                            child: Text(
//                              memberships,
//                              style: TextStyle(
//                                fontSize: 12.0,
//                                fontFamily: 'Montserrat',
//                                //fontWeight: FontWeight.w500
//                              ),
//                            ),
//                          ),
//                        ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),

                /// Show Banner Ad
                // getSivisoftAdWidget(),
              ],
            ),
      bottomNavigationBar: Material(
        elevation: 7.0,
        color: Colors.indigo[700],
        child: Container(
          height: 50.0,
          child: Row(
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          BookingAppointmentScreen(
                        doctor: userDoctorInfo,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: deviceWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Book an Appointment",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Montserrat'),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Icon(
                        Icons.calendar_today,
                        size: 30,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
