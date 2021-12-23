import 'dart:convert';
// import 'dart:js';

import '../event_schedul/doctor_schedule_info.dart';
import '../login/api/api_calling.dart';
import '../login/utils.dart';
import '../login/utils/custom_progress_dialog.dart';
import '../repo/common_repository.dart';
import '../ui/booking_appointment/models/doctor_info.dart';
import '../ui/custom_drawer/custom_app_bar.dart';
import '../utils/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/badge/gf_badge.dart';
import 'package:getwidget/shape/gf_badge_shape.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:table_calendar/table_calendar.dart';
import '../ui_utils/app_colors.dart';
import 'advertise/adWidget.dart';
import 'booking_appointment/models/doctor_availability.dart';
import 'doctor_availability_screen.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import '../ui_utils/icon_utils.dart';

class DoctorSchedulerScreen extends StatefulWidget {
  final UserAsDoctorInfo userInfo;
  DoctorSchedulerScreen(
      {Key key, this.title = "Schedule", this.userInfo = null})
      : super(key: key);

  final String title;

  @override
  _DoctorSchedulerScreenState createState() => _DoctorSchedulerScreenState();
}

class _DoctorSchedulerScreenState extends State<DoctorSchedulerScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  Map<DateTime, List> _events = {};
  List _selectedEvents = [];
  AnimationController _animationController;
  CalendarController _calendarController;
  bool _isLoading = true;
  List<DoctorAvailability> doctorAvailableDates = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final format = DateFormat("hh:mm a");
  TextEditingController _startTimeController;
  TextEditingController _endTimeController;
  String selectedDate = "";
  String _startTime = "";
  String DELETE_SUCCESS_MESSAGE = "Slot deleted successfully";
  String DELETE_FAILED_MESSAGE = "The Slot has been booked";
  String UPDATE_SUCCESS_MESSAGE = "Slot updated successfully";
  String UPDATE_FAILED_MESSAGE = "The Slot has been booked";
  String _endTime = "";
  DateTime selectedDay = DateTime.now();
  var _firstPress = true;
  int duration;
  var alertStartDuration;
  var alertEndDuration;

  @override
  void initState() {
    super.initState();
    selectedDate = DateFormat("MM/dd/yyyy").format(DateTime.now());
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
    getDoctorsAvailabilityList(null);

    initializeAd();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  getDoctorsAvailabilityList(DateTime date) async {
    Map<String, dynamic> jsonMapData = new Map();

    WebserviceHelper helper = WebserviceHelper();
    String loggedInUserName = await AppPreferences.getUsername();
    if (widget.userInfo != null) {
      loggedInUserName = widget.userInfo.userName;
    }
    String departmentName = await AppPreferences.getDeptName();
    Map<String, String> header = {};
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => loggedInUserName);
    header.putIfAbsent("tenant", () => WebserviceConstants.tenant);
    String url = WebserviceConstants.baseAppointmentURL +
        "/v2/doctor_availability/department/$departmentName/doctor/$loggedInUserName/consolidated";
    //https://qa.servicedx.com/isd/v2/doctor_availability/department/ISDHealth/doctor/SCDC10055/consolidated

    final response =
        await helper.get(url, headers: header, isOAuthTokenNeeded: false);

    // debugPrint("response - ${response.toString()}");
    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      List<dynamic> jsonData;
      try {
        jsonData = jsonDecode(response.body);

        jsonMapData.putIfAbsent("doctorAvailabilityList", () => jsonData);
      } catch (_) {
        // print("" + _);
      }

      if (jsonData != null) {
        doctorAvailableDates = jsonMapData["doctorAvailabilityList"]
            .map<DoctorAvailability>((x) => DoctorAvailability.fromJson(x))
            .toList();
        setState(() {
          _isLoading = false;
        });
        setState(() {
          setDoctorDateOnCalendar(date);
        });
      }
    }
    // doctorFilteredList = doctorList;
    setState(() {
      _isLoading = false;
    });
  }

  setDoctorDateOnCalendar(DateTime date) {
    for (int i = 0; i < doctorAvailableDates.length; i++) {
      DoctorAvailability obj = doctorAvailableDates[i];
      DateTime d = DateFormat("MM/dd/yyyy").parse(obj.availableDate);
      _events[d] = obj.slots;
      DateTime selDate = (date == null) ? DateTime.now() : date;
      if (obj.availableDate == DateFormat("MM/dd/yyyy").format(selDate)) {
        _selectedEvents = _events[DateFormat("MM/dd/yyyy")
            .parse(doctorAvailableDates[i].availableDate)];
      }
    } //end of for loop
    setState(() {
      _isLoading = false;
    });
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    // print('CALLBACK: _onDaySelected');
    selectedDay = day;
    selectedDate = DateFormat('MM/dd/yyyy').format(day);
    setState(() {
      _selectedEvents = events ?? [];
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    // print('CALLBACK: _onVisibleDaysChanged');
    selectedDay = first;
    selectedDate = DateFormat('MM/dd/yyyy').format(first);
    setState(() {
      _selectedEvents = _events[first] ?? [];
    });
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    // print('CALLBACK: _onCalendarCreated');
    // _buildEventList(context);
  }
  bool showCreateSlotButton() {
    DateTime initialDate = DateTime.now();

    DateTime lastDate =
        new DateTime(initialDate.year, initialDate.month + 2, initialDate.day);
    final difference = (selectedDay).difference(initialDate).inDays;

    if (selectedDay.isBefore(lastDate) && selectedDay.isAfter(initialDate)) {
      return true;
    } else if (difference == 0) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          /* AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text("Schedule"),
      ), */
          CustomAppBar(title: widget.title, pageId: 0),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
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
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      // Switch out 2 lines below to play with TableCalendar's settings
                      //-----------------------
                      // _buildTableCalendar(),
                      _buildTableCalendarWithBuilders(),
                      const SizedBox(height: 8.0),
                      Expanded(child: _buildEventList(context)),
                    ],
                  ),
          ),

          /// Show Banner Ad
          getSivisoftAdWidget(),
        ],
      ),
      floatingActionButton: showCreateSlotButton()
          ? Container(
              margin: EdgeInsets.only(bottom: 45),
              child: RaisedButton(
                elevation: 6,
                color: AppColors.darkGrassGreen,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 12.0, bottom: 12, left: 5, right: 5),
                  child: Text("Create Slot",
                      style: TextStyle(
                        color: Colors.white,
                      )),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DoctorAvailabilityScreen(
                            callbackForSlotAdded: (bool isSlotAdded) {
                              if (isSlotAdded) {
                                //API call for refreshinh
                                getDoctorsAvailabilityList(selectedDay);
                              }
                            },
                            fromDate: selectedDay,
                            userInfo: widget.userInfo)),
                  );
                },
              ),
            )
          : Container(),
    );
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {
    DateTime initialDate = DateTime.now();
    DateTime lastDate =
        new DateTime(initialDate.year, initialDate.month + 2, initialDate.day);

    return TableCalendar(
      // locale: 'pl_PL',
      endDay: lastDate,
      calendarController: _calendarController,

      events: _events,
      // holidays: _holidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
        holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: Colors.deepOrange[300],
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: Colors.amber[400],
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(Transform.translate(
              offset: Offset(15, -35),
              child: GFBadge(
                child: Text(
                  "${events.length}",
                  style: TextStyle(color: Colors.white),
                ),
                color: AppColors.primaryColor,
                shape: GFBadgeShape.pills,
                size: GFSize.MEDIUM,
              ),
            ));
          }
          return children;
        },
      ),
      onDaySelected: (date, events, holidays) {
        _onDaySelected(date, events, holidays);
        _animationController.forward(from: 0.0);
        _buildEventList(context);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return Row(children: markers(events));
  }

  List<Widget> markers(List events) {
    List<Widget> temp = [];
    for (int i = 0; i < events.length; i++) {
      temp.add(AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue[400],
        ),
        width: 10.0,
        height: 10.0,
      ));
    }
    return temp;
  }

  Widget _buildEventsMarker2(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date)
                ? Colors.brown[300]
                : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  _buildEventList(BuildContext context) {
    // showDialog(
    //     builder: (cxt) {
    //       return AlertDialog(
    //         contentPadding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
    //         title: Row(
    //           children: [
    //             Text("Appointment List"),
    //             Spacer(),
    //             InkWell(
    //               child: Icon(Icons.close),
    //               onTap: () {
    //                 Navigator.pop(context);
    //               },
    //             )
    //           ],
    //         ),
    //         content: Container(
    //           height: 400,
    //           width: MediaQuery.of(context).size.width * 0.9,
    //           child:
// if(){}

    List temp = [], temp2 = [];
    for (var i = 0; i < _selectedEvents.length; i++) {
      String startDateTimeString =
          selectedDate + " " + _selectedEvents[i].startTime + ":00";
      DateTime startDateTime =
          new DateFormat("MM/dd/yyyy HH:mm:ss").parse(startDateTimeString);
      String scheduledDate =
          new DateFormat(DateUtils.defaultDateFormat).format(startDateTime);
      String endDateTimeString =
          selectedDate + " " + _selectedEvents[i].endTime + ":00";
      DateTime endDateTime =
          new DateFormat("MM/dd/yyyy HH:mm:ss").parse(endDateTimeString);
      format.format(endDateTime);
      final now = DateTime.now();
      DateTime selDate = new DateFormat("MM/dd/yyyy").parse(selectedDate);

      final difference = (selDate).difference(now).inDays;
      final timeDifference = (startDateTime).difference(now).inMinutes;
      final duration = (endDateTime).difference(startDateTime).inMinutes;
      if (difference > 0 || timeDifference > 0) {
        temp.add(_selectedEvents[i]);
      } else {
        temp2.add(_selectedEvents[i]);
      }
    }
    // _selectedEvents
    setState(() {
      _selectedEvents = temp + temp2;
    });
    return ListView(
      padding: EdgeInsets.all(8.0),
      children: _selectedEvents.map((event) {
        String startDateTimeString =
            selectedDate + " " + event.startTime + ":00";
        DateTime startDateTime =
            new DateFormat("MM/dd/yyyy HH:mm:ss").parse(startDateTimeString);
        String scheduledDate =
            new DateFormat(DateUtils.defaultDateFormat).format(startDateTime);
        String endDateTimeString = selectedDate + " " + event.endTime + ":00";
        DateTime endDateTime =
            new DateFormat("MM/dd/yyyy HH:mm:ss").parse(endDateTimeString);
        format.format(endDateTime);
        final now = DateTime.now();
        DateTime selDate = new DateFormat("MM/dd/yyyy").parse(selectedDate);

        final difference = (selDate).difference(now).inDays;
        final timeDifference = (startDateTime).difference(now).inMinutes;
        final duration = (endDateTime).difference(startDateTime).inMinutes;
// difference >= 0 && timeDifference > 0

        return Container(
          width: MediaQuery.of(context).size.width * 0.87,
          decoration: BoxDecoration(
            // border: Border.all(width: 0.8),
            color: difference >= 0
                ? (timeDifference > 0 ? Colors.blue[400] : Colors.grey[400])
                : Colors.grey[400],
            borderRadius: BorderRadius.circular(12.0),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ListTile(
//             trailing: FlatButton(
//                 // color: Colors.green,
//                 child: Icon(Icons.delete_forever),
//                 onPressed: () {
// //show alert
//                   deletAlertDialog(
//                       context, "You want to delete the slot.", event);
//                 }),
            title: Row(
              children: [
                Text(
                  "$scheduledDate\n${format.format(startDateTime)} - ${format.format(endDateTime)}",
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
                Spacer(),
                Text(
                  "Duration ${duration} mins",
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
            onTap: () {
              if (difference >= 0) {
                if (timeDifference > 0) {
                  _scheduleEvent("Slot", event);
                } else {
                  Utils.toasterMessage("Slot is not editable");
                }
              } else {
                Utils.toasterMessage("Slot is not editable");
              }
            },
          ),
        );
      }).toList(),
    );
    //     ),
    //   );
    // },
    // context: context);

    // return Container();
  }

  Future deletAlertDialog(
      BuildContext context, String message, DoctorAvailabilitySlot slot) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: 170.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Are you sure ?",
                        style: TextStyle(fontSize: 24.0),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 4.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: Text(
                      message,
                      maxLines: 2,
                    ),
                  ),
                  deleteFlatButton(slot)
                ],
              ),
            ),
          );
        });
  }

  _scheduleEvent(String caption, DoctorAvailabilitySlot slot) {
    String startDateTimeString = selectedDate + " " + slot.startTime + ":00";
    DateTime startDateTime =
        new DateFormat("MM/dd/yyyy HH:mm:ss").parse(startDateTimeString);
    String endDateTimeString = selectedDate + " " + slot.endTime + ":00";
    DateTime endDateTime =
        new DateFormat("MM/dd/yyyy HH:mm:ss").parse(endDateTimeString);

    if (startDateTime.compareTo(DateTime.now()) >= 0) {
      showDialog(
        context: AppPreferences().context,
        builder: (context) => new AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0))),
          title: Row(
            children: [
              Text("Set " + caption),
              Spacer(),
              InkWell(
                  child: Icon(Icons.close),
                  onTap: () {
                    Navigator.of(context).pop();
                    if (_startTimeController != null) {
                      _startTimeController.clear();
                    }
                    // _endTimeController.clear();
                    if (_endTimeController != null) {
                      _endTimeController.clear();
                    }
                  })
            ],
          ),
          contentPadding: const EdgeInsets.all(16.0),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  DateTimeField(
                    controller: _startTimeController,
                    validator: (value) {
                      if (value == null) {
                        return 'Please choose start time';
                      }
                      return null;
                    },
                    // initialValue: DateTime.parse(slot.startTime),
                    decoration: new InputDecoration(
                      prefixIcon: Icon(Icons.access_time),
                      labelText: "Start time",
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    format: format,
                    initialValue: startDateTime,
                    onShowPicker: (context, currentValue) async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                            currentValue ?? DateTime.now()),
                      );

                      _startTime = DateFormat('HH:mm')
                          .format(DateTimeField.convert(time));
                      return DateTimeField.convert(time);
                    },
                  ),
                  SizedBox(height: 10),
                  DateTimeField(
                    controller: _endTimeController,
                    validator: (value) {
                      if (value == null) {
                        return 'Please choose end time';
                      }
                      return null;
                    },
                    initialValue: endDateTime,
                    decoration: new InputDecoration(
                      prefixIcon: Icon(Icons.access_time),
                      labelText: "End time",
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    format: format,
                    onShowPicker: (context, currentValue) async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                            currentValue ?? DateTime.now()),
                      );
                      _endTime = DateFormat('HH:mm')
                          .format(DateTimeField.convert(time));
                      // DateTime.format(DateTimeField.convert(time));

                      //print(DateTimeField.convert(time));

                      return DateTimeField.convert(time);
                    },
                  ),
                  SizedBox(height: 10),
                  Text(
                    "*Deleting slot may contain appointments",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                  // Text("Duration - ${duration} min",
                  //     style: TextStyle(fontSize: 15))
                ],
              ),
            ),
          ),
          //BasicTimeField();
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  color: Colors.green,
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    setState(() {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        if (_startTime.isEmpty) {
                          _startTime = DateFormat('HH:mm').format(
                              DateTimeField.convert(TimeOfDay.fromDateTime(
                                  startDateTime ?? DateTime.now())));
                        }
                        if (_endTime.isEmpty) {
                          _endTime = DateFormat('HH:mm').format(
                              DateTimeField.convert(TimeOfDay.fromDateTime(
                                  endDateTime ?? DateTime.now())));
                        }
                        slot.startTime = _startTime;
                        slot.endTime = _endTime;

                        apiCall(slot, false);

                        // _startTimeController.clear();
                        // _endTimeController.clear();
                      } else {}
                    });
                  },
                ),
                SizedBox(
                  width: 10.0,
                ),
                deleteFlatButton(slot)
              ],
            ),
          ],
        ),
      );
    }
  }

  Widget deleteFlatButton(DoctorAvailabilitySlot slot) {
    _firstPress = true;
    return Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
        child: FlatButton(
          color: Colors.red,
          child: Text(
            'Delete',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            apiCall(slot, true);

            // _startTimeController.clear();
            // _endTimeController.clear();
          },
        ));
  }

