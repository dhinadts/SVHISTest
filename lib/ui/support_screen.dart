import 'dart:convert';
import 'dart:io';

import '../bloc/geo_bloc.dart';
import '../country_picker_util/country_code_picker.dart';
import '../login/api/api_calling.dart';
import '../login/colors/color_info.dart';
import '../login/constants/api_constants.dart';
import '../login/utils.dart';
import '../login/utils/custom_progress_dialog.dart';
import '../model/user_info.dart';
import '../repo/common_repository.dart';
import '../ui/tabs/app_localizations.dart';
import '../ui_utils/text_styles.dart';
import '../ui_utils/widget_styles.dart';
import '../utils/app_preferences.dart';
import '../utils/constants.dart';
import '../utils/location_utils.dart';
import '../utils/routes.dart';
import '../utils/validation_utils.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

import 'custom_drawer/custom_app_bar.dart';
import 'custom_drawer/navigation_home_screen.dart';

class SupportWidget extends StatefulWidget {
  final String username;
  final String title;

  SupportWidget({this.username, this.title});

  @override
  SupportWidgetState createState() => SupportWidgetState();
}

class SupportWidgetState extends State<SupportWidget> {
  TextStyle style = TextStyle(
      fontSize: 15.0, color: Colors.black /* Color(ColorInfo.APP_BLUE) */);
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  bool isLoginSelected = true;
  bool _loginSutoValidate = false;

  bool loginPasswordVisible = true,
      confirmPasswordVisible = true,
      signUpPasswordVisible;
  double _width = 0.0;
  List docuementData = new List();

  final firstNameController = TextEditingController();
  final titleController = TextEditingController();
  final phoneController = TextEditingController();

  final myEmailController = TextEditingController();

//  final descriptionShortController = TextEditingController();
  final descriptionLongController = TextEditingController();

  File _userImageFile, globalFile;

  //var subscription;
  bool isAnimViewShow = false;

  String countryCodeDialCode = "";
  String SUCCESS = "success", ERROR = "error";

