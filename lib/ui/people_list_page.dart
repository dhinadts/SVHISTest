import '../bloc/people_list_bloc.dart';
import '../bloc/user_info_validation_bloc.dart';
import '../model/passing_arg.dart';
import '../model/people.dart';
import '../model/people_response.dart';
import '../ui/custom_drawer/custom_app_bar.dart';
import '../ui/hierarchical/bloc/department_bloc.dart';
// import '../ui/diabetes_risk_score/diabetes_risk_score_screen.dart';
import '../ui/tabs/app_localizations.dart';
import '../ui/user_list_hierarchical/ui/hierarchical_user_list_widget.dart';
import '../ui_utils/app_colors.dart';
import '../ui_utils/ui_dimens.dart';
import '../utils/app_preferences.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../utils/validation_utils.dart';
// import '../widgets/current_status_widget.dart';
import '../widgets/people_list_loading.dart';
import '../widgets/people_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'advertise/adWidget.dart';
import 'diabetes_risk_score/diabetes_risk_score_screen.dart';
import 'subscription/subscription_screen.dart';

import '../ui/user_list_hierarchical/widgets/user_list_searchbar.dart';

class PeopleListPage extends StatefulWidget {
  final bool isCameFromContactInfo;
  final bool isCameFromCoping;
  final UserInfoValidationBloc actionBloc;
  final String usernameForContact;
  final bool isCameFromAddUserFamily;
  final bool isCameFromSubscription;
  final bool isCameFromDiabetesRiskScore;
  final List<SelectedUser> constructingDataList;
  final String title;

  PeopleListPage({
    this.usernameForContact,
    this.actionBloc,
    this.title,
    this.isCameFromContactInfo: false,
    this.isCameFromCoping: false,
    this.isCameFromSubscription: false,
    this.isCameFromAddUserFamily: false,
    this.isCameFromDiabetesRiskScore: false,
    this.constructingDataList,
  });

  @override
  PeopleListPageState createState() => PeopleListPageState();
}

class PeopleListPageState extends State<PeopleListPage> {
  bool isVisibilityCurrentState = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PeopleListBloc _bloc;
  static List peopleList = [];
  List<People> peopleListForSubscriptionTemp = new List();
  PeopleResponse response;
  bool init = false, searchableStringEntered = false;
  String searchQuery = "";
  var controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool _showDailyWellnessReminder = false;
  String totalUserLabel = "Users/Members";
  int tempPageId;

  bool isHierarchy = false, isLoaded = false;
  DepartmentBloc departmentBloc;
  List<String> membershipFlow;
  var filterMenulist = List<PopupMenuEntry<Object>>();
  double popupMenuItemHeight = 40;
  int selectedSearchOption = -1;
  String searchOutside = "";
  @override
  void initState() {
    super.initState();
    //debugPrint("people list initState called....");
    text = "";
    _bloc = new PeopleListBloc(context);
    initializeData(widget.isCameFromAddUserFamily);
    if (widget.actionBloc != null)
      widget.actionBloc.actionTrigger.listen((value) {
        controller?.text = "";
        try {
          FocusScope.of(context).requestFocus(new FocusNode());
        } catch (_) {}
        initializeData(value);
      });
    // debugPrint("=================> Memberhip Applicable ==> "+AppPreferences().isMembershipApplicable.toString());
    initializeAd();
  }

  initializeData(bool actionTriggerValue) {
    isHierarchy = false;
    isLoaded = false;
    setState(() {});
    departmentBloc = DepartmentBloc(context);
    departmentBloc.getDepartment();
    departmentBloc.departmentFetcher.listen((value) {
      if (ValidationUtils.isSuccessResponse(value.status) &&
          value.subDepartments != null &&
          value.subDepartments.length > 0) {
        isHierarchy = true;
        setState(() {});
      } else {
        if (AppPreferences().role == Constants.supervisorRole) {
          // print(
          // "Pranay --username of supervisor role ${AppPreferences().username}");
          // print(
          // "Pranay --Department of supervisor role ${AppPreferences().deptmentName}");
          _showDailyWellnessReminder = true;
          _bloc.fetchPeopleList(onlyPrimary: widget.isCameFromSubscription);
        } else {
          //Testing purpose
          /*_bloc.fetchSecondaryUserList(
          parentUserName: "ThiruMal12",
          departmentName: AppPreferences().deptmentName);*/
          // debugPrint("actionTriggerValue --> $actionTriggerValue");
          _bloc.fetchSecondaryUserList(
              parentUserName: AppPreferences().username,
              departmentName: AppPreferences().deptmentName,
              isFromAddUserFamily: actionTriggerValue);
        }
      }
    });
    getMembershipFlow();
  }

