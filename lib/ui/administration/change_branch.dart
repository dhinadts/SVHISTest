import '../../bloc/people_list_bloc.dart';
import '../../bloc/user_info_bloc.dart';
import '../../model/people.dart';
import '../../model/people_response.dart';
import '../../repo/auth_repository.dart';
import '../advertise/adWidget.dart';
import '../hierarchical/bloc/department_bloc.dart';
import '../hierarchical/model/department_model.dart';
import '../../ui_utils/app_colors.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../custom_drawer/custom_app_bar.dart';
import 'package:flutter/services.dart';

class BranchChange extends StatefulWidget {
  @override
  _BranchChangeState createState() => _BranchChangeState();
}

class _BranchChangeState extends State<BranchChange> {
  // with WidgetsBindingObserver {
  String sourceDepartment;
  String targetDepartment;
  TextEditingController searchController = new TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DepartmentBloc _bloc;
  PeopleListBloc peopleListBloc;
  List<String> departmentsList = [];
  List<String> targetDepartmentsList = [];

  List<bool> userCheckList = [];
  List<PeopleResponse> userCheckedList; // = [];
  PeopleResponse peopleResponse;
  bool isFirstLoad = true;
  final FocusNode _titleFocus = FocusNode();
  bool suffixI = false;
  @override
  void initState() {
    // WidgetsBinding.instance.addObserver(this);
    _bloc = DepartmentBloc(context);
    peopleListBloc = PeopleListBloc(context);
    initializeData();
    peopleListBloc.peopleListFetcher.listen((value) {
      print("inside listen Method");
      peopleResponse = value;
      setState(() {
        isFirstLoad = false;
      });
    });
    super.initState();
  }

  initializeData() async {
    await _bloc.getDepartment();
    /* await peopleListBloc.fetchPeopleList(
        isFromDiabetesRiskScore: false,
        onlyPrimary: true,
        departmentName: AppPreferences().deptmentName);*/
    initializeAd();
  }