  var enabledBorder = const OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black, width: 0.0),
      borderRadius: BorderRadius.all(Radius.circular(15.0)));

  String initialValueForText = "";
  String country;
  GeoBloc _bloc;

  String phone, name, email;
  BuildContext context;
  static double lat;
  static double long;

  //Mode _mode = Mode.fullscreen;
  double latitude = 0.0;
  double longitude = 0.0;
  bool isAddress = true;

  /// GET GPS location
  locationRequest() async {
    LocationData _locationData;
    Location location = await LocationUtils.getLocationObject();
    if (location != null) {
      _locationData = await location.getLocation();
      // print(
      // "Location data ${_locationData.latitude} , ${_locationData.longitude}");
      setState(() {
        lat = _locationData.latitude;
        long = _locationData.longitude;
      });

      _bloc = new GeoBloc(context);
      _bloc.fetchAddress(lat, long);
      await AppPreferences.setLatLang("$lat,$long");
      _bloc.geoFetcher.listen((value) async {
        if (value?.status != "false") {
          setState(() {
            country = value.prov;
          });
        } else {
          /*  Fluttertoast.showToast(
              msg: AppLocalizations.of(context).translate("key_unable_to_load"),
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 5,
              gravity: ToastGravity.TOP);*/
        }
      });
    }
  }

  String _chosenValue;
  @override
  void initState() {
    super.initState();
    setState(() {
      if (AppPreferences().loginStatus) {
        firstNameController.text = AppPreferences().fullName2;
        myEmailController.text = AppPreferences().email;
        setPhoneNumber();

        // phoneController.text = AppPreferences()
        //     .phoneNo
        //     ?.substring(AppPreferences().phoneNo.length - 10);

        // countryCodeDialCode = AppPreferences().phoneNo.replaceFirst(
        //     AppPreferences()
        //         .phoneNo
        //         ?.substring(AppPreferences().phoneNo.length - 10),
        //     "");
      }
      // country = AppPreferences().country;
    });
    if (!AppPreferences().loginStatus) {
      locationRequest();
    }
  }

  setPhoneNumber() async {
    UserInfo userInfo = await AppPreferences.getUserInfo();
    setState(() {
      phoneController.text = (userInfo.countryCodeValue != null)
          ? userInfo.mobileNo.substring(userInfo.countryCodeValue.length)
          : userInfo.mobileNo;
      countryCodeDialCode = userInfo.countryCodeValue;
      country = userInfo.countryCode;

      if (phoneController.text.length > 10) {
        phoneController.text = phoneController.text.substring(
            (phoneController.text.length - 10), phoneController.text.length);
        if (userInfo.countryCodeValue != null &&
            userInfo.countryCodeValue.isEmpty) {
          countryCodeDialCode =
              userInfo.mobileNo.substring(0, (userInfo.mobileNo.length - 10));
        }
      }
    });
  }

  String mobile = "";

  @override
  Widget build(BuildContext context) {
    /// Child View defined here///
    // print("width ${MediaQuery.of(context).size.width}");
    AppPreferences().setGlobalContext(context);
    this.context = context;

    final title = new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Padding(
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: TextFormField(
              controller: titleController,
              autocorrect: false,
              textInputAction: TextInputAction.next,
              validator: (String arg) {
                if (arg.trim().length > 0) {
                  return null;
                } else {
                  return AppLocalizations.of(context)
                      .translate("key_entersubject");
                }
              },
              onSaved: (String val) {},
              obscureText: false,
              keyboardType: TextInputType.emailAddress,
              style: style,
              decoration: WidgetStyles.decoration(
                  AppLocalizations.of(context).translate("key_subject")),
            ))
      ],
    );

    final firstName = new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Padding(
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: TextFormField(
              controller: firstNameController,
              autocorrect: false,
              textInputAction: TextInputAction.next,
              validator: (String arg) {
                if (arg.trim().length > 0) {
                  if (isName(arg.trim()))
                    return null;
                  else
                    return Constants.VALIDATION_VALID_NAME;
                } else {
                  return AppLocalizations.of(context)
                      .translate("key_namecantbeblank");
                }
              },
              onSaved: (String val) {},
              obscureText: false,
              keyboardType: TextInputType.emailAddress,
              style: style,
              decoration: WidgetStyles.decoration(
                  AppLocalizations.of(context).translate("key_name")),
            ))
      ],
    );

    final emailField = new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Padding(
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: TextFormField(
              controller: myEmailController,
              autocorrect: false,
              textInputAction: TextInputAction.next,
              validator: ValidationUtils.emailValidation,
              obscureText: false,
              keyboardType: TextInputType.emailAddress,
              style: style,
              decoration: WidgetStyles.decoration(
                  AppLocalizations.of(context).translate("key_email")),
            ))
      ],
    );

    final longDescription = new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: new ConstrainedBox(
                constraints: new BoxConstraints(
                  minHeight: 100.0,
                  maxHeight: 300.0,
                ),
                child: TextFormField(
                  minLines: 5,
                  controller: descriptionLongController,
                  autocorrect: false,
                  validator: (String arg) {
                    if (arg.trim().length > 0) {
                      return null;
                    } else {
                      return AppLocalizations.of(context)
                          .translate("key_enterdescriotion");
                    }
                  },
                  onSaved: (String val) {},
                  obscureText: false,
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(
                    letterSpacing: 0.7,
                    height: 1.5,
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                  // Color(ColorInfo.APP_BLUE)),
                  maxLines: null,
                  decoration: WidgetStyles.decoration(
                      AppLocalizations.of(context).translate("key_des")),
                )))
      ],
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
              AppLocalizations.of(context).translate("key_submit"),
              style: TextStyle(
                color: Color(ColorInfo.WHITE),
                fontSize: 15.0,
              ),
            ),
          )),
      onTap: () {
        onNextClick();
      },
    ));

    final dropDownDescription = Container(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          color: Colors.grey[100],
          // borderRadius: BorderRadius.circular(15.0),
        ),
        child: new Center(
            child: Padding(
          padding: EdgeInsets.fromLTRB(10, 0.0, 0.0, 0.0),
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            focusColor: Colors.white,
            value: _chosenValue,
            //elevation: 5,
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[100]))),
            style: style,
            iconEnabledColor: Colors.black,

            items: (AppPreferences().getSupportCategoryList)
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: style,
                ),
              );
            }).toList(),
            hint: Text(
              "Select Category",
              style: TextStyle(
                  /*color:  Color(ColorInfo.APP_BLUE) */ color: Colors.black,
                  fontSize: 14),
            ),
            onChanged: (String value) {
              if (value == null || value == "Select Category") {
                return "Please select a category";
              } else {
                setState(() {
                  _chosenValue = value;
                });
              }
            },
            validator: (String val) {
              if (val == null || val == "Select Category") {
                return "Please select a category";
              } else {
                return null;
              }
            },
          ),
        )));

    final submitContainer = Form(
        key: _loginFormKey,
        autovalidate: _loginSutoValidate,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Column(
              children: <Widget>[
                // SizedBox(height: 4.0),
                title,
                // SizedBox(height: 4.0),
                firstName,
                SizedBox(height: 15.0),
                //phoneNo,
                phoneNo(),
                // SizedBox(height: 4.0),
                emailField,
                SizedBox(height: 15.0),

                dropDownDescription,
                SizedBox(height: 4.0),
                longDescription,

                SizedBox(
                  height: 25.0,
                ),
                buttonView,
                SizedBox(
                  height: 35.0,
                ),
              ],
            ),
          ),
        ));

    // Main View Design
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/images/userInfo.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: Scaffold(
                appBar: AppPreferences().loginStatus
                    ? CustomAppBar(
                        title: widget.title, pageId: Constants.PAGE_ID_SUPPORT)
                    : WidgetStyles.buildAppBar(context, title: widget.title),
                backgroundColor: Colors.white,
                body: new Container(
                    color: Colors.white,
                    child:
                        new SingleChildScrollView(child: submitContainer)))));
  }

  //==================== METHODS DEFINED HERE ==================================

  Widget phoneNo() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              child: Container(
            width: MediaQuery.of(context).size.width / 7,
            child: Stack(
                // alignment: Alignment.center,
                children: <Widget>[
                  TextFormField(
                    initialValue: " ",
                    readOnly: true,
                    validator: (arg) {
                      if (country == "" || country == null) {
                        return " ";
                      }
                      return null;
                    },
                    decoration: WidgetStyles.decoration("") ??
                        InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                  ),
                  Center(
                    child: CountryCodePicker(
                      onChanged: (code) {
                        setState(() {
                          countryCodeDialCode = code.dialCode;
                          country = code.code;
                        });
                      },
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: false,
                      initialSelection:
                          (country == "" || country == null) ? "IN" : country,
                      showFlag: true,
                      showFlagDialog: false,
                      enabled: true,
                      onInit: (code) {},
                      builder: (code) {
                        if (country == null || country == "") {
                          return Padding(
                              padding: EdgeInsets.all(13),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                        child: Text(
                                      "Select",
                                      textAlign: TextAlign.center,
                                      style: TextStyles.countryCodeStyle,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                    Icon(Icons.keyboard_arrow_down),
                                    //SizedBox(width: 10)
                                  ]));
                        } else {
                          countryCodeDialCode = code.dialCode;
                          country = code.code;
                          return Padding(
                              padding: EdgeInsets.all(15),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      code.dialCode.toUpperCase(),
                                      style: style,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ]));
                        }
                      },
                    ),
                  ),
                ]),
          )),
          SizedBox(
            width: 3,
          ),
          Container(
              width: MediaQuery.of(context).size.width / 1.6,
              child: TextFormField(
                readOnly: false,
                controller: phoneController,
                maxLength: 10,
                textInputAction: TextInputAction.next,
                style: style,
                decoration: WidgetStyles.decoration("Enter Phone No") ??
                    InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
                validator: ValidationUtils.mobileValidation,
              )),
        ]);
  }

  void onNextClick() {
    _validateInputsForLogin();
  }

  bool isEmailValid(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }

  bool isName(String em) {
    return RegExp(r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$").hasMatch(em);
  }

  void _validateInputsForLogin() async {
    if (_loginFormKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _loginFormKey.currentState.save();

      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile) {
        // I am connected to a mobile network.

        await makeSubmitApiCall();
      } else if (connectivityResult == ConnectivityResult.wifi) {
        // I am connected to a wifi network.

        await makeSubmitApiCall();
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

  makeSubmitApiCall() async {
    CustomProgressLoader.showLoader(context);
    String url = WebserviceConstants.baseURL + ApiConstants.SUPPORT;

    List email = new List();
    email.add(myEmailController.text);
    email.add("support@sivisoft.com");
    email.add("diabetestrinidad.app@gmail.com");
    List phone = new List();
    phone.add((countryCodeDialCode.replaceAll("+", "") + phoneController.text));

    String dataForContenet = "Subject: " +
        titleController.text +
        "\n" +
        "From: " +
        firstNameController.text +
        "\n" +
        "Email: " +
        myEmailController.text +
        "\n" +
        "Phone: " +
        (countryCodeDialCode + phoneController.text) +
        "\n" +
        "Category: " +
        _chosenValue +
        "\n" +
        "Description: " +
        descriptionLongController.text;

    Map map = {
      "messageContent": dataForContenet,
      "messageSubject": /* _chosenValue + " " + */ titleController.text,
      "category": _chosenValue,
      "toMailId": email
    };

    String body = json.encode(map);

    // print(url);

    print(body);

    int response = await APICalling.apiPostWithHeaderRequest(url, map);

    // print("---------Code" + response.toString());
    CustomProgressLoader.cancelLoader(context);
    if (response == 204 || response == 200) {
      AppPreferences.getUsername().toString();
      Utils.toasterMessage(
          AppLocalizations.of(context).translate("key_sendinformation"));
      await AppPreferences().init();
      if (AppPreferences().loginStatus) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => NavigationHomeScreen()),
            ModalRoute.withName(Routes.navigatorHomeScreen));
      } else {
        Navigator.pop(context);
      }
    } else {
      if (response == 500) {
        Utils.toasterMessage(
            AppLocalizations.of(context).translate("key_aleradysaved"));
      } else {}
    }
  }

  getphone(String phone) {
    setState(() {
      this.phone = phone;
    });
  }

  getemail(String name) {
    setState(() {
      this.name = name;
    });
  }

  getUserName(String email) {
    setState(() {
      this.email = email;
    });
  }
}