  getMembershipFlow() async {
    membershipFlow = List<String>();
    membershipFlow = await AppPreferences.getMembershipWorkFlow();

    debugPrint("Membership flow --> $membershipFlow");
    debugPrint("Membership flow length --> ${membershipFlow.length}");
    createFilterDropDown();
  }

  createFilterDropDown() {
    filterMenulist.clear();
    addSearchByFilter();
    if (membershipFlow != null && membershipFlow.length > 0) {
      addFilterByStatus();
    }
    addClearFilter();
  }

  addSearchByFilter() {
    filterMenulist.add(
      PopupMenuItem(
        height: popupMenuItemHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Filter by Category",
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
            Text('Users'),
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
            Text('Members'),
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

    if (membershipFlow != null && membershipFlow.isNotEmpty) {
      // To set the value
      int tempCount = 3; //till 2, it is known values
      membershipFlow.forEach((membershipFlowStatus) {
        if (membershipFlowStatus.isNotEmpty) {
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
                  Text(membershipFlowStatus),
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
        value: 2,
      ),
    );
  }

  String getPageTitle() {
    if (widget.isCameFromContactInfo) {
      tempPageId = 0;
      return AppPreferences().isTTDEnvironment()
          ? AppLocalizations.of(context).translate("key_peoplelist_tt")
          : AppLocalizations.of(context).translate("key_peoplelist");
    } else if (widget.isCameFromCoping) {
      tempPageId = Constants.PAGE_ID_COPING;
      return AppLocalizations.of(context).translate("key_how_are_you_coping");
    } else if (widget.isCameFromAddUserFamily) {
      tempPageId = Constants.PAGE_ID_ADD_USER_FAMILY;
      return AppLocalizations.of(context).translate("key_edit_my_family");
    } else if (widget.isCameFromSubscription) {
      tempPageId = 0;
      return AppPreferences().isTTDEnvironment()
          ? AppLocalizations.of(context).translate("key_peoplelist_tt")
          : AppLocalizations.of(context).translate("key_peoplelist");
    } else if (widget.isCameFromDiabetesRiskScore) {
      tempPageId = Constants.PAGE_ID_DIABETES;
      return AppLocalizations.of(context).translate("key_diabetes_risk_title");
    } else {
      tempPageId = Constants.PAGE_ID_PEOPLE_LIST;
      if (AppPreferences().role == Constants.supervisorRole) {
        return AppPreferences().isTTDEnvironment()
            ? AppLocalizations.of(context).translate("key_peoplelist_tt")
            : AppLocalizations.of(context).translate("key_peoplelist");
      } else {
        return AppLocalizations.of(context).translate(
            AppPreferences().isTTDEnvironment()
                ? "key_dailycheckin_tt"
                : "key_dailycheckin");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (widget.isCameFromContactInfo || widget.isCameFromSubscription)
          ? buildAppBar(context)
          : CustomAppBar(title: getPageTitle(), pageId: tempPageId),
      body: Column(
        children: [
          Expanded(
            child: isHierarchy
                ? HierarchicalUserListWidget()
                : Form(
                    key: _formKey,
                    autovalidate: true,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 30,
                          ),
//              widget.isCameFromSubscription ? Text("Total selected ${peopleListForSubscriptionTemp?.length + widget.constructingDataList?.length}"):Container(),
//              SizedBox(
//                height: 10,
//              ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.70,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: AppUIDimens.paddingSmall),
                                  child: TextFormField(
                                    focusNode: focusNode,
                                    onChanged: (data) {
                                      //_filter(data);
                                      if (data.length == 0 &&
                                          selectedSearchOption == -1) {
                                        callSearchAPI();
                                      }
                                    },
                                    controller: controller,
                                    decoration: InputDecoration(
                                      labelText: AppLocalizations.of(context)
                                          .translate("key_search_by_name"),
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        //fillColor: Colors.green
                                      ),
                                    ),
                                    keyboardType: TextInputType.text,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.deny(
                                          RegExp('[0-9]')),
                                    ],
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

//              if (false)
                                Ink(
                                  decoration: const ShapeDecoration(
                                    color: Colors.blueGrey,
                                    shape: CircleBorder(),
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.search),
                                    color: Colors.white,
                                    onPressed: () {
                                      if (_formKey.currentState.validate() &&
                                          controller.text.trim().length > 1) {
                                        setState(() {
                                          searchableStringEntered = true;
                                        });

                                        if (searchOutside.isEmpty ||
                                            searchOutside == "" ||
                                            searchOutside == null) {
                                          selectedSearchOption = -1;

                                          _bloc.fetchPeopleList(
                                            searchUsernameString:
                                                controller.text,
                                          );
                                        } else {
                                          if (searchOutside.toLowerCase() ==
                                                  "Active".toLowerCase() ||
                                              searchOutside.toLowerCase() ==
                                                  "Expired".toLowerCase()) {
                                            _bloc.fetchPeopleList(
                                                searchUsernameString:
                                                    controller.text,
                                                membershipEntitlements:
                                                    searchOutside);
                                          } else if (searchOutside
                                                      .toLowerCase() ==
                                                  "User".toLowerCase() ||
                                              searchOutside.toLowerCase() ==
                                                  "Member".toLowerCase()) {
                                            _bloc.fetchPeopleList(
                                                searchUsernameString:
                                                    controller.text,
                                                membershipType: searchOutside);
                                          } else {
                                            _bloc.fetchPeopleList(
                                                searchUsernameString:
                                                    controller.text,
                                                tempMembershipStatus:
                                                    searchOutside);
                                          }
                                        }
                                        /* _bloc.fetchPeopleList(
                                searchUsernameString: controller.text,
                                departmentName: widget.departmentName,
                              ); */
                                      } else {
                                        setState(() {
                                          if (controller.text.trim().length ==
                                              0) {
                                            Fluttertoast.showToast(
                                                msg: AppLocalizations.of(
                                                        context)
                                                    .translate(
                                                        "key_entersometext"),
                                                gravity: ToastGravity.TOP,
                                                toastLength: Toast.LENGTH_LONG);
                                            focusNode.requestFocus();
                                          }
                                        });
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                if (AppPreferences().isMembershipApplicable)
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
                                            controller.clear();
                                            searchOutside = "Member";
                                            _bloc.fetchPeopleList(
                                                searchUsernameString:
                                                    controller.text,
                                                membershipType: "Member");
                                            setState(() {
                                              totalUserLabel = "Members";
                                            });
                                          }

                                          if (selectedSearchOption == 2) {
                                            // clear all

                                            searchOutside = "";
                                            setState(() {
                                              totalUserLabel = "Users/Members";
                                            });
                                            controller.clear();
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());

                                            selectedSearchOption = -1;
                                            _bloc.fetchPeopleList(
                                              searchUsernameString:
                                                  controller.text,
                                              // membershipEntitlements: membershipFlow[tmpValue],
                                            );
                                          } else if (selectedSearchOption > 2) {
                                            controller.clear();
                                            setState(() {
                                              totalUserLabel = "Members";
                                            });
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                            int tmpValue =
                                                selectedSearchOption -
                                                    3; // subtract the tempCount
                                            if (membershipFlow != null &&
                                                membershipFlow.length > 0) {
                                              searchOutside =
                                                  membershipFlow[tmpValue];
                                              if (membershipFlow[tmpValue]
                                                          .toLowerCase() ==
                                                      "Active".toLowerCase() ||
                                                  membershipFlow[tmpValue]
                                                          .toLowerCase() ==
                                                      "Expired".toLowerCase()) {
                                                _bloc.fetchPeopleList(
                                                  searchUsernameString:
                                                      controller.text,
                                                  membershipEntitlements:
                                                      membershipFlow[tmpValue],
                                                );
                                              } else {
                                                _bloc.fetchPeopleList(
                                                  searchUsernameString:
                                                      controller.text,
                                                  tempMembershipStatus:
                                                      membershipFlow[tmpValue],
                                                );
                                              }
                                            }
                                          } else if (selectedSearchOption ==
                                              0) {
                                            setState(() {
                                              totalUserLabel = "Users";
                                            });
                                            controller.clear();
                                            searchOutside = "User";
                                            _bloc.fetchPeopleList(
                                                searchUsernameString:
                                                    controller.text,
                                                membershipType: "User"
                                                // membershipEntitlements: "membershipId",
                                                );

                                            // searchOutside = "membershipId";
                                          }

                                          // else if (selectedSearchOption == 1) {
                                          //   _bloc.fetchPeopleList(
                                          //     searchUsernameString: controller.text,
                                          //     departmentName: widget.departmentName,
                                          //     // membershipEntitlements: "Name",
                                          //   );

                                          //   searchOutside = "membershipId";
                                          // }
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
                              ]),
                          SizedBox(
                            height: 10.0,
                          ),
                          Visibility(
                            visible: widget.isCameFromDiabetesRiskScore,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                RaisedButton(
                                  onPressed: () {
                                    Navigator.push<bool>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DiabetesRiskScoreScreen(
                                          isProspect: true,
                                        ),
                                      ),
                                    );
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  textColor: Colors.white,
                                  color: AppColors.arrivedColor,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.person_add,
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Text('Prospective user'),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height:
                                widget.isCameFromDiabetesRiskScore ? 10 : 25,
                          ),

                          StreamBuilder(
                              stream: _bloc.peopleListFetcher,
                              builder: (context,
                                  AsyncSnapshot<PeopleResponse> snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data is PeopleResponse &&
                                      snapshot.data?.peopleResponse?.length >
                                          0) {
                                    // print(
                                    // "People Length : ${snapshot.data?.peopleResponse
                                    // ?.length}");
                                    if (!init) {
                                      response = snapshot.data;
                                      init = true;
                                    }
                                    if (snapshot.data?.peopleResponse != null) {
//for mydata and count is 1 , show no-record container
                                      if (snapshot
                                              .data?.peopleResponse?.length ==
                                          1) {
                                        if ((snapshot.data?.peopleResponse[0]
                                                    .userName ==
                                                AppPreferences().username) &&
                                            widget.isCameFromContactInfo) {
                                          return Container(
                                              child: Text(searchQuery.isNotEmpty
                                                  ? AppLocalizations.of(context)
                                                      .translate(
                                                          "key_no_record_found")
                                                  : AppLocalizations.of(context)
                                                      .translate(
                                                          "key_no_data_found")));
                                        }
                                      }
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                              padding: EdgeInsets.only(
                                                  left: 8.0, bottom: 8.0),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Total ${computeTotalUsersLable(snapshot.data?.peopleResponse.length, totalUserLabel)} : ${snapshot.data?.peopleResponse.length}",
                                                style: TextStyle(fontSize: 17),
                                              )),
                                          PeopleListWidget(
                                              snapshot.data?.peopleResponse,
                                              updateListData,
                                              showBottomSheet: true,
                                              isCameFromContactInfo:
                                                  widget.isCameFromContactInfo,
                                              usernameForContact:
                                                  widget.usernameForContact,
                                              isCameFromCoping:
                                                  widget.isCameFromCoping,
                                              isCameFromAddUserFamily: widget
                                                  .isCameFromAddUserFamily,
                                              isCameFromSubscription:
                                                  widget.isCameFromSubscription,
                                              isCameFromDiabetesRiskScore: widget
                                                  .isCameFromDiabetesRiskScore,
                                              constructingDataList:
                                                  widget.constructingDataList,
                                              peopleListForSubscription:
                                                  (peopleListForSubscription) {
                                            setState(() {
                                              // print("length of peopleListForSubscription afterPeople list widget ${peopleListForSubscription.length}");
                                              // print("Value of peopleListForSubscription afterPeople list widget ${peopleListForSubscription[0].userName}");

                                              peopleListForSubscriptionTemp =
                                                  List.from(
                                                      peopleListForSubscription);
                                              // print("length of peopleListForSubscriptionTemp after copy list widget ${peopleListForSubscriptionTemp.length}");
                                              //  peopleListForSubscription = peopleListForSubscription;
                                              if ((peopleListForSubscriptionTemp
                                                          .length +
                                                      widget
                                                          .constructingDataList
                                                          .length) >
                                                  25) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Already added max number of users",
                                                    gravity: ToastGravity.TOP,
                                                    toastLength:
                                                        Toast.LENGTH_LONG);
                                              }
                                            });
                                          }),
                                        ],
                                      );
                                    } else {
                                      return Container(
                                          child: Text(searchQuery.isNotEmpty
                                              ? AppLocalizations.of(context)
                                                  .translate(
                                                      "key_no_record_found")
                                              : AppLocalizations.of(context)
                                                  .translate(
                                                      "key_no_data_found")));
                                    }
                                  } else {
                                    return Container(
                                        child: Text(searchQuery.isNotEmpty
                                            ? AppLocalizations.of(context)
                                                .translate(
                                                    "key_no_record_found")
                                            : AppLocalizations.of(context)
                                                .translate(
                                                    "key_no_data_found")));
                                  }
                                }
                                return PeopleListLoadingWidget();
                              })
                        ],
                      ),
                    ),
                  ),
          ),

          /// Show Banner Ad
          getSivisoftAdWidget(),
        ],
      ),
      floatingActionButton:
          (AppPreferences().role != Constants.supervisorRole &&
                  (widget.isCameFromAddUserFamily))
              ? FloatingActionButton(
                  onPressed: () {
                    moveToPersonalInfoScreen();
                  },
                  child: Icon(Icons.add),
                )
              : (AppPreferences().role == Constants.supervisorRole &&
                      (widget.isCameFromSubscription))
                  ? Container(
                      alignment: Alignment.bottomCenter,
                      child: FloatingActionButton(
                        backgroundColor: Colors.indigo[700],
                        onPressed: () {
                          addAndRemoveUsersToSubscriptionScreen();
                          // Navigator.pop(context);
                        },
                        child: Icon(Icons.add),
                      ),
                    )
                  : Container(),
    );
  }

  computeTotalUsersLable(int count, String lable) {
    if (count > 1) {
      return lable;
    } else {
      if (lable == "Users/Members") {
        var temp = lable.split("/")[0].split("");
        String firstLabel = "";
        String lastLabel = "";
        for (var i = 0; i < temp.length; i++) {
          if (i < temp.length - 1) {
            firstLabel = firstLabel + temp[i];
          }
        }
        temp = lable.split("/")[1].split("");
        for (var i = 0; i < temp.length; i++) {
          if (i < temp.length - 1) {
            lastLabel = lastLabel + temp[i];
          }
        }
        return firstLabel + "/" + lastLabel;
      } else {
        var temp = lable.split("");
        String firstLabel = "";
        for (var i = 0; i < temp.length; i++) {
          if (i != temp.length - 1) {
            firstLabel = firstLabel + temp[i];
          }
        }
        return firstLabel;
      }
    }
  }

  void moveToPersonalInfoScreen() async {
    final userName = await Navigator.pushNamed(
        context, Routes.personalInformationScreen,
        arguments: Args(
            arg: "",
            from: "create",
            people: null,
            username: AppPreferences().username));
    // debugPrint("moveToPersonalInfoScreen userName --> $userName");
    updateListData(userName);
  }

  void addAndRemoveUsersToSubscriptionScreen() async {
    // print(
    // "length of peopleListForSubscription on Click of add ${peopleListForSubscriptionTemp
    // .length}");
    //print("Value of peopleListForSubscription ${peopleListForSubscription[0].userName}");

    if ((peopleListForSubscriptionTemp.length +
            widget.constructingDataList.length) >
        25) {
      Fluttertoast.showToast(
          msg: "Already added max number of users",
          gravity: ToastGravity.TOP,
          toastLength: Toast.LENGTH_LONG);
    } else if (peopleListForSubscriptionTemp.length == 0) {
      Fluttertoast.showToast(
          msg: "No user is added",
          gravity: ToastGravity.TOP,
          toastLength: Toast.LENGTH_LONG);
      Navigator.pop(context, peopleListForSubscriptionTemp);
    } else if (peopleListForSubscriptionTemp.length == 1) {
      Fluttertoast.showToast(
          msg: "User is added",
          gravity: ToastGravity.TOP,
          toastLength: Toast.LENGTH_LONG);
      Navigator.pop(context, peopleListForSubscriptionTemp);
    } else {
      Fluttertoast.showToast(
          msg: "Users are added",
          gravity: ToastGravity.TOP,
          toastLength: Toast.LENGTH_LONG);
      Navigator.pop(context, peopleListForSubscriptionTemp);
    }
  }

  void updateListData(String userName) {
    // print("updateListData called....");
    if (userName != null && userName.isNotEmpty) {
      //updatedUserName = userName;
      init = false;
      if (userName == "Updated") {
        _bloc.fetchPeopleList();
      } else {
        _bloc
            .fetchSecondaryUserList(
                parentUserName: AppPreferences().username,
                departmentName: AppPreferences().deptmentName,
                isFromAddUserFamily: true)
            .then((value) {
          // debugPrint("updateListData called....");
        });
      }
    }
  }

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      backgroundColor: AppColors.primaryColor,
      centerTitle: true,
      iconTheme: new IconThemeData(color: Colors.white),
      title: new Text(
        widget.title ??
            (AppPreferences().isTTDEnvironment()
                ? AppLocalizations.of(context).translate("key_peoplelist_tt")
                : AppLocalizations.of(context).translate("key_peoplelist")),
        style: AppPreferences().isLanguageTamil()
            ? TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)
            : TextStyle(color: Colors.white),
      ),
      actions: widget.isCameFromSubscription
          ? <Widget>[
              Align(
                  alignment: Alignment.center,
                  child: Padding(
                      padding:
                          EdgeInsets.only(right: AppUIDimens.paddingMedium),
                      child: Text(
                        "${peopleListForSubscriptionTemp?.length + widget.constructingDataList?.length}/25",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w700),
                      )))
            ]
          : null,
    );
  }

  callSearchAPI() {
    // debugPrint("callSearchAPI ...");
    _formKey.currentState.validate();
    if (searchableStringEntered && controller.text.length == 0) {
      setState(() {
        searchableStringEntered = false;
      });
      _bloc.fetchPeopleList(onlyPrimary: widget.isCameFromSubscription);
    }
  }

  _filter(String searchPeople) {
    setState(() {
      searchQuery = searchPeople;
    });
    // print("Search date is --> $searchPeople");
    List<dynamic> filteredList = new List();
    for (final people in response.peopleResponse) {
      //TODO: Need to clarify search option by username or first and last name?
      if (people.firstName.toLowerCase().contains(searchPeople.toLowerCase()) ||
          people.lastName.toLowerCase().contains(searchPeople.toLowerCase())) {
        filteredList.add(people.toJson());
      }
    }
    Map<String, dynamic> jsonMapData = new Map();
    try {
      jsonMapData.putIfAbsent("peopleResponse", () => filteredList);
      // debugPrint("filtered peopleList - ${filteredList.toString()}");
    } catch (_) {
      // print("" + _);
    }
    PeopleResponse historyList = PeopleResponse.fromJson(jsonMapData);
    _bloc.peopleListFetcher.sink.add(historyList);
  }
}
