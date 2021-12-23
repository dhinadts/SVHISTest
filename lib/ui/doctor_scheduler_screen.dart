// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:http/http.dart' as http;
// import 'package:unicorndial/unicorndial.dart';
// import 'package:intl/intl.dart';
// import '../event_schedul//eventservice.dart';
// import '../event_schedul//eventmodel.dart';
// import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
// import '../login/utils.dart';
// import '../ui/custom_drawer/custom_app_bar.dart';
// import 'doctor_availability_screen.dart';

// class DoctorSchedulerScreen extends StatefulWidget {
//   static const String id = 'calendar_screen';

//   @override
//   _DoctorSchedulerScreenState createState() => _DoctorSchedulerScreenState();
// }

// class _DoctorSchedulerScreenState extends State<DoctorSchedulerScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   final format = DateFormat("hh:mm a");
//   CalendarController _calendarController;
//   TextEditingController _eventController;
//   TextEditingController _fromDate;
//   TextEditingController _endDate;
//   Map<DateTime, List<dynamic>> _events;
//   List<dynamic> _selectedEvents;
//   SharedPreferences prefs;
//   event regModel = new event();

//   static const _listEventUrl =
//       'https://qa.servicedx.com/subscription/applications/Covid19Test/events/';
//   static final _headers = {
//     'username': 'SuperAdmin',
//     'Content-Type': 'application/json'
//   };

//   List<dynamic> _dataProvince = List();

//   getEvent() async {
//     final _response = await http.get(_listEventUrl, headers: _headers);

//     var listData = jsonDecode(_response.body);
//     setState(() {
//       _dataProvince = listData;
//     });
//     print("data : $listData");
//   }

//   @override
//   void initState() {
//     super.initState();
//     _calendarController = CalendarController();
//     _eventController = TextEditingController();
//     _fromDate = TextEditingController();
//     _endDate = TextEditingController();
//     _events = {};
//     _selectedEvents = [];
//     initPrefs();
//     getEvent();
//   }

//   initPrefs() async {
//     prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _events = Map<DateTime, List<dynamic>>.from(
//           decodeMap(json.decode(prefs.get('events') ?? '{}')));
//     });
//   }

//   // Encode Date Time Helper Method
//   Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
//     Map<String, dynamic> newMap = {};
//     map.forEach((key, value) {
//       newMap[key.toString()] = map[key];
//     });
//     return newMap;
//   }

//   // decode Date Time Helper Method
//   Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
//     Map<DateTime, dynamic> newMap = {};
//     map.forEach((key, value) {
//       newMap[DateTime.parse(key)] = map[key];
//     });
//     return newMap;
//   }

//   @override
//   Widget build(BuildContext context) {
//     var childButtons = List<UnicornButton>();

//     childButtons.add(UnicornButton(
//         hasLabel: true,
//         labelText: "Select Event",
//         currentButton: FloatingActionButton(
//           heroTag: "Select Event",
//           backgroundColor: Colors.blue,
//           mini: true,
//           child: Icon(Icons.assignment),
//           onPressed: () {
//             getEvent().then((result) {
//               _showEvent();
//             });
//           },
//         )));

//     childButtons.add(UnicornButton(
//         hasLabel: true,
//         labelText: "Create Event",
//         currentButton: FloatingActionButton(
//           heroTag: "Create Event",
//           backgroundColor: Colors.blue,
//           mini: true,
//           child: Icon(Icons.event),
//           onPressed: () {
//             _CreateEvent();
//           },
//         )));

//     return new Scaffold(
//       key: _scaffoldKey,
//       appBar: CustomAppBar(title: "Schedule Time", pageId: 0),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             TableCalendar(
//               events: _events,
//               initialCalendarFormat: CalendarFormat.month,
//               formatAnimation: FormatAnimation.slide,
//               startingDayOfWeek: StartingDayOfWeek.sunday,
//               availableGestures: AvailableGestures.all,
//               calendarStyle: CalendarStyle(
//                 weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
//                 holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
//                 //markersColor: Colors.purple,
//                 todayColor: Colors.blueGrey,
//                 selectedColor: Colors.blue,
//                 todayStyle:
//                     TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//               ),
//               daysOfWeekStyle: DaysOfWeekStyle(
//                 weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
//               ),
//               headerStyle: HeaderStyle(
//                 centerHeaderTitle: true,
//                 // if Headtitle, needed enableit
//                 //formatButtonVisible: false,  // if month,week not needed enableit
//                 formatButtonDecoration: BoxDecoration(
//                   color: Colors.blueGrey,
//                   borderRadius: BorderRadius.circular(20.0),
//                 ),
//                 formatButtonTextStyle: TextStyle(color: Colors.white),
//                 formatButtonShowsNext: false,
//               ),
//               builders: CalendarBuilders(
//                 markersBuilder: (context, date, events, holidays) {
//                   final children = <Widget>[];

