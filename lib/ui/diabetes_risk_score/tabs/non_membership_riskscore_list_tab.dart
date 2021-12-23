import '../../../utils/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../bloc/people_list_bloc.dart';
import '../../../model/people_response.dart';
import '../../../ui_utils/ui_dimens.dart';
import '../../../widgets/people_list_loading.dart';
import '../../../widgets/people_list_widget.dart';
import '../../tabs/app_localizations.dart';

class NonMembershipRiskScoreListTab extends StatefulWidget {
  @override
  _NonMembershipRiskScoreListTabState createState() =>
      _NonMembershipRiskScoreListTabState();
}

class _NonMembershipRiskScoreListTabState
    extends State<NonMembershipRiskScoreListTab> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode focusNode = FocusNode();
  bool init = false, searchableStringEntered = false;
  String searchQuery = "";
  var controller = TextEditingController();

  PeopleListBloc _bloc;
  PeopleResponse response;

  @override
  void initState() {
    super.initState();
    _bloc = new PeopleListBloc(context);
    _bloc.fetchPeopleList(
        // onlyPrimary: false,
        departmentName: AppPreferences().deptmentName,
        membershipType: "User");
    _bloc.peopleListFetcher.listen((value) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        autovalidate: true,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Row(children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  padding: EdgeInsets.symmetric(
                      horizontal: AppUIDimens.paddingSmall),
                  child: TextFormField(
                    focusNode: focusNode,
                    onChanged: (data) {
                      //_filter(data);
                      if (data.length == 0) {
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
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.deny(RegExp('[0-9]')),
                    ],
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
                        //_bloc.fetchPeopleList(
                        //searchUsernameString: controller.text);
                        // _bloc.fetchNonMembershipList(
                        //     searchUsernameString: controller.text);
                        _bloc.fetchPeopleList(
                            searchUsernameString: controller.text,
                            departmentName: AppPreferences().deptmentName,
                            membershipType: "User");
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
              ]),
              SizedBox(
                height: 10.0,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     RaisedButton(
              //       onPressed: () {
              //         Navigator.push<bool>(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => DiabetesRiskScoreScreen(
              //               isProspect: true,
              //             ),
              //           ),
              //         );
              //       },
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(15.0),
              //       ),
              //       textColor: Colors.white,
              //       color: AppColors.arrivedColor,
              //       child: Row(
              //         children: [
              //           Icon(
              //             Icons.person_add,
              //           ),
              //           SizedBox(
              //             width: 10.0,
              //           ),
              //           Text('Prospective user'),
              //         ],
              //       ),
              //     ),
              //     SizedBox(
              //       width: 20.0,
              //     ),
              //   ],
              // ),
              SizedBox(
                height: 10,
              ),
              StreamBuilder(
                  stream: _bloc.peopleListFetcher,
                  builder: (context, AsyncSnapshot<PeopleResponse> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data is PeopleResponse &&
                          snapshot.data.peopleResponse != null &&
                          snapshot.data.peopleResponse.length > 0) {
                        if (!init) {
                          response = snapshot.data;
                          init = true;
                        }
                        if (snapshot.data?.peopleResponse != null) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  padding:
                                      EdgeInsets.only(left: 8.0, bottom: 8.0),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Total User${snapshot.data?.peopleResponse.length > 1 ? 's' : ''} : ${snapshot.data?.peopleResponse.length}",
                                    style: TextStyle(fontSize: 17),
                                  )),
                              PeopleListWidget(
                                  snapshot.data?.peopleResponse, updateListData,
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
                    }
                    return PeopleListLoadingWidget();
                  })
            ],
          ),
        ),
      ),
    );
  }

  void updateListData(String userName) {
    // print("updateListData called....");
  }

  callSearchAPI() {
    // debugPrint("callSearchAPI ...");
    _formKey.currentState.validate();
    if (searchableStringEntered && controller.text.length == 0) {
      setState(() {
        searchableStringEntered = false;
      });
      //_bloc.fetchPeopleList(isFromDiabetesRiskScore: true);
      // _bloc.fetchNonMembershipList();
      _bloc.fetchPeopleList(
          // onlyPrimary: false,
          searchUsernameString: controller.text,
          departmentName: AppPreferences().deptmentName,
          membershipType: "User");
    }
  }
}
