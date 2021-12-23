import 'dart:convert';
import '../../ui/advertise/adWidget.dart';
import '../../ui/membership/widgets/docs_upload_widget.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_preferences.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../ui/custom_drawer/navigation_home_screen.dart';
import '../../utils/routes.dart';
import '../../repo/common_repository.dart';
import '../../ui_utils/icon_utils.dart';
import '../../utils/constants.dart';
import '../custom_drawer/custom_app_bar.dart';
import 'event_registration_inapp_webview.dart';
import 'event_new_feed.dart';
import 'event_registration.dart';
import 'events_new_bloc.dart';
import 'user_event.dart';
import 'package:share/share.dart';
import '../../ui_utils/app_colors.dart';
import 'package:flutter/material.dart';

import '../../ui_utils/app_colors.dart';
import '../../utils/constants.dart';

enum EventAction { accept, decline }

class EventDetails extends StatefulWidget {
  final UserEvent event;
  final Function refresh;
  final String title;
  const EventDetails({Key key, this.event, this.refresh, this.title})
      : super(key: key);

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  String currencySymbol = "";
  String currencySuffix = "";

  EventFeed _eventFeed;
  bool isDataLoaded = false;

  Map<String, String> get _displayDetails => {
        // "Name": event.eventName,
        "Start Date & Time":
            "${DateUtils.convertUTCToLocalTime(_eventFeed.startDate)}",
        "End Date & Time":
            "${DateUtils.convertUTCToLocalTime(_eventFeed.endDate)}",
      };

  int getMilliSeconds(String date) {
    //date = DateUtils.convertUTCToLocalTime(date);
    // int milliSeconds =
    //     DateFormat('dd/mm/yyyy HH:mm:ss').parse(date).millisecondsSinceEpoch;
    int milliSeconds = DateTime.parse(date).millisecondsSinceEpoch;
    // print('Date from getMilliSeconds.....$milliSeconds');
    // print('DateTime now ............${DateTime.now().millisecondsSinceEpoch}');
    return milliSeconds;
  }

