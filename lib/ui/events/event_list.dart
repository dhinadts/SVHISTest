import '../../event_schedul/event.dart';
import '../../ui_utils/app_colors.dart';
import '../../utils/app_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/components/badge/gf_badge.dart';
import 'package:getwidget/shape/gf_badge_shape.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../ui_utils/icon_utils.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../custom_drawer/custom_app_bar.dart';
import '../custom_drawer/navigation_home_screen.dart';
import 'event_details.dart';
import 'events_new_bloc.dart';
import 'user_event.dart';

class FeedListScreenNew extends StatefulWidget {
  final String title;
  const FeedListScreenNew({
    Key key,
    this.title = "Event List",
  }) : super(key: key);

  @override
  _FeedListScreenNewState createState() => _FeedListScreenNewState();
}

class _FeedListScreenNewState extends State<FeedListScreenNew>
    with TickerProviderStateMixin {
  EventsBloc _eventBloc;
  Stream<List<UserEvent>> _eventListStream;
  Stream<String> dateFilterSubject;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var searchController = TextEditingController();
  var filterMenulist = List<PopupMenuEntry<Object>>();

  int selectedSearchOption = 0;
  List<String> filterStatusList;
  static int filterByDate = 1;
  static int clear_all = 2;

  double popupMenuItemHeight = 40;

  AnimationController _animationController;
  CalendarController _calendarController;
  Map<DateTime, List> _events = {};
  DateTime selectedDay = DateTime.now();
  List _selectedEvents = new List();
  String selectedDate = "";
  bool calendarMarkerUpdated = false;

  List<UserEvent> userEventList = [];

  @override
  void initState() {
    selectedDate = DateFormat("MM/dd/yyyy").format(DateTime.now());
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
    _eventBloc = EventsBloc(context);
    _eventBloc.init();
    _eventListStream = _eventBloc.eventListFetcher.stream;
    _eventBloc.getEvenItems();
    _eventBloc.eventListFetcher.listen((value) {
      if (!calendarMarkerUpdated) {
        updateCalendarMarkers();
      }
    });

    super.initState();
    getFilterStatus();
  }

  @override
  void dispose() {
    _eventBloc.dispose();
    super.dispose();
  }

  // gettingMonthWiseList() {
  //   _eventBloc = EventsBloc(context);
  //   _eventBloc.init();
  //   _eventListStream = _eventBloc.eventListFetcher.stream;
  //   var checkMonthly = _eventBloc.getEvenItems();
  //   print(checkMonthly.length);
  //   // for (var i = 0; i < checkMonthly.length; i++) {
  //   //   print(checkMonthly.length);
  //   // }
  // }

  refresh() {
    _eventBloc.getEvenItems();
    _eventListStream = _eventBloc.eventListFetcher.stream;
  }

  Icon calendarDefault =
      Icon(Icons.calendar_today_outlined, color: Colors.white);
  Icon calendarListView = Icon(Icons.list_alt, color: Colors.white);
  Icon selectedIcon =
      Icon(Icons.calendar_today, color: Colors.white); // = calendarDefault;
  bool calnderView = true;

  updateCalendarMarkers() {
    for (var i = 0; i < _eventBloc.eventsList.length; i++) {
      DateTime d = DateFormat(AppPreferences().defaultDateFormat).parse(
          DateUtils.convertUTCToLocalTime(_eventBloc.eventsList[i].startDate));
      List jsonList = [
        DateUtils.convertUTCToLocalTime(_eventBloc.eventsList[i].startDate)
      ];
      if (_events.containsKey(d)) {
        _events[d].addAll(jsonList);
      } else {
        _events[d] = jsonList;
      }
    }
    setState(() {
      calendarMarkerUpdated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // return DefaultTabController(
    //   length: 1,
    //   child: Scaffold(
    //     appBar: buildAppBar(),
    //     body: Column(
    //       children: [
    //         buildSearchBar(),
    //         buildEventList(),
    //       ],
    //     ),
    //   ),
    // );
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: AppColors.primaryColor,
        title: Text(
          widget.title == null ? "Event List" : widget.title,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          calendarMarkerUpdated
              ? IconButton(
                  icon: calnderView ? calendarDefault : calendarListView,
                  onPressed: () {
                    setState(() {
                      calnderView = !calnderView;
                    });

                    if (calnderView) {
                      _eventBloc = EventsBloc(context);
                      _eventBloc.init();
                      _eventListStream = _eventBloc.eventListFetcher.stream;
                      _eventBloc.getEvenItems();
                    } else {
                      // _eventBloc.searchEventByDate(null);
                      selectedDay = DateTime.now();
                      String selectedDate =
                          new DateFormat(DateUtils.defaultDateFormat)
                              .format(selectedDay);

                      _eventBloc.searchEventByDate(selectedDate);
                    }
                  })
              : SizedBox.shrink(),
          IconButton(
            icon: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(
                Icons.home,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NavigationHomeScreen()),
                  ModalRoute.withName(Routes.dashBoard));
            },
          )
        ],
      ),
      body: calnderView
          ? Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                buildSearchBar(),
                buildEventList(),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                // Switch out 2 lines below to play with TableCalendar's settings
                //-----------------------
                // _buildTableCalendar(),
                _buildTableCalendarWithBuilders(),
                /* const SizedBox(height: 8.0),
                _buildButtons(),*/
                const SizedBox(height: 8.0),
                Expanded(
                    child: _buildEventList(
                  context,
                )),
              ],
            ),
    );
  }

  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      // locale: 'pl_PL',
      calendarController: _calendarController,
      events: _events,
      // holidays: _holidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
        CalendarFormat.twoWeeks: 'Two Weeks',
        CalendarFormat.week: 'Week',
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
        formatButtonVisible: true,
        formatButtonShowsNext: false,
        formatButtonDecoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20.0),
        ),
        formatButtonTextStyle: TextStyle(color: Colors.white),
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
          // print("total events" + events.toString());
          if (events.isNotEmpty) {
            children.add(Transform.translate(
              offset: Offset(15, -30),
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
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildButtons() {
    final dateTime = _events.keys.elementAt(_events.length - 2);

    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              child: Text('Month'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.month);
                });
              },
            ),
            RaisedButton(
              child: Text('2 weeks'),
              onPressed: () {
                setState(() {
                  _calendarController
                      .setCalendarFormat(CalendarFormat.twoWeeks);
                });
              },
            ),
            RaisedButton(
              child: Text('Week'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.week);
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        RaisedButton(
          child: Text(
              'Set day ${dateTime.day}-${dateTime.month}-${dateTime.year}'),
          onPressed: () {
            _calendarController.setSelectedDay(
              DateTime(dateTime.year, dateTime.month, dateTime.day),
              runCallback: true,
            );
          },
        ),
      ],
    );
  }

  bool setting = false;
  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    // print('CALLBACK: _onVisibleDaysChanged');
    //  _calendarController.toggleCalendarFormat();
    // print(format.toString());
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    // print('CALLBACK: _onCalendarCreated');
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    // print('CALLBACK: _onDaySelected');
    selectedDay = day;
    selectedDate = DateFormat('MM/dd/yyyy').format(day);
    setState(() {
      _selectedEvents = events;
    });
  }

  Widget _buildEventList(BuildContext context) {
    // _eventBloc.searchEventByDate(null);
    String selectedDate =
        new DateFormat(DateUtils.defaultDateFormat).format(selectedDay);
    // print(selectedDate);

    _eventBloc.searchEventByDate(selectedDate);

    return StreamBuilder<List<UserEvent>>(
      stream: _eventListStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return buildLoading();
        }
        if (snapshot.hasError || snapshot.data.length == 0) {
          return buildEmptyMessage();
        }
        return ListView(
          semanticChildCount: snapshot.data.length,
          children: snapshot.data
              .map<Widget>((event) => buildEventItemByMonth(event))
              .toList(),
        );
      },
    );
  }

  Widget buildLoading() => Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );

  Widget buildEmptyMessage() => Container(
        child: Center(
          child: Text("No data available"),
        ),
      );

  Widget buildEventList() {
    return Flexible(
      flex: 1,
      fit: FlexFit.tight,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: StreamBuilder<List<UserEvent>>(
          stream: _eventListStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return buildLoading();
            }
            if (snapshot.hasError || snapshot.data.length == 0) {
              return buildEmptyMessage();
            }
            userEventList = snapshot.data;
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return buildEventItem(snapshot.data[index], index);
              },
              itemCount: snapshot.data.length,
            );
          },
        ),
      ),
    );
  }

  Widget buildEventItemByMonth(UserEvent event) {
    // var startTime = null, endTime = null;
    // String timeOfSession1 = null, timeOfSession2 = null;
    // if (event != null) {
    //   print("event.startDate");
    //   print(event.startDate);
    //   print(event.startDate.split("T")[1].split(":"));
    //   print(int.parse(event.startDate.split("T")[1].split(":")[0]) > 12
    //       ? "${int.parse(event.startDate.split("T")[1].split(":")[0]) - 12}:${event.startDate.split("T")[1].split(":")[1]} PM"
    //       : "${int.parse(event.startDate.split("T")[1].split(":")[0])}:${event.startDate.split("T")[1].split(":")[1]} AM");
    //   print("event.endDate");
    //   print(event.endDate);
    //   print(event.endDate.split("T")[1].split(":"));
    //   print(int.parse(event.endDate.split("T")[1].split(":")[0]) > 12
    //       ? "${int.parse(event.endDate.split("T")[1].split(":")[0]) - 12}:${event.endDate.split("T")[1].split(":")[1]} PM"
    //       : "${int.parse(event.endDate.split("T")[1].split(":")[0])}:${event.endDate.split("T")[1].split(":")[1]} AM");

    //   print("SSSSTARTTTT DATE");
    //   print(DateUtils.convertUTCToLocalTime(event.startDate).split(" ")[1]);
    //   print(DateUtils.convertUTCToLocalTime(event.startDate)
    //       .split(" ")[1]
    //       .split(":")[0]);

    //   print(event.endDate);
    // }

    return InkWell(
      onTap: () async {
        bool shouldRefresh = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                //EventDetails(event: event, refresh: refresh),
                EventDetails(event: event),
          ),
        );
        if (shouldRefresh == true) _eventBloc.getEvenItems();
      },
      child: Card(
        child: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(8).copyWith(right: 10),
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: event.registrationImage == null
                      ? Image.asset("assets/images/placeholder_icon.png")
                      : Image.network(event.registrationImage["attachmentUrl"]),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.eventName,
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 12),
                      ),
                      event.registrationType == "Session Wise"
                          ? Text(
                              "Session: ${event.sessionName}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 11),
                            )
                          : Container(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //  Text(DateUtils.convertUTCToLocalTime(event.startDate)
                          //  .split("/")[2]
                          //  .split(" ")[1]),
                          // // SizedBox(width: 5),
                          // Text("-"),
                          // Text(DateUtils.convertUTCToLocalTime(event.endDate)
                          //     .split("/")[2]
                          //     .split(" ")[1]),

                          if (DateUtils.convertUTCToLocalTime(event.startDate)
                                  .split(" ")[0] ==
                              DateUtils.convertUTCToLocalTime(event.endDate)
                                  .split(" ")[0])
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateUtils.convertUTCToLocalTime(
                                      event.startDate),
                                  style: TextStyle(fontSize: 11),
                                ),
                                Text(" - "),
                                Text(
                                  DateUtils.convertUTCToLocalTime(
                                      event.endDate),
                                  style: TextStyle(fontSize: 11),
                                ),
                              ],
                            )
                          else
                            Row(
                              children: [
                                Text(
                                  DateUtils.convertUTCToLocalTime(
                                          event.startDate)
                                      .split(" ")[0],
                                  style: TextStyle(fontSize: 11),
                                ),
                                Text(" "),
                                Text(
                                  DateUtils.convertUTCToLocalTime(event.startDate),
                                  style: TextStyle(fontSize: 11),
                                ),

                                // SizedBox(width: 5),
                                Text(" - "),
                                Text(
                                  DateUtils.convertUTCToLocalTime(event.endDate)
                                      .split(" ")[0],
                                  style: TextStyle(fontSize: 11),
                                ),
                                Text(" "),
                                Text(
                                  DateUtils.convertUTCToLocalTime(event.endDate),
                                  style: TextStyle(fontSize: 11),
                                ),
                              ],
                            ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Organizer: ",
                                style: TextStyle(fontSize: 11),
                              ),
                              Text(
                                event.eventDepartmentName,
                                style: TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: event.status == "DECLINED"
                                    ? Colors.red
                                    : event.status == "REGISTERED"
                                        ? Colors.green
                                        : event.status == ""
                                            ? Colors.white
                                            : Colors.blue,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                event.status,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 11),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    // } else {
    //   return SizedBox.shrink();
    // }
  }

  Widget buildEventItem(UserEvent event, int index) {
    print(event.registrationType);
    if (event.registrationType?.toLowerCase() == "session wise") {
      return buildSessionWiseEventItem(event, index);
    } else {
      return InkWell(
        onTap: () async {
          bool shouldRefresh = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  //EventDetails(event: event, refresh: refresh),
                  EventDetails(event: event),
            ),
          );
          if (shouldRefresh == true) _eventBloc.getEvenItems();
        },
        child: Card(
          child: Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.all(8).copyWith(right: 10),
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: event.registrationImage == null
                        ? Image.asset("assets/images/placeholder_icon.png")
                        : Image.network(
                            event.registrationImage["attachmentUrl"]),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.eventName,
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 12),
                        ),
                        Row(
                          children: [
                            if (DateUtils.convertUTCToLocalTime(event.startDate)
                                    .split(" ")[0] ==
                                DateUtils.convertUTCToLocalTime(event.endDate)
                                    .split(" ")[0])
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(DateUtils.convertUTCToLocalTime(
                                      event.startDate), style: TextStyle(
                                      color: Colors.black, fontSize: 12)),
                                  Text(" - "),
                                  Text(DateUtils.convertUTCToLocalTime(
                                      event.endDate), style: TextStyle(
                                      color: Colors.black, fontSize: 12)),
                                ],
                              )
                            else
                              Row(
                                children: [
                                  Text(DateUtils.convertUTCToLocalTime(
                                      event.startDate), style: TextStyle(
                                      color: Colors.black, fontSize: 12)),
                                  Text(" - "),
                                  Text(DateUtils.convertUTCToLocalTime(
                                      event.endDate), style: TextStyle(
                                      color: Colors.black, fontSize: 12)),
                                ],
                              ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Organizer: ",
                                    style: TextStyle(fontSize: 11)),
                                Text(event.eventDepartmentName,
                                    style: TextStyle(fontSize: 11)),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: event.status == "DECLINED"
                                      ? Colors.red
                                      : event.status == "REGISTERED"
                                          ? Colors.green
                                          : event.status == ""
                                              ? Colors.white
                                              : Colors.blue,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  event.status,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 11),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget buildSessionWiseEventItem(UserEvent event, int index) {
    List<Widget> expansionTileChildrenList = [];
    for (var i = 0; i < userEventList.length; i++) {
      if (userEventList[i].eventId == event.eventId) {
        if (index > i) {
          break;
        } else {
          expansionTileChildrenList.add(Card(
              child: InkWell(
            onTap: () async {
              bool shouldRefresh = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      //EventDetails(event: event, refresh: refresh),
                      EventDetails(event: userEventList[i]),
                ),
              );
              if (shouldRefresh == true) _eventBloc.getEvenItems();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Session: ${userEventList[i].sessionDisplayName ?? userEventList[i].sessionName}",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (DateUtils.convertUTCToLocalTime(
                                      userEventList[i].startDate)
                                  .split(" ")[0] ==
                              DateUtils.convertUTCToLocalTime(
                                      userEventList[i].endDate)
                                  .split(" ")[0])
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(DateUtils.convertUTCToLocalTime(
                                    userEventList[i].startDate),style: TextStyle(fontSize: 12),),
                                Text(" - "),
                                Text(DateUtils.convertUTCToLocalTime(
                                    userEventList[i].endDate),style: TextStyle(fontSize: 12),),
                              ],
                            )
                          else
                            Row(
                              children: [
                                Text(DateUtils.convertUTCToLocalTime(
                                    userEventList[i].startDate),style: TextStyle(fontSize: 12),),
                                Text(" - "),
                                Text(DateUtils.convertUTCToLocalTime(
                                    userEventList[i].endDate),style: TextStyle(fontSize: 12),),
                              ],
                            ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: userEventList[i].status == "DECLINED"
                                ? Colors.red
                                : userEventList[i].status == "REGISTERED"
                                    ? Colors.green
                                    : userEventList[i].status == ""
                                        ? Colors.white
                                        : Colors.blue,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            userEventList[i].status,
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ),
                      ),
                    ],
                  ),
                  /* Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //  Text(DateUtils.convertUTCToLocalTime(event.startDate)
                              //  .split("/")[2]
                              //  .split(" ")[1]),
                              // // SizedBox(width: 5),
                              // Text("-"),
                              // Text(DateUtils.convertUTCToLocalTime(event.endDate)
                              //     .split("/")[2]
                              //     .split(" ")[1]),

                              if (DateUtils.convertUTCToLocalTime(event.startDate)
                                      .split(" ")[0] ==
                                  DateUtils.convertUTCToLocalTime(event.endDate)
                                      .split(" ")[0])
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(int.parse(event.startDate
                                                .split("T")[1]
                                                .split(":")[0]) >
                                            12
                                        ? "${int.parse(event.startDate.split("T")[1].split(":")[0]) - 12}:${event.startDate.split("T")[1].split(":")[1]} PM"
                                        : "${int.parse(event.startDate.split("T")[1].split(":")[0])}:${event.startDate.split("T")[1].split(":")[1]} AM"),
                                    Text(" - "),
                                    Text(int.parse(event.endDate
                                                .split("T")[1]
                                                .split(":")[0]) >
                                            12
                                        ? "${int.parse(event.endDate.split("T")[1].split(":")[0]) - 12}:${event.endDate.split("T")[1].split(":")[1]} PM"
                                        : "${int.parse(event.endDate.split("T")[1].split(":")[0])}:${event.endDate.split("T")[1].split(":")[1]} AM"),
                                  ],
                                )
                              else
                                Row(
                                  children: [
                                    Text(DateUtils.convertUTCToLocalTime(
                                            event.startDate)
                                        .split(" ")[0]),
                                    Text(" "),
                                    Text(int.parse(event.startDate
                                                .split("T")[1]
                                                .split(":")[0]) >
                                            12
                                        ? "${int.parse(event.startDate.split("T")[1].split(":")[0]) - 12}:${event.startDate.split("T")[1].split(":")[1]} PM"
                                        : "${int.parse(event.startDate.split("T")[1].split(":")[0])}:${event.startDate.split("T")[1].split(":")[1]} AM"),

                                    // SizedBox(width: 5),
                                    Text(" - "),
                                    Text(DateUtils.convertUTCToLocalTime(
                                            event.endDate)
                                        .split(" ")[0]),
                                    Text(" "),
                                    Text(int.parse(event.endDate
                                                .split("T")[1]
                                                .split(":")[0]) >
                                            12
                                        ? "${int.parse(event.endDate.split("T")[1].split(":")[0]) - 12}:${event.endDate.split("T")[1].split(":")[1]} PM"
                                        : "${int.parse(event.endDate.split("T")[1].split(":")[0])}:${event.endDate.split("T")[1].split(":")[1]} AM"),
                                  ],
                                ),
                            ],
                          ),
 */
                ],
              ),
            ),
          )));
        }
      }
    }
    if (expansionTileChildrenList.isNotEmpty) {
      return Card(
        child: ExpansionTile(
          backgroundColor: Colors.white,
          childrenPadding: EdgeInsets.zero,
          title: Row(
            children: [
              Container(
                margin: const EdgeInsets.all(8).copyWith(right: 10),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                ),
                child: event.registrationImage == null
                    ? Image.asset("assets/images/placeholder_icon.png")
                    : Image.network(event.registrationImage["attachmentUrl"]),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      event.eventName,
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Organizer: ", style: TextStyle(fontSize: 11)),
                        Text(event.eventDepartmentName,
                            style: TextStyle(fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          children: expansionTileChildrenList,
        ),
      );
    } else {
      return SizedBox();
    }
  }

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Form(
        key: _formKey,
        child: Row(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: TextFormField(
                controller: searchController,
                validator: (value) {
                  if (value.length > 0 && value.length < 2) {
                    return "Search string must be 2 characters";
                  } else if (value.length == 0) {
                    Fluttertoast.showToast(
                        msg: "Please enter text",
                        toastLength: Toast.LENGTH_LONG,
                        timeInSecForIosWeb: 5,
                        gravity: ToastGravity.TOP);
                  }
                },
                onChanged: (newVal) {
                  if (newVal.length == 0) {
                    _eventBloc.searchEventByName(newVal);
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Search by Event Name",
                ),
                // inputFormatters: <TextInputFormatter>[
                //   FilteringTextInputFormatter.deny(RegExp('[0-9]')),
                // ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Ink(
                decoration: const ShapeDecoration(
                  color: Colors.blueGrey,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: Icon(Icons.search),
                  color: Colors.white,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _eventBloc.searchEventByName(searchController.text);
                    }
                  },
                ),
              ),
            ),
            // Container(
            //   width: 10,
            // ),
            // InkWell(
            //   onTap: () {},
            //   child: Container(
            //     decoration: BoxDecoration(
            //         color: Colors.blueGrey,
            //         borderRadius: BorderRadius.circular(30)),
            //     child: Center(
            //       child: Padding(
            //         padding: const EdgeInsets.all(10.0),
            //         child: Icon(
            //           Icons.search,
            //           color: Colors.white,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            // Container(
            //   width: 10,
            // ),
            // InkWell(
            //   onTap: () {},
            //   child: Container(
            //     decoration: BoxDecoration(
            //         color: Colors.blueGrey,
            //         borderRadius: BorderRadius.circular(30)),
            //     child: Center(
            //       child: Padding(
            //         padding: const EdgeInsets.all(10.0),
            //         child: Icon(
            //           Icons.filter_alt_outlined,
            //           color: Colors.white,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            PopupMenuButton(
              itemBuilder: (context) {
                return filterMenulist;
              },
              onCanceled: () {},
              onSelected: (value) {
                setState(() {
                  if (value != -1) {
                    selectedSearchOption = value;

                    if (selectedSearchOption == 1) {
                      // clear all
                      searchController.clear();
                      FocusScope.of(context).requestFocus(FocusNode());
                      selectedSearchOption = 0;

                      showDatePicker();
                    } else if (selectedSearchOption == 2) {
                      // clear all
                      searchController.clear();
                      FocusScope.of(context).requestFocus(FocusNode());
                      selectedSearchOption = 0;
                      _eventBloc.searchEventByName("");
                    } else if (selectedSearchOption > 2) {
                      searchController.clear();
                      FocusScope.of(context).requestFocus(FocusNode());
                      int tmpValue =
                          selectedSearchOption - 3; // subtract the tempCount
                      if (filterStatusList != null &&
                          filterStatusList.length > 0) {
                        _eventBloc
                            .searchEventByStatus(filterStatusList[tmpValue]);
                      }
                    }
                  }
                  createFilterDropDown();
                });
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
            SizedBox(width: 5),
          ],
        ),
      ),
    );
  }

  Widget buildAppBar() {
    return CustomAppBar(
      tabBar: TabBar(
        isScrollable: true,
        indicatorColor: Colors.white,
        tabs: [
          Tab(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text("Event List"),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    child: StreamBuilder<List<UserEvent>>(
                        stream: _eventListStream,
                        builder: (context, snapshot) {
                          String countText = "0";
                          if ((snapshot.connectionState ==
                                      ConnectionState.done ||
                                  snapshot.connectionState ==
                                      ConnectionState.active) &&
                              snapshot.hasData) {
                            countText = snapshot.data.length.toString();
                          }
                          return Text(
                            countText,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      pageId: Constants.PAGE_ID_EVENTS_LIST,
      title: "Event List",
    );
  }

  addSearchByFilter() {
    filterMenulist.add(
      PopupMenuItem(
        height: popupMenuItemHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Filter by Status",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Icon(
              Icons.cancel,
              size: 30.0,
            ),
          ],
        ),
        value: -1,
      ),
    );
    filterMenulist.add(
      PopupMenuItem(
        height: popupMenuItemHeight,
        child: Row(
          children: [
            Icon(
              Icons.done,
              color:
                  selectedSearchOption == 0 ? Colors.green : Colors.transparent,
            ),
            SizedBox(width: 10),
            Text('Membership Id'),
          ],
        ),
        value: 0,
      ),
    );
    filterMenulist.add(
      PopupMenuItem(
        height: popupMenuItemHeight,
        child: Row(
          children: [
            Icon(
              Icons.done,
              color:
                  selectedSearchOption == 1 ? Colors.green : Colors.transparent,
            ),
            SizedBox(width: 10),
            Text('Name'),
          ],
        ),
        value: 1,
      ),
    );
    filterMenulist.add(
      PopupMenuDivider(
        height: 10,
      ),
    );
  }

  addFilterByDate() {
    filterMenulist.add(
      PopupMenuItem(
        height: popupMenuItemHeight,
        child: Text(
          "Filter",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        value: -1,
      ),
    );
    filterMenulist.add(
      PopupMenuItem(
        height: popupMenuItemHeight,
        child: Row(
          children: [
            Icon(
              Icons.done,
              color: Colors.transparent,
            ),
            SizedBox(width: 10),
            Text('By Date'),
          ],
        ),
        value: filterByDate,
      ),
    );
  }

  addFilterByStatus() {
    filterMenulist.add(
      PopupMenuItem(
        height: popupMenuItemHeight,
        child: Text(
          "Filter by Status",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        value: -1,
      ),
    );

    if (filterStatusList != null && filterStatusList.isNotEmpty) {
      // To set the value
      int tempCount = 3; //till 2, it is known values
      filterStatusList.forEach((eventStatus) {
        if (eventStatus.isNotEmpty) {
          filterMenulist.add(
            PopupMenuItem(
              height: popupMenuItemHeight,
              child: Row(
                children: [
                  Icon(
                    Icons.done,
                    color: selectedSearchOption == tempCount
                        ? Colors.green
                        : Colors.transparent,
                  ),
                  SizedBox(width: 10),
                  Text(eventStatus),
                ],
              ),
              value: tempCount,
            ),
          );
          tempCount += 1;
        }
      });
    }
    filterMenulist.add(
      PopupMenuDivider(
        height: 10,
      ),
    );
  }

  addClearFilter() {
    filterMenulist.add(
      PopupMenuItem(
        height: popupMenuItemHeight,
        child: Text(
          "Clear",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        value: -1,
      ),
    );
    filterMenulist.add(
      PopupMenuItem(
        height: popupMenuItemHeight,
        child: Row(
          children: [
            Icon(
              Icons.done,
              color: Colors.transparent,
            ),
            SizedBox(width: 10),
            Text('All'),
          ],
        ),
        value: clear_all,
      ),
    );
  }

  createFilterDropDown() {
    filterMenulist.clear();
    addFilterByDate();

    if (filterStatusList != null && filterStatusList.length > 0) {
      addFilterByStatus();
    }
    addClearFilter();
  }

  getFilterStatus() async {
    filterStatusList = ['Registered', 'Invited', 'Declined'];

    createFilterDropDown();
  }

  Future<DateTime> showDatePicker() {
    DateTime dateTime = DateTime.now();
    return showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (context) => Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.width * 0.75,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Dismiss"),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(dateTime);
                    String selectedDate =
                        new DateFormat(DateUtils.defaultDateFormat)
                            .format(dateTime);
                    // print(selectedDate);
                    _eventBloc.searchEventByDate(selectedDate);
                  },
                  child: Text("Submit"),
                ),
              ],
            ),
            Container(
              height: 1,
              color: Colors.black,
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: CupertinoDatePicker(
                maximumDate: DateTime.now().add(Duration(days: 365 * 2)),
                mode: CupertinoDatePickerMode.date,
                initialDateTime: DateTime.now(),
                onDateTimeChanged: (newDate) {
                  dateTime = newDate;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//"2021-02-27T19:11:48"
// mm/dd/yyyy
