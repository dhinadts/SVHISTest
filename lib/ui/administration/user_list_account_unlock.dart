import 'dart:convert';

import '../../bloc/people_list_bloc.dart';
import '../../login/api/api_calling.dart';
import '../../login/colors/color_info.dart';
import '../../login/constants/api_constants.dart';
import '../../login/utils.dart';
import '../../login/utils/custom_progress_dialog.dart';
import '../../model/people.dart';
import '../../model/people_response.dart';
import '../../repo/common_repository.dart';
import '../../ui/custom_drawer/custom_app_bar.dart';
import '../../utils/constants.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../utils/app_preferences.dart';

class UserListAccountUnlockScreen extends StatefulWidget {
  final String title;
  UserListAccountUnlockScreen({this.title = "Users"});

  @override
  _UserListAccountUnlockScreenState createState() =>
      _UserListAccountUnlockScreenState();
}

class _UserListAccountUnlockScreenState
    extends State<UserListAccountUnlockScreen> {
  String sourceDepartment;
  String targetDepartment;
  PeopleListBloc peopleListBloc;

  List<bool> userCheckList = [];
  PeopleResponse peopleResponse;
  bool isFirstLoad = true;
  var enabledBorder = const OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black, width: 0.0),
      borderRadius: BorderRadius.all(Radius.circular(15.0)));
  TextStyle style = TextStyle(fontSize: 20.0, color: Color(ColorInfo.APP_GRAY));
  final myPasswordController = TextEditingController();

  final myConfirmPasswordController = TextEditingController();
  bool loginPasswordVisible = true;
  bool isLoginSelected = true;

  String _password = "";
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  bool _loginSutoValidate = false;
  String deptName = "";
  TextEditingController searchUserController = TextEditingController();
  @override
  void initState() {
    super.initState();
    peopleListBloc = PeopleListBloc(context);
    peopleListBloc.peopleListFetcher.listen((value) {
      print("inside listen Method");
      peopleResponse = value;
      setState(() {
        isFirstLoad = false;
      });
    });
    fetchDeptName();
  }

  Future<dynamic> fetchDeptName() async {
    deptName = await AppPreferences.getDeptName();
    if (deptName != null && deptName.length > 0) {
      peopleListBloc.fetchPeopleList(
          departmentName: deptName,
          isFromDiabetesRiskScore: false,
          onlyPrimary: true);
    }
    return deptName;
  }

  onSearchTextChanged(String text) async {
    if (text.isEmpty) {
      setState(() {});
      return;
    } else
      peopleListBloc.fetchPeopleList(searchUsernameString: text);

    // patientList.forEach((userDetail) {
    //   if ((userDetail.emailId != null &&
    //           userDetail.emailId.toLowerCase().contains(text)) ||
    //       (userDetail.mobileNo != null &&
    //           userDetail.mobileNo.toLowerCase().contains(text)) ||
    //       (userDetail.userName != null &&
    //           userDetail.userName.toLowerCase().contains(text)))
    //     patientListFiltered.add(userDetail);
    // });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          pageId: null,
          title: widget.title,
        ),
        body: SingleChildScrollView(
            primary: false,
            child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: StreamBuilder(
                    stream: peopleListBloc.peopleListFetcher,
                    builder: (cxt, AsyncSnapshot<PeopleResponse> snp) {
                      if (snp.hasData) {
                        if (snp.data.peopleResponse.length == 0) {
                          return Text("No Items found");
                        } else {
                          snp.data.peopleResponse.sort(
                              (a, b) => a.firstName.compareTo(b.firstName));
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                                child: TextFormField(
                                  controller: searchUserController,
                                  decoration: new InputDecoration(
                                    hintText: 'Search',
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                    prefixIcon: IconButton(
                                      icon: Icon(Icons.search),
                                      onPressed: () {
                                        if (searchUserController.text.length ==
                                            0) {
                                          peopleListBloc.fetchPeopleList();
                                          // _bloc.fetchPeopleList(onlyPrimary: widget.isCameFromSubscription);
                                        } else {
                                          onSearchTextChanged(
                                              searchUserController.text);
                                        }
                                      },
                                    ),
                                    suffixIcon: IconButton(
                                      icon: new Icon(Icons.cancel),
                                      onPressed: () {
                                        searchUserController.clear();
                                        peopleListBloc.fetchPeopleList(
                                            searchUsernameString: "");
                                      },
                                    ),
                                  ),
                                  // onChanged: (data) {
                                  //   if (data.length == 0) {
                                  //     onSearchTextChanged("");
                                  //   } else {
                                  //     onSearchTextChanged(data);
                                  //   }
                                ),
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: snp.data.peopleResponse.length,
                                  itemBuilder: (context, index) {
                                    List<People> list1 =
                                        snp.data.peopleResponse;
                                    Comparator<People> nameComparator =
                                        (a, b) =>
                                            a.firstName.compareTo(b.firstName);

                                    list1.sort(nameComparator);

                                    return Card(
                                      child: Column(children: [
                                        userListTile(
                                            snp.data.peopleResponse[index]),
                                        Divider(
                                          color: Colors.grey,
                                          height: 1.0,
                                        ),
                                      ]),
                                    );
                                  }),
                            ],
                          );
                        }
                      } else {
                        return isFirstLoad
                            ? Text("No Data Found")
                            : Center(child: CircularProgressIndicator());
                      }
                    }))));
  }

  Widget userListTile(People user) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: AssetImage("assets/images/userInfo.png"),
          ),
          SizedBox(width: 10),
          Text(
            "${user.firstName} ${user.lastName}",
            style: TextStyle(fontSize: 14),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.remove_red_eye, color: Colors.black),
            onPressed: () {
              //Show reset Password Popup
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20.0)), //this right here
                      child: Container(
                        height: 400,
                        child: resetPasswordContainer(user),
                      ),
                    );
                  });
            },
          ),
          user.invalidLoginCount != null && user.invalidLoginCount > 3
              ? IconButton(
                  icon: Icon(
                    Icons.lock,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    unlockApiCall(user);
                  },
                )
              : Container()
        ]));
  }

  Widget passwordField() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      controller: myPasswordController,
      obscureText: loginPasswordVisible,
      style: style,
      validator: (String arg) {
        if (arg.length > 0) {
          if (isPass(arg))
            return null;
          else {
            String msg = isLoginSelected
                ? Constants.VALIDATION_VALID_PASSWORD_LOGIN
                : Constants.VALIDATION_VALID_PASSWORD;

            return msg;
          }
        } else {
          return Constants.VALIDATION_BLANK_PASSWORD;
        }
      },
      onSaved: (String val) {
        _password = val;
      },
      decoration: InputDecoration(
        labelText: "Enter password",
        hintStyle: Utils.hintStyleBlack,
        errorMaxLines: 3,
        fillColor: Colors.transparent,
        filled: true,
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Colors.red)),
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide(color: Colors.black)),
        enabledBorder: enabledBorder,
        // suffixIcon: IconButton(
        //   icon: Icon(
        //     // Based on passwordVisible state choose the icon
        //     loginPasswordVisible
        //         ? Icons.visibility
        //         : Icons.visibility_off,
        //     color: Colors.black,
        //   ),
        //   onPressed: () {
        //     // Update the state i.e. toogle the state of passwordVisible variable
        //     setState(() {
        //       loginPasswordVisible = !loginPasswordVisible;
        //     });
        //   },
        // ),
      ),
    );
  }

  Widget confirmPasswordField() {
    return TextFormField(
      textInputAction: TextInputAction.done,
      controller: myConfirmPasswordController,
      obscureText: loginPasswordVisible,
      style: style,
      validator: (String arg) {
        if (arg.length > 0) {
          return null;
        } else {
          return Constants.VALIDATION_BLANK_PASSWORD;
        }
      },
      onSaved: (String val) {
        _password = val;
      },
      decoration: InputDecoration(
        labelText: "Enter confirm password",
        hintStyle: Utils.hintStyleBlack,
        errorMaxLines: 3,
        fillColor: Colors.transparent,
        filled: true,
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Colors.red)),
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide(color: Colors.black)),
        enabledBorder: enabledBorder,
        // suffixIcon: IconButton(
        //   icon: Icon(
        //     // Based on passwordVisible state choose the icon
        //     loginPasswordVisible
        //         ? Icons.visibility
        //         : Icons.visibility_off,
        //     color: Colors.black,
        //   ),
        //   onPressed: () {
        //     // Update the state i.e. toogle the state of passwordVisible variable
        //     setState(() {
        //       loginPasswordVisible = !loginPasswordVisible;
        //     });
        //   },
        // ),
      ),
    );
  }

  bool isPass(String em) {
    String passwordReguExp =
        r'^.*(?=.{8,})(?=.*\d)(?=.*[a-z])(?=.*[a-z])(^[a-zA-Z0-9@\$=!:.#%]+$)';

    RegExp regExp = RegExp(passwordReguExp);
    bool isPasw = regExp.hasMatch(em);

    return isPasw;
  }

  Widget resetPasswordContainer(People user) {
    myPasswordController.text = "";
    myConfirmPasswordController.text = "";
    return Form(
        key: _loginFormKey,
        autovalidate: _loginSutoValidate,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Text("Reset Password"),
                SizedBox(height: 20.0),

                passwordField(),
                SizedBox(height: 15.0),
                confirmPasswordField(),
                SizedBox(
                  height: 15.0,
                ),
                //forgotPasswordAndRememberMe,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.red,
                    ),
                    RaisedButton(
                      onPressed: () {
                        _validateInputsForResetPassword(user);
                      },
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: const Color(0xFF1BC0C5),
                    )
                  ],
                ),
                SizedBox(
                  height: 35.0,
                ),
              ],
            ),
          ),
        ));
  }

  void _validateInputsForResetPassword(People user) async {
    if (_loginFormKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _loginFormKey.currentState.save();
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile) {
        // I am connected to a mobile network.
        if (myPasswordController.text == myConfirmPasswordController.text) {
          restPasswordApiCall(myPasswordController.text, user);
        } else {
          Utils.toasterMessage("Password and Confirmpassword do not match.");
        }
      } else if (connectivityResult == ConnectivityResult.wifi) {
        // I am connected to a wifi network.
        if (myPasswordController.text == myConfirmPasswordController.text) {
          restPasswordApiCall(myPasswordController.text, user);
        } else {
          Utils.toasterMessage("Password and Confirmpassword do not match.");
        }
      } else {
        Utils.toasterMessage(Constants.NO_INTERNET_CONNECTION);
      }
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _loginSutoValidate = true;
      });
    }
  }

  restPasswordApiCall(String newPssword, People user) async {
    CustomProgressLoader.showLoader(context);
    String url = WebserviceConstants.baseAdminURL + "/users/setPassword";
    Map map = {
      'userName': user.userName,
      'newPassword': newPssword,
    };
    dynamic response1 = await APICalling.apiPostWithHeaderRequest(url, map);

    debugPrint("Resett API CAll");
    debugPrint(response1.toString());
    debugPrint(response1.toString());

    CustomProgressLoader.cancelLoader(context);

    if (response1 == 204) {
      print("Success");
      Utils.toasterMessage("Your Password successfully saved.");
      Navigator.of(context).pop(true);
    } else {
      Utils.toasterMessage(AppPreferences().getApisErrorMessage);
    }
  }

  unlockApiCall(People user) async {
    CustomProgressLoader.showLoader(context);

    Map data = {
      "invalidLoginCount": 0,
    };
    String userDeptName = user.departmentName;
    String userName = user.userName;

    String body = json.encode(data);
    var url = WebserviceConstants.baseAdminURL +
        "/departments/$userDeptName/users/$userName/dynamicUpdate";
    var headers = {
      "username": AppPreferences().username,
      "tenant": WebserviceConstants.tenant,
      'content-type': 'application/json',
    };
    http.Response response = await http.post(
      '$url',
      headers: headers,
      body: body,
    );

    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE ||
        response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE_2) {
      // Map<String, dynamic> jsonMapData = new Map();

      peopleListBloc.fetchPeopleList(
          departmentName: deptName,
          isFromDiabetesRiskScore: false,
          onlyPrimary: true);
      CustomProgressLoader.cancelLoader(context);

      try {
        // jsonMapData = jsonDecode(response.body);
        // print(jsonMapData);
      } catch (_) {
        // print("" + _);
      }
    } else {
      Utils.toasterMessage(" Error in unlocking the user");
    }
  }
}
