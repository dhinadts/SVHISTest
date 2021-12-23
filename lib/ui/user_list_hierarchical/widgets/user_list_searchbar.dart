import '../../../utils/app_preferences.dart';

import '../../../bloc/people_list_bloc.dart';
import '../../../ui/tabs/app_localizations.dart';
import '../../../ui_utils/ui_dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

String text = "";

class UserListSearch extends StatefulWidget {
  final Function(String) onCallAPI;
  final Function(String) onsearchText;
  final PeopleListBloc bloc;
  final String departmentName;
  final List<String> membershipFlow;
  final int usersCount;
  final String totalUserLable;
  final String searchingText;
  final TextEditingController searchController;
  UserListSearch(
      {this.departmentName,
      this.membershipFlow,
      this.searchingText,
      this.bloc,
      this.onCallAPI,
      this.onsearchText,
      this.totalUserLable,
      this.usersCount,
      this.searchController});

  @override
  UserListSearchState createState() => UserListSearchState();
}

class UserListSearchState extends State<UserListSearch> {
  //final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool searchableStringEntered = false;
  String searchQuery = "";
  String searchOutside = "";
  int selectedSearchOption = -1;
  var filterMenulist = List<PopupMenuEntry<Object>>();
  double popupMenuItemHeight = 40;
  // var searchController = TextEditingController();
  @override
  void initState() {
    // test = searchController.text;
    super.initState();
    if (widget.departmentName == AppPreferences().deptmentName) {
      widget.searchController.text = text;
    } else {
      widget.searchController.text = text;
    }

    createFilterDropDown();
  }

