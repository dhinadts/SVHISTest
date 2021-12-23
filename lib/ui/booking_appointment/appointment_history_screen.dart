import 'dart:convert';
import 'dart:math';
import 'dart:developer' as developer;
import '../../ui_utils/widget_styles.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../../repo/common_repository.dart';
import '../../ui/agora/pages/call.dart';
import '../../ui/agora/pages/video_call_screen.dart';
import '../../ui/booking_appointment/appointment_details.dart';
import '../../ui/custom_drawer/navigation_home_screen.dart';
import '../../ui_utils/app_colors.dart';
import '../../ui_utils/icon_utils.dart';
import '../../utils/app_preferences.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../widgets/mode_tag.dart';
import '../../ui/customDatePicker.dart' as picker;
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:avatar_letter/avatar_letter.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/badge/gf_badge.dart';
import 'package:getwidget/shape/gf_badge_shape.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../ui_utils/ui_dimens.dart';
import '../../ui/tabs/app_localizations.dart';
import 'models/appointment.dart';
import 'repo/appointments_repo.dart';
import 'models/doctor_info.dart';

bool showfornow = false;

class AppointmentHistoryScreen extends StatefulWidget {
  final String pageName;
  final String title;

  AppointmentHistoryScreen({this.pageName, this.title});
  @override
  _AppointmentHistoryScreenState createState() =>
      _AppointmentHistoryScreenState();
}