  Future fetchEventFeed() async {
    final url =
        '${WebserviceConstants.baseEventFeedURL}/event/${widget.event.eventDepartmentName}?event_name=${widget.event.eventName}';
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      print(
          '${WebserviceConstants.baseEventFeedURL}/event/${widget.event.eventDepartmentName}?event_name=${widget.event.eventName}');
      _eventFeed = EventFeed.fromJson(jsonDecode(response.body));
      setState(() {
        isDataLoaded = true;
      });
    } else {
      String errorMsg = jsonDecode(response.body)['message'] as String;
      AlertUtils.showAlertDialog(
          context,
          errorMsg != null && errorMsg.isNotEmpty
              ? errorMsg
              : AppPreferences().getApisErrorMessage);
    }
  }

  @override
  void initState() {
    fetchEventFeed();
    setDefaultCurrency();
    super.initState();

    /// Initialize Admob
    initializeAd();
  }

  setDefaultCurrency() {
    currencySymbol = AppPreferences().defaultCurrencySymbol;
    currencySuffix = AppPreferences().defaultCurrencySuffix;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint("event --> ${}");

    return Scaffold(
      appBar: buildAppBar(),
      body: isDataLoaded
          ? Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              buildTitleContainer(),
                              buildImageContainer(context),
                              buildDetailsContainer(),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // event registeration is yes
                          if (_eventFeed.registrationRequired != null &&
                              _eventFeed.registrationRequired.toLowerCase() ==
                                  'yes' &&
                              getMilliSeconds(_eventFeed.registrationEndDate) >
                                  DateTime.now().millisecondsSinceEpoch)
                            buildImageButton(context),
                          if (_eventFeed.registrationRequired != null &&
                              _eventFeed.registrationRequired.toLowerCase() ==
                                  'yes' &&
                              getMilliSeconds(_eventFeed.registrationEndDate) >
                                  DateTime.now().millisecondsSinceEpoch)
                            buildDeclineButton(),

                          // event registeration is no
                          if (_eventFeed.registrationRequired != null &&
                              _eventFeed.registrationRequired.toLowerCase() ==
                                  'no' &&
                              getMilliSeconds(_eventFeed.endDate) >
                                  DateTime.now().millisecondsSinceEpoch)
                            buildAcceptButton(context),
                          if (_eventFeed.registrationRequired != null &&
                              _eventFeed.registrationRequired.toLowerCase() ==
                                  'no' &&
                              getMilliSeconds(_eventFeed.endDate) >
                                  DateTime.now().millisecondsSinceEpoch)
                            buildDeclineButton(),
                        ],
                      ),
                      widget.event.status != null &&
                              widget.event.status == "DECLINED"
                          ? Builder(
                              builder: (context) => Center(
                                child: FlatButton(
                                  child: Text("Request to Rejoin"),
                                  color: Color(0xFF1a49a0),
                                  onPressed: () async {
                                    // await Navigator.of(context).pushReplacement(
                                    //   MaterialPageRoute(
                                    //     builder: (context) => EventRegistration(
                                    //         event: widget.event, refresh: widget.refresh),
                                    //   ),
                                    // );
                                    // if (registerResponse) {
                                    //   Navigator.of(context).pop(true);
                                    // }
                                    bool registerResponse;
                                    if (_eventFeed.eventRegisterFormDefn ==
                                            null ||
                                        _eventFeed.eventRegisterFormDefn ==
                                            "null" ||
                                        _eventFeed
                                            .eventRegisterFormDefn.isEmpty) {
                                      registerResponse =
                                          await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EventRegistration(
                                            event: widget.event,
                                            eventFeed: _eventFeed,
                                          ),
                                        ),
                                      );
                                    } else {
                                      registerResponse =
                                          await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EventRegistrationInAppWebView(
                                            event: widget.event,
                                            eventFeed: _eventFeed,
                                          ),
                                        ),
                                      );
                                    }
                                    if (registerResponse != null &&
                                        registerResponse) {
                                      Navigator.of(context).pop(true);
                                    }
                                  },
                                  colorBrightness: Brightness.dark,
                                ),
                              ),
                            )
                          : const SizedBox.shrink()
                    ],
                  ),
                ),

                /// Show Banner Ad
                getSivisoftAdWidget(),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  disableEventInvite(EventAction eventAction) async {
    showDialog(
      context: context,
      builder: (context) => Container(
        color: Colors.black.withAlpha(128),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
    final result = (eventAction == EventAction.accept)
        ? await EventsBloc(context).acceptEvent(widget.event)
        : await EventsBloc(context).declinedEvent(widget.event);
    Navigator.of(context).pop();
    if (result) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => NavigationHomeScreen(
                    drawerIndex: Constants.PAGE_ID_EVENTS_LIST,
                  )),
          ModalRoute.withName(Routes.navigatorHomeScreen));
      return;
    }
    Fluttertoast.showToast(
        msg: "Error declining event",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP);
