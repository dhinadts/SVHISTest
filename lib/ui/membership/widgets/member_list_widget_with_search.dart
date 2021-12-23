import '../api/membership_api_client.dart';
import '../bloc/membership_bloc.dart';
import '../bloc/membership_event.dart';
import '../repo/membership_repo.dart';
import 'membership_list_widget.dart';
import '../../tabs/app_localizations.dart';
import '../../../ui_utils/ui_dimens.dart';
import '../../../utils/app_preferences.dart';
import '../../../widgets/people_list_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class MembershipListWidgetWithSearch extends StatefulWidget {
  final String departmentName;
  final void Function(bool) successCallback;

  MembershipListWidgetWithSearch(this.departmentName, {this.successCallback});

  @override
  _MembershipListWidgetWithSearchState createState() =>
      _MembershipListWidgetWithSearchState();
}

class _MembershipListWidgetWithSearchState
    extends State<MembershipListWidgetWithSearch> {
  final FocusNode focusNode = FocusNode();
  final TextEditingController controller = TextEditingController();
  final membershipRepo = MembershipRepository(
      membershipApiClient: MembershipApiClient(httpClient: http.Client()));

  MembershipBloc _membershipBloc;

  int selectedSearchOption = 0;

  double popupMenuItemHeight = 40;

  List<String> membershipFlow;
  var filterMenulist = List<PopupMenuEntry<Object>>();

  @override
  void initState() {
    super.initState();
    getMembershipFlow();
    _membershipBloc = MembershipBloc(repository: membershipRepo);
    _membershipBloc
        .add(GetMembershipHierarchyList(departmentName: widget.departmentName));
  }

  getMembershipFlow() async {
    membershipFlow = List<String>();
    membershipFlow = await AppPreferences.getMembershipWorkFlow();
    debugPrint("Membership flow search --> $membershipFlow");
    debugPrint("Membership flow search length --> ${membershipFlow.length}");
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
              "Search By",
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
          if (membershipFlowStatus.toLowerCase() == "Active".toLowerCase() ||
              membershipFlowStatus.toLowerCase() == "Expired".toLowerCase()) {
          } else {
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

  int lastIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _membershipBloc,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: AppUIDimens.paddingXMedium),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.4,
                    padding: EdgeInsets.symmetric(
                        horizontal: AppUIDimens.paddingSmall),
                    child: TextFormField(
                      style: TextStyle(fontSize: 14),
                      focusNode: focusNode,
                      onChanged: (data) {
                        if (lastIndex != 0 && data.length == 0) {
                          _membershipBloc.add(GetMembershipHierarchyList(
                              departmentName: widget.departmentName));
                          lastIndex = 0;
                        } else {
                          lastIndex = data.length;
                        }
                      },
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: (selectedSearchOption) == 1
                            ? AppLocalizations.of(context)
                                .translate("key_search_by_name")
                            : AppLocalizations.of(context)
                                .translate("key_search_by_membership_id"),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      inputFormatters: (selectedSearchOption) == 1
                          ? <TextInputFormatter>[
                              FilteringTextInputFormatter.deny(RegExp('[0-9]')),
                            ]
                          : [],
                      keyboardType: TextInputType.text,
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
                Ink(
                  child: Container(
                      decoration: const ShapeDecoration(
                        color: Colors.blueGrey,
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.search),
                        color: Colors.white,
                        onPressed: () {
                          if (controller.text.trim().length > 1) {
                            if (selectedSearchOption == 0)
                              _membershipBloc.add(GetMembershipListBySearch(
                                  controller.text,
                                  SEARCH_MEMERSHIP.MembershipId,
                                  false,
                                  departmentName: widget.departmentName));
                            else if (selectedSearchOption == 1)
                              _membershipBloc.add(GetMembershipListBySearch(
                                  controller.text, SEARCH_MEMERSHIP.Name, false,
                                  departmentName: widget.departmentName));
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
                      )),
                ),
                SizedBox(width: 10),
                PopupMenuButton(
                  itemBuilder: (context) {
                    return filterMenulist;
                  },
                  onCanceled: () {},
                  onSelected: (value) {
                    setState(() {
                      if (value != -1) {
                        selectedSearchOption = value;
                        print(selectedSearchOption);
                        if (selectedSearchOption == 2) {
                          // clear all
                          controller.clear();
                          FocusScope.of(context).requestFocus(FocusNode());
                          selectedSearchOption = 0;
                          _membershipBloc.add(GetMembershipList());
                        } else if (selectedSearchOption > 2) {
                          controller.clear();
                          FocusScope.of(context).requestFocus(FocusNode());
                          int tmpValue = selectedSearchOption -
                              3; // subtract the tempCount
                          if (membershipFlow != null &&
                              membershipFlow.length > 0) {
                            _membershipBloc.add(GetMembershipListByFilter(
                                membershipFlow[tmpValue]));
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
            SizedBox(
              height: 25,
            ),
            BlocBuilder<MembershipBloc, MembershipState>(
              builder: (context, state) {
                //debugPrint("State is --> ${state.}");
                if (state.isLoading) {
                  return PeopleListLoadingWidget();
                }
                if (state.hasError) {
                  return Container(
                      child: Text(AppPreferences().getApisErrorMessage));
                }
                if (state.membershipList.isNotEmpty) {
                  return Column(
                    children: [
                      Container(
                          padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Total Members : ${state.membershipList.length}",
                            style: TextStyle(fontSize: 17),
                          )),
                      MembershipListWidget(
                        membershipInfoList: state.membershipList,
                        successCallback: updateListData,
                        membershipListWidgetSource:
                            MembershipListWidgetSource.MembershipHierarchy,
                      ),
                    ],
                  );
                }
                return Container(child: Text("No data available"));
              },
            ),
          ],
        ),
      ),
    );
  }

  void updateListData(bool isChangedData) {
    if (isChangedData != null && isChangedData) {
      _membershipBloc.add(
          GetMembershipHierarchyList(departmentName: widget.departmentName));
    }
  }
}
