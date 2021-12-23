import '../bloc/check_in_bloc.dart';
import '../bloc/dynamic_fields_bloc.dart';
import '../bloc/history_bloc.dart';
import '../login/utils/custom_progress_dialog.dart';
import '../model/check_in_dynamic.dart';
import '../model/check_in_dynamic_response.dart';
import '../model/dynamic_fields_reponse.dart';
import '../model/passing_arg.dart';
import '../model/people.dart';
import '../model/user_info.dart';
import '../ui/advertise/adWidget.dart';
import '../ui/custom_drawer/navigation_home_screen.dart';
import '../ui/log_reports/chart_state.dart';
import '../ui/tabs/app_localizations.dart';
import '../ui_utils/app_colors.dart';
import '../ui_utils/ui_dimens.dart';
import '../ui_utils/widget_styles.dart';
import '../utils/alert_utils.dart';
import '../utils/app_preferences.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../utils/validation_utils.dart';
import '../widgets/check_in_list_widget.dart';
import '../widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'log_reports/logbook_summary_report.dart';

class CheckInHistoryScreen extends StatefulWidget {
  final People people;
  final String userName;
  CheckInHistoryScreen(this.people, this.userName) {
    if (this.people != null)
      chartUser = this.people.userName;
    else
      chartUser = AppPreferences().username;
  }

  @override
  CheckInHistoryScreenState createState() => CheckInHistoryScreenState();
}

