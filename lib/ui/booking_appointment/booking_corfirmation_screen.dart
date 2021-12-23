import '../../login/colors/color_info.dart';
import '../../ui/booking_appointment/models/doctor_info.dart';
import '../../utils/routes.dart';
import 'package:flutter/material.dart';
import '../../ui/custom_drawer/navigation_home_screen.dart';
import 'models/doctor.dart';
import 'dart:convert';

class BookingConfirmationScreen extends StatefulWidget {
  final UserAsDoctorInfo doctor;
  final String date;
  final String time;
  final String latestBookingId;

  const BookingConfirmationScreen(
      {Key key, this.doctor, this.date, this.time, this.latestBookingId})
      : super(key: key);

  @override
  _BookingConfirmationScreenState createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              Container(
                height: MediaQuery.of(context).size.height * .90,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(15.0)),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height * .12,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: MediaQuery.of(context).size.height * .12,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Booking Confirmed",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16.0),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .01,
                              ),
                              Text(
                                "Booking Id : ${widget.latestBookingId}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16.0),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .02,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 40.0, right: 40.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "Confirmation has been sent to your registered email and SMS",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16.0),
                                ),
                                // Text(
                                //   "registered email and SMS",
                                //   style: TextStyle(
                                //       fontWeight: FontWeight.w700, fontSize: 16.0),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .04,
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    child: Text(
                                  "Appointment Details",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey),
                                )),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .01,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * .95,
                                  height:
                                      MediaQuery.of(context).size.height * .19,
                                  child: doctorDetails(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .02,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        NavigationHomeScreen()),
                                ModalRoute.withName(Routes.dashBoard));
                          },
                          child: Container(
                            color: Color(ColorInfo.APP_BLUE),
                            width: MediaQuery.of(context).size.width * .4,
                            height: MediaQuery.of(context).size.height * .08,
                            child: Center(
                                child: Text(
                              "Done",
                              style: TextStyle(color: Colors.white),
                            )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
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
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width * .25,
                //color: Colors.red,
                child: widget.doctor.downloadProfileURL.length == 0
                    ? Image.asset(
                        'assets/images/doctor_image.png',
                        width: 100.0,
                        height: 100.0,
                      )
                    : CircleAvatar(
                        radius: 80.0,
                        backgroundColor: Colors.grey,
                        //backgroundImage: MemoryImage(base64.decode(widget.doctor.profileImage)
                              backgroundImage: NetworkImage(
                              widget.doctor.downloadProfileURL),
                      )),
            SizedBox(
              width: 8.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width * .50,
              //color: Colors.blue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${widget.doctor.userFullName}",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 18.0),
                        ),
                      ),
                      SizedBox(
                        height: 1.0,
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          child:
                              Text("${widget.doctor.specialities.join(', ')}")),
                    ],
                  ),
                  Container(
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
                              "${widget.date}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "${widget.time}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
