import 'dart:convert';

import '../../ui/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../ui_utils/app_colors.dart';
import '../../ui_utils/icon_utils.dart';
import '../../utils/routes.dart';
import '../../widgets/loading_widget.dart';
import '../custom_drawer/navigation_home_screen.dart';
import 'add_edit_committee_screen.dart';
import 'bloc/committees_bloc.dart';
import 'model/committee_data.dart';
import '../tabs/app_localizations.dart';
import 'repository/committees_repository.dart';
import 'package:fluttertoast/fluttertoast.dart';
import "../../utils/app_preferences.dart";

class CommitteesListScreen extends StatefulWidget {
  final String title;
  const CommitteesListScreen({Key key, this.title}) : super(key: key);
  @override
  _CommitteesListScreenState createState() => _CommitteesListScreenState();
}

class _CommitteesListScreenState extends State<CommitteesListScreen> {
  List<CommitteeData> committeeList = new List();
  bool isDataLoaded = false;
  bool isDataEmpty = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<CommitteeData> committeeSearchFilteredList = List();
  TextEditingController searchController = new TextEditingController();
  CommitteesRepository committeeRepositary = new CommitteesRepository();
  FocusNode focusNode = FocusNode();
  var filterMenulist = List<PopupMenuEntry<Object>>();
  int selectedSearchOption = 0;
  List<String> membershipFlow;

