import '../../../bloc/people_list_bloc.dart';
import '../../../model/people.dart';
import '../../../model/people_response.dart';
import '../../../ui/diabetes_risk_score/diabetes_risk_score_screen.dart';
import '../../../ui/membership/api/membership_api_client.dart';
import '../../../ui/membership/bloc/membership_bloc.dart';
import '../../../ui/membership/repo/membership_repo.dart';
import '../../../ui/tabs/app_localizations.dart';
import '../../../ui/user_list_hierarchical/widgets/user_list_searchbar.dart';
import '../../../ui_utils/app_colors.dart';
import '../../../utils/app_preferences.dart';
import '../../../widgets/people_list_loading.dart';
import '../../../widgets/people_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

//var searchController = TextEditingController();
var mainSearchController = TextEditingController();
//final FocusNode focusNodeInner = FocusNode();

class UserListWidgetWithSearch extends StatefulWidget {
  final String departmentName;
  final TextEditingController searchController;
  final void Function(bool) successCallback;

  UserListWidgetWithSearch(this.departmentName,
      {this.successCallback, this.searchController});

  @override
  _UserListWidgetWithSearchState createState() =>
      _UserListWidgetWithSearchState();
}

class _UserListWidgetWithSearchState extends State<UserListWidgetWithSearch> {
  // final FocusNode focusNode = FocusNode();
  // final TextEditingController controller = TextEditingController();
  final membershipRepo = MembershipRepository(
      membershipApiClient: MembershipApiClient(httpClient: http.Client()));

  PeopleListBloc _bloc;

  MembershipBloc _membershipBloc;

  int selectedSearchOption = -1;

  double popupMenuItemHeight = 40;

  List<String> membershipFlow;
  var filterMenulist = List<PopupMenuEntry<Object>>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PeopleResponse response;
  bool init = false, searchableStringEntered = false;
  String searchQuery = "";
  String totalUserLable = "Users/Members";
  bool userListEmpty = false;
  static List peopleList = [];
  List<People> peopleListForSubscriptionTemp = new List();

