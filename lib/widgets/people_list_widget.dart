import 'dart:convert';

import 'package:Memberly/repo/common_repository.dart';
import 'package:Memberly/ui/diabetes_risk_score/model/health_score.dart';

import '../bloc/user_info_validation_bloc.dart';
import '../model/drawer_item.dart';
import '../model/menu_item.dart';
import '../model/notice_board_response.dart';
import '../model/passing_arg.dart';
import '../model/people.dart';
import '../ui/avatar_bottom_sheet.dart';
import '../ui/subscription/subscription_screen.dart';
import '../ui/tabs/app_localizations.dart';
import '../ui_utils/app_colors.dart';
import '../utils/app_preferences.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../widgets/people_list_item.dart';
import '../widgets/user_list_bottomsheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PeopleListWidget extends StatefulWidget {
  final List<People> people;
  final bool isCameFromContactInfo;
  final bool isCameFromCoping;
  final bool isCameFromAddUserFamily;
  final bool isCameFromSubscription;
  final bool isCameFromDiabetesRiskScore;
  final String usernameForContact;
  final bool showBottomSheet;
  final void Function(String) _successCallback;
  final List<SelectedUser> constructingDataList;
  final void Function(List<People>) peopleListForSubscription;
  final bool isGlobalSearch;

  PeopleListWidget(this.people, this._successCallback,
      {this.usernameForContact,
      this.isCameFromContactInfo: false,
      this.isCameFromCoping: false,
      this.isCameFromSubscription: false,
      this.isCameFromAddUserFamily: false,
      this.isCameFromDiabetesRiskScore: false,
      this.constructingDataList,
      this.peopleListForSubscription,
      this.showBottomSheet,
      this.isGlobalSearch: false});

  @override
  _PeopleListWidgetState createState() => _PeopleListWidgetState();
}

class _PeopleListWidgetState extends State<PeopleListWidget> {
  List<People> peopleList = new List();

  UserInfoValidationBloc ailmentBloc;
  List<HealthScore> hasRiskScore1;
  @override
  initState() {
    super.initState();
    ailmentBloc = UserInfoValidationBloc(context);
    print("Global Search : ${widget.isGlobalSearch}");
  }