//                   if (events.isNotEmpty) {
//                     children.add(
//                       Positioned(
//                         right: 1,
//                         top: 1,
//                         child: _buildEventsMarker(date, events),
//                       ),
//                     );
//                   }

//                   if (holidays.isNotEmpty) {
//                     children.add(
//                       Positioned(
//                         right: -2,
//                         top: -2,
//                         child: _buildHolidaysMarker(),
//                       ),
//                     );
//                   }

//                   return children;
//                 },
//               ),
//               calendarController: _calendarController,
//               onDaySelected: (date, events, events1) {
//                 setState(() {
//                   print(date.toIso8601String());
//                   _selectedEvents = events;
//                   print(events);
//                   setDoctorSchedule(date.toString());
//                 });
//               },
//             ),
//             ..._selectedEvents.map(
//               (event) => Padding(
//                 padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.all(5),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.blueGrey, // color border
//                           border: Border.all(width: 0.8),
//                           borderRadius: BorderRadius.circular(12.0),
//                         ),
//                         child: Padding(
//                           padding: EdgeInsets.all(10.0),
//                           child: Text(
//                             event,
//                             style: TextStyle(
//                                 fontSize: 14.0,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.blueGrey,
//         child: Icon(
//           Icons.add,
//           color: Colors.white,
//         ),
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => DoctorAvailabilityScreen()),
//           );
//         },
//       ),

//       /* floatingActionButton: UnicornDialer(
//           backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
//           parentButtonBackground: Colors.blueGrey,
//           orientation: UnicornOrientation.VERTICAL,
//           parentButton: Icon(Icons.add_chart),
//          childButtons: childButtons),*/
//     );
//   }

//   _showEvent() {
//     String _selectedId;
//     showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(20.0))),
//           title: Text('Add Calendar Event:'),
//           content: StatefulBuilder(
//             builder: (BuildContext context, StateSetter setState) {
//               //child: Form();
//               return SingleChildScrollView(
//                 child: Form(
//                   //key: _formKey1,
//                   child: Column(
//                     children: <Widget>[
//                       Container(
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                         decoration: BoxDecoration(
//                             color: Colors.grey[100],
//                             borderRadius: BorderRadius.circular(30)),
//                         child: DropdownButton(
//                           icon: Icon(Icons.arrow_drop_down),
//                           iconSize: 42,
//                           underline: SizedBox(),
//                           isExpanded: true,
//                           hint: const Text("Select Event"),
//                           value: _selectedId,
//                           items: _dataProvince.map((item) {
//                             return DropdownMenuItem(
//                               value: item['eventName'],
//                               child: Text(item['eventName']),
//                             );
//                           }).toList(),
//                           onChanged: (item) {
//                             setState(() {
//                               _selectedId = item;
//                               print(_selectedId);
//                             });
//                           },
//                         ),
//                       ),
//                       SizedBox(height: 10),
//                       new DateTimeField(
//                         controller: _fromDate,
//                         decoration: new InputDecoration(
//                           prefixIcon: Icon(Icons.access_time),
//                           labelText: 'Time',
//                           contentPadding:
//                               const EdgeInsets.symmetric(vertical: 15.0),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(30.0),
//                           ),
//                         ),
//                         format: format,
//                         onShowPicker: (context, currentValue) async {
//                           final time = await showTimePicker(
//                             context: context,
//                             initialTime: TimeOfDay.fromDateTime(
//                                 currentValue ?? DateTime.now()),
//                           );
//                           return DateTimeField.convert(time);
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//           actions: <Widget>[
//             Row(
//               children: <Widget>[
//                 FlatButton(
//                   color: Colors.blueGrey,
//                   child: Text(
//                     'Save',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       _events.update(
//                         _calendarController.selectedDay,
//                         (previousEvents) => previousEvents
//                           ..add(_selectedId + " , Time: " + _fromDate.text),
//                         ifAbsent: () =>
//                             [_selectedId + " , Time: " + _fromDate.text],
//                       );
//                       Navigator.of(context).pop();
//                       _selectedId = '';
//                       _fromDate.clear();
//                     });
//                   },
//                 ),
//                 SizedBox(
//                   width: 10.0,
//                 ),
//                 FlatButton(
//                   color: Colors.grey,
//                   child: Text(
//                     'Cancel',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 )
//               ],
//             ),
//           ],
//         );
//       },
//     );
//   }

//   _CreateEvent() {
//     showDialog(
//       context: context,
//       builder: (context) => new AlertDialog(
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(20.0))),
//         title: Text('Create Event:'),
//         contentPadding: const EdgeInsets.all(16.0),
//         content: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: <Widget>[
//                 SizedBox(height: 10),
//                 TextFormField(
//                   controller: _eventController,
//                   keyboardType: TextInputType.multiline,
//                   maxLines: 1,
//                   validator: (value) {
//                     if (value.isEmpty) {
//                       return 'Please enter a Event';
//                     }
//                     return null;
//                   },
//                   onSaved: (String value) {
//                     print(value);
//                     regModel.eventName = value;
//                   },
//                   decoration: InputDecoration(
//                     prefixIcon: Icon(Icons.edit, color: Colors.grey),
//                     labelText: 'Event Name',
//                     alignLabelWithHint: true,
//                     hintText: 'eg. SDX',
//                     contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30.0),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 DateTimeField(
//                   controller: _fromDate,
//                   validator: (value) {
//                     if (value == null) {
//                       return 'Please choose a Time';
//                     }
//                     return null;
//                   },
//                   decoration: new InputDecoration(
//                     prefixIcon: Icon(Icons.access_time),
//                     labelText: 'Time',
//                     contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30.0),
//                     ),
//                   ),
//                   format: format,
//                   onShowPicker: (context, currentValue) async {
//                     final time = await showTimePicker(
//                       context: context,
//                       initialTime: TimeOfDay.fromDateTime(
//                           currentValue ?? DateTime.now()),
//                     );
//                     //print(DateTimeField.convert(time));
//                     return DateTimeField.convert(time);
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//         //BasicTimeField();
//         actions: <Widget>[
//           Row(
//             children: <Widget>[
//               FlatButton(
//                 color: Colors.blueGrey,
//                 child: Text(
//                   'Save',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     if (_formKey.currentState.validate()) {
//                       _formKey.currentState.save();
//                       regModel.active = 'true';
//                       regModel.applicationName = 'Covid19Test';
//                       regModel.comments = '--';
//                       regModel.eventType = 'sample';