class _AppointmentHistoryScreenState extends State<AppointmentHistoryScreen>
    with SingleTickerProviderStateMixin {
  bool doctor;
  bool doctor1 = true;
  TabController _controller;

  List<Appointment> appointmentDataFilterList = [];
  List<Appointment> appointmentHistoryDataList = List();
  List<Appointment> pastAppointmentHistoryDataList = List();
  List<Appointment> tempPastAppointmentHistoryDataList = List();
  List<Appointment> upComingAppointmentHistoryDataList = List();
  List<Appointment> tempUpComingAppointmentHistoryDataList = List();
  List<Appointment> declinedAppointmentHistoryDataList = List();
  List<Appointment> tempDeclinedAppointmentHistoryDataList = List();

  bool _isLoading = false;
  List<Tab> tabBar = [];
  getDeclined() async {
    tempDeclinedAppointmentHistoryDataList.clear();
    declinedAppointmentHistoryDataList.clear();
    var responseDeclined;
    String userCategory = await AppPreferences.getUserCategory();
    String loggedInUserName = await AppPreferences.getUsername();

    Map<String, String> header = {};
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => loggedInUserName);
    header.putIfAbsent("tenant", () => WebserviceConstants.tenant);
    print(AppPreferences().userCategory);
    if (userCategory == "DOCTOR") {
      declinedAppointmentHistoryDataList.clear();
      // print(WebserviceConstants.baseAppointmentURL);

      responseDeclined = await http.get(
        WebserviceConstants.baseAppointmentURL +
            "/v2/doctor_appointment/${AppPreferences().deptmentName}/${AppPreferences().username}?appointment_status=DECLINED",
        headers: header,
      );

      var test1 = jsonDecode(responseDeclined.body);
      setState(() {
        tempDeclinedAppointmentHistoryDataList =
            test1.map<Appointment>((x) => Appointment.fromJson(x)).toList();
        for (var i = 0;
            i < tempDeclinedAppointmentHistoryDataList.length;
            i++) {
          if (tempDeclinedAppointmentHistoryDataList[i].departmentName ==
              AppPreferences().deptmentName) {
            declinedAppointmentHistoryDataList
                .add(tempDeclinedAppointmentHistoryDataList[i]);
          }
          setState(() {});
        }
      });

      responseDeclined = await http.get(
        WebserviceConstants.baseAppointmentURL +
            "/v2/doctor_appointment/${AppPreferences().deptmentName}/${AppPreferences().username}?appointment_status=CANCELLED",
        headers: header,
      );

      test1 = jsonDecode(responseDeclined.body);
      setState(() {
        List<Appointment> appointmentList =
            test1.map<Appointment>((x) => Appointment.fromJson(x)).toList();
        declinedAppointmentHistoryDataList = [
          ...declinedAppointmentHistoryDataList,
          ...appointmentList
        ];
      });
      declinedAppointmentHistoryDataList.sort((a, b) =>
          DateTime.parse(a.appointmentTime + " " + a.appointmentStartTime)
              .compareTo(DateTime.parse(
                  b.appointmentTime + " " + b.appointmentStartTime)));
    } else if (AppPreferences().role != Constants.supervisorRole &&
        AppPreferences().userCategory != "CONSULTANT") {
      declinedAppointmentHistoryDataList.clear();
      // print(WebserviceConstants.baseAppointmentURL);

      responseDeclined = await http.get(
        WebserviceConstants.baseAppointmentURL +
            "/v2/patient_appointment/${AppPreferences().deptmentName}/${AppPreferences().username}?appointment_status=CANCELLED",
        headers: header,
      );
      //print(header.toString());

      var test1 = jsonDecode(responseDeclined.body);
      print("test111 =============> $test1");
      setState(() {
        tempDeclinedAppointmentHistoryDataList =
            test1.map<Appointment>((x) => Appointment.fromJson(x)).toList();
        for (var i = 0;
            i < tempDeclinedAppointmentHistoryDataList.length;
            i++) {
          if (tempDeclinedAppointmentHistoryDataList[i].departmentName ==
              AppPreferences().deptmentName) {
            declinedAppointmentHistoryDataList
                .add(tempDeclinedAppointmentHistoryDataList[i]);
          }
          setState(() {});
        }
        declinedAppointmentHistoryDataList
          ..sort((a, b) =>
              DateTime.parse(a.appointmentTime + " " + a.appointmentStartTime)
                  .compareTo(DateTime.parse(
                      b.appointmentTime + " " + b.appointmentStartTime)));
      });
    } else if (AppPreferences().userCategory.toString().trim() ==
        "CONSULTANT") {
      declinedAppointmentHistoryDataList.clear();
      print("Inside the Consultant");

      responseDeclined = await http.get(
        WebserviceConstants.baseAppointmentURL +
            "/v2/patient_appointment?doctor_department_name=${AppPreferences().deptmentName}&appointment_status=CANCELLED",
        headers: header,
      );

      var test1 = jsonDecode(responseDeclined.body);
      // setState(() {
      tempDeclinedAppointmentHistoryDataList =
          test1.map<Appointment>((x) => Appointment.fromJson(x)).toList();
// Declined Code
      for (var i = 0; i < tempDeclinedAppointmentHistoryDataList.length; i++) {
        if (tempDeclinedAppointmentHistoryDataList[i].departmentName ==
            AppPreferences().deptmentName) {
          // print("$i ..tempDeclinedAppointmentHistoryDataList[i].toJson()");
          // print(tempDeclinedAppointmentHistoryDataList[i].toJson());
          declinedAppointmentHistoryDataList
              .add(tempDeclinedAppointmentHistoryDataList[i]);
        }
        setState(() {});
      }
      // });
      // print(test1);

      // Enable the comments to get the DECLINED appointment list

      // responseDeclined = await http.get(
      //   WebserviceConstants.baseAppointmentURL +
      //       "/v2/patient_appointment?doctor_department_name=${AppPreferences().deptmentName}&appointment_status=DECLINED",
      //   headers: header,
      // );

      // test1 = jsonDecode(responseDeclined.body);
      // print(test1);
      // setState(() {
      //   List<Appointment> list =
      //       test1.map<Appointment>((x) => Appointment.fromJson(x)).toList();
      //   declinedAppointmentHistoryDataList = [
      //     ...declinedAppointmentHistoryDataList,
      //     ...list
      //   ];
      // });
      declinedAppointmentHistoryDataList.sort((a, b) {
        return DateTime.parse(
                a.appointmentTiming + " " + a.appointmentStartTime)
            .compareTo(DateTime.parse(
                b.appointmentTiming + " " + b.appointmentStartTime));
      });
    } else {
      declinedAppointmentHistoryDataList.clear();
      // print(WebserviceConstants.baseAppointmentURL);
      responseDeclined = await http.get(
        WebserviceConstants.baseAppointmentURL +
            "/v2/patient_appointment/${AppPreferences().deptmentName}/${AppPreferences().username}?appointment_status=DECLINED",
        headers: header,
      );
      //print(header.toString());
      var test1 = jsonDecode(responseDeclined.body);
      print("test1 ======> $test1");
      setState(() {
        declinedAppointmentHistoryDataList =
            test1.map<Appointment>((x) => Appointment.fromJson(x)).toList();
        declinedAppointmentHistoryDataList.sort((a, b) =>
            DateTime.parse(a.appointmentTiming + " " + a.appointmentStartTime)
                .compareTo(DateTime.parse(
                    b.appointmentTiming + " " + b.appointmentStartTime)));
      });
    }
  }

  getAppointmentList(String type) async {
    // tempPastAppointmentHistoryDataList.clear();
    // tempUpComingAppointmentHistoryDataList.clear();
    // pastAppointmentHistoryDataList.clear();
    // upComingAppointmentHistoryDataList.clear();
    String loggedInUserName = await AppPreferences.getUsername();

    Map<String, String> header = {};
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => loggedInUserName);
    header.putIfAbsent("tenant", () => WebserviceConstants.tenant);
    /*  final response = await helper.get(
        AppPreferences().apiURL + "/isd" +
            "/v2/patient_appointment?type=$type",
        headers: header,
        isOAuthTokenNeeded: false); */
    String userCategory = await AppPreferences.getUserCategory();
