import 'dart:convert';

import '../login/api/api_calling.dart';
import '../login/colors/color_info.dart';
import '../login/constants/api_constants.dart';
import '../login/login_screen.dart';
import '../login/preferences/user_preference.dart';
import '../login/stateLessWidget/upper_logo_widget.dart';
import '../login/utils/custom_progress_dialog.dart';
import '../login/utils/utils.dart';
import '../utils/constants.dart';
import '../utils/app_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class SetPassword extends StatefulWidget {
  String otp;

  SetPassword(this.otp);

  @override
  _SetPasswordState createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword>
    with TickerProviderStateMixin {
  TextStyle style = TextStyle(fontSize: 20.0, color: Color(ColorInfo.APP_GRAY));
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  bool isLoginSelected = true;
  bool _loginSutoValidate = false;

  String _email, _password = "";
  bool loginPasswordVisible = true,
      confirmPasswordVisible = true,
      signUpPasswordVisible;

  final myPasswordController = TextEditingController();

  final myConfirmEmailController = TextEditingController();

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
    myPasswordController.dispose();
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    /// Child View defined here///

    final passwordField = new Column(
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
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(color: Colors.black)),
                      enabledBorder: enabledBorder,
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          loginPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            loginPasswordVisible = !loginPasswordVisible;
                          });
                        },
                      ),
                    ),
                  )))
        ]);
    final confirmPasswordField = new Column(
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
                    controller: myConfirmEmailController,
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
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(color: Colors.black)),
                      enabledBorder: enabledBorder,
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          loginPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            loginPasswordVisible = !loginPasswordVisible;
                          });
                        },
                      ),
                    ),
                  )))
        ]);

    final buttonView = new Container(
        child: new InkWell(
      child: new Container(
          height: 50.0,
          width: 120.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Color(ColorInfo.APP_BLUE),
          ),
          child: new Center(
            child: new Text(
              "Submit",
              style: TextStyle(
                color: Color(ColorInfo.WHITE),
                fontSize: 18.0,
              ),
            ),
          )),
      onTap: () {
        onNextClick();
      },
    ));

    final logInContainer = Form(
        key: _loginFormKey,
        autovalidate: _loginSutoValidate,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 200.0,
                  color: Colors.white,
                  child: new UpperLogoWidget(),
                ),
                SizedBox(height: 10.0),
                new Text(
                    "Password must have at least 8 characters with at least one letter and one number"),
                passwordField,
                SizedBox(height: 15.0),
                confirmPasswordField,
                SizedBox(
                  height: 35.0,
                ),
                //forgotPasswordAndRememberMe,
                buttonView,
                SizedBox(
                  height: 35.0,
                ),
              ],
            ),
          ),
        ));

    // Sign up Container

    // Main View Design
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: new Material(
            child: Container(
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage("assets/images/user.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Scaffold(
                    backgroundColor: Colors.white,
                    body: new Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.white,
                        child: new Center(
                            child: new SingleChildScrollView(
                                child: logInContainer)))))));
  }

  //==================== METHODS DEFINED HERE ==================================

  void onNextClick() {
    _validateInputsForLogin();
  }

  bool isEmailValid(String em) {
    if (em.length > 1) {
      return true;
    } else {
      return false;
    }
    //return regExp.hasMatch(em);
  }

  bool isName(String em) {
    return RegExp(r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$").hasMatch(em);
  }

  bool isPass(String em) {
    String passwordReguExp =
        r'^.*(?=.{8,})(?=.*\d)(?=.*[a-z])(?=.*[a-z])(^[a-zA-Z0-9@\$=!:.#%]+$)';

    RegExp regExp = RegExp(passwordReguExp);
    bool isPasw = regExp.hasMatch(em);

    return isPasw;
  }

  void _validateInputsForLogin() async {
    if (_loginFormKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _loginFormKey.currentState.save();

      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile) {
        // I am connected to a mobile network.

        if (myPasswordController.text == myConfirmEmailController.text) {
          apiCall();
        } else {
          Utils.toasterMessage("Password and Confirmpassword do not match.");
        }
      } else if (connectivityResult == ConnectivityResult.wifi) {
        // I am connected to a wifi network.
        if (myPasswordController.text == myConfirmEmailController.text) {
          apiCall();
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

  apiCall() async {
    CustomProgressLoader.showLoader(context);
    String url = ApiConstants.BASE_URL + ApiConstants.SET_PASSWORD;

    Map map = {
      'userName': UserPreference.getUserId(),
      'newPassword': myPasswordController.text,
    };

    String body = json.encode(map);

    // print(url);

    // print(body);

    String response = await APICalling.apiPostWithHeaderRequest(url, map);

    // print("---------Code" + response);
    CustomProgressLoader.cancelLoader(context);
    // var parsedJson = json.decode(response);

    if (response == "204") {
      Utils.toasterMessage("Your Password successfully saved.");

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      if (response == "204") {
        Utils.toasterMessage("Please choose another password.");
      } else {
        Utils.toasterMessage(AppPreferences().getApisErrorMessage);
      }
    }
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
