import '../bloc/auth_bloc.dart';
import '../login/colors/color_info.dart';
import '../login/preferences/user_preference.dart';
import '../login/utils/custom_progress_dialog.dart';
import '../login/utils/utils.dart';
import '../ui/tabs/app_localizations.dart';
import '../ui_utils/app_colors.dart';
import '../ui_utils/network_check.dart';
import '../utils/app_preferences.dart';
import '../utils/constants.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'custom_drawer/navigation_home_screen.dart';
import '../utils/alert_utils.dart';

class ResetPassword extends StatefulWidget {
  final ValueChanged<bool> onRefreshDrawerHomeScreen;

  ResetPassword({Key key, this.title, this.onRefreshDrawerHomeScreen})
      : super(key: key);
  final String title;

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword>
    with TickerProviderStateMixin {
  TextStyle style = TextStyle(
      fontFamily: Constants.LatoRegular,
      fontSize: 20.0,
      color: Color(ColorInfo.APP_GRAY));

  final GlobalKey<FormState> _forgetFormKey = GlobalKey<FormState>();

  bool isLoginSelected = true;
  bool _loginSutoValidate = false;
  bool oldPasswordVisible = true;
  bool newPasswordVisible = true;
  bool confirmNewPasswordVisible = true;

  String _oldPassword, _newPassword, _confirmNewPassword = "";

  final myOldPasswordController = TextEditingController();
  final myNewPasswordController = TextEditingController();
  final myConfirmNewPasswordController = TextEditingController();

  var subscription;
  bool isAnimViewShow = false;

  String SUCCESS = "success", ERROR = "error";

  var enabledBorder = const OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black, width: 0.0),
      borderRadius: BorderRadius.all(Radius.circular(15.0)));

  String initalValueForText = "";

  bool isRememberMeChecked = false;
  bool isTermsAndConditionChecked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Init preferences

    UserPreference.initSharedPreference();

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // Got a new connectivity status!
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myOldPasswordController.dispose();
    super.dispose();
    // subscription.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Child View defined here///

    final oldPassword = new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Padding(
              padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
              child: new Theme(
                  data: new ThemeData(
                    primaryColor: Colors.black,
                    primaryColorDark: Colors.black,
                  ),
                  child: TextFormField(
                    textInputAction: isLoginSelected
                        ? TextInputAction.done
                        : TextInputAction.next,
                    controller: myOldPasswordController,
                    obscureText: oldPasswordVisible,
                    style: style,
                    validator: (String arg) {
                      if (arg.length > 0) {
                        return null;
                      } else {
                        return AppLocalizations.of(context)
                            .translate("key_oldpassword");
                      }
                    },
                    onSaved: (String val) {
                      _oldPassword = val;
                    },
                    decoration: InputDecoration(
                      hintText:
                          AppLocalizations.of(context).translate("key_oldpwd"),
                      hintStyle: Utils.hintStyleBlack,
                      errorMaxLines: 3,
                      fillColor: Colors.transparent,
                      filled: true,
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0),
                          borderSide: BorderSide(color: Colors.red)),
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(color: Colors.black)),
                      enabledBorder: enabledBorder,
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          oldPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            oldPasswordVisible = !oldPasswordVisible;
                          });
                        },
                      ),
                    ),
                  )))
        ]);
    final newPassword = new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Padding(
              padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
              child: new Theme(
                  data: new ThemeData(
                    primaryColor: Colors.black,
                    primaryColorDark: Colors.black,
                  ),
                  child: TextFormField(
                    textInputAction: isLoginSelected
                        ? TextInputAction.done
                        : TextInputAction.next,
                    controller: myNewPasswordController,
                    obscureText: newPasswordVisible,
                    style: style,
                    validator: validatePassword,
                    onSaved: (String val) {
                      _newPassword = val;
                    },
                    onChanged: (value) {
                      setState(() {
                        validatePasswordCompilance(value);
                      });
                    },
                    decoration: InputDecoration(
                      hintText:
                          AppLocalizations.of(context).translate("key_newpwd"),
                      hintStyle: Utils.hintStyleBlack,
                      errorMaxLines: 3,
                      fillColor: Colors.transparent,
                      filled: true,
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0),
                          borderSide: BorderSide(color: Colors.red)),
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(color: Colors.black)),
                      enabledBorder: enabledBorder,
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          newPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            newPasswordVisible = !newPasswordVisible;
                          });
                        },
                      ),
                    ),
                  )))
        ]);
    final confirmNewPassword = new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Padding(
              padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
              child: new Theme(
                  data: new ThemeData(
                    primaryColor: Colors.black,
                    primaryColorDark: Colors.black,
                  ),
                  child: TextFormField(
                    textInputAction: isLoginSelected
                        ? TextInputAction.done
                        : TextInputAction.next,
                    controller: myConfirmNewPasswordController,
                    obscureText: confirmNewPasswordVisible,
                    style: style,
                    validator: (String arg) {
                      if (arg.length > 0) {
                        if (arg != myNewPasswordController.text) {
                          return AppLocalizations.of(context)
                              .translate("key_match_pass_error");
                        } else {
                          return null;
                        }
                      } else {
                        return AppLocalizations.of(context)
                            .translate("key_confirmpassword");
                      }
                    },
                    onSaved: (String val) {
                      _confirmNewPassword = val;
                    },
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)
                          .translate("key_confirmnewpwd"),
                      hintStyle: Utils.hintStyleBlack,
                      errorMaxLines: 3,
                      fillColor: Colors.transparent,
                      filled: true,
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0),
                          borderSide: BorderSide(color: Colors.red)),
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(color: Colors.black)),
                      enabledBorder: enabledBorder,
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          confirmNewPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            confirmNewPasswordVisible =
                                !confirmNewPasswordVisible;
                          });
                        },
                      ),
                    ),
                  )))
        ]);
    final buttonView = new Container(
        child: Container(
      height: 50.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Material(
          color: Color(ColorInfo.APP_BLUE),
          child: new InkWell(
            child: new Center(
              child: new Text(
                AppLocalizations.of(context).translate("key_finish"),
                style: TextStyle(
                    color: Color(ColorInfo.WHITE),
                    fontSize: 18.0,
                    fontFamily: Constants.LatoRegular),
              ),
            ),
            onTap: () {
              onNextClick();
            },
          ),
        ),
      ),
    ));

    final logInContainer = Form(
        key: _forgetFormKey,
        autovalidate: _loginSutoValidate,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10.0),
                SizedBox(
                  height: 10.0,
                ),
                oldPassword,
                SizedBox(
                  height: 10.0,
                ),
                newPassword,
                showValidationsDetailRow(),
                SizedBox(
                  height: 10.0,
                ),
                confirmNewPassword,
                SizedBox(
                  height: 35.0,
                ),
                //forgotPasswordAndRememberMe,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Container(),
                    ),
                    Flexible(flex: 8, child: buttonView),
                    Flexible(flex: 1, child: Container()),
                  ],
                ),
                SizedBox(
                  height: 35.0,
                ),
              ],
            ),
          ),
        ));

    // Sign up Container

    // Main View Design
    return WillPopScope(
      onWillPop: () async {
        if (AppPreferences().passwordChanged == true) {
          // exit(0);
          return true;
        } else {
          return true;
        }
        // await Navigator.pop(context);
      },
      child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: new Material(
              child: Container(
                  child: Scaffold(
                      appBar: Constants.SETTINGS_ENABLED
                          ? new AppBar(
                              leading: AppPreferences().passwordChanged == false
                                  ? null
                                  : IconButton(
                                      icon: Icon(Icons.arrow_back),
                                      onPressed: () async {
                                        if (AppPreferences().passwordChanged ==
                                            false) {
                                          exit(0);
                                        } else {
                                          Navigator.pop(context);
                                        }
                                      },
                                    ),
                              backgroundColor: HexColor.fromHex(
                                  AppPreferences().primaryColor),
                              // automaticallyImplyLeading: false,
                              centerTitle: true,
                              title: new Text(AppLocalizations.of(context)
                                  .translate("key_reset")),
                            )
                          : null,
                      backgroundColor: Colors.white,
                      body: new Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.white,
                          child: new Center(
                              child: new SingleChildScrollView(
                                  child: logInContainer))))))),
    );
  }

  Widget showValidationsDetailRow() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 47,
            child: ListTile(
              leading: Icon(
                Icons.check_circle,
                color: isEightChar ? Colors.green : null,
              ),
              title: new Text(
                AppLocalizations.of(context).translate("key_mustbe"),
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
          SizedBox(
            height: 47,
            child: ListTile(
              leading: Icon(Icons.check_circle,
                  color: hasDigits ? Colors.green : null),
              title: new Text(
                AppLocalizations.of(context).translate("key_aleast"),
                maxLines: 3,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
          SizedBox(
            height: 47,
            child: ListTile(
              leading: Icon(Icons.check_circle,
                  color: hasUppercase ? Colors.green : null),
              title: new Text(
                AppLocalizations.of(context).translate("key_capital"),
                maxLines: 3,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
          SizedBox(
            height: 47,
            child: ListTile(
              leading: Icon(Icons.check_circle,
                  color: hasLowercase ? Colors.green : null),
              title: new Text(
                AppLocalizations.of(context).translate("key_small"),
                maxLines: 3,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
          SizedBox(
            height: 47,
            child: ListTile(
              leading: Icon(Icons.check_circle,
                  color: hasSpecialCharacters ? Colors.green : null),
              title: new Text(
                AppLocalizations.of(context).translate("key_special"),
                style: TextStyle(fontSize: 12),
              ),
            ),
          )
        ],
      ),
    );
  }

  void onNextClick() {
    _validateInputsForResetPassword();
  }

  String validatePassword(String value) {
    if (value.isEmpty) {
      return AppLocalizations.of(context).translate("key_newpassword");
    } else {
      if (isValidPassword) {
        return null;
      } else {
        return AppLocalizations.of(context).translate("key_doesntmatch");
      }
    }
  }

  bool passwordValidateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool isEmailValid(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }

  void _validateInputsForResetPassword() async {
    if (_forgetFormKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _forgetFormKey.currentState.save();

      var connectivityResult = await NetworkCheck().check();
      if (connectivityResult) {
        apiCall();
      } else {
        Utils.toasterMessage(
            AppLocalizations.of(context).translate("key_checknetwork"));
      }
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _loginSutoValidate = true;
      });
    }
  }

  apiCall() async {
    CustomProgressLoader.showLoader(context);
    AuthBloc _bloc = new AuthBloc(context);
    _bloc.authResetPassword(_oldPassword, _newPassword);
    _bloc.resetPasswordRespFetcher.listen((response) async {
      // debugPrint(response.toJson().toString());
      if (response.status == 204) {
        CustomProgressLoader.cancelLoader(context);
        Fluttertoast.showToast(
            timeInSecForIosWeb: 5,
            msg: AppLocalizations.of(context).translate("key_resetsucessfully"),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);
        //TODO  : Go to login activity
        if (Constants.SETTINGS_ENABLED) {
          //Navigator.pop(context);
          await AppPreferences.setPasswordChanged(true);
          await AppPreferences().init();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => NavigationHomeScreen(
                        drawerIndex: AppPreferences().passwordChanged
                            ? Constants.PAGE_ID_HOME
                            : Constants.PAGE_ID_USER_PROFILE,
                        fetchMenuFromServer: true,
                      )));
        } else {
          widget.onRefreshDrawerHomeScreen(true);
        }
      } else {
        CustomProgressLoader.cancelLoader(context);
        Fluttertoast.showToast(
            msg: response?.message ??
                AppLocalizations.of(context)
                    .translate("key_somethingwentwrong"),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);
      }
    });
  }

  bool hasUppercase = false;
  bool hasDigits = false;
  bool hasLowercase = false;
  bool hasSpecialCharacters = false;
  bool isEightChar = false;
  bool isValidPassword = false;

  validatePasswordCompilance(String password) {
    // print(password);
    if (!password?.isEmpty) {
      // Check if valid special characters are present
      hasSpecialCharacters =
          password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
      hasUppercase = password.contains(new RegExp(r'^(?=.*?[A-Z])'));
      hasLowercase = password.contains(new RegExp(r'^(?=.*?[a-z])'));
      hasDigits = password.contains(new RegExp(r'^(?=.*?[0-9])'));
    } else {
      hasUppercase = false;
      hasDigits = false;
      hasLowercase = false;
      hasSpecialCharacters = false;
    }

    if (password.length >= 8) {
      isEightChar = true;
    } else {
      isEightChar = false;
    }

    if (hasUppercase &&
        hasDigits &&
        hasLowercase &&
        hasSpecialCharacters &&
        isEightChar) {
      isValidPassword = true;
    } else {
      isValidPassword = false;
    }
  }

  bool isDigit(String s, int idx) =>
      "0".compareTo(s[idx]) <= 0 && "9".compareTo(s[idx]) >= 0;
}