  _displayDialog(BuildContext context, int selectedIndex) async {
    String menuStr = await AppPreferences.getMenuItemsData();
    List<dynamic> jsonData = json.decode(menuStr);
    MenuItems items = MenuItems.fromJson(jsonData[0]);
    List<DrawerItem> drawerItems = [];
    drawerItems.add(DrawerItem(
        title: "Edit Profile",
        assetUrl: "assets/images/user.png",
        pageId: 100));
    for (USER item in items.menuInfo.uSER) {
      if (Constants.PAGE_ID_DAILY_CHECK_IN == item.pageId) {
        drawerItems.add(DrawerItem(
            title: item.label, assetUrl: item.icon, pageId: item.pageId));
      }
    }
    setState(() {});
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Choose an Option"),
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
            content: Container(
              width: double.maxFinite,
              child: ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: drawerItems.length,
                itemBuilder: (BuildContext context, int i) => Column(
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          switch (drawerItems[i].pageId) {
                            case 100:
                              moveToPersonalInformationScreen(
                                  context, widget.people[selectedIndex]);
                              break;

                            case Constants.PAGE_ID_DAILY_CHECK_IN:
                              Navigator.pushNamed(context,
                                  Routes.dailyStatusHistoryDynamicScreen,
                                  arguments: Args(
                                      isCameFromEditFamily:
                                          widget.isCameFromAddUserFamily,
                                      people: widget.people[selectedIndex]));
                              break;
                          }
                        },
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 5),
                            child: Row(
                              children: <Widget>[
                                Image.asset(
                                  drawerItems[i].assetUrl,
                                  width: 30,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(drawerItems[i].title)
                              ],
                            ))),
                    //SizedBox(height: 10,),
                    Visibility(
                      visible: i != drawerItems.length - 1,
                      child: Container(
                        width: double.infinity,
                        //margin: EdgeInsets.symmetric(horizontal: 7),
                        height: 1,
                        color: AppColors.borderLine,
                      ),
                    ),
                    Visibility(
                      visible: i != drawerItems.length - 1,
                      child: Container(
                        width: double.infinity,
                        //margin: EdgeInsets.symmetric(horizontal: 7),
                        height: 3,
                        color: AppColors.borderShadow,
                      ),
                    ),
                  ],
                )
                //AssetImage("assets/images/user.png")

                ,
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      // _widgetTitle(),
      ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: widget.people?.length,
          itemBuilder: (BuildContext context, int index) {
            var selectedCheckBox = false;
            if (widget.isCameFromSubscription) {
              widget.constructingDataList.forEach((element) {
                if (element.name == widget.people[index].userName) {
                  selectedCheckBox = true;
                  return;
                }
              });
            }
            if (widget.people[index].roleName == Constants.USER_ROLE &&
                (widget.people[index].userName != AppPreferences().username ||
                    (!widget.isCameFromAddUserFamily)) &&
                widget.people[index].userName != widget.usernameForContact) {
              print('GLOBAL SEARCH : ${widget.isGlobalSearch}');
              Widget view = getListItem(index,
                  selectedCheckBox: selectedCheckBox,
                  isGlobalSearch: widget.isGlobalSearch);
              return view;
            } else if (widget.isCameFromDiabetesRiskScore &&
                widget.people[index].userName != AppPreferences().username) {
              Widget widget =
                  getListItem(index, selectedCheckBox: selectedCheckBox);
              return widget;
            } else {
              return Container();
            }
          })
    ]);
  }

  Widget getListItem(int index, {bool isGlobalSearch, bool selectedCheckBox}) {
    // getHealthScoreHistoryList(widget.people.userName);
    // if (widget.isCameFromDiabetesRiskScore == true) {
    //   getHealthScoreHistoryList(widget.people[index].userName);
    // } else {}
    return PeopleListItem(
      widget.people[index],
      selectedValue: selectedCheckBox,
      hasRiskScore: hasRiskScore1 == null ||
              hasRiskScore1.length == 0 ||
              hasRiskScore1.isEmpty
          ? false
          : true,
      isCameFromSubscription: widget.isCameFromSubscription,
      isCameFromDiabetesRiskScore: widget.isCameFromDiabetesRiskScore,
      //isCameFromDiabetesRiskScore: widget.isCameFromDiabetesRiskScore,
      isGlobalSearch: isGlobalSearch,
      addRemoveSubscriberFromPeopleList: (People people, bool add) {
        setState(() {
          addOrRemoveUserFromPeopleList(people, add);
          widget.peopleListForSubscription(peopleList);
        });
      },
      onPress: () async {
        NewNotification item = NewNotification(type: "Profile");
        // print(widget.people[index].gender);
        if (widget.showBottomSheet) {
          showAvatarModalBottomSheet(
            isRecentActivity: false,
            expand: true,
            context: context,
            enableDrag: false,
            notification: item,
            people: widget.people[index],
            backgroundColor: Colors.transparent,
            builder: (context) => UserListBottomSheet(
                widget.people[index], ailmentBloc, widget._successCallback),
          );
        } else {
          Navigator.pushNamed(context, Routes.diabetesRiskScoreList,
              arguments: Args(people: widget.people[index]));
        }

        //openCupertinoBottomSheet(context,widget.people[index]);
        // if (AppPreferences().isDailyCheckInEnabled) if (widget
        //     .isCameFromSubscription) {
        // } else if (widget.isCameFromContactInfo) {
        //   print("Called ContactInfo");
        //   Navigator.pop(context, widget.people[index]);
        // } else if (widget.isCameFromAddUserFamily) {
        //   //todo : show dialog
        //   if (AppPreferences().role != Constants.supervisorRole) ;
        //   _displayDialog(context, index);
        //   //moveToPersonalInformationScreen(context, widget.people[index])
        // } else if (widget.isCameFromDiabetesRiskScore) {
        //   Navigator.pushNamed(context, Routes.diabetesRiskScoreList,
        //       arguments: Args(people: widget.people[index]));
        // } else {
        //   // daily checin
        //   Navigator.pushNamed(context, Routes.checkInHistoryScreen,
        //       arguments: Args(people: widget.people[index]));
        // }
      },
    );
  }

  // Future<Map<String, String>> createHeader(
  //     {String userName, String departmentName}) async {
  //   Map<String, String> header = {};
  //   String username = userName ?? await AppPreferences.getUsername();
  //   if (departmentName != null) {
  //     header.putIfAbsent(
  //         WebserviceConstants.departmentName, () => departmentName);
  //   }
  //   header.putIfAbsent(WebserviceConstants.contentType,
  //       () => WebserviceConstants.applicationJson);
  //   header.putIfAbsent(WebserviceConstants.username, () => username);
  //   return header;
  // }

  // getHealthScoreHistoryList(String userName) async {
  //   http.Client httpClient;
  //   String deptName = await AppPreferences.getDeptName();
  //   List<HealthScore> healthScoreList;
  //   final url = WebserviceConstants.baseFilingURL +
  //       WebserviceConstants.healthScore +
  //       "${WebserviceConstants.departments}$deptName${WebserviceConstants.users}$userName";
  //   Map<String, String> header = await createHeader(
  //     userName: userName,
  //     departmentName: deptName,
  //   );
  //   debugPrint("getHealthScoreHistoryList url --> $url");
  //   debugPrint("getHealthScoreHistoryList header --> $header");

  //   http.Response response = await http.get(url, headers: header);
  //   // debugPrint("getHealthScoreHistoryList response --> ${response.body}");
  //   // debugPrint(
  //   //     "getHealthScoreHistoryList response statuscode--> ${response.statusCode}");
  //   if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
  //     List<dynamic> data = jsonDecode(response.body);
  //     healthScoreList = data.map((data) => HealthScore.fromJson(data)).toList();
  //     setState(() {
  //       hasRiskScore1 = healthScoreList;
  //     });
  //     // return healthScoreList;

  //   } else {
  //     setState(() {
  //       hasRiskScore1 = [];
  //     });
  //     // return [];
  //   }
  // }

  addOrRemoveUserFromPeopleList(People people, bool add) {
    if (add) {
      peopleList.add(people);
      // print("Hello Pranay after add in People List ${peopleList[0].userName}");
      // print("Hello Pranay length of People List ${peopleList.length}");
    } else {
      for (int i = 0; i < peopleList.length; i++) {
        if (people.userName == peopleList[i].userName) {
          peopleList.removeAt(i);
          return;
        }
      }
    }
  }

  void moveToPersonalInformationScreen(
      BuildContext context, People people) async {
    final userName = await Navigator.pushNamed(
        context, Routes.personalInformationScreen,
        arguments: Args(
            arg: "",
            from: "update",
            people: people,
            username: people.userName));

    widget._successCallback(userName);
  }

  void moveToUserInformationScreen(BuildContext context, People people) async {
    final status = await Navigator.pushNamed(context, Routes.userInfoScreen,
        arguments: Args(people: people));
    if (status ?? false) widget._successCallback("Updated");
  }

  Widget _widgetTitle(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        margin: EdgeInsets.only(top: 10, right: 10, left: 10),
        decoration: BoxDecoration(
            color: AppColors.arrivedColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(15.0),
            )),
        child: SizedBox(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 7,
            ),
            Expanded(
                child: Container(
                    margin: EdgeInsets.only(left: 25),
                    padding: EdgeInsets.all(15),
                    child: Text(
                      AppLocalizations.of(context).translate("key_name"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ))),
            Container(
                margin: EdgeInsets.only(right: 15),
                padding: EdgeInsets.all(15),
                child: Text(
                  AppLocalizations.of(context).translate("key_age"),
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