/*    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text("Error declining event")));*/
  }

  Widget buildDeclineButton() {
    return widget.event.status == "INVITED" || widget.event.status == ""
        ? Builder(
            builder: (context) => Center(
              child: FlatButton(
                // minWidth: double.infinity,
                //  height: 60,
                child: Text("Decline Event Invite"),
                color: Color(0xFF1a49a0),
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Decline Event"),
                        content: Text(
                            "Are you sure want to decline the event? Please confirm."),
                        actions: [
                          FlatButton(
                            child: Text("Yes"),
                            onPressed: () {
                              Navigator.pop(context);
                              disableEventInvite(EventAction.decline);
                            },
                          ),
                          FlatButton(
                            child: Text("No"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      );
                    },
                  );
                },
                colorBrightness: Brightness.dark,
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  showDisableAlert(context) {
    showDialog(
      context: context,
      builder: (BuildContext con) {
        return AlertDialog(
          title: Text("Decline Event"),
          content:
              Text("Are you sure want to decline the event? Please confirm."),
          actions: [
            FlatButton(
              child: Text("Yes"),
              onPressed: () async {
                Navigator.pop(con);
                try {
                  showDialog(
                    context: context,
                    builder: (context) => Container(
                      color: Colors.black.withAlpha(128),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                  final result =
                      await EventsBloc(context).declinedEvent(widget.event);
                  // print("=============================> enterede here $result");
                  if (result) {
                    Navigator.of(context).pop();
                    return;
                  }
                  Navigator.of(context).pop();
                  Fluttertoast.showToast(
                      msg: "Error declining event",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM);
                } catch (e) {
                  // print(e);
                }
              },
            ),
            FlatButton(
              child: Text("No"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  List<Widget> buildUserEventWidgets() => _eventFeed == null
      ? [Container()]
      : _displayDetails.keys
          .map<Widget>(
            (key) => Padding(
              padding: const EdgeInsets.only(top: 12, left: 12),
              child: Text(
                "$key : ${_displayDetails[key]}",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
          .toList();

  Widget buildUrl() {
    if (_eventFeed == null || _eventFeed.registrationUrl == null)
      return Container();
    return InkWell(
      onTap: () async {
        if (await canLaunch(_eventFeed.registrationUrl)) {
          launch(_eventFeed.registrationUrl);
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 12, left: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Event Url : ",
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Text(
                _eventFeed.registrationUrl,
                overflow: TextOverflow.fade,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFee() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Event Fee : ",
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Text(
              (_eventFeed.paidEvent != null && _eventFeed.paidEvent)
                  ? widget.event.registrationType != "Session Wise"
                      ? "$currencySymbol ${_eventFeed.eventFee} $currencySuffix"
                      : "N/A"
                  : "Free",
              overflow: TextOverflow.fade,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEventDescription() {
    if (_eventFeed == null || _eventFeed.comments == null) return Container();
    return InkWell(
      onTap: () async {
        if (await canLaunch(_eventFeed.registrationUrl)) {
          launch(_eventFeed.registrationUrl);
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 12, left: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Description : ",
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Text(
                _eventFeed.comments,
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildSessionCards() {
    if (_eventFeed == null)
      return [
        Container(
          margin: const EdgeInsets.only(top: 50),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        )
      ];
    return _eventFeed.sessions.map<Widget>((session) {
      if (session.sessionName == widget.event.sessionName &&
          widget.event.registrationType != null &&
          widget.event.registrationType.toLowerCase() == "session wise") {
        return getSessionsListUI(session);
      } else if (widget.event.registrationType != null &&
          widget.event.registrationType.toLowerCase() != "session wise") {
        return getSessionsListUI(session);
      } else {
        return Container();
      }
    }).toList();
  }

  getSessionsListUI(Sessions session) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: GestureDetector(
        onTap: () {
          // _showSessionDialog();
        },
        child: Card(
          color: Colors.blueGrey,
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Session Name: ${session.sessionDisplayName ?? session.sessionName}',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Sponsor Name: ${session.sponsor ?? 'N/A'}',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Speaker Name: ${session.speaker ?? "N/A"}',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Session Start: ${DateUtils.convertUTCToLocalTime(session.startDate)}',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Session End: ${DateUtils.convertUTCToLocalTime(session.endDate)}',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Event Fee : ${session.eventFee != null ? currencySymbol + session.eventFee.toString() + " " +currencySuffix : "N/A"}',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Location: ${session.location ?? "N/A"}',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDetailsContainer() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: buildUserEventWidgets()
          ..add(buildUrl())
          ..add(buildFee())
          ..add(buildEventDescription())
          ..add(Padding(
            padding: const EdgeInsets.only(left: 8, top: 16),
            child: Text(
              "Sessions",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ))
          ..addAll(buildSessionCards()),
      ),
    );
  }

  Widget buildAcceptButton(context) =>
      widget.event.status == "INVITED" || widget.event.status == ""
          ? Center(
              child: FlatButton(
                onPressed: () async {
                  // bool registerResponse = await Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => EventRegistration(
                  //       event: widget.event,
                  //       eventFeed: _eventFeed,
                  //     ),
                  //   ),
                  // );
                  // if (registerResponse != null && registerResponse) {
                  //   Navigator.of(context).pop(true);
                  // }
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Accept Event"),
                        content: Text(
                            "Are you sure want to accept the event? Please confirm."),
                        actions: [
                          FlatButton(
                            child: Text("Yes"),
                            onPressed: () {
                              Navigator.pop(context);
                              disableEventInvite(EventAction.accept);
                            },
                          ),
                          FlatButton(
                            child: Text("No"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      );
                    },
                  );
                },
                colorBrightness: Brightness.dark,
                color: Color(0xFF1a49a0),
                child: Text("Accept"),
              ),
            )
          : const SizedBox.shrink();

  Widget buildImageButton(context) =>
      widget.event.status == "INVITED" || widget.event.status == ""
          ? Center(
              child: FlatButton(
                onPressed: () async {
                  bool registerResponse = false;
                  print(_eventFeed.eventRegisterFormDefn);
                  if (_eventFeed.eventRegisterFormDefn == null ||
                      _eventFeed.eventRegisterFormDefn == "null" ||
                      _eventFeed.eventRegisterFormDefn.isEmpty) {
                    registerResponse = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EventRegistration(
                          event: widget.event,
                          eventFeed: _eventFeed,
                        ),
                      ),
                    );
                  } else {
                    registerResponse = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EventRegistrationInAppWebView(
                          event: widget.event,
                          eventFeed: _eventFeed,
                        ),
                      ),
                    );
                  }

                  if (registerResponse != null && registerResponse) {
                    Navigator.of(context).pop(true);
                  }
                },
                colorBrightness: Brightness.dark,
                color: Color(0xFF1a49a0),
                child: Text("Registration"),
              ),
            )
          : const SizedBox.shrink();

  Widget buildImageContainer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      height: 300,
      child: DottedBorder(
        dashPattern: [5, 5],
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              widget.event.registrationImage == null
                  ? Image.asset("assets/images/photo_placeholder.jpg")
                  : Image.network(
                      widget.event.registrationImage["attachmentUrl"],
                      fit: BoxFit.scaleDown,
                      width: double.infinity,
                      height: 300,
                    ),
              if (widget.event.registrationImage != null)
                Positioned(
                  top: 5,
                  right: 5,
                  child: GestureDetector(
                    child: Icon(
                      Icons.fullscreen,
                      size: 30.0,
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ImageViewerDialog(
                              imageFile: null,
                              imageUrl: widget
                                  .event.registrationImage["attachmentUrl"],
                            );
                          });
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTitleContainer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Container(
          //   margin: const EdgeInsets.all(8).copyWith(right: 18),
          //   height: 50,
          //   width: 50,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(35),
          //   ),
          //   child: Image.asset("assets/images/placeholder_icon.png"),
          // ),
          Flexible(
            child: Text(
              widget.event.eventName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w100,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      title: Text(
        widget.title == null ? "Event Details" : widget.title,
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        IconButton(
            icon: Icon(Icons.share, color: Colors.white),
            onPressed: () {
              // print(_eventFeed.registrationUrl);
              Share.share(
                  "Event Details\n\nEvent Name :- ${_eventFeed.eventName}\n\nEvent Location :- ${widget.event.location ?? 'N/A'}\n\nEvent Start Date and Time :- ${DateUtils.convertUTCToLocalTime(_eventFeed.startDate)}\n\nEvent End Date and Time :- ${DateUtils.convertUTCToLocalTime(_eventFeed.endDate)}\n\nEvent Url :- ${_eventFeed.registrationUrl}");
            }),
        IconButton(
            icon: Icon(Icons.home, color: Colors.white),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NavigationHomeScreen()),
                  ModalRoute.withName(Routes.dashBoard));
            }),
      ],
    );
  }

  Widget setupAlertDialogContainer() {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text('Session'),
          );
        },
      ),
    );
  }

  Future<void> _showSessionDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Please select the session to join : ',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 13,
            ),
          ),
          content: SingleChildScrollView(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text('Session'),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Continue'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