  double popupMenuItemHeight = 40;
  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    // TODO: implement initState
    /* flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('ic_launcher');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android: android, iOS: iOS);

    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: _onSelectNotification); */
    getCommitteeList();
    super.initState();
    getMembershipFlow();
  }

  /* Future<void> _onSelectNotification(String json) async {
    // final obj = jsonDecode(json);
    
    debugPrint(json);

    if (json == jsonDecode("success")) {
      // OpenFile.open(obj['filePath']);
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SettingsScreen(title: "Testing"),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('error'),
        ),
      );
    }
  } */

  getCommitteeList() {
    CommitteesBloc committeesBloc = CommitteesBloc(context);
    committeesBloc.getCommitteesList();
    committeesBloc.committeesListFetcher.listen((value) {
      // print("Value getCommitteesList $value");
      if (value == null) {
        committeeList.clear();
        setState(() {
          isDataLoaded = true;
          isDataEmpty = true;
        });
      }
      if (value != null && value.length != 0) {
        committeeList.clear();
        committeeSearchFilteredList.clear();
        for (dynamic v in value) {
          CommitteeData committeeData = CommitteeData.fromJson(v);
          //debugPrint("committeeData --> ${committeeData.members}");
          committeeList.add(committeeData);
          committeeSearchFilteredList.add(committeeData);
        }
        setState(() {
          isDataLoaded = true;
          isDataEmpty = false;
        });
      }
    });
  }

  getMembershipFlow() async {
    membershipFlow = List<String>();
    membershipFlow = ['Active', 'Inactive'];

    debugPrint("Membership flow --> $membershipFlow");
    debugPrint("Membership flow length --> ${membershipFlow.length}");
    createFilterDropDown();
  }

  createFilterDropDown() {
    filterMenulist.clear();
    addFilterByStatus();
    addClearFilter();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          widget.title != null ? widget.title : "Committee",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                //replaceHome();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NavigationHomeScreen()),
                    ModalRoute.withName(Routes.dashBoard));
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        //backgroundColor: AppColors.arrivedColor,
        onPressed: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          final refresh = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditCommitteeScreen(
                  // callbackForRefreshCommittee: (bool isRefreshCommittee) {
                  //   if (isRefreshCommittee) {
                  //     getCommitteeList();
                  //   }
                  // },
                  ),
            ),
          );
          updateListData(refresh);
        },
        child: Icon(
          Icons.add,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Container(
              //   height: MediaQuery.of(context).size.height * .08,
              //   child: searchBox(),
              // ),
              searchBox(),
              SizedBox(height: 8.0),
              committeeTitleText(),
              !isDataLoaded
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListLoading(),
                    )
                  : !isDataEmpty
                      ? SingleChildScrollView(
                          child: Container(
                            height: MediaQuery.of(context).size.height * .65,
                            child: committeeSearchFilteredList.length == 0 //&&
                                //searchController.text.isNotEmpty
                                ? noDataWidget()
                                // : committeeSearchFilteredList.length == 0
                                //     ? noDataWidget()
                                : ListView.builder(
                                    primary: false,
                                    shrinkWrap: true,
                                    itemCount:
                                        committeeSearchFilteredList.length !=
                                                    0 ||
                                                searchController.text.isNotEmpty
                                            ? committeeSearchFilteredList.length
                                            : committeeList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return committeeListItem(
                                        committeeSearchFilteredList.length !=
                                                    0 ||
                                                searchController.text.isNotEmpty
                                            ? committeeSearchFilteredList[index]
                                            : committeeList[index],
                                      );
                                    }),
                          ),
                        )
                      : Center(
                          child: Padding(
                              padding: const EdgeInsets.only(top: 100.0),
                              child: Container(
                                child: Text("No data available"),
                              )),
                        ),
            ],
          ),
        ),
      ),
    );
  }

  void updateListData(bool isChangedData) {
    // debugPrint("isChangedData --> $isChangedData");
    if (isChangedData != null && isChangedData) {
      getCommitteeList();
    }
  }

  Widget noDataWidget() {
    return Center(child: Text("No data available"));
  }

  Widget committeeTitleText() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: AppColors.arrivedColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15.0),
          )),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Name",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchBox() {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 12,
        ),
        Expanded(
          child: Container(
            // width: MediaQuery.of(context).size.width * .65,
            child: Center(
              child: Form(
                key: _formKey,
                child: TextFormField(
                  focusNode: focusNode,
                  controller: searchController,
                  decoration: new InputDecoration(
                    labelText: 'Search by Committee',
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  validator: (value) {
                    if (searchController.text.trim().length < 2) {
                      return "Search string must be 2 characters";
                    }
                  },
                  onChanged: (value) {
                    if (value.length == 0 || value.isEmpty) {
                      onSearchTextChanged(value);
                      setState(() {});
                    }
                  },
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
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
                if (searchController.text.isEmpty ||
                    searchController.text == null) {
                  Fluttertoast.showToast(
                      msg: AppLocalizations.of(context)
                          .translate("key_entersometext"),
                      gravity: ToastGravity.TOP,
                      toastLength: Toast.LENGTH_LONG);
                } else {
                  if (_formKey.currentState.validate() &&
                      searchController.text.trim().length > 1) {
                    onSearchTextChanged(searchController.text);
                  } else {
                    setState(() {
                      if (searchController.text.trim().length == 0) {
                        Fluttertoast.showToast(
                            msg: AppLocalizations.of(context)
                                .translate("key_entersometext"),
                            gravity: ToastGravity.TOP,
                            toastLength: Toast.LENGTH_LONG);
                        focusNode.requestFocus();
                      }
                    });
                  }
                }
              }),
        ),

        //Add filter option for active and inactive

        SizedBox(width: 10),
        PopupMenuButton(
          itemBuilder: (context) {
            return filterMenulist;
          },
          onCanceled: () {},
          onSelected: (value) {
            //  print("VALUE::::: $value");
            setState(() {
              if (value != -1) {
                selectedSearchOption = value;

                if (selectedSearchOption == 2) {
                  // clear all
                  searchController.clear();
                  FocusScope.of(context).requestFocus(FocusNode());
                  selectedSearchOption = 0;
                  committeeSearchFilteredList.clear();
                  // committeeSearchFilteredList.addAll(committeeList);
                  getCommitteeList();
                } else if (selectedSearchOption > 2) {
                  searchController.clear();
                  FocusScope.of(context).requestFocus(FocusNode());
                  //  print("=====================> ${selectedSearchOption}");
                  int tmpValue =
                      selectedSearchOption - 3; // subtract the tempCount
// tmpValue = 0;//Inactive
                  committeeSearchFilteredList.clear();

                  for (int i = 0; i < committeeList.length; i++) {
                    if (tmpValue == 0) {
                      if (committeeList[i].active) {
                        committeeSearchFilteredList.add(committeeList[i]);
                      }
                    } else {
                      if (!committeeList[i].active) {
                        //if (committeeList[i].active == false) {
                        committeeSearchFilteredList.add(committeeList[i]);
                      }
                    }
                  }
                  setState(() {
                    isDataLoaded = true;
                  });
                }
              }

              //  print("Length  ========  ${committeeSearchFilteredList.length}");
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
    );
  }

  deleteCommitteeAlert(committeeName) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Alert"),
          content: Text("Are you sure you want to delete?"),
          actions: [
            FlatButton(
              onPressed: () async {
                int status =
                    await committeeRepositary.deleteCommittee(committeeName);
                Navigator.pop(context);
                var message = "Committee deleted successfully";
                if (status != 204) {
                  message = AppPreferences().getApisErrorMessage;
                } else {
                  getCommitteeList();
                }
                Fluttertoast.showToast(gravity: ToastGravity.TOP, msg: message);
              },
              child: Text("Yes"),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("No"),
            )
          ],
        );
      },
    );
  }

  Widget committeeListItem(CommitteeData committeeData) {
    String lastUpdated =
        DateUtils.convertUTCToLocalTime(committeeData.modifiedOn);
    // print("=====================> Active ==>  ${committeeData.active}");
    return InkWell(
      onTap: () async {
        final refresh = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddEditCommitteeScreen(
              committeeName: committeeData.committeeName,
              committeeDepartmentName: committeeData.departmentName,
              isUpdate: true,
              // callbackForRefreshCommittee: (bool isRefreshCommittee) {
              //   if (isRefreshCommittee) {
              //     getCommitteeList();
              //   }
              // },
            ),
          ),
        );
        updateListData(refresh);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      "${committeeData.committeeName}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 0.0),
                    child: IconButton(
                      onPressed: () {
                        deleteCommitteeAlert(committeeData.committeeName);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  //     Container(
                  //       decoration: BoxDecoration(
                  //           color: committeeData.active
                  //               ? Colors.green
                  //               : Colors.red,
                  //           borderRadius: BorderRadius.circular(10)),
                  //       child: Padding(
                  //         padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  //         child: Text(
                  //           committeeData.active ? "Active" : "Inactive",
                  //           style: TextStyle(color: Colors.white, fontSize: 12),
                  //         ),
                  //       ),
                  //     )
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Last updated : " + lastUpdated,
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: committeeData.active ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Text(
                      committeeData.active ? "Active" : "Inactive",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                )
              ]),
              SizedBox(
                height: 15,
              ),
              Container(
                width: double.infinity,
                //margin: EdgeInsets.symmetric(horizontal: 7),
                height: 1,
                color: AppColors.borderLine,
              ),
              Container(
                width: double.infinity,
                //margin: EdgeInsets.symmetric(horizontal: 7),
                height: 5,
                color: AppColors.borderShadow,
              ),
            ],
          ),
        ),
      ),
    );
  }

  onSearchTextChanged(String text) async {
    committeeSearchFilteredList.clear();
    if (text.isEmpty) {
      setState(() {
        getCommitteeList();
      });
      return;
    }
    setState(() {
      isDataLoaded = false;
    });
    selectedSearchOption = 2;
    committeeList = await committeeRepositary.getCommitteeSearchList(
        text, selectedSearchOption);
    for (int i = 0; i < committeeList.length; i++) {
      if (committeeList[i]
          .committeeName
          .toLowerCase()
          .contains(text.toLowerCase())) {
        committeeSearchFilteredList.add(committeeList[i]);
      }
    }

    setState(() {
      isDataLoaded = true;
    });
  }
}
