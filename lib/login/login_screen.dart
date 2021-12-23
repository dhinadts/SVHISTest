import '../bloc/auth_bloc.dart';
import '../bloc/user_info_bloc.dart';
import '../login/colors/color_info.dart';
import '../login/preferences/user_preference.dart';
import '../login/stateLessWidget/upper_logo_widget.dart';
import '../login/utils/custom_progress_dialog.dart';
import '../login/utils/utils.dart';
import '../model/user_info.dart';
import '../repo/common_repository.dart';
import '../ui/app_translations.dart';
import '../ui/custom_drawer/remainders_list_data.dart';
import '../ui/custom_drawer/navigation_home_screen.dart';
import '../ui/forgot_password_screen.dart';
import '../ui/rooted_device_message_screen.dart';
import '../ui/signup_inappwebview.dart';
import '../ui/splash_screen.dart';
import '../ui/tabs/AppLanguage.dart';
import '../ui/tabs/app_localizations.dart';
import '../utils/app_preferences.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../utils/validation_utils.dart';
import '../ui/reset_password_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:root_checker/root_checker.dart';
import '../repo/app_env_props_rep.dart';
import '../ui/sign_up_screen.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  TextStyle style = TextStyle(fontSize: 20.0, color: Color(ColorInfo.APP_GRAY));
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextStyle forgotPasswordStyle = TextStyle(
    color: Colors.black38,
    fontSize: 15.0,
  );
  TextStyle forgotPasswordStyleTamil = TextStyle(
    color: Colors.black38,
    fontSize: 14,
  );
  TextStyle countryStyle = TextStyle(
    color: Colors.black38,
    fontSize: 15.0,
  );
  TextStyle selectedCountryStyle = TextStyle(
    color: Color(ColorInfo.APP_GRAY),
    fontSize: 15.0,
  );
  bool isLoginSelected = true;
  bool _loginSutoValidate = false;
  bool showCountry = false;
  String _email, _password = "";
  bool loginPasswordVisible = true,
      confirmPasswordVisible = true,
      signUpPasswordVisible;

  final myPasswordController = TextEditingController();
  final myEmailController = TextEditingController();
  final myConfirmEmailController = TextEditingController();

  bool isAnimViewShow = false;

  String success = "success", error = "error";
  String lag;

  var enabledBorder = const OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black, width: 0.0),
      borderRadius: BorderRadius.all(Radius.circular(15.0)));

  String initalValueForText = "";

  bool isRememberMeChecked = false;
  bool isTermsAndConditionChecked = false;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.initState();
    // _setLocale();
    setState(() {
      lag = AppPreferences().language;
    });
    // wishes();
  }

  wishes() async {
    if (WebserviceConstants.baseURL != null) {
      remaindersListData = await CommonRepository().getWishesList();
      setState(() {});
    }
  }

  void onLocaleChange(Locale locale) async {
    setState(() {
      AppTranslations.load(locale);
    });
    // Init preferences

    UserPreference.initSharedPreference();

    /* if (AppPreferences().country == "" || AppPreferences().country == null) {
      print("Country not Available Please select your country");
      //TODO: Need to develop Popup country
      //showCountryList();
      showCountry = true;
      Fluttertoast.showToast(
          msg: AppLocalizations.of(context).translate('key_contry'),
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          gravity: ToastGravity.TOP);
    }*/
  }

  bool initCall = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Child View defined here///

    AppPreferences().setGlobalContext(context);
    var appLanguage = Provider.of<AppLanguage>(context);

    final emailField = new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        new Padding(
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: new Theme(
                data: new ThemeData(
                  primaryColor: Colors.black,
                  primaryColorDark: Colors.black,
                ),
                child: TextFormField(
                  controller: myEmailController,
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    BlacklistingTextInputFormatter(new RegExp(r"\s\b|\b\s"))
                  ],
                  // validator: ValidationUtils.usernameValidation,
                  validator: (value) {
                    if (value.isEmpty || value == null) {
                      return "Username cannot be blank";
                    }
                  },
                  onSaved: (String val) {
                    _email = val;
                  },
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  style: style,
                  decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)
                          .translate("key_username"),
                      hintStyle: Utils.hintStyleBlack,
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      fillColor: Colors.transparent,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(color: Colors.black)),
                      enabledBorder: enabledBorder),
                )))
      ],
    );

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
                        /*if (ValidationUtils.isValidPassword(arg))
                        return null;
                        else {
                          String msg = isLoginSelected
                              ? Constants.VALIDATION_VALID_PASSWORD_LOGIN
                              : Constants.VALIDATION_VALID_PASSWORD;

                          return msg;
                        }*/
                        return null;
                      } else {
                        return AppLocalizations.of(context)
                            .translate("key_passwordcantbeblank");
                      }
                    },
                    onSaved: (String val) {
                      _password = val;
                    },
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)
                          .translate("key_password"),
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
    final forgetUsernameButton = Container(
      width: MediaQuery.of(context).size.width / 2.3,
      child: Container(
        margin: EdgeInsets.only(left: 5),
        child: Material(
          color: Colors.white,
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ForgotPassword(
                            title: AppLocalizations.of(context)
                                .translate("key_forgettitleusername"),
                          )));
            },
            child: Text(
              AppLocalizations.of(context).translate("key_forgetusername"),
              style: AppPreferences().isLanguageTamil()
                  ? forgotPasswordStyleTamil
                  : forgotPasswordStyle,
            ),
          ),
        ),
      ),
    );
    final forgetPasswordButton = Container(
      width: MediaQuery.of(context).size.width / 2.3,
      child: Container(
        child: Material(
          color: Colors.white,
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ForgotPassword(
                            title: AppLocalizations.of(context)
                                .translate("key_forgettitlepassword"),
                          )));
            },
            child: Text(
              AppLocalizations.of(context).translate("key_forgetpassword"),
              textAlign: TextAlign.end,
              maxLines: null,
              style: AppPreferences().isLanguageTamil()
                  ? forgotPasswordStyleTamil
                  : forgotPasswordStyle,
            ),
          ),
        ),
      ),
    );
    final buttonView = new Container(
        child: new InkWell(
      child: new Container(
          height: 50.0,
          width: 200.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Color(ColorInfo.APP_BLUE),
          ),
          child: new Center(
            child: new Text(
              AppLocalizations.of(context).translate("key_signin"),
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  color: Colors.white,
                  child: Container(
                      color: Colors.white,
                      child: AppPreferences().environmentCode ==
                              Constants.TT_ENV_CODE
                          ? UpperLogoWidgetDATT(
                              showPoweredBy: false,
                            )
                          : UpperLogoWidget(
                              showPoweredBy: false,
                              showVersion: true,
                              showTitle: true)),
                ),
                SizedBox(height: 50.0),
                if (Constants.LANGUAGE_ENABLED)
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                              AppLocalizations.of(context)
                                  .translate("key_selectlanguage"),
                              style: AppPreferences().isLanguageTamil()
                                  ? forgotPasswordStyleTamil
                                  : forgotPasswordStyle),
                          Spacer(),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: DropdownButton<String>(
                                underline: Container(),
                                hint: Text(
                                    lag ??
                                        AppLocalizations.of(context)
                                            .translate("key_select"),
                                    style: TextStyle(fontSize: 12)),
                                items: <String>[
                                  Constants.ENGLISH_VALUE_KEY,
                                  Constants.TAMIL_VALUE_KEY,
                                  Constants.HINDI_VALUE_KEY,
                                  /*'Telugu'*/
                                ].map((String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value,
                                        style: TextStyle(fontSize: 16)),
                                  );
                                }).toList(),
                                onChanged: (_) async {
                                  setState(() {
                                    lag = _;
                                  });

                                  if (_ == Constants.ENGLISH_VALUE_KEY) {
                                    debugPrint("English selected");
                                    appLanguage.changeLanguage(Locale("en"));
                                  } else if (_ == Constants.TAMIL_VALUE_KEY) {
                                    debugPrint("Tamil selected");
                                    appLanguage.changeLanguage(Locale("ta"));
                                  } else if (_ == Constants.HINDI_VALUE_KEY) {
                                    debugPrint("Hindi selected");
                                    appLanguage.changeLanguage(Locale("hi"));
                                  } else if (_ == Constants.TELUGU_KEY) {
                                    debugPrint("Telugu selected");
                                    appLanguage.changeLanguage(Locale("te"));
                                  }
                                  await AppPreferences.setLanguage(_);
                                },
                              ))
                        ],
                      )),
                //SizedBox(height: 30.0),
                emailField,
                SizedBox(height: 15.0),
                passwordField,
                SizedBox(height: 10),
                //if (lag != "Tamil")
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(child: forgetUsernameButton),
                    forgetPasswordButton,
                  ],
                ),
                SizedBox(
                  height: 25.0,
                ),
                //forgotPasswordAndRememberMe,
                buttonView,
                SizedBox(
                  height: 25.0,
                ),
                Container(
                    child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        AppLocalizations.of(context)
                            .translate("key_donthaveaccount"),
                        style:
                            TextStyle(color: Colors.black38, fontSize: 16.0)),
                    SizedBox(
                      width: 7,
                    ),
                    InkWell(
                      child: Text(
                          AppLocalizations.of(context).translate("key_signup"),
                          style: TextStyle(
                              color: Color(ColorInfo.APP_BLUE),
                              fontSize: 18.0)),
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => SignUpScreen()));
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return SignupInappWebview(
                              departmentName: AppPreferences().deptmentName,
                              clientId: AppPreferences().clientId,
                            );
                          }),
                        );
                      },
                    )
                  ],
                )),

                Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: IconButton(
                    icon: new Image.asset('assets/images/conversation.png'),
                    iconSize: 50,
                    color: Colors.green,
                    splashColor: Colors.purple,
                    onPressed: () {
                      debugPrint("Support screen");
                      Navigator.pushNamed(context, Routes.supportScreen);
                    },
                  ),
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
                child: Scaffold(
                    backgroundColor: Colors.white,
                    body: new Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.white,
                        child: new Center(
                            child: new SingleChildScrollView(
                                child: kReleaseMode
                                    ? FutureBuilder(
                                        future: RootChecker.isDeviceRooted,
                                        builder: (BuildContext context,
                                            AsyncSnapshot<bool> snapshot) {
                                          if (snapshot.hasData) {
                                            if (snapshot.data) {
                                              return RootedDeviceMessageScreen();
                                            } else {
                                              return logInContainer;
                                            }
                                          } else {
                                            // TODO: Error message has to be added when API is not able to respond
                                            return _loader;
                                          }
                                        })
                                    : logInContainer)))))));
  }

  //==================== METHODS DEFINED HERE ==================================

  void onNextClick() {
    _validateInputsForLogin();
  }

  Widget get _loader => Center(
        child: CircularProgressIndicator(),
      );

  bool isEmailValid(String em) {
    if (em.length > 1) {
      return true;
    } else {
      return false;
    }
    //return regExp.hasMatch(em);
  }

  bool isName(String em) {
    return RegExp(r"^[a-zA-Z]+(([',.-][a-zA-Z ])?[a-zA-Z]*)*$").hasMatch(em);
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
      apiCall();
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
    _bloc.authLogin(_email, _password);
    _bloc.baseRespFetcher.listen((response) async {
      if (response.status == 200) {
        AppPreferences.setRole(response.userRole);
        AppPreferences.setUsername(response.userName);
        AppPreferences.setFullName(response.userFullName);
        AppPreferences.setDeptName(response.userDepartment);
        AuthBloc bloc = AuthBloc(context);
        await bloc.getDepartmentConfigInformation();
        UserInfo userInfo = await bloc.getUserInformation();
        await AppEnvPropRepo.fetchEnvProps();
        Fluttertoast.showToast(
            timeInSecForIosWeb: 5,
            msg: AppLocalizations.of(context).translate('key_loginsuccessful'),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);
        AppPreferences.setLoginStatus(true);
        await AppPreferences().init();
        CustomProgressLoader.cancelLoader(context);
        AppPreferences.setUserCategory(userInfo.userCategory);

        //Navigator.pushReplacementNamed(context, Routes.navigatorHomeScreen);
        AppPreferences.setPasswordChanged((userInfo.pwdChangeFlag ||
            response.userRole == Constants.supervisorRole));
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //         builder: (BuildContext context) => NavigationHomeScreen(
        //               drawerIndex: (userInfo.pwdChangeFlag ||
        //                       response.userRole == Constants.supervisorRole)
        //                   ? Constants.PAGE_ID_HOME
        //                   : Constants.PAGE_ID_RESET_PASSWORD,
        //               fetchMenuFromServer: true,
        //             )));
        if (!(userInfo.pwdChangeFlag ||
            response.userRole == Constants.supervisorRole)) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ResetPassword()),
          );
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => NavigationHomeScreen()));
        }
        FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
        _firebaseMessaging.getToken().then((value) => sendTokenToServer(value));
      } else if (response.status == 403) {
        CustomProgressLoader.cancelLoader(context);
        await AppPreferences.logoutClearPreferences();
        getVersion();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SplashScreen()),
            ModalRoute.withName(Routes.splashScreen));
        Fluttertoast.showToast(
            msg: response?.error_description ?? "Invalid Access",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);
      } else {
        CustomProgressLoader.cancelLoader(context);
        Fluttertoast.showToast(
            msg: response?.error_description ??
                AppLocalizations.of(context)
                    .translate('key_somethingwentwrong'),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);
      }
    });
  }

  sendTokenToServer(String token) {
    // debugPrint("FCM Device token---------------$token");
    UserInfoBloc userInfoBloc = new UserInfoBloc(context);
    userInfoBloc.updateUserFcmToken(token);
  }

  getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    debugPrint("version = $version");
    await AppPreferences.setVersion(version);
  }
}
