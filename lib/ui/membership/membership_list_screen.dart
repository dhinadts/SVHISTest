import '../../model/people.dart';
import '../../ui/custom_drawer/custom_app_bar.dart';
import '../../ui/diagnosis/bloc/people_search_bloc.dart';
import '../../ui/hierarchical/bloc/department_bloc.dart';
import '../../ui/hierarchical/ui/hierarchical_membership_widget.dart';
import '../../utils/app_preferences.dart';
import '../../utils/constants.dart';
import '../../utils/validation_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../../ui_utils/ui_dimens.dart';
import '../../widgets/people_list_loading.dart';
import '../custom_people_search.dart';
import '../tabs/app_localizations.dart';
import 'api/membership_api_client.dart';
import 'bloc/membership_bloc.dart';
import 'bloc/membership_event.dart';
import 'membership_inapp_webview_screen.dart';
import 'membership_screen.dart';
import 'repo/membership_repo.dart';
import 'widgets/membership_list_widget.dart';

class MembershipListScreen extends StatefulWidget {
  final String title;
  const MembershipListScreen({Key key, this.title}) : super(key: key);
  @override
  _MembershipListScreenState createState() => _MembershipListScreenState();
}

class _MembershipListScreenState extends State<MembershipListScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode focusNode = FocusNode();
  final TextEditingController controller = TextEditingController();
  MembershipRepository membershipRepo;
  DepartmentBloc departmentBloc;
  MembershipBloc _membershipBloc;

  int selectedSearchOption = 0;

  double popupMenuItemHeight = 40;

  bool isHierarchy = false, isLoaded = false;

  int lastIndex = 0;

  List<String> membershipFlow;
  var filterMenulist = List<PopupMenuEntry<Object>>();

  PeopleBloc _peopleBloc;
  MembershipRepository _membershipRepository;

  @override
  void initState() {
    super.initState();
    getMembershipFlow();
    initializeData();

    /// To fetch the non-members
    _membershipRepository = MembershipRepository(
        membershipApiClient: MembershipApiClient(httpClient: http.Client()));
    _peopleBloc = PeopleBloc(
      diagnosisRepository: null,
      membershipRepository: _membershipRepository,
      fromRepo: FromRepo.Membership,
    );
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

  @override
  void deactivate() {
    _peopleBloc.close();
    super.deactivate();
  }

  initializeData() {
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
      } else {
        membershipRepo = MembershipRepository(
            membershipApiClient:
                MembershipApiClient(httpClient: http.Client()));
        _membershipBloc = MembershipBloc(repository: membershipRepo);
        _membershipBloc.add(GetMembershipList());
      }
      setState(() {
        isLoaded = true;
      });
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: widget.title, pageId: Constants.PAGE_ID_MEMBERSHIP),
      body: isHierarchy
          ? HierarchicalMembershipWidget()
          : isLoaded
              ? BlocProvider(
                  create: (context) => _membershipBloc,
                  child: Form(
                    key: _formKey,
                    autovalidate: true,
                    child: SingleChildScrollView(
                      padding:
                          EdgeInsets.only(bottom: AppUIDimens.paddingXMedium),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.4,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: AppUIDimens.paddingSmall),
                                  child: TextFormField(
                                    focusNode: focusNode,
                                    onChanged: (data) {
                                      if (lastIndex != 0 && data.length == 0) {
                                        _membershipBloc
                                            .add(GetMembershipList());
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
                                              .translate(
                                                  "key_search_by_membership_id"),
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    inputFormatters: (selectedSearchOption) == 1
                                        ? <TextInputFormatter>[
                                            FilteringTextInputFormatter.deny(
                                                RegExp('[0-9]')),
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
                                      if (selectedSearchOption == 0)
                                        _membershipBloc.add(
                                            GetMembershipListBySearch(
                                                controller.text,
                                                SEARCH_MEMERSHIP.MembershipId,
                                                false,
                                                departmentName: AppPreferences()
                                                    .deptmentName));
                                      else if (selectedSearchOption == 1)
                                        _membershipBloc.add(
                                            GetMembershipListBySearch(
                                                controller.text,
                                                SEARCH_MEMERSHIP.Name,
                                                false,
                                                departmentName: AppPreferences()
                                                    .deptmentName));
                                    } else {
                                      setState(() {
                                        if (controller.text.trim().length ==
                                            0) {
                                          Fluttertoast.showToast(
                                              msg: AppLocalizations.of(context)
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

                                      if (selectedSearchOption == 2) {
                                        // clear all
                                        controller.clear();
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        selectedSearchOption = 0;
                                        _membershipBloc
                                            .add(GetMembershipList());
                                      } else if (selectedSearchOption > 2) {
                                        controller.clear();
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        int tmpValue = selectedSearchOption -
                                            3; // subtract the tempCount
                                        if (membershipFlow != null &&
                                            membershipFlow.length > 0) {
                                          _membershipBloc.add(
                                              GetMembershipListByFilter(
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
                                    child: Text(
                                        AppPreferences().getApisErrorMessage));
                              }
                              if (state.membershipList.isNotEmpty) {
                                return Column(
                                  children: [
                                    Container(
                                        padding: EdgeInsets.only(
                                            left: 8.0, bottom: 8.0),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Total Members : ${state.membershipList.length}",
                                          style: TextStyle(fontSize: 17),
                                        )),
                                    MembershipListWidget(
                                      membershipInfoList: state.membershipList,
                                      successCallback: updateListData,
                                      membershipListWidgetSource:
                                          MembershipListWidgetSource.Membership,
                                    ),
                                  ],
                                );
                              }
                              return Container(
                                  child: Text("No data available"));
                            },
                          ),
                        ],
                      ),
                    ),
                  ))
              : PeopleListLoadingWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          People people = await showSearch<People>(
            context: context,
            delegate: PeopleSearch(peopleBloc: _peopleBloc, searchText: ""),
          );

          if (people != null) {
            final refresh = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MembershipInappWebviewScreen(
                  departmentName: people.departmentName,
                  userName: people.userName,
                  loggedInRole: "supervisor",
                  membershipId: null,
                  clientId: AppPreferences().clientId,
                ),
              ),
            );
            updateListData(refresh);
          }

          // final refresh = await Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => MembershipScreen(
          //       membershipId: null,
          //       isCameHierarchyFrom: isHierarchy,
          //     ),
          //   ),
          // );
          //updateListData(refresh);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void updateListData(bool isChangedData) {
    debugPrint("updateListData called... -> $isChangedData");
    if (isChangedData != null && isChangedData) {
      initializeData();
    }
  }
}
