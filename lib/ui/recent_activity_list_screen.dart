import 'dart:async';
import '../bloc/new_notification_bloc.dart';
import '../bloc/notification_bloc.dart';
import '../login/utils/custom_progress_dialog.dart';
import '../model/notice_board_response.dart';
import '../ui/custom_drawer/custom_app_bar.dart';
import '../ui/notification_list_item_new.dart';
import '../ui/tabs/app_localizations.dart';
import '../ui/tabs/modal_inside_modal.dart';
import '../utils/alert_utils.dart';
import '../utils/app_preferences.dart';
import '../utils/constants.dart';
import '../utils/loading_state.dart';
import '../widgets/mode_tag.dart';
import '../widgets/recent_activity_list_loading.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'custom_drawer/navigation_home_screen.dart';
import '../ui/custom_drawer/navigation_home_screen.dart';
import 'avatar_bottom_sheet.dart';

class RecentActivityScreen extends StatefulWidget {
  final String title;
  const RecentActivityScreen({Key key, this.title}) : super(key: key);
  // RecentActivityScreen();

  @override
  RecentActivityScreenState createState() => RecentActivityScreenState();
}

class RecentActivityScreenState extends State<RecentActivityScreen> {
  NewNotificationBloc _bloc;
  int pageNo = 1;
  LoadingState pageContentLoadingState;
  ScrollController controller;
  final GlobalKey _settingsMenuKey = new GlobalKey();
  String filterValue = "All", filterViewValue = "All";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = NewNotificationBloc(context);
    initializeData();
    controller = ScrollController()..addListener(_scrollListener);
    getRecentActivityFileds();
  }

  initializeData() {
    _bloc.fetchNotifications(pageNo, filterType: filterValue);
  }

  List<String> typesRecentActivity = List();
  List<String> typesRecentActivityModified = List();
  getRecentActivityFileds() async {
    typesRecentActivity =
        await AppPreferences.getRecentActivityOptions() ?? null;
    typesRecentActivityModified.clear();
    // print(typesRecentActivity);
    for (var i = 0; i < typesRecentActivity.length; i++) {
      if (typesRecentActivity[i].contains("_")) {
        typesRecentActivity[i].split("_");
        // print(typesRecentActivity[i].split("_").removeAt(0));
        typesRecentActivityModified
            .add(typesRecentActivity[i].split("_").removeAt(0));
      } else {
        typesRecentActivityModified.add(typesRecentActivity[i]);
      }
    }
    // print("All Values after split: ${typesRecentActivityModified}");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final popupSettingMenu = new PopupMenuButton(
        child: InkWell(
            onTap: () {
              dynamic state = _settingsMenuKey.currentState;
              state.showButtonMenu();
            },
            child: ModeTag(
              filterViewValue,
              leading: true,
              capsLockOff: true,
            )),
        key: _settingsMenuKey,
        itemBuilder: (_) => <PopupMenuItem<String>>[
              PopupMenuItem<String>(child: const Text('All'), value: 'All'),
              for (var i = 0; i < typesRecentActivityModified.length; i++)
                new PopupMenuItem<String>(
                    child: Text("${typesRecentActivityModified[i]}"),
                    value: "${typesRecentActivityModified[i]}"),
              // new PopupMenuItem<String>(
              //     child: const Text('Email Notification'), value: 'Email'),
              // new PopupMenuItem<String>(
              //     child: const Text('SMS Notification'), value: 'SMS'),
              // new PopupMenuItem<String>(
              //     child: const Text('Mobile Application'),
              //     value: 'Mobile_Application'),
              // new PopupMenuItem<String>(
              //     child: const Text('Push Notification'),
              //     value: 'Push_Notification'),
              // new PopupMenuItem<String>(
              //     child: const Text('WhatsApp Notification'),
              //     value: 'Whatsapp_Notification'),
            ],
        onSelected: (_) {
          setState(() {
            pageNo = 1;
            filterValue = _;
            if (filterValue == "All") {
              filterViewValue = "All";
            } else if (filterValue == _) {
              if (_ == "Push") {
                filterValue = _ + "_Notification";
              } else if (_ == "Mobile") {
                filterValue = _ + "_Application";
              }
              filterViewValue = _;
            }
          });
          initializeData();
        });
    // print("=============>  ${widget.title}");
    return Scaffold(
        appBar: CustomAppBar(
            title: widget.title != null ? widget.title : "Recent Activity",
            pageId: Constants.PAGE_ID_RECENT_ACTIVITY),
        body: RefreshIndicator(
            onRefresh: refreshPage,
            child: Column(children: [
              Container(
                  height: 50,
                  padding: EdgeInsets.only(left: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Filter",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      popupSettingMenu
                    ],
                  )),
              Expanded(
                  //height: MediaQuery.of(context).size.height - 190,
                  child: StreamBuilder<NoticeBoardResponse>(
                      stream: _bloc.notificationFetcher,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<NewNotification> notifications =
                              snapshot?.data?.results ?? List();
                          if (pageContentLoadingState == null ||
                              pageContentLoadingState ==
                                  LoadingState.inprogess) {
                            pageContentLoadingState = LoadingState.completed;
                          }
                          Widget widgetToReturn = ListView(
                              controller: controller,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: ListView.separated(
                                      shrinkWrap: true,
                                      primary: false,
                                      itemCount: notifications.length,
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return SizedBox(
                                          height: 5,
                                        );
                                      },
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                            // onTapCancel: () {
                                            //   AlertUtils.showAlertNotificationDialog( context, notifications[index], (value) {

                                            //     NewNotification item = notifications[index];
                                            //     if (value == "Acknowledged") {
                                            //       item.messageStatus = "Acknowledged";
                                            //     } else {
                                            //       item.messageStatus = "NotAcknowledged";
                                            //     }
                                            //     Navigator.pop(context);
                                            //     //TODO:
                                            //     _sendMessage(item);
                                            //   });
                                            // },

                                            onTap: () {
                                              NewNotification item =
                                                  notifications[index];
                                              showAvatarModalBottomSheet(
                                                isRecentActivity: true,
                                                expand: true,
                                                context: context,
                                                enableDrag: false,
                                                notification: item,
                                                backgroundColor:
                                                    Colors.transparent,
                                                builder: (context) =>
                                                    ModalInsideModal(item),
                                              );
                                            },
                                            child: NotificationListItemNew(
                                                notifications[index]));
                                      }),
                                ),
                                pageContentLoadingState == LoadingState.started
                                    ? RecentActivityListLoadingWidget(
                                        itemCount: 3,
                                      )
                                    : Container()
                              ]);
                          if (notifications.length == 0) {
                            widgetToReturn = Center(
                                child: Text(AppLocalizations.of(context)
                                    .translate("key_no_data_found")));
                          }
                          if (pageContentLoadingState == LoadingState.started) {
                            pageContentLoadingState = LoadingState.inprogess;
                          }
                          return widgetToReturn;
                        }
                        return Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: RecentActivityListLoadingWidget());
                      }))
            ])));
  }

  _sendMessage(NewNotification item) {
    CustomProgressLoader.showLoader(context);
    NotificationBloc _blocL = NotificationBloc(context);
    _blocL.updateAckStatus(item.messageStatus, item.messageId.toString());
    _blocL.updateMsgFetcher.listen((value) {
      CustomProgressLoader.cancelLoader(context);

      if (value.status == 200 || value.status == 201) {
        pageNo = 1;
        _bloc.fetchNotifications(pageNo, filterType: filterValue);
        refreshPage(refresh: true);
        Fluttertoast.showToast(
            msg: value.message,
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 5,
            gravity: ToastGravity.TOP);
      } else {
        Fluttertoast.showToast(
            msg: value.message,
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 5,
            gravity: ToastGravity.TOP);
      }
    });
  }

  Future<void> refreshPage({bool refresh: false}) {
    setState(() {
      if (refresh) {
        new Future.delayed(const Duration(seconds: 10), () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => NavigationHomeScreen(
                        drawerIndex: Constants.PAGE_ID_RECENT_ACTIVITY,
                      )));
        });
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => NavigationHomeScreen(
                      drawerIndex: Constants.PAGE_ID_RECENT_ACTIVITY,
                    )));
      }
    });
    return Future.value();
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      if (pageContentLoadingState == LoadingState.completed &&
          !_bloc.isAllPagesLoaded) {
        setState(() {
          pageContentLoadingState = LoadingState.started;
          _moveDown();
          pageNo++;
          _bloc.fetchNotifications(pageNo, filterType: filterValue);
        });
      }
    }
  }

  void _moveDown() {
    Timer(Duration(milliseconds: 300), () {
      controller.animateTo(
        controller.position.maxScrollExtent,
        curve: Curves.ease,
        duration: const Duration(milliseconds: 300),
      );
    });
  }
}