//curl -X GET "https://qa.servicedx.com/isd/v2/doctor_appointment/ISDHealth/JenniferLoius" -H "accept: application/json"
//${AppPreferences().deptmentName}&user_name=${AppPreferences().username}
    var response;

    String userRole = AppPreferences().role;

    if (userRole == "Supervisor") {
      // print(WebserviceConstants.baseAppointmentURL);
      // print("TTTTTTTTT");
      // print(WebserviceConstants.baseAppointmentURL +
      //     "/v2/patient_appointment?doctor_department_name=${AppPreferences().deptmentName}&type=$type");

      response = await http.get(
        WebserviceConstants.baseAppointmentURL +
            "/v2/patient_appointment?doctor_department_name=${AppPreferences().deptmentName}&type=$type",
        headers: header,
      );
      if (mounted) {
        setState(() {
          doctor = false;
        });
      }
    } else {
      if (userCategory == "DOCTOR") {
        // print(WebserviceConstants.baseAppointmentURL);
        // print("doctor......");
        response = await http.get(
          WebserviceConstants.baseAppointmentURL +
              "/v2/doctor_appointment/${AppPreferences().deptmentName}/${AppPreferences().username}?type=$type",
          headers: header,
        );

        setState(() {
          doctor = true;
        });
      } else {
        // print(WebserviceConstants.baseAppointmentURL);
        // print("123456789");
        // print(WebserviceConstants.baseAppointmentURL +
        //     "/v2/patient_appointment/${AppPreferences().deptmentName}/${AppPreferences().username}?type=$type");
        response = await http.get(
          WebserviceConstants.baseAppointmentURL +
              "/v2/patient_appointment/${AppPreferences().deptmentName}/${AppPreferences().username}?type=$type",
          headers: header,
        );
        // debug//print(AppPreferences().apiURL + "/isd" +
        // "/v2/patient_appointment/${AppPreferences().deptmentName}/${AppPreferences().username}?type=$type");
        // debug//print(response.body);
        if (mounted) {
          setState(() {
            doctor = false;
          });
        }
      }
    }
    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      Map<String, dynamic> jsonMapData = new Map();
      List<dynamic> jsonData;
      try {
        jsonData = jsonDecode(response.body);
        developer.log("RES APPOINTMENT:  : $jsonData");
        jsonMapData.putIfAbsent("appointmentList", () => jsonData);
      } catch (_) {
        // //print("" + _);
      }

      if (jsonData != null) {
        if (type == "PAST") {
          setState(() {
            tempPastAppointmentHistoryDataList =
                jsonMapData["appointmentList"].map<Appointment>((x) {
              return Appointment.fromJson(x);
            }).toList();
// Past records filtered based on department name since back end didnot implement to be filterred department name
            for (var i = 0;
                i < tempPastAppointmentHistoryDataList.length;
                i++) {
              if (tempPastAppointmentHistoryDataList[i].departmentName ==
                  AppPreferences().deptmentName) {
                // print("$i ..tempPastAppointmentHistoryDataList[i].toJson()");
                // print(tempPastAppointmentHistoryDataList[i].toJson());
                pastAppointmentHistoryDataList
                    .add(tempPastAppointmentHistoryDataList[i]);
              }
              setState(() {});
            }

            pastAppointmentHistoryDataList =
                pastAppointmentHistoryDataList.where((appointment) {
              if (appointment.appointmentStatus.toLowerCase() != "cancelled" &&
                  appointment.appointmentStatus.toLowerCase() != "declined") {
                return true;
              }
              return false;
            }).toList();
          });
          pastAppointmentHistoryDataList.sort((a, b) =>
              DateTime.parse(a.appointmentTiming + " " + a.appointmentStartTime)
                  .compareTo(DateTime.parse(
                      b.appointmentTiming + " " + b.appointmentStartTime)));
        } else {
          setState(() {
            tempUpComingAppointmentHistoryDataList =
                jsonMapData["appointmentList"].map<Appointment>((x) {
              return Appointment.fromJson(x);
            }).toList();
// Future records filtered based on department name since back end didnot implement to be filterred department name
            for (var i = 0;
                i < tempUpComingAppointmentHistoryDataList.length;
                i++) {
              if (tempUpComingAppointmentHistoryDataList[i].departmentName ==
                  AppPreferences().deptmentName) {
                // print(
                //     "$i... Future .. ${tempUpComingAppointmentHistoryDataList[i].departmentName}");
                // print(tempUpComingAppointmentHistoryDataList[i].toJson());
                upComingAppointmentHistoryDataList
                    .add(tempUpComingAppointmentHistoryDataList[i]);
              }
              setState(() {});
            }
            upComingAppointmentHistoryDataList =
                upComingAppointmentHistoryDataList.where((appointment) {
              if (appointment.appointmentStatus.toLowerCase() != "cancelled" &&
                  appointment.appointmentStatus.toLowerCase() != "declined") {
                return true;
              }
              return false;
            }).toList();

            upComingAppointmentHistoryDataList.sort((a, b) => DateTime.parse(
                    a.appointmentTiming + " " + a.appointmentStartTime)
                .compareTo(DateTime.parse(
                    b.appointmentTiming + " " + b.appointmentStartTime)));
          });
        }
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = new TabController(
      length: 3,
      vsync: this,
    );
    setState(() {
      _isLoading = true;
    });
    getAppointmentList("FUTURE");
    getDeclined();
    getTabsOfUser();
  }

  getTabsOfUser() {
    int tabCount = 3;
    List<String> tabTitles = [
      "Upcoming",
      "Past",
      AppPreferences().userCategory == "DOCTOR" ||
              AppPreferences().role == Constants.supervisorRole &&
                  AppPreferences().userCategory != "CONSULTANT"
          ? "Cancelled"
          : "Cancelled"
    ];
    List<String> assetsPaths = [
      "assets/images/Upcoming_24.png",
      "assets/images/Past_32.png",
      "assets/images/declined.png"
    ];
    List<int> appointmentsCount = [
      upComingAppointmentHistoryDataList.length,
      pastAppointmentHistoryDataList.length,
      declinedAppointmentHistoryDataList.length
    ];
    for (int i = 0; i < tabCount; i++) {
      tabBar.add(
        Tab(
          // icon: Image.asset(assetsPaths[i]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                tabTitles[i],
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
              upComingAppointmentHistoryDataList.length > 0
                  ? SizedBox(width: 5.0)
                  : SizedBox.shrink(),
              upComingAppointmentHistoryDataList.length > 0
                  ? GFBadge(
                      child: Text(
                        appointmentsCount[i].toString(),
                        style: TextStyle(color: Colors.black),
                      ),
                      color: Colors.white,
                      shape: GFBadgeShape.pills,
                      size: GFSize.MEDIUM,
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      );
    }
    setState(() {
      tabBar = tabBar;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: AppColors.primaryColor,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NavigationHomeScreen()),
                  ModalRoute.withName(Routes.dashBoard));
            },
          ),
        ],
        centerTitle: true,
        // bottom: TabBar(
        //   controller: _controller,
        //   indicator: BoxDecoration(
        //     borderRadius: BorderRadius.circular(
        //       0.0,
        //     ),
        //     color: Colors.grey,
        //   ),
        //   labelColor: Colors.red,
        //   unselectedLabelColor: Colors.black, // labelColor: Color(0xFFFFFFFF),
        //   tabs: tabBar,
        // ),
      ),
      body: _isLoading == false
          ? mainTabBarView()
          : Center(
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
            ),
    );
  }

  Widget mainTabBarView() {
    return Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
        child: Column(children: [
          // give the tab bar a height [can change hheight to preferred height]
          Container(
            height: 45,
            decoration: BoxDecoration(
              color: AppColors.backupPrimaryColor,
              borderRadius: BorderRadius.circular(
                0.0,
              ),
            ),
            child: TabBar(
              controller: _controller,
              indicator: BoxDecoration(
                // borderRadius: BorderRadius.circular(
                //   0.0,
                // ),
                border: Border(
                    bottom: BorderSide(
                  color: Colors.cyanAccent,
                  width: 3.0,
                )),
                color: AppColors.primaryColor,
              ),
              unselectedLabelColor:
                  Colors.black, // labelColor: Color(0xFFFFFFFF),
              tabs: tabBar,
            ),
          ),
          // tab bar view here
          Expanded(child: tabBarView())
        ]));
  }

  Widget tabBarView() {
    return AppPreferences().userCategory == "DOCTOR" &&
            AppPreferences().userCategory != "CONSULTANT"
        ? TabBarView(
            controller: _controller,
            children: <Widget>[
              upComingAppointmentHistoryDataList.length == 0
                  ? getFutureAppointments()
                  : new TabScreen(
                      doctor, upComingAppointmentHistoryDataList, true),
              pastAppointmentHistoryDataList.length == 0
                  ? getPastAppointments()
                  : new TabScreen(
                      doctor, pastAppointmentHistoryDataList, false),
              declinedAppointmentHistoryDataList.length == 0
                  ? getFutureAppointments()
                  : new TabScreen(
                      doctor, declinedAppointmentHistoryDataList, false)
            ],
          )
        : TabBarView(
            controller: _controller,
            children: <Widget>[
              upComingAppointmentHistoryDataList.length == 0
                  ? getFutureAppointments()
                  : new TabScreen(
                      doctor, upComingAppointmentHistoryDataList, true),
              pastAppointmentHistoryDataList.length == 0
                  ? getPastAppointments()
                  : new TabScreen(
                      doctor, pastAppointmentHistoryDataList, false),
              declinedAppointmentHistoryDataList.length == 0
                  ? getFutureAppointments()
                  : new TabScreen(
                      doctor, declinedAppointmentHistoryDataList, false),
            ],
          );
  }

  Widget getPastAppointments() {
    getAppointmentList("PAST");
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.center,
          child: SizedBox(
            // height: 60,
            // width: 60,
            child: Text('No Data'),
          ),
        ),
      ),
    );
  }

  Widget getFutureAppointments() {
    // getAppointmentList("PAST");
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.center,
          child: SizedBox(
            // height: 60,
            // width: 60,
            child: Text('No Data'),
          ),
        ),
      ),
    );
  }
}