//                       var Service = new CreateEvent();
//                       Service.create(regModel).then((value) =>
//                           _scaffoldKey.currentState.showSnackBar(new SnackBar(
//                             backgroundColor: Colors.blue,
//                             content:
//                                 Text('Event ${value.eventName}! is Created'),
//                             duration: Duration(seconds: 3),
//                           )));
//                       print(_fromDate.text);
//                       if (_eventController.text.isEmpty) return;
//                       if (_events[_calendarController.selectedDay] != null) {
//                         _events[_calendarController.selectedDay].add(
//                             _eventController.text +
//                                 " , Time : " +
//                                 _fromDate.text);
//                       } else {
//                         _events[_calendarController.selectedDay] = [
//                           _eventController.text + " , Time : " + _fromDate.text
//                         ];
//                       }
//                       prefs.setString(
//                           'events', json.encode(encodeMap(_events)));
//                       Navigator.of(context).pop();
//                       _eventController.clear();
//                       _fromDate.clear();
//                     } else {
//                       //_eventController.clear();
//                       //_fromDate.clear();
//                     }
//                   });
//                 },
//               ),
//               SizedBox(
//                 width: 10.0,
//               ),
//               FlatButton(
//                 color: Colors.grey,
//                 child: Text(
//                   'Cancel',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   _eventController.clear();
//                   _fromDate.clear();
//                 },
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEventsMarker(DateTime date, List events) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: _calendarController.isSelected(date)
//             ? Colors.blueGrey[500]
//             : _calendarController.isToday(date)
//                 ? Colors.blue[400]
//                 : Colors.blue[400],
//       ),
//       width: 16.0,
//       height: 16.0,
//       child: Center(
//         child: Text(
//           '${events.length}',
//           style: TextStyle().copyWith(
//             color: Colors.white,
//             fontSize: 12.0,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHolidaysMarker() {
//     return Icon(
//       Icons.add_box,
//       size: 20.0,
//       color: Colors.blueGrey[800],
//     );
//   }

//   void setDoctorSchedule(String _date) {
//     List<String> dateList;
//     if (_date.split('T') != null) {
//       dateList = _date.split(' ');
//     }
//     if (dateList[0] != null) {
//       DateFormat format = DateFormat("yyyy-MM-dd");
//       DateTime dateNow = format.parse(format.format(DateTime.now()));
//       DateTime dateCheck = format.parse(dateList[0]);
//       if (dateCheck.difference(dateNow).inDays == 0 ||
//           dateCheck.isAfter(dateNow)) {
//         _scheduleEvent("Schedule Time");
//       } else {
//         Utils.toasterMessage("Can not book past days");
//       }
//     }
//   }

