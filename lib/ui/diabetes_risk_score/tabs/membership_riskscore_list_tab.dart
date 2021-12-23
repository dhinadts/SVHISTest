import '../../../bloc/people_list_bloc.dart';
import '../../../model/people_response.dart';
import '../../../ui/diabetes_risk_score/diabetes_risk_score_screen.dart';
import '../../../utils/app_preferences.dart';
import '../../../widgets/people_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../../../ui_utils/ui_dimens.dart';
import '../../../widgets/people_list_loading.dart';
import '../../membership/api/membership_api_client.dart';
import '../../membership/bloc/membership_bloc.dart';
import '../../membership/bloc/membership_event.dart';
import '../../membership/repo/membership_repo.dart';
import '../../membership/widgets/membership_list_widget.dart';
import '../../tabs/app_localizations.dart';

class MembershipRiskScoreListTab extends StatefulWidget {
  const MembershipRiskScoreListTab({Key key}) : super(key: key);

  @override
  _MembershipRiskScoreListTabState createState() =>
      _MembershipRiskScoreListTabState();
}

class _MembershipRiskScoreListTabState
    extends State<MembershipRiskScoreListTab> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode focusNode = FocusNode();
  final TextEditingController controller = TextEditingController();
  final membershipRepo = MembershipRepository(
      membershipApiClient: MembershipApiClient(httpClient: http.Client()));
  MembershipBloc _membershipBloc;

  int selectedSearchOption = 0;

  double popupMenuItemHeight = 40;

  int lastIndex = 0;
  PeopleListBloc _bloc;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _membershipBloc = MembershipBloc(repository: membershipRepo);
    _membershipBloc.add(GetMembershipListByFilter("Approved"));
    _bloc = new PeopleListBloc(context);
    /*_bloc.fetchSecondaryUserList(
        parentUserName: '',
        departmentName: widget.departmentName,
        isFromAddUserFamily: false);*/
    _bloc.fetchPeopleList(
        // onlyPrimary: false,
        departmentName: AppPreferences().deptmentName,
        membershipType: "Member");
    _bloc.peopleListFetcher.listen((value) {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _membershipBloc,
      child: Scaffold(
        body: Form(
          key: _formKey,
          autovalidate: true,
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
                          focusNode: focusNode,
                          onChanged: (data) {
                            if (lastIndex != 0 && data.length == 0) {
                              // _membershipBloc
                              //     .add(GetMembershipListByFilter("Approved"));
                              _bloc.fetchPeopleList(
                                  // onlyPrimary: false,
                                  departmentName: AppPreferences().deptmentName,
                                  membershipType: "Member");
                              lastIndex = 0;
                            } else {
                              lastIndex = data.length;
                            }
                          },
                          controller: controller,
                          decoration: InputDecoration(
                            // labelText: (selectedSearchOption) == 0
                            //     ? AppLocalizations.of(context)
                            //         .translate("key_search_by_membership_id")
                            //     : AppLocalizations.of(context)
                            //         .translate("key_search_by_name"),
                            labelText: AppLocalizations.of(context)
                                .translate("key_search_by_name"),
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
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
                            _bloc.fetchPeopleList(
                                searchUsernameString: controller.text,
                                // departmentName: widget.departmentName,
                                membershipType: "Member");
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
                    SizedBox(width: 10),
                    /*      PopupMenuButton(
                      itemBuilder: (context) {
                        var list = List<PopupMenuEntry<Object>>();

                        list.add(
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
                        list.add(
                          PopupMenuDivider(
                            height: 10,
                          ),
                        );
                        list.add(
                          PopupMenuItem(
                            height: popupMenuItemHeight,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.done,
                                  color: selectedSearchOption == 0
                                      ? Colors.green
                                      : Colors.transparent,
                                ),
                                SizedBox(width: 10),
                                Text('Membership Id'),
                              ],
                            ),
                            value: 0,
                          ),
                        );
                        list.add(
                          PopupMenuItem(
                            height: popupMenuItemHeight,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.done,
                                  color: selectedSearchOption == 1
                                      ? Colors.green
                                      : Colors.transparent,
                                ),
                                SizedBox(width: 10),
                                Text('Name'),
                              ],
                            ),
                            value: 1,
                          ),
                        );
                        return list;
                      },
                      onCanceled: () {},
                      onSelected: (value) {
                        setState(() {
                          if (value != -1) selectedSearchOption = value;
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
                */
                    SizedBox(width: 5),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                /*        BlocBuilder<MembershipBloc, MembershipState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return PeopleListLoadingWidget();
                    }
                    if (state.hasError) {
                      return Container(child: Text(AppPreferences().getApisErrorMessage));
                    }
                    if (state.membershipList.isNotEmpty) {
                      return MembershipListWidget(
                        membershipInfoList: state.membershipList,
                        successCallback: updateListData,
                        membershipListWidgetSource:
                            MembershipListWidgetSource.RiskScore,
                      );
                    }
                    return Container(
                        child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text("No data available"),
                    ));
                  },
                ), */
                StreamBuilder(
                    stream: _bloc.peopleListFetcher,
                    builder: (context, AsyncSnapshot<PeopleResponse> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data is PeopleResponse &&
                            snapshot.data?.peopleResponse?.length > 0) {
                          // print(
                          // "People Length : ${snapshot.data?.peopleResponse
                          // ?.length}");

                          if (snapshot.data?.peopleResponse != null) {
//for mydata and count is 1 , show no-record container
                            if (snapshot.data?.peopleResponse?.length == 1) {
                              if ((snapshot.data?.peopleResponse[0].userName ==
                                      AppPreferences().username) &&
                                  false) {
                                return Container(
                                    child: Text(searchQuery.isNotEmpty
                                        ? AppLocalizations.of(context)
                                            .translate("key_no_record_found")
                                        : AppLocalizations.of(context)
                                            .translate("key_no_data_found")));
                              }
                            }
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    padding:
                                        EdgeInsets.only(left: 8.0, bottom: 8.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Total Member${snapshot.data?.peopleResponse.length > 1 ? 's' : ''} : ${snapshot.data?.peopleResponse.length}",
                                      style: TextStyle(fontSize: 17),
                                    )),
                                PeopleListWidget(snapshot.data?.peopleResponse,
                                    updateListData,
                                    showBottomSheet: false,
                                    isCameFromDiabetesRiskScore: true),
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
          ),
        ),
      ),
    );
  }

  void updateListData(String username) {
    // _bloc.fetchPeopleList(
    //   onlyPrimary: false,
    //   // departmentName: widget.departmentName,
    // );
  }
}