  /* @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final value = WidgetsBinding.instance.window.viewInsets.bottom;
     if (value == 0) {
    _titleFocus.unfocus();
     }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _titleFocus.dispose();
    super.dispose();
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        pageId: null,
        title: "Branch Change",
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              primary: false,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: StreamBuilder<DepartmentModel>(
                        stream: _bloc.departmentFetcher,
                        builder: (BuildContext context,
                            AsyncSnapshot<DepartmentModel> snapshot) {
                          if (snapshot.hasData) {
                            departmentsList = [];
                            targetDepartmentsList = [];
                            departmentsList.add(snapshot.data.departmentName);
                            snapshot.data.subDepartments.forEach((element) {
                              departmentsList.add(element.departmentName);
                            });

                            targetDepartmentsList.addAll(departmentsList);
                            if (targetDepartmentsList
                                .contains(sourceDepartment)) {
                              targetDepartmentsList.remove(sourceDepartment);
                            }
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Source Branch",
                                      style: TextStyle(fontSize: 18),
                                      textAlign: TextAlign.left,
                                    )),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      hint: Text(
                                        '-Select Branch-',
                                      ), // Not necessary for Option 1
                                      value: sourceDepartment,
                                      onChanged: (String newValue) {
                                        // userCheckList.clear();
                                        // suffixI = false;
                                        FocusScope.of(context).unfocus();
                                        FocusScopeNode currentFocus =
                                            FocusScope.of(context);
                                        if (!currentFocus.hasPrimaryFocus &&
                                            currentFocus.focusedChild != null) {
                                          currentFocus.focusedChild.unfocus();
                                        }
                                        if (targetDepartment == newValue) {
                                          setState(() {
                                            targetDepartment = null;
                                          });
                                        } else {
                                          setState(() {
                                            if (targetDepartmentsList
                                                .contains(sourceDepartment)) {
                                              targetDepartmentsList
                                                  .remove(sourceDepartment);
                                            }
                                            sourceDepartment = newValue;
                                            userCheckList = [];
                                          });
                                          peopleListBloc
                                              .fetchPeopleList(
                                                  departmentName: newValue,
                                                  isFromDiabetesRiskScore:
                                                      false,
                                                  onlyPrimary: true);
                                          //     .then((value) {
                                          //   print("tttttt");
                                          //   print(value.peopleResponse.length);
                                          //   for (int i = 0;
                                          //       i < value.peopleResponse.length;
                                          //       i++) {
                                          //     userCheckList.add(false);
                                          //   }
                                          // });
                                        }

                                        searchController.clear();
                                      },
                                      items: departmentsList.map((location) {
                                        return DropdownMenuItem(
                                          child: new Text(location.toString()),
                                          value: location,
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Column(
                                    children: [
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Select Users:",
                                            style: TextStyle(fontSize: 18),
                                            textAlign: TextAlign.left,
                                          )),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey,
                                                width: 2.0)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Column(
                                            children: [
                                              isFirstLoad
                                                  ? Container()
                                                  : Form(
                                                      key: _formKey,
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                TextFormField(
                                                              // readOnly: suffixI,
                                                              controller:
                                                                  searchController,
                                                              // ignore: missing_return
                                                              enableInteractiveSelection:
                                                                  false,
                                                              // autofocus: false,
                                                              focusNode:
                                                                  _titleFocus,
                                                              validator:
                                                                  (value) {
                                                                if (value.length >
                                                                        0 &&
                                                                    value.length <
                                                                        2) {
                                                                  return "Search string must be 2 characters";
                                                                } else if (value
                                                                        .length ==
                                                                    0) {
                                                                  Fluttertoast.showToast(
                                                                      msg:
                                                                          "Please enter text",
                                                                      toastLength:
                                                                          Toast
                                                                              .LENGTH_LONG,
                                                                      timeInSecForIosWeb:
                                                                          5,
                                                                      gravity:
                                                                          ToastGravity
                                                                              .TOP);
                                                                }
                                                              },
                                                              onChanged: (val) {
                                                                if (val.length ==
                                                                    0) {
                                                                  peopleListBloc.fetchPeopleList(
                                                                      // searchUsernameString:
                                                                      //     "",
                                                                      departmentName: sourceDepartment,
                                                                      onlyPrimary: true,
                                                                      isFromDiabetesRiskScore: false);
                                                                }
                                                                setState(() {});
                                                              },

                                                              /*  onChanged:
                                                                  (newVal) {
                                                                if (newVal
                                                                        .isNotEmpty &&
                                                                    newVal.length >
                                                                        2) {
                                                                  peopleListBloc.fetchPeopleList(
                                                                      searchUsernameString:
                                                                          newVal,
                                                                      departmentName:
                                                                          sourceDepartment,
                                                                      onlyPrimary:
                                                                          true,
                                                                      isFromDiabetesRiskScore:
                                                                          false);
                                                                }
                                                              },
                                                              */
                                                              decoration: InputDecoration(
                                                                  contentPadding: EdgeInsets.only(left: 8),
                                                                  border: OutlineInputBorder(),
                                                                  hintText: "Search by User Name",
                                                                  prefix: false
                                                                      ? IconButton(
                                                                          icon: Icon(
                                                                            Icons.clear,
                                                                            size:
                                                                                15,
                                                                          ),
                                                                          onPressed: () {
                                                                            setState(() {
                                                                              userCheckList.clear();
                                                                              searchController.clear();
                                                                              // suffixI = false;
                                                                              peopleListBloc.fetchPeopleList(
                                                                                  // searchUsernameString:
                                                                                  //     "",
                                                                                  departmentName: sourceDepartment,
                                                                                  onlyPrimary: true,
                                                                                  isFromDiabetesRiskScore: false);
                                                                            });
                                                                          })
                                                                      : null,
                                                                  suffixIcon: false // suffixI
                                                                      ? IconButton(
                                                                          icon:
                                                                              Icon(Icons.notification_important),
                                                                          onPressed:
                                                                              () {
                                                                            if (suffixI) {
                                                                              Fluttertoast.showToast(msg: "Please move selected members", toastLength: Toast.LENGTH_LONG, timeInSecForIosWeb: 5, gravity: ToastGravity.TOP);
                                                                            } else {
                                                                              Fluttertoast.showToast(msg: "Please select a members", toastLength: Toast.LENGTH_LONG, timeInSecForIosWeb: 5, gravity: ToastGravity.TOP);
                                                                            }
                                                                          },
                                                                        )
                                                                      : null),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Ink(
                                                              decoration:
                                                                  const ShapeDecoration(
                                                                color: Colors
                                                                    .blueGrey,
                                                                shape:
                                                                    CircleBorder(),
                                                              ),
                                                              child: IconButton(
                                                                icon: Icon(Icons
                                                                    .search),
                                                                color: Colors
                                                                    .white,
                                                                onPressed: () {
                                                                  userCheckList
                                                                      .clear();
                                                                  // suffixI =
                                                                  //     false;
                                                                  if (_formKey
                                                                      .currentState
                                                                      .validate()) {
                                                                    if (searchController
                                                                            .text
                                                                            .length >
                                                                        2) {
                                                                      userCheckList
                                                                          .clear();
                                                                      // suffixI =
                                                                      //     false;
                                                                      peopleListBloc.fetchPeopleList(
                                                                          departmentName:
                                                                              sourceDepartment,
                                                                          isFromDiabetesRiskScore:
                                                                              false,
                                                                          onlyPrimary:
                                                                              true,
                                                                          searchUsernameString:
                                                                              searchController.text);
                                                                    }
                                                                  }
                                                                  FocusScopeNode
                                                                      currentFocus =
                                                                      FocusScope.of(
                                                                          context);
                                                                  if (!currentFocus
                                                                          .hasPrimaryFocus &&
                                                                      currentFocus
                                                                              .focusedChild !=
                                                                          null) {
                                                                    currentFocus
                                                                        .focusedChild
                                                                        .unfocus();
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                              Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.4,
                                                child: StreamBuilder(
                                                    stream: peopleListBloc
                                                        .peopleListFetcher,
                                                    builder: (cxt,
                                                        AsyncSnapshot<
                                                                PeopleResponse>
                                                            snp) {
                                                      if (snp.hasData) {
                                                        // userCheckList = [];
                                                        if (snp
                                                                .data
                                                                .peopleResponse
                                                                .length ==
                                                            0) {
                                                          return Text(
                                                              "No data found");
                                                        } else {
                                                          snp.data
                                                              .peopleResponse
                                                              .sort((a, b) => a
                                                                  .firstName
                                                                  .compareTo(b
                                                                      .firstName));
                                                          return ListView
                                                              .builder(
                                                                  shrinkWrap:
                                                                      true,
                                                                  primary:
                                                                      false,
                                                                  itemCount: snp
                                                                      .data
                                                                      .peopleResponse
                                                                      .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    List<People>
                                                                        list1 =
                                                                        snp.data
                                                                            .peopleResponse;
                                                                    Comparator<
                                                                            People>
                                                                        nameComparator =
                                                                        (a, b) => a
                                                                            .firstName
                                                                            .compareTo(b.firstName);

                                                                    list1.sort(
                                                                        nameComparator);

                                                                    userCheckList
                                                                        .add(
                                                                            false);
                                                                    // print("..... " +
                                                                    //     "${userCheckList.length}");

                                                                    return SizedBox(
                                                                        height:
                                                                            35,
                                                                        child:
                                                                            CheckboxListTile(
                                                                          contentPadding:
                                                                              EdgeInsets.zero,
                                                                          onChanged:
                                                                              (bool value) {
                                                                            // print(index);
                                                                            // print(userCheckList[index]);
                                                                            // print(snp.data.peopleResponse[index].firstName);
                                                                            setState(() {
                                                                              userCheckList[index] = !userCheckList[index];
                                                                            });
                                                                            // if (userCheckList[index]) {
                                                                            //   setState(() {
                                                                            //     suffixI = true;
                                                                            //   });
                                                                            // }
                                                                          },
                                                                          value:
                                                                              userCheckList[index],
                                                                          dense:
                                                                              true,
                                                                          controlAffinity:
                                                                              ListTileControlAffinity.leading,
                                                                          title:
                                                                              Text(
                                                                            "${snp.data.peopleResponse[index].firstName} ${snp.data.peopleResponse[index].lastName}",
                                                                            style:
                                                                                TextStyle(fontSize: 14),
                                                                          ),
                                                                        ));
                                                                  });
                                                        }
                                                      } else {
                                                        return isFirstLoad
                                                            ? Text(
                                                                "No Data Found")
                                                            : Center(
                                                                child:
                                                                    CircularProgressIndicator());
                                                      }
                                                    }),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Target Branch",
                                      style: TextStyle(fontSize: 18),
                                      textAlign: TextAlign.left,
                                    )),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      hint: Text(
                                        '-Select Branch-',
                                      ), // Not necessary for Option 1
                                      value: targetDepartment,
                                      onChanged: (String newValue) {
                                        // setState(() {

                                        // _titleFocus.unfocus();
                                        // FocusManager.instance.primaryFocus
                                        //     ?.unfocus();
                                        // FocusScopeNode currentFocus =
                                        //     FocusScope.of(context);
                                        // if (!currentFocus.hasPrimaryFocus &&
                                        //     currentFocus.focusedChild != null) {
                                        //   currentFocus.focusedChild.unfocus();
                                        //   currentFocus.unfocus();
                                        // }
                                        // // FocusScopeNode current =
                                        // //     FocusScope.of(context);
                                        // FocusScope.of(context).unfocus();
                                        // // FocusScopeNode currentFocus =
                                        // //     FocusScope.of(context);

                                        // if (currentFocus.hasPrimaryFocus) {
                                        //   currentFocus.focusedChild.unfocus();
                                        //   currentFocus.unfocus();
                                        // }
                                        // FocusScopeNode currentFocus =
                                        //     FocusScope.of(context);

                                        // if (!currentFocus.hasPrimaryFocus) {
                                        //   currentFocus.unfocus();
                                        // }
                                        // _titleFocus.unfocus();
                                        // _titleFocus.canRequestFocus;
                                        // currentFocus.unfocus();
                                        FocusScope.of(context)
                                            .requestFocus(new FocusNode());
                                        FocusScope.of(context).unfocus();

                                        // print("1234567890");
                                        // print(currentFocus.hasPrimaryFocus);
                                        // print(currentFocus.focusedChild);

                                        // });

                                        if (sourceDepartment ==
                                            targetDepartment) {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Please select the Source branch",
                                              gravity: ToastGravity.TOP);
                                        } else {
                                          setState(() {
                                            targetDepartment = newValue;
                                            // currentFocus.unfocus();
                                          });
                                        }
                                      },
                                      items:
                                          targetDepartmentsList.map((location) {
                                        return DropdownMenuItem(
                                          child: new Text(location.toString()),
                                          value: location,
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: RaisedButton(
                                    color: AppColors.primaryColor,
                                    onPressed: () async {
                                      await updateBranchChange();
                                      searchController.clear();
                                    },
                                    child: Text("Submit",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                )
                              ],
                            );
                          } else {
                            return LinearProgressIndicator();
                          }
                        }),
                  ),
                ),
              ),
            ),
          ),
          // getSivisoftAdWidget(),
        ],
      ),
    );
  }

  updateBranchChange() async {
    if (sourceDepartment == null || sourceDepartment.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please select the Source branch", gravity: ToastGravity.TOP);
      return;
    }

    if (targetDepartment == null || targetDepartment.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please select the Target branch", gravity: ToastGravity.TOP);
      return;
    }

    if (sourceDepartment == targetDepartment) {
      Fluttertoast.showToast(
          msg: "Source and Target cannot be same", gravity: ToastGravity.TOP);
      return;
    }

    if (userCheckList.indexWhere((element) => element == true) == -1) {
      Fluttertoast.showToast(
          msg: "Please select atleast one User", gravity: ToastGravity.TOP);
      return;
    }
    showProgress();
    UserInfoBloc userInfoBloc = new UserInfoBloc(context);
    AuthRepository authRepository = new AuthRepository();
    int i = 0;
    bool isUpdated = false;

    for (var people in peopleResponse.peopleResponse) {
      
      if (i < userCheckList.length) {
        if (userCheckList[i]) {
          var userInfo = await authRepository.getUserInfo(people.userName,
              departmentName: sourceDepartment);
          userInfo.departmentName = targetDepartment;
          //print(people.userName);
          isUpdated = await userInfoBloc.updateUserDepartmentname(
              userInfo, null, sourceDepartment);
        }
      }
      i = i + 1;
    }
    Navigator.pop(context);
    if (isUpdated) {
      Fluttertoast.showToast(
          msg:
              "Selected User(s) moved to $targetDepartment branch successfully",

          // "Moved selected users to the $targetDepartment successfully",

          gravity: ToastGravity.TOP);
      userCheckList.clear();
      // suffixI = false;
      peopleListBloc.fetchPeopleList(
          departmentName: sourceDepartment,
          isFromDiabetesRiskScore: false,
          onlyPrimary: true);
    } else {
      Fluttertoast.showToast(msg: "Unable to move", gravity: ToastGravity.TOP);
    }
  }

  Future<void> showProgress() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CupertinoActivityIndicator(radius: 20),
          );
        });
  }
}
