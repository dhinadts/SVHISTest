import 'dart:convert';

import '../../repo/common_repository.dart';
import '../../ui/booking_appointment/appointment_confirmation_screen.dart';
import '../../ui/custom_drawer/navigation_home_screen.dart';
import '../../ui_utils/app_colors.dart';
import '../../ui_utils/text_styles.dart';
import '../../ui_utils/widget_styles.dart';
import '../../utils/app_preferences.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/mode_tag.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../ui_utils/icon_utils.dart';
import 'models/appointment.dart';

class AppointmentConfirmationListScreen extends StatefulWidget {
  final String title;
  const AppointmentConfirmationListScreen({Key key, this.title})
      : super(key: key);
  @override
  _AppointmentConfirmationListScreenState createState() =>
      _AppointmentConfirmationListScreenState();
}

class _AppointmentConfirmationListScreenState
    extends State<AppointmentConfirmationListScreen> {
  List<Appointment> appointmentDataList = List();

  bool isDataLoaded = false;
  bool isDataEmpty = false;
  String appointmentType = "FUTURE";
  final GlobalKey _settingsMenuKey = new GlobalKey();
  List<Appointment> appointmentSearchFilteredList = List();
  TextEditingController searchController = new TextEditingController();
  List<Appointment> appointmentDataFilterList = List();
  @override
  void initState() {
    getAppointmentList();
    super.initState();
  }

  getAppointmentList() async {
    WebserviceHelper helper = WebserviceHelper();
    String loggedInUserName = await AppPreferences.getUsername();
    Map<String, String> header = {};
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => loggedInUserName);
    header.putIfAbsent("tenant", () => WebserviceConstants.tenant);

    /*final response = await helper.get(
        WebserviceConstants.baseAppointmentURL +
            "/v2/patient_appointment?type=$appointmentType",
        headers: header,
        isOAuthTokenNeeded: false);*/

    final response = await helper.get(
        WebserviceConstants.baseAppointmentURL +
            "/v2/doctor_appointment/${AppPreferences().deptmentName}"
                "/${AppPreferences().username}?type=$appointmentType",
        headers: header,
        isOAuthTokenNeeded: false);

    // debugPrint("response - ${response.statusCode}");
    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      Map<String, dynamic> jsonMapData = new Map();
      List<dynamic> jsonData;
      try {
        jsonData = jsonDecode(response.body);
        jsonMapData.putIfAbsent("appointmentList", () => jsonData);
      } catch (_) {
        // print("" + _);
      }

      if (jsonData != null) {
        setState(() {
          isDataEmpty = false;
          isDataLoaded = true;
          appointmentDataList = jsonMapData["appointmentList"]
              .map<Appointment>((x) => Appointment.fromJson(x))
              .toList();
        });
      } else {
        setState(() {
          isDataEmpty = true;
          isDataLoaded = true;
        });
      }
    }

    /* setState(() {
      _isLoading = false;
    });*/
  }

  filterFunctionality(String value) {
    if (value == "All") {
      getAppointmentList();
    }
    appointmentDataFilterList.clear();

    for (var i = 0; i < appointmentDataList.length; i++) {
      if (value.toLowerCase() ==
          appointmentDataList[i].appointmentStatus.toLowerCase()) {
        appointmentDataFilterList.add(appointmentDataList[i]);
        setState(() {});
      }
    }

    if (appointmentDataFilterList.length == 0) {
      setState(() {
        isDataEmpty = true;
      });
    } else {
      setState(() {
        isDataEmpty = false;
      });
    }
    setState(() {});
  }

  String chipsValue = "All";
  Widget popUpMenuItems() {
    final popupSettingMenu = new PopupMenuButton(
        child: InkWell(
            onTap: () {
              dynamic state = _settingsMenuKey.currentState;
              state.showButtonMenu();
            },
            child: ModeTag(
              chipsValue,
              leading: true,
            )),
        key: _settingsMenuKey,
        itemBuilder: (_) => <PopupMenuItem<String>>[
              new PopupMenuItem<String>(child: const Text('All'), value: 'All'),
              new PopupMenuItem<String>(
                  child: const Text('Booked'), value: 'Booked'),
              new PopupMenuItem<String>(
                  child: const Text('Confirmed'), value: 'Confirmed'),
              new PopupMenuItem<String>(
                  child: const Text('Declined'), value: 'Declined'),
            ],
        onSelected: (_) {
          setState(() {
            chipsValue = _;
          });
          // if (localPaymentList != null && localPaymentList.length > 0)
          filterFunctionality(chipsValue);
        });
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
            child: Container(
                padding: EdgeInsets.only(left: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Filter",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    popupSettingMenu
                  ],
                ))),
        SizedBox(
          width: 25,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          widget.title,
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              /*Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * .08,
                child: searchBox(),
              ),*/
              SizedBox(
                height: 10,
              ),
              Container(
                decoration:
                    BoxDecoration(boxShadow: WidgetStyles.cardBoxShadow),
                child: Column(
                  children: <Widget>[
                    // _titleTransaction()
                  ],
                ),
              ),
              popUpMenuItems(),
              SizedBox(height: 8.0),
              appointmentTitleText(),
              !isDataLoaded
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListLoading(),
                    )
                  : !isDataEmpty
                      ? SingleChildScrollView(
                          child: Container(
                            child: appointmentSearchFilteredList.length == 0 &&
                                    appointmentDataList.length == 0 &&
                                    searchController.text.isEmpty
                                ? noDataWidget()
                                : ListView.builder(
                                    primary: false,
                                    shrinkWrap: true,
                                    itemCount:
                                        appointmentDataFilterList.length != 0 ||
                                                searchController.text.isNotEmpty
                                            ? appointmentDataFilterList.length
                                            : appointmentDataList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return appointmentListItem(
                                        appointmentDataFilterList.length != 0 ||
                                                searchController.text.isNotEmpty
                                            ? appointmentDataFilterList[index]
                                            : appointmentDataList[index],
                                      );
                                    }),
                          ),
                        )
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 100.0),
                            child: Container(
                                child: Text(Constants.NO_RECORD_FOUND,
                                    style: TextStyles.countryCodeStyle)),
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }

/*  void updateListData(bool isChangedData) {
    debugPrint("isChangedData --> $isChangedData");
    if (isChangedData != null && isChangedData) {
      getCommitteeList();
    }
  }*/

  Widget noDataWidget() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        child: Center(child: Text("No data available")),
      ),
    );
  }

  Widget appointmentTitleText() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: AppColors.arrivedColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15.0),
          )),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Date",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Status",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchBox() {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: searchController,
            decoration: new InputDecoration(
              labelText: 'Search by Date',
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            // onChanged: onSearchTextChanged,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Ink(
          decoration: const ShapeDecoration(
            color: Colors.blueGrey,
            shape: CircleBorder(),
          ),
          child: IconButton(
              icon: Icon(Icons.search),
              color: Colors.white,
              onPressed: () {
                onSearchTextChanged(searchController.text);
              }),
        ),
      ],
    );
  }

  Widget getAppointmentStatus(String status) {
    Color statusColor;
    switch (status.toLowerCase()) {
      case "booked":
        statusColor = AppColors.arrivedColor;
        break;
      case "confirmed":
        statusColor = AppColors.darkGrassGreen;
        break;
      case "declined":
        statusColor = AppColors.brick;
        break;
      default:
        statusColor = AppColors.accentColor;
        break;
    }
    return Container(
        decoration: BoxDecoration(
            color: statusColor,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        child: Text(
          status,
          style: TextStyle(color: Colors.white, fontSize: 12),
        ));
  }

  Widget appointmentListItem(Appointment appointmentData) {
    String sTime = appointmentData.appointmentTiming +
        " " +
        appointmentData.appointmentStartTime;
    String eTime = appointmentData.appointmentTiming +
        " " +
        appointmentData.appointmentEndTime;

    var sTime1 = DateFormat("h:mm a").format(DateTime.parse(sTime));
    var eTime1 = DateFormat("hh:mm a").format(DateTime.parse(eTime));

    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AppointmentConfirmationScreen(
              appointment: appointmentData,
            ),
          ),
        ).then((value) {
          if (value != null && value == true) {
            getAppointmentList();
          }
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${appointmentData.patientFullName}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  getAppointmentStatus(appointmentData.appointmentStatus)
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Appointment Date : ${DateFormat(DateUtils.defaultDateFormat).format(DateTime.parse(appointmentData.appointmentTiming + " " + appointmentData.appointmentStartTime))}",
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Appointment Time : $sTime1 - $eTime1",
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Booking Id : " + appointmentData.bookingId,
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                //margin: EdgeInsets.symmetric(horizontal: 7),
                height: 1,
                color: AppColors.borderLine,
              ),
              Container(
                width: double.infinity,
                //margin: EdgeInsets.symmetric(horizontal: 7),
                height: 5,
                color: AppColors.borderShadow,
              ),
            ],
          ),
        ),
      ),
    );
  }

  onSearchTextChanged(String text) async {
    appointmentSearchFilteredList.clear();
    if (text.isEmpty) {
      setState(() {
        getAppointmentList();
      });
      return;
    }
    setState(() {
      isDataLoaded = false;
    });
/*    committeeList = await committeeRepositary.getCommitteeSearchList(text);
    print(committeeList);
    for (int i = 0; i < committeeList.length; i++) {
      if (committeeList[i]
          .committeeName
          .toLowerCase()
          .contains(text.toLowerCase())) {
        committeeSearchFilteredList.add(committeeList[i]);
      }
    }*/

    setState(() {
      isDataLoaded = true;
    });
  }
}