//   _scheduleEvent(String caption) {
//     showDialog(
//       context: context,
//       builder: (context) => new AlertDialog(
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(20.0))),
//         title: Text("Set " + caption),
//         contentPadding: const EdgeInsets.all(16.0),
//         content: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: <Widget>[
//                 SizedBox(height: 10),
//                 TextFormField(
//                   controller: _eventController,
//                   keyboardType: TextInputType.multiline,
//                   maxLines: 1,
//                   validator: (value) {
//                     if (value.isEmpty) {
//                       return 'Please enter ' + caption;
//                     }
//                     return null;
//                   },
//                   onSaved: (String value) {
//                     print(value);
//                     regModel.eventName = value;
//                   },
//                   decoration: InputDecoration(
//                     prefixIcon: Icon(Icons.edit, color: Colors.grey),
//                     labelText: "Time Schedule",
//                     alignLabelWithHint: true,
//                     hintText: "Time Schedule",
//                     contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30.0),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 DateTimeField(
//                   controller: _fromDate,
//                   validator: (value) {
//                     if (value == null) {
//                       return 'Please choose start time';
//                     }
//                     return null;
//                   },
//                   decoration: new InputDecoration(
//                     prefixIcon: Icon(Icons.access_time),
//                     labelText: "Start time",
//                     contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30.0),
//                     ),
//                   ),
//                   format: format,
//                   onShowPicker: (context, currentValue) async {
//                     final time = await showTimePicker(
//                       context: context,
//                       initialTime: TimeOfDay.fromDateTime(
//                           currentValue ?? DateTime.now()),
//                     );
//                     //print(DateTimeField.convert(time));
//                     return DateTimeField.convert(time);
//                   },
//                 ),
//                 SizedBox(height: 10),
//                 DateTimeField(
//                   controller: _endDate,
//                   validator: (value) {
//                     if (value == null) {
//                       return 'Please choose end time';
//                     }
//                     return null;
//                   },
//                   decoration: new InputDecoration(
//                     prefixIcon: Icon(Icons.access_time),
//                     labelText: "End time",
//                     contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30.0),
//                     ),
//                   ),
//                   format: format,
//                   onShowPicker: (context, currentValue) async {
//                     final time = await showTimePicker(
//                       context: context,
//                       initialTime: TimeOfDay.fromDateTime(
//                           currentValue ?? DateTime.now()),
//                     );
//                     //print(DateTimeField.convert(time));
//                     return DateTimeField.convert(time);
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//         //BasicTimeField();
//         actions: <Widget>[
//           Row(
//             children: <Widget>[
//               FlatButton(
//                 color: Colors.blueGrey,
//                 child: Text(
//                   'Save',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     if (_formKey.currentState.validate()) {
//                       _formKey.currentState.save();
//                       regModel.active = 'true';
//                       regModel.applicationName = 'Covid19Test';
//                       regModel.comments = '--';
//                       regModel.eventType = 'sample';

//                       var Service = new CreateEvent();
//                       Service.create(regModel).then((value) =>
//                           _scaffoldKey.currentState.showSnackBar(new SnackBar(
//                             backgroundColor: Colors.blue,
//                             content: Text('${value.eventName} is Scheduled'),
//                             duration: Duration(seconds: 3),
//                           )));
//                       print(_fromDate.text);
//                       if (_eventController.text.isEmpty) return;
//                       if (_events[_calendarController.selectedDay] != null) {
//                         _events[_calendarController.selectedDay].add(
//                             _eventController.text +
//                                 " : Start Time , " +
//                                 _fromDate.text +
//                                 " End Time , " +
//                                 _endDate.text);
//                       } else {
//                         _events[_calendarController.selectedDay] = [
//                           _eventController.text +
//                               " : Start Time , " +
//                               _fromDate.text +
//                               " End Time , " +
//                               _endDate.text
//                         ];
//                       }
//                       prefs.setString(
//                           'events', json.encode(encodeMap(_events)));
//                       Navigator.of(context).pop();
//                       _eventController.clear();
//                       _fromDate.clear();
//                       _endDate.clear();
//                     } else {
//                       //_eventController.clear();
//                       //_fromDate.clear();
//                     }
//                   });
//                 },
//               ),
//               SizedBox(
//                 width: 10.0,
//               ),
//               FlatButton(
//                 color: Colors.grey,
//                 child: Text(
//                   'Cancel',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   _eventController.clear();
//                   _fromDate.clear();
//                   _endDate.clear();
//                 },
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