//"https://qa.servicedx.com/isd/v2/doctor_availability/id/8469fe30-9e75-419d-96c9-ba862a685bbf"
  apiCall(DoctorAvailabilitySlot slot, bool isForDelete) async {
    CustomProgressLoader.showLoader(context);
    String slotId = slot.id;
    var response;
    String url = WebserviceConstants.baseAppointmentURL +
        "/v2/doctor_availability/id/$slotId";
    if (isForDelete) {
      response = await APICalling.apiDelete(url);
    } else {
      String userName = widget.userInfo != null
          ? widget.userInfo.userName
          : await AppPreferences.getUsername();
      String departmentName = await AppPreferences.getDeptName();

      DoctorScheduleInfo doctorScheduleInfo = new DoctorScheduleInfo();
      doctorScheduleInfo.active = "true";
      doctorScheduleInfo.availabilityStatus = "AVAILABLE";
      doctorScheduleInfo.availableDate = selectedDate;
      doctorScheduleInfo.departmentName = departmentName;
      doctorScheduleInfo.doctorName = userName;
      doctorScheduleInfo.type = "VIDEO";
      doctorScheduleInfo.startTime = slot.startTime;
      doctorScheduleInfo.endTime = slot.endTime;
      doctorScheduleInfo.id = slot.id;
      response = await APICalling.apiPut(url, json.encode(doctorScheduleInfo));
    }
    CustomProgressLoader.cancelLoader(context);
    if (response == 204 || response == 200 || response == 201) {
      // UPDATE THE EVENTS ARRAY
      if (isForDelete) {
        Utils.toasterMessage(DELETE_SUCCESS_MESSAGE);
        if (_selectedEvents.contains(slot)) {
          _selectedEvents.remove(slot);
          setState(() {});
        }
      } else {
        Utils.toasterMessage(UPDATE_SUCCESS_MESSAGE);
      }
    } else {
      if (response == 500) {
        if (isForDelete) {
          Utils.toasterMessage(DELETE_FAILED_MESSAGE);
        } else {
          Utils.toasterMessage(UPDATE_FAILED_MESSAGE);
        }
      }
    }
    Navigator.of(context).pop();
  }
}
