import '../ui_utils/widget_styles.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../repo/common_repository.dart';
import '../ui/advertise/adWidget.dart';
import '../ui/booking_appointment/models/doctor_info.dart';
import '../ui/customDatePicker.dart' as picker;
import '../ui_utils/app_colors.dart';
import '../ui_utils/text_styles.dart';
import '../utils/alert_utils.dart';
import 'package:time/time.dart';
import '../utils/app_preferences.dart';
import '../utils/validation_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'custom_drawer/custom_app_bar.dart';
import '../widgets/submit_button.dart';
import 'package:intl/intl.dart';
import '../event_schedul//doctor_schedule_info.dart';
import '../login/utils.dart';
import '../login/api/api_calling.dart';
import '../login/utils/custom_progress_dialog.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

typedef VoidCallback = void Function(bool isSlotAdded);

class DoctorAvailabilityScreen extends StatefulWidget {
  final VoidCallback callbackForSlotAdded;
  final DateTime fromDate;
  final UserAsDoctorInfo userInfo;
  DoctorAvailabilityScreen({
    Key key,
    @required this.callbackForSlotAdded,
    this.fromDate,
    this.userInfo,
  }) : super(key: key);

  @override
  _DoctorAvailabilityScreenState createState() =>
      new _DoctorAvailabilityScreenState();
}

class _DoctorAvailabilityScreenState extends State<DoctorAvailabilityScreen> {
  // List<bool> setDay = [true, true, true, true, true, true, true];
  // List<String> selectedDateList = new List(7);
  List<String> startHourList = new List(100);
  List<String> startMinuteList = new List(100);
  List<String> startPeriodList = new List(100);

  List<String> startDurationList = new List(100);
  List<String> endHourList = new List(100);
  List<String> endMinuteList = new List(100);
  List<String> endPeriodList = new List(100);
  List<int> slotCountList = new List(100);

  TimeOfDay start, end;
  bool _autoValidate = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var startHourController = TextEditingController();
  var startMinuteController = TextEditingController();
  var endHourController = TextEditingController();
  var endMinuteController = TextEditingController();
  var slotHourController = TextEditingController();
  var slotMinuteController = TextEditingController();
  String _startHour = "";
  String _startMinute = "";
  String _endHour = "";
  String _endMinute = "";
  String _slotHour = "";
  String _startDate = "";
  String _endDate = "";
  DateTime _startDateFormat;
  DateTime _endDateFormat;
  String _startDateLbl = "";
  String _endDateLbl = "";
  int totalDays = 0;
  List<Map<String, dynamic>> slots = [];
  DateTime finalEndTime;
  DateTime finalStartTime;
  // [{'_startHour': "", "_startMinute": "", "_endHour": "", "_endMinute": ""}]; //
  Map<String, dynamic> slot = {
    '_startHour': "",
    "_startMinute": "",
    "_endHour": "",
    "_endMinute": ""
  };
  List<Map> weekDays = [
    {"day": "Mon", "isSelected": false, "enabled": false},
    {"day": "Tue", "isSelected": false, "enabled": false},
    {"day": "Wed", "isSelected": false, "enabled": false},
    {"day": "Thu", "isSelected": false, "enabled": false},
    {"day": "Fri", "isSelected": false, "enabled": false},
    {"day": "Sat", "isSelected": false, "enabled": false},
    {"day": "Sun", "isSelected": false, "enabled": false},
  ];
  final _controller = ScrollController();

  // int index = 1;
  bool plusIcon = true;
  DateTime selectedDate = DateTime.now();

  List<int> createdSlot = [];

  List<int> scheduleDurationList = [15, 30, 45, 60, 90, 120];