  String searchOutside = "";
  String searchedText = "";
  //var searchController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // mainSearchController.clear();
  }

  @override
  void initState() {
    //searchController.clear();
    mainSearchController.clear();
    super.initState();
    getMembershipFlow();
    _bloc = new PeopleListBloc(context);
    /*_bloc.fetchSecondaryUserList(
        parentUserName: '',
        departmentName: widget.departmentName,
        isFromAddUserFamily: false);*/
    _bloc.fetchPeopleList(
        onlyPrimary: false,
        departmentName: widget.departmentName,
        membershipEntitlements: "");

    _bloc.peopleListFetcher.listen((value) {
      if (value != null) {
        setState(() {
          init = true;
        });
      }
    });
  }

  int lastIndex = 0;
  getMembershipFlow() async {
    membershipFlow = List<String>();
    membershipFlow = await AppPreferences.getMembershipWorkFlow();

    debugPrint("Membership flow --> $membershipFlow");
    debugPrint("Membership flow length --> ${membershipFlow.length}");
    //createFilterDropDown();
  }

  /* createFilterDropDown() {
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

  callSearchAPI() {
    // debugPrint("callSearchAPI ...");
    _formKey.currentState.validate();
    if (searchableStringEntered && controller.text.length == 0) {
      setState(() {
        searchableStringEntered = false;
      });
      _bloc.fetchPeopleList(
        onlyPrimary: false,
        departmentName: widget.departmentName,
      );
      */ /* _bloc.fetchSecondaryUserList(
          parentUserName: '',
          departmentName: widget.departmentName,
          isFromAddUserFamily: false);*/ /*
    }
  }*/

  void updateListData(String userName) {
    // print("updateListData called....");
    if (userName != null && userName.isNotEmpty) {
      //updatedUserName = userName;
      init = false;
      if (userName == "Updated") {
        //_bloc.fetchPeopleList();
        _bloc.fetchPeopleList(
          onlyPrimary: false,
          departmentName: widget.departmentName,
        );
        /*_bloc
            .fetchSecondaryUserList(
            parentUserName: '',
            departmentName: widget.departmentName,
            isFromAddUserFamily: false)
            .then((value) {
          // debugPrint("updateListData called....");
        });*/
      } else {
        _bloc.fetchPeopleList(
          onlyPrimary: false,
          departmentName: widget.departmentName,
        );
        /*_bloc
            .fetchSecondaryUserList(
            parentUserName: '',
            departmentName: widget.departmentName,
            isFromAddUserFamily: false)
            .then((value) {
          // debugPrint("updateListData called....");
        });*/
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          if (init)
            const SizedBox(
              height: 30,
            ),
//              false ? Text("Total selected ${peopleListForSubscriptionTemp?.length + widget.constructingDataList?.length}"):Container(),
//              SizedBox(
//                height: 10,
//              ),
          /* if (init)
              Row(children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppUIDimens.paddingSmall),
                    child: TextFormField(
                      focusNode: focusNode,
                      onChanged: (data) {
                        //_filter(data);
                        if (data.length == 0 && selectedSearchOption == -1) {
                          callSearchAPI();
                        }
                      },
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)
                            .translate("key_search_by_name"),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        //fillColor: Colors.green
                      ),
                      keyboardType: TextInputType.text,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.deny(RegExp('[0-9]')),
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
                            searchUsernameString: controller.text,
                            departmentName: widget.departmentName,
                          );
                        } else {
                          if (searchOutside.toLowerCase() ==
                                  "Active".toLowerCase() ||
                              searchOutside.toLowerCase() ==
                                  "Expired".toLowerCase()) {
                            _bloc.fetchPeopleList(
                                searchUsernameString: controller.text,
                                departmentName: widget.departmentName,
                                membershipEntitlements: searchOutside);
                          } else if (searchOutside.toLowerCase() ==
                                  "User".toLowerCase() ||
                              searchOutside.toLowerCase() ==
                                  "Member".toLowerCase()) {
                            _bloc.fetchPeopleList(
                                searchUsernameString: controller.text,
                                departmentName: widget.departmentName,
                                membershipType: searchOutside);
                          } else {
                            _bloc.fetchPeopleList(
                                searchUsernameString: controller.text,
                                departmentName: widget.departmentName,
                                tempMembershipStatus: searchOutside);
                          }
                        }
                        */ /* _bloc.fetchPeopleList(
                          searchUsernameString: controller.text,
                          departmentName: widget.departmentName,
                        ); */ /*
                      } else {
                        setState(() {
                          if (controller.text.trim().length == 0) {
                            Fluttertoast.showToast(
                                msg: AppLocalizations.of(context)
                                    .translate("key_entersometext"),
                                gravity: ToastGravity.TOP,
                                toastLength: Toast.LENGTH_LONG);
                            focusNode.requestFocus();
                          }
                        });
                      }
                    },
                  ),
                ),
                if (init)
                  const SizedBox(
                    width: 10,
                  ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: PopupMenuButton(
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
                                searchUsernameString: controller.text,
                                departmentName: widget.departmentName,
                                membershipType: "Member");
                          }

                          if (selectedSearchOption == 2) {
                            // clear all

                            searchOutside = "";

                            controller.clear();
                            FocusScope.of(context).requestFocus(FocusNode());

                            selectedSearchOption = -1;
                            _bloc.fetchPeopleList(
                              searchUsernameString: controller.text,
                              departmentName: widget.departmentName,
                              // membershipEntitlements: membershipFlow[tmpValue],
                            );
                          } else if (selectedSearchOption > 2) {
                            controller.clear();

                            FocusScope.of(context).requestFocus(FocusNode());
                            int tmpValue = selectedSearchOption -
                                3; // subtract the tempCount
                            if (membershipFlow != null &&
                                membershipFlow.length > 0) {
                              searchOutside = membershipFlow[tmpValue];
                              if (membershipFlow[tmpValue].toLowerCase() ==
                                      "Active".toLowerCase() ||
                                  membershipFlow[tmpValue].toLowerCase() ==
                                      "Expired".toLowerCase()) {
                                _bloc.fetchPeopleList(
                                  searchUsernameString: controller.text,
                                  departmentName: widget.departmentName,
                                  membershipEntitlements:
                                      membershipFlow[tmpValue],
                                );
                              } else {
                                _bloc.fetchPeopleList(
                                  searchUsernameString: controller.text,
                                  departmentName: widget.departmentName,
                                  tempMembershipStatus:
                                      membershipFlow[tmpValue],
                                );
                              }
                            }
                          } else if (selectedSearchOption == 0) {
                            controller.clear();
                            searchOutside = "User";
                            _bloc.fetchPeopleList(
                                searchUsernameString: controller.text,
                                departmentName: widget.departmentName,
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
                ),
              ]),*/

          if (userListEmpty)
            UserListSearch(
                bloc: _bloc,
                searchController: widget.searchController,
                departmentName: widget.departmentName,
                usersCount: 0,
                onCallAPI: (lable) {
                  setState(() {
                    totalUserLable = lable;
                  });
                },
                onsearchText: (search) {
                  setState(() {
                    searchedText = search;
                  });
                },
                searchingText: searchedText,
                totalUserLable: totalUserLable,
                membershipFlow: membershipFlow),

          StreamBuilder(
              stream: _bloc.peopleListFetcher,
              builder: (context, AsyncSnapshot<PeopleResponse> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data is PeopleResponse &&
                      snapshot.data?.peopleResponse?.length > 0) {
                    if (userListEmpty) {
                      Future.delayed(Duration(milliseconds: 500), () {
                        setState(() {
                          userListEmpty = false;
                        });
                      });
                    }
                    // print(
                    // "People Length : ${snapshot.data?.peopleResponse
                    // ?.length}");
                    if (!init) {
                      response = snapshot.data;
                      init = true;
                    }
                    if (snapshot.data?.peopleResponse != null) {
//for mydata and count is 1 , show no-record container
                      if (snapshot.data?.peopleResponse?.length == 1) {
                        if ((snapshot.data?.peopleResponse[0].userName ==
                                AppPreferences().username) &&
                            false) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                child: Text(searchQuery.isNotEmpty
                                    ? AppLocalizations.of(context)
                                        .translate("key_no_record_found")
                                    : AppLocalizations.of(context)
                                        .translate("key_no_data_found"))),
                          );
                        }
                      }
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (init)
                            UserListSearch(
                                bloc: _bloc,
                                searchController: widget.searchController,
                                departmentName: widget.departmentName,
                                usersCount: snapshot.data.peopleResponse.length,
                                onCallAPI: (lable) {
                                  setState(() {
                                    totalUserLable = lable;
                                  });
                                },
                                totalUserLable: totalUserLable,
                                membershipFlow: membershipFlow),
                          if (init)
                            const SizedBox(
                              height: 10.0,
                            ),
                          Visibility(
                            visible: false,
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
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      Text('Prospective user'),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 20.0,
                                ),
                              ],
                            ),
                          ),
                          PeopleListWidget(
                              snapshot.data?.peopleResponse, updateListData,
                              showBottomSheet: true,
                              isCameFromContactInfo: false,
                              usernameForContact: null,
                              isCameFromCoping: false,
                              isCameFromAddUserFamily: false,
                              isCameFromSubscription: false,
                              isCameFromDiabetesRiskScore: false,
                              constructingDataList: null,
                              peopleListForSubscription:
                                  (peopleListForSubscription) {
                            setState(() {
                              // print("length of peopleListForSubscription afterPeople list widget ${peopleListForSubscription.length}");
                              // print("Value of peopleListForSubscription afterPeople list widget ${peopleListForSubscription[0].userName}");

                              peopleListForSubscriptionTemp =
                                  List.from(peopleListForSubscription);
                              // print("length of peopleListForSubscriptionTemp after copy list widget ${peopleListForSubscriptionTemp.length}");
                              //  peopleListForSubscription = peopleListForSubscription;
                              if ((peopleListForSubscriptionTemp.length + 0) >
                                  25) {
                                Fluttertoast.showToast(
                                    msg: "Already added max number of users",
                                    gravity: ToastGravity.TOP,
                                    toastLength: Toast.LENGTH_LONG);
                              }
                            });
                          }),
                        ],
                      );
                    } else {
                      return Container(
                          child: Text(searchQuery.isNotEmpty
                              ? AppLocalizations.of(context)
                                  .translate("key_no_record_found")
                              : AppLocalizations.of(context)
                                  .translate("key_no_data_found")));
                    }
                  } else {
                    if (!userListEmpty) {
                      Future.delayed(Duration(milliseconds: 500), () {
                        setState(() {
                          userListEmpty = true;
                        });
                      });
                    }
                    return Container(
                        child: Text(searchQuery.isNotEmpty
                            ? AppLocalizations.of(context)
                                .translate("key_no_record_found")
                            : AppLocalizations.of(context)
                                .translate("key_no_data_found")));
                  }
                } else {
                  return PeopleListLoadingWidget();
                }
              })
        ],
      ),
    );
  }
}