class TabScreen extends StatefulWidget {
  TabScreen(this.doctor, this.appointmentHistoryDataList, this.upComing);

  final List<Appointment> appointmentHistoryDataList;
  final bool upComing;
  final bool doctor;

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  bool showTestButton = false;
  String userCategory;
  String supervisor = AppPreferences().role;
  List<Appointment> appointmentDataFilterList = [];
  bool isDataEmpty = false;
  UserAsDoctorInfo userDoctorInfo;
  String filter =
      AppPreferences().userCategory == "CONSULTANT" ? "My Appointments" : "All";
  List<String> filterCategory = [
    "My Appointments",
    "Doctors",
    "Consultants",
    "All"
  ];
  final GlobalKey _settingsMenuKey = new GlobalKey();
  var controller = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String searchPlaceholder = "Search By Booking Id or Date";
  int selectedSearchOption = 0;
  int selectedUser = 1;
  @override
  initState() {
    super.initState();
    showTestConnect();

    setState(() {
      if (filter == "All") {
        appointmentDataFilterList.addAll(widget.appointmentHistoryDataList);
      } else {
        appointmentDataFilterList = widget.appointmentHistoryDataList
            .where((element) => element.doctorName == AppPreferences().username)
            .toList();
      }

      appointmentDataFilterList = appointmentDataFilterList.reversed.toList();
    });
  }

  filterFunctionality(String value) {
    appointmentDataFilterList.clear();
    List<Appointment> appointmentList = widget.appointmentHistoryDataList;
    if (value == "All") {
      appointmentDataFilterList.addAll(appointmentList);
    } else {
      for (var i = 0; i < appointmentList.length; i++) {
        if (value.toLowerCase() ==
            appointmentList[i].appointmentStatus.toLowerCase()) {
          appointmentDataFilterList.add(appointmentList[i]);
        }
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
        /*Expanded(
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
        ),*/
        TextButton(
          child: Text("Filter by : $chipsValue"),
          onPressed: () {
            displayFilterBottomSheet(context).then((value) {
              if (value != null) {
                setState(() {
                  chipsValue = value;
                });
                // if (localPaymentList != null && localPaymentList.length > 0)
                filterFunctionality(chipsValue);
              }
            });
          },
        )
      ],
    );
  }