  callSearchAPI() {
    // debugPrint("callSearchAPI ...");
    _formKey.currentState.validate();
    if (searchableStringEntered && widget.searchController.text.length == 0) {
      setState(() {
        searchableStringEntered = false;
      });
      widget.bloc.fetchPeopleList(
        onlyPrimary: false,
        departmentName: widget.departmentName,
      );
      /* _bloc.fetchSecondaryUserList(
          parentUserName: '',
          departmentName: widget.departmentName,
          isFromAddUserFamily: false);*/
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        autovalidate: true,
        child: Column(
          children: [
            Row(children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppUIDimens.paddingSmall),
                  child: TextFormField(
                    key: Key(widget.departmentName),
                    //focusNode: focusNodeInner,
                    onChanged: (data) {
                      //_filter(data);
                      if (data.length == 0) {
                        print('Reset Data');
// if()
                        setState(() {
                          text = "";
                        });
                        //mainSearchController.clear();
                        widget.searchController.clear();
                        FocusScope.of(context).unfocus();

                        widget.bloc.fetchPeopleList(
                            searchUsernameString: '',
                            departmentName: widget.departmentName,
                            tempMembershipStatus: searchOutside);
                      }
                    },
                    controller: widget.searchController,
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
                    text = widget.searchController.text;
                    FocusScope.of(context).unfocus();
                    if (_formKey.currentState.validate() &&
                        widget.searchController.text.trim().length > 1) {
                      setState(() {
                        searchableStringEntered = true;
                      });

                      // test = searchController.text;

                      if (searchOutside.isEmpty ||
                          searchOutside == "" ||
                          searchOutside == null) {
                        selectedSearchOption = -1;

                        widget.bloc.fetchPeopleList(
                          searchUsernameString: widget.searchController.text,
                          departmentName: widget.departmentName,
                        );
                      } else {
                        if (searchOutside.toLowerCase() ==
                                "Active".toLowerCase() ||
                            searchOutside.toLowerCase() ==
                                "Expired".toLowerCase()) {
                          widget.bloc.fetchPeopleList(
                              searchUsernameString:
                                  widget.searchController.text,
                              departmentName: widget.departmentName,
                              membershipEntitlements: searchOutside);
                        } else if (searchOutside.toLowerCase() ==
                                "User".toLowerCase() ||
                            searchOutside.toLowerCase() ==
                                "Member".toLowerCase()) {
                          widget.bloc.fetchPeopleList(
                              searchUsernameString:
                                  widget.searchController.text,
                              departmentName: widget.departmentName,
                              membershipType: searchOutside);
                        } else {
                          widget.bloc.fetchPeopleList(
                              searchUsernameString:
                                  widget.searchController.text,
                              departmentName: widget.departmentName,
                              tempMembershipStatus: searchOutside);
                        }
                      }
                      // setState(() {
                      //   searchController.text = test;
                      // });
                      /* widget.bloc.fetchPeopleList(
                              searchUsernameString: controller.text,
                              departmentName: widget.departmentName,
                            ); */
                    } else {
                      if (widget.searchController.text.trim().length == 0) {
                        setState(() {
                          Fluttertoast.showToast(
                              msg: AppLocalizations.of(context)
                                  .translate("key_entersometext"),
                              gravity: ToastGravity.TOP,
                              toastLength: Toast.LENGTH_LONG);
                          // focusNodeInner.requestFocus();
                        });
                      }
                    }
                  },
                ),
              ),
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
                          widget.searchController.clear();
                          searchOutside = "Member";
                          widget.bloc.fetchPeopleList(
                              searchUsernameString:
                                  widget.searchController.text,
                              departmentName: widget.departmentName,
                              membershipType: "Member");
                          widget.onCallAPI("Members");
                        }

                        if (selectedSearchOption == 2) {
                          // clear all
                          // setState(() {
                          widget.onCallAPI("Users/Members");
                          // });
                          searchOutside = "";

                          widget.searchController.clear();
                          // FocusScope.of(context).requestFocus(FocusNode());

                          selectedSearchOption = -1;
                          widget.bloc.fetchPeopleList(
                            searchUsernameString: widget.searchController.text,
                            departmentName: widget.departmentName,
                            // membershipEntitlements: widget.membershipFlow[tmpValue],
                          );
                        } else if (selectedSearchOption > 2) {
                          widget.searchController.clear();

                          widget.onCallAPI("Members");
                          // FocusScope.of(context).requestFocus(FocusNode());
                          int tmpValue = selectedSearchOption -
                              3; // subtract the tempCount
                          if (widget.membershipFlow != null &&
                              widget.membershipFlow.length > 0) {
                            searchOutside = widget.membershipFlow[tmpValue];
                            if (widget.membershipFlow[tmpValue].toLowerCase() ==
                                    "Active".toLowerCase() ||
                                widget.membershipFlow[tmpValue].toLowerCase() ==
                                    "Expired".toLowerCase()) {
                              widget.bloc.fetchPeopleList(
                                searchUsernameString:
                                    widget.searchController.text,
                                departmentName: widget.departmentName,
                                membershipEntitlements:
                                    widget.membershipFlow[tmpValue],
                              );
                            } else {
                              widget.bloc.fetchPeopleList(
                                searchUsernameString:
                                    widget.searchController.text,
                                departmentName: widget.departmentName,
                                tempMembershipStatus:
                                    widget.membershipFlow[tmpValue],
                              );
                            }
                          }
                        } else if (selectedSearchOption == 0) {
                          widget.searchController.clear();
                          widget.onCallAPI("Users");
                          searchOutside = "User";
                          widget.bloc.fetchPeopleList(
                              searchUsernameString:
                                  widget.searchController.text,
                              departmentName: widget.departmentName,
                              membershipType: "User"
                              // membershipEntitlements: "membershipId",
                              );

                          // searchOutside = "membershipId";
                        }

                        // else if (selectedSearchOption == 1) {
                        //   widget.bloc.fetchPeopleList(
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
            ]),
            SizedBox(
              height: 10,
            ),
            Container(
                padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Total ${computeTotalUsersLable(widget.usersCount, widget.totalUserLable)} : ${widget.usersCount}",
                  style: TextStyle(fontSize: 17),
                )),
          ],
        ));
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

  createFilterDropDown() {
    filterMenulist.clear();
    addSearchByFilter();
    if (widget.membershipFlow != null && widget.membershipFlow.length > 0) {
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

    if (widget.membershipFlow != null && widget.membershipFlow.isNotEmpty) {
      // To set the value
      int tempCount = 3; //till 2, it is known values
      widget.membershipFlow.forEach((membershipFlowStatus) {
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
}
