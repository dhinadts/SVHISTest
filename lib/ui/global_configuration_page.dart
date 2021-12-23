import 'dart:io';

import '../bloc/auth_bloc.dart';
import '../bloc/global_configuration_bloc.dart';
import '../bloc/user_info_bloc.dart';
import '../login/stateLessWidget/upper_logo_widget.dart';
import '../login/utils/custom_progress_dialog.dart';
import '../repo/app_env_props_rep.dart';
import '../ui/tabs/app_localizations.dart';
import '../ui_utils/app_colors.dart';
import '../ui_utils/widget_styles.dart';
import '../utils/app_preferences.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../widgets/sign_in_card_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class GlobalConfigurationPage extends StatefulWidget {
  final String token;
  final UserInfoBloc bloc;

  GlobalConfigurationPage({this.token, this.bloc});

  @override
  _GlobalConfigurationPageState createState() =>
      _GlobalConfigurationPageState();
}

class _GlobalConfigurationPageState extends State<GlobalConfigurationPage>
    with AutomaticKeepAliveClientMixin<GlobalConfigurationPage> {
  final GlobalKey<FormState> configFormKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  TextEditingController _tokenEditingController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  var tokenErrorMsg = "";

  bool resetErrorMsg = false;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _tokenEditingController.text = widget.token;
    });

    if (widget.bloc != null) {
      widget.bloc.countryCodeFetcher.listen((value) {
        if (this.mounted)
          setState(() {
            _tokenEditingController.text = value;
          });
      });
      widget.bloc.simplifyLoginModelFetcher.listen((value) {
        if (this.mounted)
          setState(() {
            _tokenEditingController.text = value.userPromoCode;
            passwordController.text = value.password;
            usernameController.text = value.username;
          });
      });
    }
    super.initState();
  }

  List<bool> isSelected = [true, false];

  @override
  Widget build(BuildContext context) {
    AppPreferences().setContext(context);
    return Form(
        key: configFormKey,
        autovalidate: _autoValidate,
        child: Scaffold(
            appBar: Constants.GC_REGISTRATION_ENABLED
                ? null
                : AppBar(
                    backgroundColor: AppColors.primaryColor,
                    title: Center(child: Text(Constants.appName)),
                  ),
            body: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8, top: 25, bottom: 30),
                  child: UpperLogoWidget(),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (false)
                      Container(
                          height: 45,
                          child: ToggleButtons(
                            textStyle: TextStyle(fontWeight: FontWeight.bold),
                            borderColor: AppColors.dispatchedColor,
                            borderWidth: 2,
                            color: Colors.grey[500],
                            disabledBorderColor: Colors.grey,
                            hoverColor: Colors.grey,
                            selectedBorderColor: AppColors.dispatchedColor,
                            children: <Widget>[
                              Container(
                                  alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width / 2.5,
                                  padding: EdgeInsets.all(10),
                                  child: Text("Promo Code")),
                              Container(
                                  alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width / 2.5,
                                  padding: EdgeInsets.all(10),
                                  child: Text("Token")),
                            ],
                            onPressed: (int index) {
                              // debugPrint("Selected index --> $index");

                              setState(() {
                                resetErrorMsg = true;
                                tokenErrorMsg = "";
                                if (configFormKey.currentState.validate()) {
                                  // debugPrint("configFormKey index --> $index");
                                }
                                for (int buttonIndex = 0;
                                    buttonIndex < isSelected.length;
                                    buttonIndex++) {
                                  if (buttonIndex == index) {
                                    isSelected[buttonIndex] = true;
                                  } else {
                                    isSelected[buttonIndex] = false;
                                  }
                                }
                              });
                            },
                            isSelected: isSelected,
                          )),
                    if (false)
                      SizedBox(
                        height: 30,
                      ),
                    if (false)
                      RaisedButton(
                        padding: EdgeInsets.fromLTRB(23, 13, 23, 13),
                        color: AppColors.arrivedColor,
                        child: Text(
                          "Scan QR Code",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          PermissionHandler permissionHandler =
                              PermissionHandler();
                          PermissionStatus permissionStatus =
                              await permissionHandler.checkPermissionStatus(
                                  PermissionGroup.camera);
                          if (permissionStatus != PermissionStatus.granted) {
                            permissionStatus = (await permissionHandler
                                .requestPermissions([
                              PermissionGroup.camera
                            ]))[PermissionGroup.camera];
                            if (permissionStatus == PermissionStatus.denied ||
                                (Platform.isAndroid
                                    ? permissionStatus ==
                                        PermissionStatus.neverAskAgain
                                    : permissionStatus ==
                                        PermissionStatus.restricted)) {
                              await showDialog<bool>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Allow camera access',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    content: Text(
                                      'Camera access is required to use QR scan',
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                    actions: [
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          return Future.value(true);
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      FlatButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          await permissionHandler
                                              .openAppSettings();
                                          return Future.value(true);
                                        },
                                        child: Text('Go to settings'),
                                      ),
                                    ],
                                  );
                                },
                              );
//                              Navigator.pop(context);
                              return Future.value(true);
                            } else {
                              // scanQrCode();
                              return Future.value(false);
                            }
                          } else {
                            // scanQrCode();
                            return Future.value(false);
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    if (false)
                      Center(
                          child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              child: Container(
                                color: Colors.grey[300],
                                height: 1,
                              ),
                              flex: 2,
                              fit: FlexFit.tight,
                            ),
                            Flexible(
                                child: Text(
                                  "OR",
                                  textAlign: TextAlign.center,
                                ),
                                flex: 1,
                                fit: FlexFit.tight),
                            Flexible(
                              child: Container(
                                color: Colors.grey[300],
                                height: 1,
                              ),
                              flex: 2,
                              fit: FlexFit.tight,
                            ),
                          ],
                        ),
                      )),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: TextFormField(
                          controller: _tokenEditingController,
                          enabled: !(usernameController.text != null &&
                              usernameController.text.isNotEmpty &&
                              passwordController.text != null &&
                              passwordController.text.isNotEmpty),
                          decoration: isSelected[0]
                              ? WidgetStyles.decoration("Enter your promo code")
                              : WidgetStyles.decoration("Enter your token"),
                          onChanged: (val) {
                            if (tokenErrorMsg.isNotEmpty) {
                              setState(() {
                                tokenErrorMsg = "";
                              });
                            }
                          },
                          maxLines: 1,
                          textCapitalization: TextCapitalization.characters,
                          validator: (s) {
                            if (s == null || s.isEmpty) {
                              return resetErrorMsg
                                  ? null
                                  : isSelected[0]
                                      ? "Promo code field cannot be blank"
                                      : "Token field cannot be blank";
                            } else {
                              if (tokenErrorMsg.isNotEmpty) {
                                return tokenErrorMsg;
                              }
                              return null;
                            }
                          },
                        ),
                      ),
                    )),
                    if (usernameController.text != null &&
                        usernameController.text.isNotEmpty &&
                        passwordController.text != null &&
                        passwordController.text.isNotEmpty)
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: SignInCardWidget(
                            enabled: false,
                            usernameController: usernameController,
                            passwordController: passwordController,
                          )),
                    SizedBox(
                      height: 40,
                    ),
                    RaisedButton(
                      padding: EdgeInsets.fromLTRB(43, 13, 43, 13),
                      color: AppColors.arrivedColor,
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        resetErrorMsg = false;
                        if (configFormKey.currentState.validate()) {
                          submitToken(context);
                        } else {
                          setState(() {
                            _autoValidate = true;
                          });
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ],
                ),
              ],
            )));
  }

  void submitToken(BuildContext context) {
    GlobalConfigurationBloc _globalConfigurationBloc =
        GlobalConfigurationBloc(context);
    CustomProgressLoader.showLoader(context);
    _globalConfigurationBloc.decodeGlobalConfigurationsUsingToken(
        _tokenEditingController.text,
        isPromoCode: isSelected[0]);

    _globalConfigurationBloc.globalConfigurationDecodeErrorFetcher
        .listen((value) async {
      CustomProgressLoader.cancelLoader(context);

      Fluttertoast.showToast(msg: value.message);
      setState(() {
        tokenErrorMsg = value.message;
        configFormKey.currentState.validate();
      });
    });

    _globalConfigurationBloc.globalConfigurationDecodeFetcher
        .listen((value) async {
      if (value.message != null && value.message.isNotEmpty) {
        CustomProgressLoader.cancelLoader(context);

        Fluttertoast.showToast(msg: value.message);
        setState(() {
          tokenErrorMsg = value.message;
          configFormKey.currentState.validate();
        });
      } else {
        // print(
        //     "==================================>  DepartmentName ${value.departmentProps.departmentName}");
        // print(
        //     "==================================>  ClientID ${value.departmentProps.clientId}");
        // await AppPreferences.setDeptName(value.departmentProps.departmentName);
        await AppPreferences.setPromoDepartmentName(value.departmentName);
        await AppPreferences.setDeptName(value.departmentName);
        await AppPreferences.setEnvProps(value.envProps);

        //adding environment short code key
        await AppPreferences.setEnvironmentShortCode(
            value.environmentShortCode);

        // await AppPreferences.setClientId(value.departmentProps.clientId);
        await AppPreferences.setClientId(value.envProps.clientId);
        //await AppPreferences.setDefaultCurrency(value.envProps.defaultCurrency);
        //await AppPreferences.setEnvironment(value.environmentCode);
        // AppColors.primaryColor = HexColor(value.envProps.colorScheme);
        // AppPreferences.setAppColor(value.envProps.colorScheme);
        await AppPreferences().init();
        // await AppPreferences.setAppLogo(value.envProps.logoUrl);
        // await AppPreferences.setMembershipBenefitsContent(
        //     value.envProps.membershipBenefitsContent);
        //await AppPreferences.setClientName(value.envProps.clientName);
        //await AppPreferences.setDefaultCurrency(value.envProps.defaultCurrency);
        // await AppPreferences.setSignupTermsandConditions(
        //     value.envProps.signUpTermsAndConditions);
        // await AppPreferences.setMembershipTermsandConditions(
        //     value.envProps.membershipTermsAndConditions);
        // await AppPreferences.setDailyCheckinReportEnabled(
        //     value.envProps.userDailyCheckInReportEnabled);
        // await AppPreferences.setProfileHistoryEnabled(
        //     value.envProps.profileHistoryEnabled);
        // await AppPreferences.setUserDailyCheckinEnabled(
        //     value.envProps.dailyCheckinEnabled);
        //await AppPreferences.setAgoraAppId(value.envProps.appId);
        //await AppPreferences.setAgoraAppToken(value.envProps.appToken);
       // debugPrint('apiUrl Value: ${value.apiUrl}');
        AppPreferences.setCountry(value.countryName).then((setCountryResponse) {
          AppPreferences.setApiUrl(value.apiUrl).then((setUrlResponse) async {
            AppPreferences.setTenant(value.keyspace).then((value) async {
              // To getDynamicEnvironmentProperties
              await AppEnvPropRepo.fetchEnvProps();

              CustomProgressLoader.cancelLoader(context);
              if (usernameController.text != null &&
                  usernameController.text.isNotEmpty &&
                  passwordController.text != null &&
                  passwordController.text.isNotEmpty) {
                CustomProgressLoader.showLoader(context,
                    title: "Authenticating");
                await loginAPICall(
                    usernameController.text, passwordController.text);
              } else {
                Fluttertoast.showToast(
                    msg: "Success",
                    gravity: ToastGravity.TOP,
                    toastLength: Toast.LENGTH_LONG);
                Navigator.of(context).pushNamedAndRemoveUntil(
                    Routes.login, (Route<dynamic> route) => false);
              }
            });
          });
        });
      }
    });
  }

  loginAPICall(String username, String password) async {
    AuthBloc _bloc = AuthBloc(context);
    _bloc.authLogin(username, password);
    _bloc.baseRespFetcher.listen((response) async {
      if (response.status == 200) {
        AppPreferences.setRole(response.userRole);
        AppPreferences.setUsername(response.userName);
        AppPreferences.setFullName(response.userFullName);
        AppPreferences.setDeptName(response.userDepartment);
        AuthBloc bloc = AuthBloc(context);
        try {
          await bloc.getUserInformation();
          Fluttertoast.showToast(
              timeInSecForIosWeb: 5,
              msg:
                  AppLocalizations.of(context).translate('key_loginsuccessful'),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP);
          AppPreferences.setLoginStatus(true);
          await AppPreferences().init();
          CustomProgressLoader.cancelLoader(context);
          Navigator.pushReplacementNamed(context, Routes.navigatorHomeScreen);
          FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
          _firebaseMessaging
              .getToken()
              .then((value) => sendTokenToServer(value));
        } catch (_) {
          Fluttertoast.showToast(
              timeInSecForIosWeb: 5,
              msg: AppLocalizations.of(context)
                  .translate('key_somethingwentwrong'),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP);
        }
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}