  Future displayFilterBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InkWell(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
                  child: Text(
                    "All",
                    style: TextStyle(
                        color: chipsValue == "All"
                            ? Theme.of(context).primaryColor
                            : Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context, "All");
                },
              ),
              InkWell(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
                  child: Text(
                    "Booked",
                    style: TextStyle(
                        color: chipsValue == "Booked"
                            ? Theme.of(context).primaryColor
                            : Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context, "Booked");
                },
              ),
              InkWell(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
                  child: Text(
                    "Confirmed",
                    style: TextStyle(
                        color: chipsValue == "Confirmed"
                            ? Theme.of(context).primaryColor
                            : Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context, "Confirmed");
                },
              ),
            ],
          );
        });
  }

  searchUsers() {
    if (_formKey.currentState.validate() && controller.text.trim().length > 1) {
      setState(() {
        appointmentDataFilterList =
            // widget.appointmentHistoryDataList
            widget.appointmentHistoryDataList.where((element) {
          print(element.appointmentTiming);
          return element.bookingId
                  .toLowerCase()
                  .contains(controller.text.toLowerCase()) ||
              element.appointmentTiming.contains(controller.text);
        }).toList();
        if (appointmentDataFilterList.length == 0) {
          appointmentDataFilterList.clear();
        }
      });
    } else {
      setState(() {
        if (controller.text.trim().length == 0) {
          Fluttertoast.showToast(
              msg: AppLocalizations.of(context).translate("key_entersometext"),
              gravity: ToastGravity.TOP,
              toastLength: Toast.LENGTH_LONG);
        }
      });
    }
  }

  filterAppointmentByUserCategory(int _) {
    appointmentDataFilterList.clear();

    if (controller.text.length > 0) {
      searchUsers();
    } else {
      if (widget.appointmentHistoryDataList.length > 0) {
        appointmentDataFilterList.addAll(widget.appointmentHistoryDataList);
      }
    }
    switch (_) {
      case 1:
        setState(() {
          filter = filterCategory[_ - 1];
          appointmentDataFilterList =
              appointmentDataFilterList.where((element) {
            print(element.doctorFullName);
            print(AppPreferences().userInfo.userFullName);
            return element.doctorFullName ==
                AppPreferences().userInfo.userFullName;
          }).toList();
        });
        break;
      case 2:
        setState(() {
          filter = filterCategory[_ - 1];
          // if
          appointmentDataFilterList = appointmentDataFilterList
              .where((element) => element.doctorCategory == "DOCTOR")
              .toList();
          // widget.appointmentHistoryDataList
          //     .where((element) => element.doctorCategory == "DOCTOR")
          //     .toList();
        });
        break;
      case 3:
        setState(() {
          filter = filterCategory[_ - 1];
          appointmentDataFilterList = appointmentDataFilterList
              .where((element) => element.doctorCategory == "CONSULTANT")
              .toList();
          // //filter list and remove
          // appointmentDataFilterList = appointmentDataFilterList
          // .where((element) => element.doctorCategory == "CONSULTANT" && element.doctorFullName !=
          //   AppPreferences().userInfo.userFullName)
          // .toList();
        });
        break;
      case 4:
        setState(() {
          filter = filterCategory[_ - 1];
          //check if there is no search text , then add else don't add
          if (controller.text.length == 0) {
            appointmentDataFilterList.clear();
            appointmentDataFilterList.addAll(widget.appointmentHistoryDataList);
          }
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // widget.appointmentHistoryDataList.map((element) {
    //   print("============>   ${element.doctorCategory}");
    //   return element.doctorCategory == "CONSULTANT";
    // }).toList();
    return new Scaffold(
      body: new Center(
        child: new Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // widget.upComing ? popUpMenuItems() : Container(),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(
                              horizontal: AppUIDimens.paddingSmall),
                          child: TextFormField(
                            onChanged: (data) {
                              //_filter(data);
                              if (data.length == 0) {
                                setState(() {
                                  appointmentDataFilterList.clear();
                                  appointmentDataFilterList.addAll(
                                      widget.appointmentHistoryDataList);
                                });
                              }
                            },
                            controller: controller,
                            decoration: InputDecoration(
                              labelText: searchPlaceholder,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
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
                            searchUsers();
                            if (AppPreferences().userCategory.toUpperCase() ==
                                "CONSULTANT") {
                              filterAppointmentByUserCategory(selectedUser);
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 8),
                      PopupMenuButton(
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              height: 44,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.done,
                                    color: selectedSearchOption == 1
                                        ? Colors.green
                                        : Colors.transparent,
                                  ),
                                  SizedBox(width: 10),
                                  Text('Booking Id'),
                                ],
                              ),
                              value: 1,
                            ),
                            PopupMenuItem(
                              height: 44,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.done,
                                    color: selectedSearchOption == 2
                                        ? Colors.green
                                        : Colors.transparent,
                                  ),
                                  SizedBox(width: 10),
                                  Text('Date'),
                                ],
                              ),
                              value: 2,
                            ),
                            PopupMenuItem(
                              height: 44,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.done,
                                    color: selectedSearchOption == 3
                                        ? Colors.green
                                        : Colors.transparent,
                                  ),
                                  SizedBox(width: 10),
                                  Text('Clear'),
                                ],
                              ),
                              value: 3,
                            ),
                          ];
                        },
                        onCanceled: () {},
                        onSelected: (value) async {
                          if (value == 1) {
                            searchPlaceholder = "Search By Booking Id";
                          } else if (value == 2) {
                            searchPlaceholder = "Search By  Date";
                          } else if (value == 3) {
                            searchPlaceholder = "Search By Booking Id or Date";
                          }
                          setState(() {
                            selectedSearchOption = value;
                          });
                          if (value == 2) {
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                maxTime: DateTime(2050, 1, 1),
                                minTime: DateTime(2020, 1, 1),
                                theme: WidgetStyles.datePickerTheme,
                                onChanged: (date) {
                              // print('change $date in time zone ' +
                              // date.timeZoneOffset.inHours.toString());
                            }, onConfirm: (date) {
                              var selectedDate = date;
                              setState(() {
                                controller.text = selectedDate.year.toString() +
                                    "-" +
                                    (selectedDate.month > 9
                                        ? selectedDate.month.toString()
                                        : "0" + selectedDate.month.toString()) +
                                    "-" +
                                    (selectedDate.day > 9
                                        ? selectedDate.day.toString()
                                        : "0" + selectedDate.day.toString());
                                appointmentDataFilterList = widget
                                    .appointmentHistoryDataList
                                    .where((element) =>
                                        element.bookingId
                                            .toLowerCase()
                                            .contains(controller.text
                                                .toLowerCase()) ||
                                        element.appointmentTiming
                                            .contains(controller.text))
                                    .toList();
                              });
                            },
                                currentTime: DateTime.now(),
                                locale:
                                    /*AppPreferences().isLanguageTamil() ? LocaleType.ta :*/ LocaleType
                                        .en);
                            // var selectedDate = await picker.showDatePicker(
                            //   firstDate: DateTime(2020, 1, 1),
                            //   lastDate: DateTime(2050, 1, 1),
                            //   context: context,
                            //   initialDate: DateTime.now(),
                            // );
                            // setState(() {
                            //   controller.text = selectedDate.year.toString() +
                            //       "-" +
                            //       (selectedDate.month > 9
                            //           ? selectedDate.month.toString()
                            //           : "0" + selectedDate.month.toString()) +
                            //       "-" +
                            //       (selectedDate.day > 9
                            //           ? selectedDate.day.toString()
                            //           : "0" + selectedDate.day.toString());
                            //   appointmentDataFilterList = widget
                            //       .appointmentHistoryDataList
                            //       .where((element) =>
                            //           element.bookingId.toLowerCase().contains(
                            //               controller.text.toLowerCase()) ||
                            //           element.appointmentTiming
                            //               .contains(controller.text))
                            //       .toList();
                            // });
                          } else {
                            setState(() {
                              controller.text = "";
                              appointmentDataFilterList.clear();
                              appointmentDataFilterList
                                  .addAll(widget.appointmentHistoryDataList);
                            });
                          }
                        },
                        offset: Offset(0, 50),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: const ShapeDecoration(
                            color: Colors.blueGrey,
                            shape: CircleBorder(),
                          ),
                          child: Icon(
                            Icons.filter_list,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
            AppPreferences().userCategory == "CONSULTANT"
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20.0, top: 2, bottom: 8),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey)),
                        child: PopupMenuButton<int>(
                            initialValue: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("$filter"),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Icon(
                                    Icons.filter_list,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                            // key: _settingsMenuKey,
                            itemBuilder: (_) {
                              List<PopupMenuItem<int>> menuItems = [];
                              for (var i = 0; i < filterCategory.length; i++) {
                                menuItems.add(PopupMenuItem(
                                    child: Text(filterCategory[i]),
                                    value: i + 1));
                              }
                              return menuItems;
                            },
                            onSelected: (_) async {
                              selectedUser = _;
                              filterAppointmentByUserCategory(_);
                            }),
                      ),
                    ),
                  )
                : Container(),
            appointmentDataFilterList.length == 0
                ? Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Text("No data found"),
                  )
                : Expanded(
                    child: Container(
                      // height:
                      // widget.upComing
                      //     ? MediaQuery.of(context).size.height * .65 //.65
                      //     :
                      //  MediaQuery.of(context).size.height * .72, //.70,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: appointmentDataFilterList.length,
                          itemBuilder: (context, index) {
                            return Center(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * .95,
                                // height: MediaQuery.of(context).size.height * .20,
                                child: doctorDetails(
                                    widget.doctor,
                                    appointmentDataFilterList[index],
                                    widget.upComing),
                              ),
                            );
                          }),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future<bool> showTestConnect() async {
    showTestButton = await AppPreferences.getAgoraConnectOption();
    setState(() {
      showTestButton = showTestButton;
    });
    userCategory = await AppPreferences.getUserCategory();

    return showTestButton;
    // setState(() {
    //   showTestButton = true;
    // });
  }

  bool getAppointmentDate(Appointment appointmentHistoryData) {
    //TODO: FOR TESTING ADDED RETURN AS TRUE TO SHOW CONNECT BUTTON ALL THE TIME.ONCE TESTING DONE<REMOVE BELOW LINE
    // return true;
    //connect button will be enabled 30mins before untill slot ends

    var appTime = appointmentHistoryData.requestDate +
        " " +
        appointmentHistoryData.appointmentStartTime;
    var appEndTime = appointmentHistoryData.requestDate +
        " " +
        appointmentHistoryData.appointmentEndTime;
    // //print(appTime);
    // appTime = "02/08/2021 22:50:00.000";
    // appEndTime = "02/08/2021 23:30:00.000";

    // debugPrint(
    //     "DATE utility ---> ${DateUtils.convertUTCToLocalTime(appointmentHistoryData.requestDate)}");
    DateTime bookingDate = DateFormat("MM/dd/yyyy HH:mm").parse(appTime);
    DateTime bookingdEnDate = DateFormat("MM/dd/yyyy HH:mm").parse(appEndTime);
    DateTime beforeMin =
        bookingDate.subtract(Duration(minutes: 30)); //before 30mins

    final currentTime = DateTime.now();
    bool isAfterNow = currentTime.isAfter(beforeMin);
    bool isBeforeMinutes = currentTime.isBefore(bookingdEnDate);
    /* debugPrint("Texting isAfterNow");
    debugPrint(isAfterNow.toString());
    if (isAfterNow) {
      showfornow = true;
    } else {
      showfornow = false;
    }
    debugPrint("Texting isAfterNow");
    debugPrint(isAfterNow.toString()); */

    if (isAfterNow && isBeforeMinutes) {
      // do something
      return true;
    }

    return false;
    // return (isAfterNow && isBeforeMinutes);
  }

  Widget doctorDetails(
      bool doctor, Appointment appointmentHistoryData, bool upComing) {
    String bookingDate = appointmentHistoryData.requestDate;
    var color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    String sTime = appointmentHistoryData.appointmentTiming +
        " " +
        appointmentHistoryData.appointmentStartTime;
    String eTime = appointmentHistoryData.appointmentTiming +
        " " +
        appointmentHistoryData.appointmentEndTime;

    var sTime1 = DateFormat("hh:mm a").format(DateTime.parse(sTime));
    var eTime1 = DateFormat("hh:mm a").format(DateTime.parse(eTime));

    String bookingTime = sTime1 + " - " + eTime1;

//  2021-03-06T12:24:54.156

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
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0), bottomLeft: Radius.circular(25.0)),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
        //elevation: 2.0,
        //backgroundColor: Colors.transparent,
        //elevation: 8.0,
        decoration: BoxDecoration(
          color: Colors.white,
          //  borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
                color: Colors.grey[300],
                blurRadius: 1.0,
                spreadRadius: 1.0,
                offset: Offset(1.0, 1.0))
          ],
          border: Border(
            left: BorderSide(
              //                   <--- left side
              color: appointmentHistoryData.appointmentStatus == "BOOKED"
                  ? Colors.blue
                  : appointmentHistoryData.appointmentStatus == "CONFIRMED"
                      ? Colors.green
                      : Colors.red,
              width: 6.0,
            ),
            top: BorderSide(
              //                    <--- top side
              color: Colors.grey[300],
            ),
            right: BorderSide(
              //                    <--- top side
              color: Colors.grey[300],
            ),
            bottom: BorderSide(
              //                    <--- top side
              color: Colors.grey[300],
            ),
          ),
        ),
        /* shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(15.0)),*/
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.28,
                      child: Column(
                        children: [
                          appointmentHistoryData.downloadProfileURL.length == 0
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 3.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: color, width: 2.0),
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.transparent,
                                      child: AvatarLetter(
                                        backgroundColor: Colors.transparent,
                                        textColor: color,
                                        fontSize: 16,
                                        upperCase: true,
                                        numberLetters: 2,
                                        letterType: LetterType.Circular,
                                        text: appointmentHistoryData
                                            .doctorFullName,
                                        textColorHex: null,
                                        backgroundColorHex: null,
                                      ),
                                    ),
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 80,
                                  backgroundColor: Colors.grey,
                                  backgroundImage: NetworkImage(
                                      appointmentHistoryData
                                          .downloadProfileURL),
                                ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                bookingDate,
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 11.0),
                              ),
                              Text(
                                bookingTime,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 11.0),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                        ],
                      ),
                    ),
                    VerticalDivider(
                      thickness: 1.0,
                      color: Colors.grey[300],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              !doctor
                                  ? appointmentHistoryData.doctorName ==
                                              AppPreferences().username &&
                                          AppPreferences().userCategory ==
                                              "CONSULTANT"
                                      ? "Self"
                                      : appointmentHistoryData
                                                  .doctorFullName.length ==
                                              0
                                          ? appointmentHistoryData.doctorName
                                          : appointmentHistoryData
                                              .doctorFullName
                                  : appointmentHistoryData
                                              .patientFullName.length ==
                                          0
                                      ? appointmentHistoryData.patientName
                                      : appointmentHistoryData.patientFullName,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "${appointmentHistoryData.bookingId}",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ],
                        ),
                        Text(
                          "Created At " +
                              DateUtils.convertUTCToLocalTimeCheckIn(
                                      appointmentHistoryData.createdOn)
                                  .split(" ")[0],
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.black, fontSize: 12.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Divider(color: Colors.grey, height: 1.5),
            Container(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
              ),
              color: appointmentHistoryData.appointmentStatus == "BOOKED"
                  ? Colors.blue.withOpacity(0.05)
                  : appointmentHistoryData.appointmentStatus == "CONFIRMED"
                      ? Colors.green.withOpacity(0.05)
                      : Colors.red.withOpacity(0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: appointmentHistoryData.appointmentStatus == "BOOKED"
                        ? Colors.blue
                        : appointmentHistoryData.appointmentStatus ==
                                "CONFIRMED"
                            ? Colors.green
                            : Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 5.0, right: 5, top: 2, bottom: 2),
                      child: Text("${appointmentHistoryData.appointmentStatus}",
                          style: TextStyle(color: Colors.white, fontSize: 10)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        showConnectButton(upComing, appointmentHistoryData)
                            ? Container(
                                //color:Colors.orange,

                                child: InkWell(
                                  onTap: () {
                                    onJoin(
                                      appointmentHistoryData.doctorId,
                                      appointmentHistoryData.bookingId,
                                      appointmentHistoryData.patientName,
                                      appointmentHistoryData,
                                      true,
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.video_call,
                                          color: AppColors.primaryColor),
                                      SizedBox(width: 5),
                                      Text(
                                          userCategory == "DOCTOR"
                                              ? "Launch"
                                              : supervisor ==
                                                      Constants.supervisorRole
                                                  ? "Launch"
                                                  : "Connect",
                                          style: TextStyle(
                                              color: AppColors.primaryColor,
                                              fontSize: 10.0)),
                                    ],
                                  ),
                                ),
                              )
                            : Text(""),
                        showConnectButton(upComing, appointmentHistoryData)
                            ? Row(
                                children: [
                                  SizedBox(
                                    width: 3.5,
                                  ),
                                  SizedBox(
                                    child: Container(
                                      width: 1,
                                      height: 15,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3.5,
                                  ),
                                ],
                              )
                            : Container(),
                        showTestButton
                            ? Container(
                                //color:Colors.orange,

                                child: InkWell(
                                  onTap: () {
                                    onJoin(
                                      appointmentHistoryData.doctorId,
                                      appointmentHistoryData.bookingId,
                                      appointmentHistoryData.patientName,
                                      appointmentHistoryData,
                                      false,
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.video_call,
                                          color: AppColors.primaryColor),
                                      SizedBox(width: 5),
                                      Text(
                                          userCategory == "DOCTOR"
                                              ? "Test Launch"
                                              : supervisor ==
                                                      Constants.supervisorRole
                                                  ? "Test Launch"
                                                  : "Test Connect",
                                          style: TextStyle(
                                              color: AppColors.primaryColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10.0)),
                                    ],
                                  ),
                                ),
                              )
                            : Text(""),
                        showTestButton
                            ? Row(
                                children: [
                                  SizedBox(
                                    width: 3.5,
                                  ),
                                  SizedBox(
                                    child: Container(
                                      width: 1,
                                      height: 15,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3.5,
                                  ),
                                ],
                              )
                            : Container(),
                        Container(
                          //color:Colors.green,

                          child: InkWell(
                            onTap: () async {
                              bool refresh = await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      AppointmentDetails(
                                          color: color,
                                          appointmentDetails:
                                              appointmentHistoryData,
                                          willTestConnect: showTestButton,
                                          isUpcoming: upComing,
                                          willShowConnect: showConnectButton(
                                            upComing,
                                            appointmentHistoryData,
                                          ),
                                          enableFeedback: showConnectButton(
                                            upComing,
                                            appointmentHistoryData,
                                          )),
                                ),
                              );
                              refreshList(refresh);
                            },
                            child: Row(
                              children: [
                                Icon(Icons.visibility,
                                    color: AppColors.primaryColor),
                                SizedBox(width: 5),
                                Text(
                                  "View",
                                  style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 10.0),
                                ),
                              ],
                            ),
                          ),
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

  bool showConnectButton(
    bool upComing,
    Appointment appointmentHistoryData,
    /* bool showForNow */
  ) {
    return upComing &&
        getAppointmentDate(appointmentHistoryData) &&
        appointmentHistoryData.appointmentStatus.toLowerCase() ==
            "confirmed"; //  &&
    // showForNow;
  }

  Future<void> onJoin(String channelId, String bookingId, String patientName,
      Appointment appointment, bool isLaunch) async {
    // update input validation
    // await for camera and mic permissions before pushing video page
    AppointmentsRepo repo = AppointmentsRepo();
    // ignore: non_constant_identifier_names
    //print(Token);
    if (userCategory != "DOCTOR" && supervisor != Constants.supervisorRole) {
      if (appointment.generatedToken.length == 0) {
        showCallAlert();
      } else {
        String token = await repo.getAppointmentsToken(bookingId, patientName);

        await _handleCameraAndMic();
        var userInfo = await getUserInfo(appointment.patientName);
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Constants.VIDEO_CALLING_MODERN
                ? VideoCallScreen(
                    channelName: bookingId, // "abc", //channelId,
                    token: token,
                    role: ClientRole.Broadcaster,
                    sessionRole: SessionRole.doctor,
                    appointment: appointment,
                    isLaunch: isLaunch,
                    referenceId: userInfo.sourceReferenceId,
                  )
                : CallPage(
                    channelName: bookingId, // "abc", //channelId,
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
      var userInfo = await getUserInfo(appointment.patientName);
      // push video page with given channel name
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
                  referenceId: userInfo.sourceReferenceId ?? "",
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

  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [
        PermissionGroup.camera,
        PermissionGroup.microphone,
        PermissionGroup.storage,
        PermissionGroup.photos,
      ],
    );
  }

  refreshList(refresh) {
    if (refresh != null && refresh) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => NavigationHomeScreen()),
          ModalRoute.withName(Routes.dashBoard));
    }
  }

  Future<UserAsDoctorInfo> getUserInfo(userName) async {
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
}
