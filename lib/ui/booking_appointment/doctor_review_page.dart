import '../../ui/tabs/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../ui_utils/ui_dimens.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../repo/common_repository.dart';
import '../../utils/app_preferences.dart';
import 'models/appointment.dart';
import 'dart:convert';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../ui_utils/icon_utils.dart';
import '../../ui_utils/app_colors.dart';

class DoctorReview extends StatefulWidget {
  String doctorName;
  DoctorReview(this.doctorName);
  @override
  _DoctorReviewState createState() => _DoctorReviewState();
}

class _DoctorReviewState extends State<DoctorReview> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode focusNode = FocusNode();
  List<Appointment> appointmentList = [];
  List<Appointment> appointmentListSearched = [];
  bool loading = true;
  TextEditingController searchPatientController = TextEditingController();
  bool searchIconPos = true;

  initState() {
    getReviews();
  }

  getReviews() async {
    var response = await http.get(WebserviceConstants.baseAppointmentURL +
        "/v2/doctor_appointment/${AppPreferences().deptmentName}/${widget.doctorName}");
    print(response.body);
    print(WebserviceConstants.baseAppointmentURL +
        "/v2/doctor_appointment/${AppPreferences().deptmentName}/${widget.doctorName}");
    List data = json.decode(response.body);
    data.forEach((element) {
      var appointment = Appointment.fromJson(element);
      if ((appointment.review != null &&
              appointment.review != "null" &&
              appointment.review.trim().isNotEmpty) ||
          appointment.rating != null) {
        appointmentList.add(appointment);
      }
    });
    appointmentList.sort((a, b) {
      return DateTime.parse(b.createdOn).compareTo(DateTime.parse(a.createdOn));
    });
    setState(() {
      appointmentList = appointmentList;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Doctor Review"),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Container(
            child: loading
                ? Center(child: CircularProgressIndicator())
                : appointmentList.length == 0
                    ? Text("No Data Found")
                    : ListView(
                        shrinkWrap: true,
                        children: [
                          /*  Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: searchPatientController,
                              decoration: new InputDecoration(
                                hintText: 'Search by patient name',
                                border: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                                contentPadding: EdgeInsets.only(left: 8.0),
                                // prefixIcon: Icon(Icons.search),
                                suffixIcon: IconButton(
                                  icon: new Icon(Icons.search),
                                  onPressed: () {
                                    // searchPatientController.clear();
                                    // onSearchTextChanged('');
                                    onSearchTextChanged(
                                        searchPatientController.text);
                                  },
                                ),
                              ),
                              // onChanged: onSearchTextChanged,
                            ),
                          ), */
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 1.0,
                              // height: 50.0,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.80,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: AppUIDimens.paddingSmall),
                                      child: TextFormField(
                                        // focusNode: focusNode,
                                        controller: searchPatientController,
                                        decoration: InputDecoration(
                                          labelText: "Search by patient name",
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            //fillColor: Colors.green
                                          ),
                                        ),
                                        keyboardType: TextInputType.text,
                                        validator: (value) {
                                          if (value.isNotEmpty) {
                                            return value.length > 1
                                                ? null
                                                : "Search string must be 2 characters";
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                    ),
                                    Transform.translate(
                                      offset:
                                          Offset(0, searchIconPos ? 0 : -13),
                                      child: Ink(
                                        decoration: const ShapeDecoration(
                                          color: Colors.blueGrey,
                                          shape: CircleBorder(),
                                        ),
                                        child: IconButton(
                                          icon: Icon(Icons.search),
                                          color: Colors.white,
                                          onPressed: () {
                                            if (_formKey.currentState
                                                .validate()) {
                                              onSearchTextChanged(
                                                  searchPatientController.text);
                                            }
                                            if (searchPatientController
                                                    .text.length ==
                                                0) {
                                              Fluttertoast.showToast(
                                                  msg: AppLocalizations.of(
                                                          context)
                                                      .translate(
                                                          "key_entersometext"),
                                                  toastLength:
                                                      Toast.LENGTH_LONG,
                                                  timeInSecForIosWeb: 5,
                                                  gravity: ToastGravity.TOP);
                                            }
                                            if (_formKey.currentState
                                                    .validate() ==
                                                false) {
                                              setState(() {
                                                searchIconPos = false;
                                              });
                                            } else {
                                              setState(() {
                                                searchIconPos = true;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          searchPatientController.text.length > 0
                              ? appointmentListSearched.length > 0
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: appointmentListSearched.length,
                                      itemBuilder: (context, index) => Padding(
                                        padding: const EdgeInsets.only(
                                            right: 25.0, left: 8),
                                        child: Column(
                                          children: [
                                            ListTile(
                                              title: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      RatingBarIndicator(
                                                        rating: appointmentListSearched[
                                                                        index]
                                                                    .rating ==
                                                                null
                                                            ? 0.0
                                                            : appointmentListSearched[
                                                                        index]
                                                                    .rating +
                                                                0.0,
                                                        itemCount: 5,
                                                        itemSize: 20.0,
                                                        physics:
                                                            BouncingScrollPhysics(),
                                                        itemBuilder:
                                                            (context, _) =>
                                                                Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                        ),
                                                      ),
                                                      Text(
                                                          appointmentListSearched[
                                                                  index]
                                                              .patientFullName,
                                                          style: TextStyle(
                                                              fontSize: 14))
                                                    ],
                                                  ),
                                                  Text(
                                                      appointmentListSearched[
                                                                      index]
                                                                  .review ==
                                                              null
                                                          ? ""
                                                          : appointmentListSearched[
                                                                  index]
                                                              .review,
                                                      style: TextStyle(
                                                          fontSize: 13)),
                                                  Text(
                                                      "Created on: ${DateUtils.convertUTCToLocalTime(appointmentListSearched[index].createdOn)}",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors
                                                              .grey[600])),
                                                ],
                                              ),
                                            ),
                                            Divider(
                                              thickness: 1,
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : Center(child: Text("No Data Found"))
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemCount: appointmentList.length,
                                  itemBuilder: (context, index) {
                                    appointmentList.sort((a, b) {
                                      return DateTime.parse(b.createdOn)
                                          .compareTo(
                                              DateTime.parse(a.createdOn));
                                    });
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          right: 25.0, left: 8),
                                      child: Column(
                                        children: [
                                          ListTile(
                                            title: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    RatingBarIndicator(
                                                      rating:
                                                          appointmentList[index]
                                                                      .rating ==
                                                                  null
                                                              ? 0.0
                                                              : appointmentList[
                                                                          index]
                                                                      .rating +
                                                                  0.0,
                                                      itemCount: 5,
                                                      itemSize: 20.0,
                                                      physics:
                                                          BouncingScrollPhysics(),
                                                      itemBuilder:
                                                          (context, _) => Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                    ),
                                                    Text(
                                                        appointmentList[index]
                                                            .patientFullName,
                                                        style: TextStyle(
                                                            fontSize: 14))
                                                  ],
                                                ),
                                                Text(
                                                    appointmentList[index]
                                                                .review ==
                                                            null
                                                        ? ""
                                                        : appointmentList[index]
                                                            .review,
                                                    style: TextStyle(
                                                        fontSize: 13)),
                                                Text(
                                                    "Created on: ${DateUtils.convertUTCToLocalTime(appointmentList[index].createdOn)}",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            Colors.grey[600])),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            thickness: 1,
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                        ],
                      )),
      ),
    );
  }

  onSearchTextChanged(String val) {
    appointmentListSearched.clear();
    if (val == "" || val.isEmpty || val == null) {
      appointmentListSearched.clear();
      setState(() {});
    } else {
      appointmentList.forEach((userDetail) {
        if ((userDetail.patientFullName != null &&
            userDetail.patientFullName.toLowerCase().contains(val)))
          appointmentListSearched.add(userDetail);
        print(userDetail.patientFullName);
        setState(() {
          // appointmentList = appointmentListSearched;
        });
      });

      print("appointmentListSearched --- ${appointmentListSearched.length}");
      /* for (var i = 0; i < appointmentList.length; i++) {
        if (appointmentList[i]
            .patientFullName
            .toLowerCase()
            .contains(val.toLowerCase())) {
          appointmentListSearched.add(appointmentList[i]);
          setState(() {});
          print("$i -- $val");
          print(appointmentListSearched);
        }
      } */
    }
  }
}