class CheckInHistoryScreenState extends State<CheckInHistoryScreen>
    with TickerProviderStateMixin {
  CheckInBloc _bloc;
  TabController _tabController;
  int currIndex = 0;
  int tabsCount = 2;
  List<Tab> tabs;
  List<Widget> tabscreens;
  @override
  void initState() {
    getTabsAndScreens();
    _tabController = TabController(length: tabsCount, vsync: this);
    _tabController.addListener(() {
      if (currIndex != _tabController.index) {
        currIndex = _tabController.index;
        if (currIndex == 0) {
          fetchData();
        }
      }
    });
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    initializeData();
    if (AppPreferences().role != Constants.supervisorRole) if (ValidationUtils
            .validStringOrNot(AppPreferences().height) ||
        ValidationUtils.validStringOrNot(AppPreferences().weight)) {
      setHeightAndWeight(context);
    }
    super.initState();

    initializeAd();
  }

  setHeightAndWeight(BuildContext context) async {
    debugPrint("-------------->");
    debugPrint(widget.people?.userName ?? AppPreferences().username);
    debugPrint(widget.people?.departmentName ?? AppPreferences().deptmentName);
    debugPrint("-------------->");
    HistoryBloc bloc = HistoryBloc(context);
    bloc.fetchHistoryDynamicList(
        username: widget.people?.userName ?? AppPreferences().username,
        dept: widget.people?.departmentName ?? AppPreferences().deptmentName);
    bloc.dynamicFieldsHistoryFetcherWithData.listen((value) async {
      for (DynamicFieldsResponse response in value) {
        if (response.mappedDBColumn == "column10") {
          await AppPreferences.setHeight("${response.actualValue}");
        } else if (response.mappedDBColumn == "column9") {
          await AppPreferences.setWeight("${response.actualValue}");
        }
      }
    });
  }

  getTabsAndScreens() async {
    setState(() {
      tabs = [Tab(text: "History"), Tab(text: "Reports")];
      tabscreens = [
        buildHistory(),
        LogbookSummaryScreen(),
      ];
    });
    var enabled = await AppPreferences.getDailyCheckinReportEnabled();
    if (enabled != true) {
      setState(() {
        tabs.removeLast();
        tabscreens.removeLast();
        _tabController = TabController(length: tabs.length, vsync: this);
      });
    }
  }

  void initializeData() {
    fetchData();
  }

  void fetchData() {
    if (widget.people != null) {
      _bloc.fetchCheckInDynamicList(widget.people);
    } else {
      People people = People();
      people.userName = AppPreferences().username;
      _bloc.fetchCheckInDynamicList(people);
    }
  }

  void updateListData(bool isChangedData) {
    // debugPrint("updateListData called... $isChangedData");
    if (isChangedData != null && isChangedData) {
      initializeData();
    }
  }

  bool isCheckInAvailable = false;
  bool enableAddButton = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 35),
        child: FloatingActionButton(
          onPressed: () {
            proceedAddingDailyCheckIn(context);
          },
          child: Icon(Icons.add),
        ),
      ),
      appBar: /* widget.people == null ? null :*/ buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: tabscreens,
            ),
          ),

          /// Show Banner Ad
          getSivisoftAdWidget(),
        ],
      ),
    );
  }

  Widget buildHistory() {
    _bloc = CheckInBloc(context);
    return SingleChildScrollView(
        padding: EdgeInsets.only(bottom: AppUIDimens.paddingXMedium),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(boxShadow: WidgetStyles.cardBoxShadow),
              child: Column(
                children: <Widget>[
                  _userTitleText(),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            _bloc != null
                ? StreamBuilder(
                    stream: _bloc.checkInListFetcher,
                    builder: (context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data is CheckInDynamicResponse) {
                          List<CheckInDynamic> sym =
                              snapshot.data.checkInDynamicList;
                          //print("sym --> $sym");
                          if (sym.length > 0) {
                            isCheckInAvailable = true;
                            enableAddButton = true;
                            String n = widget.userName;
                            return CheckInListWidget(sym, widget.people,
                                updateListData, widget.userName);
                          }
                        }
                        enableAddButton = true;
                        return Text("No data available");
                      }
                      return ListLoading();
                    })
                : Container(),
          ],
        ));
  }

  Future<void> _showCheckInDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${AppPreferences().appName}"),
                  GestureDetector(
                    child: Icon(
                      Icons.cancel,
                      size: 30.0,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                AppPreferences().role == Constants.supervisorRole
                    ? "Does the User have any Symptoms?"
                    : "Do you have any Symptoms?",
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    color: Colors.green,
                    child: Text('Yes'),
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pop();
                      proceedAddingDailyCheckIn(context);
                    },
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  FlatButton(
                    color: Colors.blue,
                    child: Text('No'),
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pop();
                      createOrUpdate();
                    },
                  ),
                ],
              )
            ],
          ),
          actions: <Widget>[],
        );
      },
    );
  }

  void proceedAddingDailyCheckIn(BuildContext context) async {
//    final status = Navigator.pushNamed(context, Routes.checkInScreen,
//         arguments: Args(
//             arg: "",
//             username: widget.people != null
//                 ? widget.people.userName
//                 : AppPreferences().username));
    var status = await Navigator.pushNamed(
      context,
      Routes.checkInScreen,
      arguments: Args(
        arg: "",
        userFullName: widget.people != null &&
                widget.people.userFullName != null &&
                widget.people.userFullName.isNotEmpty
            ? widget.people.userFullName
            : fullName,
        username: widget.people != null
            ? widget.people.userName
            : AppPreferences().username,
        departmentName: widget.people != null
            ? widget.people.departmentName
            : AppPreferences().deptmentName,
      ),
    );
    // print("Status $status");
    if (status ?? false) {
      initializeData();
    }
  }

  createOrUpdate({bool isUpdate = false}) async {
    // debugPrint("Updating data");
    CustomProgressLoader.showLoader(context);
    DynamicFieldsBloc dynamicFieldsBloc = DynamicFieldsBloc(context);
    dynamicFieldsBloc.fetchDynamicFieldsCheckIn();
    dynamicFieldsBloc.dynamicFieldsStreamCheckIn
        .listen((dynamicFieldsResponse) async {
      Map responseMap = {};
      for (var dynamicField in dynamicFieldsResponse) {
        responseMap.putIfAbsent(
            dynamicField.mappedDBColumn, () => dynamicField.defaultValue);
      }
      responseMap["active"] = true;
      responseMap["departmentName"] = widget.people.departmentName;
      responseMap["status"] = "Reported";
      if (widget.people != null) {
        responseMap["userName"] = widget.people.userName;
      } else {
        responseMap["userName"] = await AppPreferences.getUsername();
      }

      dynamicFieldsBloc.postDynamicFieldCheckInData(responseMap);
      dynamicFieldsBloc.dynamicFieldPostFetcher.listen((event) async {
        CustomProgressLoader.cancelLoader(context);
        if (event != null && event.status == 201 || event.status == 200) {
          initializeData();
        } else {
          AlertUtils.showAlertDialog(
              context,
              event != null
                  ? event.message
                  : AppPreferences().getApisErrorMessage);
        }
      });
    });
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      centerTitle: true,
      title: Text(
        AppPreferences().isTTDEnvironment()
            ? AppLocalizations.of(context).translate("key_check_in_history")
            : AppLocalizations.of(context)
                .translate("key_daily_checkin_history"),
        style: TextStyle(color: Colors.white),
      ),
      actions: <Widget>[
        IconButton(
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NavigationHomeScreen()),
                  ModalRoute.withName(Routes.navigatorHomeScreen));
            })
      ],
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: Colors.white,
        tabs: tabs,
      ),
    );
  }

  String fullName = "";

  Widget _userTitleText() {
    if (widget.people != null) {
      fullName = widget.people.firstName.length > 0
          ? widget.people.firstName + " " + widget.people.lastName
          : widget.people?.userName;
    } else {
      fullName = AppPreferences().fullName2.length > 0
          ? AppPreferences().fullName2
          : AppPreferences().username;
    }

    return Container(
      color: Colors.transparent,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: AppColors.arrivedColor,
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            )),
        child: SizedBox(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 7,
            ),
            Expanded(
                child: Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 15, left: 25),
                    child: Text(
                      // AppPreferences().role == Constants.supervisorRole
                      //     : "Username",
                      "Name",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ))),
            Padding(
                padding: EdgeInsets.only(top: 15, bottom: 15, right: 25),
                child: Text(
                  fullName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                )),
            SizedBox(
              height: 7,
            ),
          ],
        )),
      ),
    );
  }
}