  Future<void> _selectDate(BuildContext context, String type) async {
// openDateSelector(String type) {

    DateTime initialDate = DateTime.now();
    DateTime lastDate =
        new DateTime(initialDate.year, initialDate.month + 2, initialDate.day);
//(date.year, date.month - 1, date.day);

    if (type == 'end') {
      //cehk if start date is selected or not . if not selected show toast for selecting start date then enddate
      if (_startDate.length == 0) {
        Utils.toasterMessage("Please select from date first");
        return;
      } else {
        initialDate = _startDateFormat;
      }
    }

    DatePicker.showDatePicker(context,
        showTitleActions: true,
        maxTime: lastDate,
        minTime: DateTime.now(), //.subtract(Duration(days: 43830)),
        theme: WidgetStyles.datePickerTheme, onChanged: (date) {
      // print('change $date in time zone ' +
      // date.timeZoneOffset.inHours.toString());
    }, onConfirm: (date) {
      // print('confirm $date');

      // setState(() {
      //   controller.text =
      //       DateFormat(DateUtils.defaultDateFormat).format(date.toLocal());
      // });
      // _filter(DateFormat(DateUtils.defaultDateFormat).format(date.toLocal()));

      var picked = date;
      if (date != null)
        setState(() {
          if (type == "start") {
            _startDate = setCreatedDate(picked, "start", 'MM/dd/yyyy');
            _startDateLbl = setCreatedDate(picked, "start", 'dd-MMM-yyyy');
            _startDateFormat = picked;
          } else {
            _endDate = setCreatedDate(picked, "end", 'MM/dd/yyyy');
            _endDateLbl = setCreatedDate(picked, "start", 'dd-MMM-yyyy');

            _endDateFormat = picked;
          }
        });
      if (_endDateFormat != null && _startDateFormat != null) {
        totalDays = _endDateFormat.difference(_startDateFormat).inDays;
        totalDays = totalDays == 0 ? 1 : totalDays + 1;

        //once date is changed refresh weekDay Array
        weekDays = [
          {"day": "Mon", "isSelected": false, "enabled": false},
          {"day": "Tue", "isSelected": false, "enabled": false},
          {"day": "Wed", "isSelected": false, "enabled": false},
          {"day": "Thu", "isSelected": false, "enabled": false},
          {"day": "Fri", "isSelected": false, "enabled": false},
          {"day": "Sat", "isSelected": false, "enabled": false},
          {"day": "Sun", "isSelected": false, "enabled": false},
        ];
      }
    },
        currentTime: DateTime.now(),
        locale:
            /*AppPreferences().isLanguageTamil() ? LocaleType.ta :*/ LocaleType
                .en);
  }

  Future<void> _selectDate1(BuildContext context, String type) async {
    DateTime initialDate = DateTime.now();
    DateTime lastDate =
        new DateTime(initialDate.year, initialDate.month + 2, initialDate.day);
//(date.year, date.month - 1, date.day);

    if (type == 'end') {
      //cehk if start date is selected or not . if not selected show toast for selecting start date then enddate
      if (_startDate.length == 0) {
        Utils.toasterMessage("Please select from date first");
        return;
      } else {
        initialDate = _startDateFormat;
      }
    }
    final DateTime picked = await picker.showDatePicker(
        context: context,
        currentDate: initialDate,
        initialDate: initialDate,
        firstDate: initialDate,
        lastDate: lastDate);
    if (picked != null)
      setState(() {
        if (type == "start") {
          _startDate = setCreatedDate(picked, "start", 'MM/dd/yyyy');
          _startDateLbl = setCreatedDate(picked, "start", 'dd-MMM-yyyy');
          _startDateFormat = picked;
        } else {
          _endDate = setCreatedDate(picked, "end", 'MM/dd/yyyy');
          _endDateLbl = setCreatedDate(picked, "start", 'dd-MMM-yyyy');

          _endDateFormat = picked;
        }
      });
    if (_endDateFormat != null && _startDateFormat != null) {
      totalDays = _endDateFormat.difference(_startDateFormat).inDays;
      totalDays = totalDays == 0 ? 1 : totalDays + 1;

      //once date is changed refresh weekDay Array
      weekDays = [
        {"day": "Mon", "isSelected": false, "enabled": false},
        {"day": "Tue", "isSelected": false, "enabled": false},
        {"day": "Wed", "isSelected": false, "enabled": false},
        {"day": "Thu", "isSelected": false, "enabled": false},
        {"day": "Fri", "isSelected": false, "enabled": false},
        {"day": "Sat", "isSelected": false, "enabled": false},
        {"day": "Sun", "isSelected": false, "enabled": false},
      ];
    }
  }

  String makeTimeFormat(String time) {
    if (time.length == 1) {
      return "0" + time;
    }
    return time;
  }

