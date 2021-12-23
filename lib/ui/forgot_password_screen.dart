import '../bloc/auth_bloc.dart';
import '../login/colors/color_info.dart';
import '../login/preferences/user_preference.dart';
import '../login/stateLessWidget/upper_logo_widget.dart';
import '../login/utils/custom_progress_dialog.dart';
import '../login/utils/utils.dart';
import '../ui/tabs/app_localizations.dart';
import '../ui_utils/app_colors.dart';
import '../ui_utils/network_check.dart';
import '../utils/app_preferences.dart';
import '../utils/constants.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword>
    with TickerProviderStateMixin {
  TextStyle style = TextStyle(
      fontFamily: Constants.LatoRegular,
      fontSize: 16.0,
      color: Color(ColorInfo.APP_GRAY));

  final GlobalKey<FormState> _forgetFormKey = GlobalKey<FormState>();

  bool isLoginSelected = true;
  bool _loginSutoValidate = false;

  String _email = "";

  final myPasswordController = TextEditingController();
  final myEmailController = TextEditingController();
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

    final emailField = new Column(
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
                  controller: myEmailController,
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    BlacklistingTextInputFormatter(new RegExp(r"\s\b|\b\s"))
                  ],
                  validator: (String arg) {
                    if (isEmailValid(arg)) {
                      return null;
                    } else {
                      return AppLocalizations.of(context)
                          .translate("key_validemail");
                    }
                  },
                  onSaved: (String val) {
                    _email = val;
                  },
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  style: style,
                  decoration: InputDecoration(
                      errorMaxLines: 2,
                      hintText: AppLocalizations.of(context)
                          .translate("key_enter_email"),
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
                AppLocalizations.of(context).translate("key_submit"),
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
                Container(
                  height: 250.0,
                  color: Colors.white,
                  child:
                      AppPreferences().environmentCode == Constants.TT_ENV_CODE
                          ? UpperLogoWidgetDATT(
                              showPoweredBy: false,
                            )
                          : UpperLogoWidget(
                              showPoweredBy: false,
                              showVersion: false,
                              showTitle: true),
                ),

                SizedBox(height: 10.0),
                emailField,
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
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: new Material(
            child: Container(
                child: Scaffold(
                    appBar: new AppBar(
                      backgroundColor: AppColors.primaryColor,
                      centerTitle: true,
                      title: new Text(
                        widget.title,
                        style: AppPreferences().isLanguageTamil()
                            ? TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold)
                            : TextStyle(color: Colors.white),
                      ),
                    ),
                    backgroundColor: Colors.white,
                    body: new Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.white,
                        child: new Center(
                            child: new SingleChildScrollView(
                                child: logInContainer)))))));
  }

  void onNextClick() {
    _validateInputsForForgotPassword();
  }

  bool isEmailValid(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }

  void _validateInputsForForgotPassword() async {
    if (_forgetFormKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _forgetFormKey.currentState.save();

      var connectivityResult = await NetworkCheck().check();
      if (connectivityResult) {
        apiCall();
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
    AuthBloc _bloc = new AuthBloc(context);
    if (widget.title.contains(
        AppLocalizations.of(context).translate("key_forgettitlepassword"))) {
      _bloc.authForgotPassword(_email);
      _bloc.forgotRespFetcher.listen((response) async {
        // debugPrint(response.toJson().toString());
        if (response.status == 204 || response.status == 201) {
          CustomProgressLoader.cancelLoader(context);
          Fluttertoast.showToast(
              timeInSecForIosWeb: 5,
              msg: AppLocalizations.of(context)
                  .translate("key_reset_password_msg"),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP);
          Navigator.pop(context);
        } else {
          CustomProgressLoader.cancelLoader(context);
          Fluttertoast.showToast(
              msg: response?.message ?? AppPreferences().getApisErrorMessage,
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 5,
              gravity: ToastGravity.TOP);
        }
      });
    } else {
      _bloc.authForgotUsername(_email);
      _bloc.forgotRespFetcher.listen((response) async {
        // debugPrint(response.toJson().toString());
        if (response.status == 204 || response.status == 201) {
          CustomProgressLoader.cancelLoader(context);
          Fluttertoast.showToast(
              timeInSecForIosWeb: 5,
              msg: "Username sent to your email",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP);
          Navigator.pop(context);
        } else {
          CustomProgressLoader.cancelLoader(context);
          Fluttertoast.showToast(
              msg: response?.message ?? AppPreferences().getApisErrorMessage,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP);
        }
      });
    }
  }
}