  Future<void> _selectTime(
      BuildContext context, final String type, int intex) async {
    if (type == "end" && start == null) {
      //Please select Start Time first
      Utils.toasterMessage("Please select start time first");
    } else {
      final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime:
            start != null ? start : TimeOfDay.fromDateTime(DateTime.now()),
      );
      if (picked != null)
        setState(() {
          if (type == "start") {
            start = picked;
            String t = picked.hourOfPeriod.toString() +
                ":" +
                picked.minute.toString() +
                " " +
                picked.period.toString().split(".").last;
            _startHour = makeTimeFormat(picked.hour.toString());
            _startMinute = makeTimeFormat(picked.minute.toString());
            startHourList[intex] = picked.hourOfPeriod.toString().length == 1
                ? "0" + picked.hourOfPeriod.toString()
                : picked.hourOfPeriod.toString();
            startMinuteList[intex] = picked.minute.toString().length == 1
                ? "0" + picked.minute.toString()
                : picked.minute.toString();
            startPeriodList[intex] =
                picked.period.toString().split(".").last.toUpperCase();
          } else {
            final now = new DateTime.now();
            DateTime startTime = DateTime(
                now.year, now.month, now.day, start.hour, start.minute);
            DateTime endTime = DateTime(
                now.year, now.month, now.day, picked.hour, picked.minute);
            //if date selected is more than 1 day , endTime will be month + 1

            if (_startDateFormat != null && _endDateFormat != null) {
              int daysNum = _endDateFormat.difference(_startDateFormat).inDays;
              if (daysNum > 0) {
                endTime = new DateTime(now.year, now.month, now.day + 1);
              }
            }
            bool isBeforeOrOnTime = endTime.isBefore(startTime) ||
                endTime.isAtSameMomentAs(startTime);
            if (isBeforeOrOnTime) {
              Utils.toasterMessage("Please select correct slot time");
              return;
            } else {
              end = picked;
              // endHourList[intex] = picked.hour.toString();
              // endMinuteList[intex] = picked.minute.toString();
              endHourList[intex] = picked.hourOfPeriod.toString().length == 1
                  ? "0" + picked.hourOfPeriod.toString()
                  : picked.hourOfPeriod.toString();
              endMinuteList[intex] = picked.minute.toString().length == 1
                  ? "0" + picked.minute.toString()
                  : picked.minute.toString();
              endPeriodList[intex] =
                  picked.period.toString().split(".").last.toUpperCase();

              _endHour = makeTimeFormat(picked.hour.toString());
              _endMinute = makeTimeFormat(picked.minute.toString());
            }
          }

//calculate time diff, if end time is selecte first its throwing exception
          if (start != null && end != null) {
            final now = new DateTime.now();
            finalStartTime = DateTime(
                now.year, now.month, now.day, start.hour, start.minute);
            finalEndTime =
                DateTime(now.year, now.month, now.day, end.hour, end.minute);
            //if start hour is more than end hour
            // if (finalEndTime.hour < start.hour) {
            //   finalEndTime = new DateTime(
            //       now.year, now.month, now.day + 1, end.hour, end.minute);
            // }
            final difference =
                finalEndTime.difference(finalStartTime).inMinutes;
            slotCountList[intex] = getTotalSlots(difference);

            // if (difference < 0) {
            //   Utils.toasterMessage("Select valid time");
            //   startDurationList[intex] = "";
            // } else {
            // startDurationList[intex] = difference.abs().toString();
            // }

            // double _doubleYourTime =
            //     end.hour.toDouble() + (end.minute.toDouble() / 60);
            // double _doubleNowTime =
            //     start.hour.toDouble() + (start.minute.toDouble() / 60);

            // double _timeDiff = _doubleYourTime - _doubleNowTime;
            // int _minute = (_timeDiff * 60).round();//.abs();
            // startDurationList[intex] = _minute.toString();
          }

          _formSlots();
        });
    }
  }

  _formSlots() {
    if (_startHour.length > 0 &&
        _startMinute.length > 0 &&
        _endHour.length > 0 &&
        _endMinute.length > 0) {
      Map<String, dynamic> slotObj = {
        '_startHour': _startHour,
        "_startMinute": _startMinute,
        "_endHour": _endHour,
        "_endMinute": _endMinute
      };
      slots.removeLast(); //As empty slot is added when + button is tapped
      slots.add(slotObj);
    }
  }

  List<DateTime> getDaysInBeteween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  List<String> getDayNamesInBeteweenStartAndEndDate(
      DateTime startDate, DateTime endDate) {
    List<String> days = [];
    var dayFormatter = new DateFormat('EEEE');
    int daysDiff = endDate.difference(startDate).inDays;

    for (int i = 0; i <= daysDiff; i++) {
      String dayFormatted = dayFormatter.format(DateTime(
          startDate.year,
          startDate.month,
          // In Dart you can set more than. 30 days, DateTime will do the trick
          startDate.day + i));
      days.add(dayFormatted);
      // if(dayFormatted!=null)

    }
    return days;
  }

  List<String> getSelectedDays() {
    List<String> selectedDays = [];
    for (int i = 0; i < weekDays.length; i++) {
      if (weekDays[i]["isSelected"] == true) {
        selectedDays.add(weekDays[i]["day"]);
      }
    }
    return selectedDays;
  }

  List<String> getDaysInBeteweenStartAndEndDate(
      DateTime startDate, DateTime endDate) {
    List<String> days = [];

    var formatter = new DateFormat('MM/dd/yyyy');
    var dayFormatter = new DateFormat('EEEE');
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      String dayFormatted = dayFormatter.format(DateTime(
          startDate.year,
          startDate.month,
          // In Dart you can set more than. 30 days, DateTime will do the trick
          startDate.day + i));
      for (int j = 0; j < getSelectedDays().length; j++) {
        if (dayFormatted.substring(0, 3).toLowerCase() ==
            getSelectedDays()[j].substring(0, 3).toLowerCase()) {
          String day = formatter.format(DateTime(
              startDate.year,
              startDate.month,
              // In Dart you can set more than. 30 days, DateTime will do the trick
              startDate.day + i));

          days.add(day);
        }
      }
      // if (setDay[daysNames.indexOf(dayFormatted.trim())]) {
      //   String day = formatter.format(DateTime(
      //       startDate.year,
      //       startDate.month,
      //       // In Dart you can set more than. 30 days, DateTime will do the trick
      //       startDate.day + i));

      //   days.add(day);
      // }
      // if(dayFormatted!=null)

    }
    return days;
  }

  String setCreatedDate(DateTime _date, String type, String format) {
    final DateFormat formatter = DateFormat(format);
    final String formatted = formatter.format(_date);
    if (type == "start") {
    } else if (type == "end") {}

    return formatted;
  }

  _addItem() {
    setState(() {
      if (slots.length > 0) {
        int currentIndex = slots.length - 1;
        Map<String, dynamic> slotObj = slots[currentIndex];

        if (slotObj["_startHour"].length == 0 ||
            slotObj["_startMinute"].length == 0 ||
            slotObj["_endHour"].length == 0 ||
            slotObj["_endMinute"].length == 0) {
          //If any data is not filled , we should not allow to to add next slot
          Utils.toasterMessage("Please fill current slot fields");
        } else {
          //once slot is added with full data , make the data empty
          _startHour = "";
          _startMinute = "";
          _endHour = "";
          _endMinute = "";
          createdSlot.add(30);
          slots.add(slot);
        }
      } else {
        createdSlot.add(30);
        slots.add(slot);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    //remove time from date, as calculation of days are getting wrong because of time in fromdate
    var dayFormatter = new DateFormat('yyyy-MM-dd');
    final DateTime formattedDate =
        dayFormatter.parse(widget.fromDate.toString());
    _startDateFormat = formattedDate;
    _startDate = setCreatedDate(_startDateFormat, "start", 'MM/dd/yyyy');
    _startDateLbl = setCreatedDate(_startDateFormat, "start", 'dd-MMM-yyyy');

    /// Initialize Admob
    initializeAd();
  }

  @override
  void dispose() {
    super.dispose();
  }

  BoxDecoration selectDayBoxDecoration() {
    return BoxDecoration(
      border: Border.all(),
      color: Colors.blue[600],
      borderRadius: BorderRadius.circular(5.0),
    );
  }

  BoxDecoration unSelectDayBoxDecoration() {
    return BoxDecoration(
      border: Border.all(),
      color: Colors.white,
      borderRadius: BorderRadius.circular(5.0),
    );
  }

  BoxDecoration _containerBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: Colors.blue[600]),
      color: Colors.white,
      borderRadius: BorderRadius.circular(5.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: CustomAppBar(title: "Set Availability", pageId: 0),
      body: Column(
        children: [
          Expanded(
            child: Container(
                margin: new EdgeInsets.only(left: 10.0, right: 10.0, top: 15),
                child: Column(children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            child: Text(
                              "Date",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            )),
                      ]),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            decoration: _containerBoxDecoration(),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 0),
                                              child: Text(
                                                "From : ",
                                                style:
                                                    TextStyles.headerTextStyle,
                                              )),
                                          Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Row(children: [
                                              Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 0),
                                                  child: Text(
// _showingDateFormat
//  DateFormat("dd-MMM-yyyy").format(DateTime.parse(_startDate)),
                                                    _startDateLbl,
                                                    style: TextStyles
                                                        .headerTextStyle,
                                                  )),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 0, vertical: 0),
                                                child: new InkWell(
                                                  child: new Icon(
                                                    Icons.date_range,
                                                    color:
                                                        AppColors.primaryColor,
                                                  ),
                                                  onTap: () {
                                                    _selectDate(
                                                        context, "start");
                                                  },
                                                ),
                                              )
                                            ]),
                                          )
                                        ]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 0),
                                              child: Text(
                                                "To :     ",
                                                style:
                                                    TextStyles.headerTextStyle,
                                              )),
                                          Row(children: [
                                            Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 0),
                                                child: Text(
                                                  _endDateLbl,
                                                  style: TextStyles
                                                      .headerTextStyle,
                                                )),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 3, vertical: 0),
                                              child: new InkWell(
                                                child: new Icon(
                                                    Icons.date_range,
                                                    color:
                                                        AppColors.primaryColor),
                                                onTap: () {
                                                  _selectDate(context, "end");
                                                },
                                              ),
                                            )
                                          ])
                                        ]),
                                  ),
                                ]))
                      ]),
                  // SizedBox(height: 20),
                  // Row(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [Text("Total days: " + totalDays.toString())]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            child: Text(
                              "Select Days",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            )),
                      ]),
                  Container(
                    padding: EdgeInsets.all(8),
                    height: 115,
                    child: selectDaysGridView(),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 1,
                          color: AppColors.primaryColor,
                        ),
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  Column(children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              child: Text(
                                "Slots",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w700),
                              )),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            child: new IconButton(
                              icon: new Icon(Icons.add_circle,
                                  color: Colors.blue),
                              highlightColor: Colors.blue,
                              onPressed: () {
                                if (getSelectedDays().length > 0) {
                                  _addItem();
                                  _controller.animateTo(
                                      (150.0 *
                                          slots
                                              .length), // 100 is the height of container and index of 6th element is 5
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeOut);
                                } else {
                                  AlertUtils.showAlertDialog(context,
                                      "Please select days of availability");
                                }
                                /*    _selectTime(context,"start");*/
                              },
                            ),
                          )
                        ]),

                    // SizedBox(
                    //   height: 10,
                    // )
                  ]),
                  Expanded(
                    child: Container(
                      child: ListView.builder(
                          controller: _controller,
                          shrinkWrap: true,
                          itemCount: slots.length,
                          itemBuilder: (context, index) =>
                              this._doctorAvailUI(index)),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: new SubmitButton(
                      text: "Submit",
                      onPress: () async {
                        if (_startDateFormat != null &&
                            _endDateFormat != null) {
                          if (slots.isEmpty) {
                            Utils.toasterMessage("Please add a slot");
                          } else {
                            if (getSelectedDays().length > 0) {
                              apiCall();
                            } else {
                              AlertUtils.showAlertDialog(context,
                                  "Please select days of availability");
                            }
                          }
                        } else {
                          Utils.toasterMessage(
                              "Please fill the From and To dates");
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10)
                ])),
          ),

          /// Show Banner Ad
          getSivisoftAdWidget(),
        ],
      ),
    );
  }

  Widget selectDaysGridView() {
    if (_startDateFormat != null && _endDateFormat != null) {
      List<String> availableDays = getDayNamesInBeteweenStartAndEndDate(
          _startDateFormat, _endDateFormat);

      for (int j = 0; j < weekDays.length; j++) {
        for (int i = 0; i < availableDays.length; i++) {
          String d = availableDays[i].substring(0, 3);
          if (d == weekDays[j]["day"]) {
            weekDays[j]["enabled"] = true;
          }
        }
      }
    }

    return GridView.builder(
        // padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        //  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
        //     childAspectRatio: 1.0, crossAxisCount: 3),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2,
        ),
        physics: NeverScrollableScrollPhysics(),
        itemCount: weekDays.length,
        itemBuilder: (context, index) {
          Color boxBgColor = Colors.grey;
          Color textColor = AppColors.primaryColor;
          if (weekDays[index]['enabled']) {
            if (weekDays[index]['isSelected']) {
              boxBgColor = AppColors.primaryColor;
              textColor = Colors.white;
            } else {
              boxBgColor = Colors.white;
            }
          }
          Color boxBorderColor = Colors.grey;
          if (weekDays[index]['enabled']) {
            if (weekDays[index]['isSelected']) {
              boxBgColor = AppColors.primaryColor;
            } else {
              boxBgColor = Colors.white;
            }
          }
          return InkWell(
              onTap: () {
                setState(() {
                  if (weekDays[index]['enabled'] == true) {
                    setState(() {
                      weekDays[index]['isSelected'] =
                          !weekDays[index]['isSelected'];
                    });
                  } else {
                    Utils.toasterMessage(
                        "Please select From and To Date to enable Days");
                  }
                });
              },
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                    color: boxBgColor,
                    border: Border.all(
                      width: 1,
                      color: boxBorderColor,
                    ),
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                    child: new Text(weekDays[index]['day'],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: textColor))),
              ));
        });
  }

  // void _validateInputs() async {
  //   String doctorId = await AppPreferences.getUsername();
  //   String doctorName = await AppPreferences.getFullName();

  //   CustomProgressLoader.showLoader(context);
  //   DoctorScheduleInfo info = new DoctorScheduleInfo();
  //   info.active = "true";
  //   info.availableDate = _startDate;
  //   info.comments = "";
  //   info.doctorId = doctorId;
  //   info.doctorName = doctorName;
  //   info.endTime = _startHour + ":" + _startMinute;
  //   info.startTime = _endHour + ":" + _endMinute;
  //   info.type = "video";
  //   var Service = new DoctorScheduleEvent();
  //   Service.create(info)
  //       .then((value) => _scaffoldKey.currentState.showSnackBar(new SnackBar(
  //             backgroundColor: Colors.blue,
  //             content: Text('Event Scheduled'),
  //             duration: Duration(seconds: 3),
  //           )));
  //   CustomProgressLoader.cancelLoader(context);
  // }

  Widget _doctorAvailUI(int index) {
    return new Column(
      children: <Widget>[
        Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Container(
              margin: const EdgeInsets.only(top: 0.0, bottom: 20),
              decoration: _containerBoxDecoration(),
              child: Column(
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: Text(
                              "Slot" + " " + (index + 1).toString(),
                              style: TextStyles.headerTextStyle,
                            )),
                      ]),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                        child: Text(
                          "From",
                          style: TextStyles.headerTextStyle,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 40,
                          margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                          child: new TextFormField(
                            onTap: () {
                              _selectTime(context, "start", index);
                            },
                            readOnly: true,
                            style: TextStyles.mlDynamicTextStyle,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 16),
                              border: OutlineInputBorder(),
                              labelText: "Hour",
                            ),
                            keyboardType: TextInputType.text,
                            controller: TextEditingController()
                              ..text = startHourList.elementAt(index),
                            onChanged: (text) => {},
                            /* enabled: false,*/
                            onSaved: (String val) {
                              _startHour = val;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Expanded(
                        child: Container(
                          height: 40,
                          margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                          child: new TextFormField(
                            style: TextStyles.mlDynamicTextStyle,
                            readOnly: true,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 16),
                              errorMaxLines: 1,
                              border: OutlineInputBorder(),
                              labelText: "Minute",
                            ),
                            keyboardType: TextInputType.text,
                            controller: TextEditingController()
                              ..text = startMinuteList.elementAt(index),
                            onChanged: (text) => {},
                            onSaved: (String val) {
                              _startMinute = val;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Expanded(
                        child: Container(
                          height: 40,
                          margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                          child: new TextFormField(
                            style: TextStyles.mlDynamicTextStyle,
                            readOnly: true,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 16),
                              errorMaxLines: 1,
                              border: OutlineInputBorder(),
                              labelText: "AM/PM",
                            ),
                            keyboardType: TextInputType.text,
                            controller: TextEditingController()
                              ..text = startPeriodList.elementAt(index),
                            onChanged: (text) => {},
                            onSaved: (String val) {
                              _startMinute = val;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        height: 40,
                        margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                        child: Text(
                          "To" + "      ",
                          style: TextStyles.headerTextStyle,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 40,
                          margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                          child: new TextFormField(
                            onTap: () {
                              _selectTime(context, "end", index);
                            },
                            readOnly: true,
                            style: TextStyles.mlDynamicTextStyle,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 16),
                              errorMaxLines: 1,
                              border: OutlineInputBorder(),
                              labelText: "Hour",
                            ),
                            controller: TextEditingController()
                              ..text = endHourList.elementAt(index),
                            onChanged: (text) => {},
                            keyboardType: TextInputType.text,
                            onSaved: (String val) {
                              _startHour = val;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Expanded(
                        child: Container(
                          height: 40,
                          margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                          child: new TextFormField(
                            style: TextStyles.mlDynamicTextStyle,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 15),
                              errorMaxLines: 1,
                              border: OutlineInputBorder(),
                              labelText: "Minute",
                            ),
                            readOnly: true,
                            controller: TextEditingController()
                              ..text = endMinuteList.elementAt(index),
                            onChanged: (text) => {},
                            keyboardType: TextInputType.text,
                            validator: ValidationUtils.stateValidation,
                            onSaved: (String val) {
                              _startMinute = val;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Expanded(
                        child: Container(
                          height: 40,
                          margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                          child: new TextFormField(
                            style: TextStyles.mlDynamicTextStyle,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 16),
                              errorMaxLines: 1,
                              border: OutlineInputBorder(),
                              labelText: "AM/PM",
                            ),
                            readOnly: true,
                            controller: TextEditingController()
                              ..text = endPeriodList.elementAt(index),
                            onChanged: (text) => {},
                            keyboardType: TextInputType.text,
                            validator: ValidationUtils.stateValidation,
                            onSaved: (String val) {
                              _startMinute = val;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(
                            left: 5.0, right: 5.0, bottom: 10),
                        child: Text(
                          "Slot Duration" + "",
                          style: TextStyles.headerTextStyle,
                        ),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: DropdownButton<int>(
                          isExpanded: true,
                          value: createdSlot[index],
                          elevation: 6,
                          items: scheduleDurationList.map((int value) {
                            return new DropdownMenuItem<int>(
                              value: value,
                              child: new Text(value.toString()),
                            );
                          }).toList(),
                          onChanged: (_) {
                            setState(() {
                              createdSlot[index] = _;
                              final difference = finalEndTime
                                  .difference(finalStartTime)
                                  .inMinutes;
                              slotCountList[index] = getTotalSlots(difference);
                            });
                          },
                        ),
                      ),
                      Text("Minutes"),
                      true
                          ? Container()
                          : Container(
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 5.0, right: 5.0, bottom: 10),
                                width: MediaQuery.of(context).size.width / 2.2,
                                child: TextFormField(
                                  style: TextStyles.mlDynamicTextStyle,
                                  controller: TextEditingController()
                                    ..text = startDurationList.elementAt(index),
                                  onChanged: (text) => {},
                                  decoration: InputDecoration(
                                      errorMaxLines: 1,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 16),
                                      border: OutlineInputBorder(),
                                      labelText: "Minute"),
                                  keyboardType: TextInputType.number,
                                  readOnly: true,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  onSaved: (String val) {},
                                ),
                              ),
                            ),
                    ],
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        child: Text(
                          slotCountList.elementAt(index) == null
                              ? ""
                              : "Total slots: " +
                                  slotCountList.elementAt(index).toString() +
                                  " " +
                                  "(per day)",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        )),
                  ]),
                ],
              ))
        ]),
      ],
    );
  }

  int getTotalSlots(int differenceInMinutes) {
    //get total minutes between two times
    double slotCount = differenceInMinutes / createdSlot.last;
    // int s = (slotCount * totalDays).floor();
    int s = slotCount.floor();
    return s;
  }

  apiCall() async {
    //check if empty slot is there
    for (int i = 0; i < slots.length; i++) {
      Map<String, dynamic> obj = slots[i];
      if (obj["_startHour"].length > 0 &&
          obj["_startMinute"].length > 0 &&
          obj["_endHour"].length > 0 &&
          obj["_endMinute"].length > 0) {
      } else {
        showAlertDialogWidget('Slot error', "Please add slot info", false);
        return;
      }
    }

    String userName = await AppPreferences.getUsername();
    String departmentName = await AppPreferences.getDeptName();
    if (widget.userInfo != null) {
      userName = widget.userInfo.userName;
    }
    if (_startDateFormat != null && _endDateFormat != null) {
      List<String> days =
          getDaysInBeteweenStartAndEndDate(_startDateFormat, _endDateFormat);
      List<DoctorScheduleInfo> data = new List();
      for (int dayIndex = 0; dayIndex < days.length; dayIndex++) {
        for (int i = 0; i < slots.length; i++) {
          // print(slots[i]["_startHour"] + ":" + slots[i]["_startMinute"]);
          var startHour = int.parse(slots[i]["_startHour"]).hours;
          var startMinute = int.parse(slots[i]["_startMinute"]).minutes;
          List<Duration> periods = [];
          var interval = createdSlot[i];
          var iter = 0;
          while (
              (startHour + startMinute + (interval * iter).minutes).inSeconds <=
                  (int.parse(slots[i]["_endHour"]).hours +
                          int.parse(slots[i]["_endMinute"]).minutes)
                      .inSeconds) {
            Duration period = (int.parse(slots[i]["_startHour"]).hours +
                int.parse(slots[i]["_startMinute"]).minutes +
                (interval * iter).minutes);
            periods.add(period);
            iter++;
          }
          var peroidIter = 1;
          // print(periods.length.toString());
          periods.forEach((element) {
            if (peroidIter < periods.length) {
              var splitdate = days[dayIndex].split("/");
              var date = splitdate[2] + "-" + splitdate[0] + "-" + splitdate[1];
              DateTime startdate = DateTime.parse(date + " 00:00:00")
                  .add(Duration(minutes: element.inMinutes));

              DateTime enddate = DateTime.parse(date + " 00:00:00")
                  .add(Duration(minutes: periods[peroidIter].inMinutes));
              if (startdate.difference(DateTime.now()).inMinutes > 0) {
                DoctorScheduleInfo doctorScheduleInfo =
                    new DoctorScheduleInfo();
                doctorScheduleInfo.active = "true";
                doctorScheduleInfo.availabilityStatus = "AVAILABLE";
                doctorScheduleInfo.availableDate = days[dayIndex];
                doctorScheduleInfo.comments = "Good";
                doctorScheduleInfo.departmentName = departmentName;
                doctorScheduleInfo.doctorName = userName;
                // doctorScheduleInfo.startTime = _startHour + ":" + _startMinute;
                // doctorScheduleInfo.endTime = _endHour + ":" + _endMinute;
                doctorScheduleInfo.type = "VIDEO";
                Map<String, dynamic> obj = slots[i];
                if (obj["_startHour"].length > 0 &&
                    obj["_startMinute"].length > 0 &&
                    obj["_endHour"].length > 0 &&
                    obj["_endMinute"].length > 0) {
                  doctorScheduleInfo.startTime = (startdate.hour > 9
                          ? startdate.hour.toString() + ":"
                          : ("0${startdate.hour.toString()}:")) +
                      "${(startdate.minute > 9) ? startdate.minute.toString() : '0' + startdate.minute.toString()}";
                  doctorScheduleInfo.endTime = (enddate.hour > 9
                          ? enddate.hour.toString() + ":"
                          : ("0${enddate.hour.toString()}:")) +
                      "${(enddate.minute > 9) ? enddate.minute.toString() : '0' + enddate.minute.toString()}";
                  data.add(doctorScheduleInfo);
                }
              }
              peroidIter++;
            }
          });
        }
      }

      if (data.length > 0) {
        CustomProgressLoader.showLoader(context);

        String url = WebserviceConstants.baseAppointmentURL +
            "/v2/doctor_availability/department/$departmentName/doctor/$userName";

        http.Response response =
            await APICalling().apiPost(url, json.encode(data));
        CustomProgressLoader.cancelLoader(context);
        if (response.statusCode == 204 ||
            response.statusCode == 200 ||
            response.statusCode == 201) {
          List<dynamic> messages = jsonDecode(response.body);
          List<String> msgList = messages.map((s) => s as String).toList();

          bool isAllSuccess = true;
          List<String> messageList = [];
          List<bool> statusList = [];
          for (int i = 0; i < msgList.length; i++) {
            String msg = msgList[i].split("-").last;
            String status = msgList[i].split("-").first;
            if (status.replaceAll(" ", "").toLowerCase() == "success") {
              statusList.add(true);
            } else {
              statusList.add(false);
            }
            messageList.add(msg);
          }

          if (msgList.length == 1) {
            isAllSuccess = statusList.contains(false) ? false : true;
          }

          showAlertDialogWidget(
              'Set Availability', messageList.join("\n\n"), isAllSuccess);
          widget.callbackForSlotAdded(true);
        } else {
          if (response.statusCode == 500) {
            showAlertDialogWidget('', 'failed', false);
          }
        }
      } else {
        Utils.toasterMessage("Please select proper available timing");
      }
    } else {
      Utils.toasterMessage("Please select From and End date");
    }
  }

  showAlertDialogWidget(String title, String body, bool isPop) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text(
        "OK",
        style: AppPreferences().isLanguageTamil()
            ? TextStyles.tamilStyle
            : TextStyle(fontSize: 15),
      ),
      onPressed: () {
        Navigator.of(context).pop(true);
        if (isPop) {
          Navigator.of(context).pop(true);
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        title,
        maxLines: 2,
        style: AppPreferences().isLanguageTamil()
            ? TextStyles.tamilStyleBold
            : TextStyle(fontSize: 15),
        overflow: TextOverflow.ellipsis,
      ),
      content: Text(
        body,
        style: AppPreferences().isLanguageTamil()
            ? TextStyles.tamilStyle
            : TextStyle(fontSize: 15),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
