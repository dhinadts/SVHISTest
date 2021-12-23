import '../bloc/user_info_bloc.dart';
import '../country_picker_util/country_code_picker.dart';
import '../login/colors/color_info.dart';
import '../login/login_screen.dart';
import '../login/utils.dart';
import '../login/utils/custom_progress_dialog.dart';
import '../model/user_info.dart';
import '../ui/tabs/app_localizations.dart';
import '../ui_utils/app_colors.dart';
import '../ui_utils/network_check.dart';
import '../ui_utils/text_styles.dart';
import '../ui_utils/widget_styles.dart';
import '../utils/alert_utils.dart';
import '../utils/app_preferences.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../utils/validation_utils.dart';
import '../widgets/age_widget.dart';
import '../widgets/gender_widget.dart';
import '../widgets/location_tracker_widget.dart';
import '../widgets/marital_status.dart';
import '../widgets/password_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

final DateFormat gnatDobFormat = DateFormat("dd/MM/yyyy");
final DateFormat originalDobFormat = DateFormat("MM/dd/yyyy");

class SignUpScreen extends StatefulWidget {
  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _autoValidate = false;
  String phoneCountryCode;

  //////////////
  List docuementData = new List();
  final myPasswordController = TextEditingController();
  final myEmailController = TextEditingController();
  final addressController = TextEditingController();
  final addressController2 = TextEditingController();
  final phoneController = TextEditingController();

  final cityController = TextEditingController();
  final firstNameController = TextEditingController();
  final userNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final stateControlller = TextEditingController();
  final zipCodeController = TextEditingController();
  final countryController = TextEditingController();

  final secondaryPhoneController = TextEditingController();
  final secondaryAddressController = TextEditingController();
  final secondaryAddressController2 = TextEditingController();
  final secondaryStateController = TextEditingController();
  final secondaryCityController = TextEditingController();
  final secondaryCountryController = TextEditingController();
  final secondaryZipCodeController = TextEditingController();
  final passwordController = TextEditingController();
  String secondaryPhoneCountryCode;
  String secondaryCountryCodeDialCode = Constants.INDIA_CODE;
  String secondaryCountry = AppPreferences().country;
  final genderController = TextEditingController();
  final maritalStatusController = TextEditingController();
  final ageController = TextEditingController();
  final dobController = TextEditingController();

  bool isAddressesSame = false;

  UserInfoBloc _bloc;
  UserInfoBloc _secondaryCountrybloc;
  TextStyle style = TextStyle(
      fontFamily: Constants.LatoRegular,
      fontSize: 15.0,
      color: Color(ColorInfo.BLACK));
  var enabledBorder = const OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black, width: 0.0),
      borderRadius: BorderRadius.all(Radius.circular(15.0)));
  String countryCodeDialCode = Constants.INDIA_CODE;

  bool isTermsAndConditionChecked = false;

  bool isHome = false;
  String locationInfo = "";
  String country = AppPreferences().country;
  TextStyle countryCodeStyle = TextStyle(
    fontFamily: Constants.LatoRegular,
    color: Colors.grey,
    fontSize: 15.0,
  );

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    _bloc = new UserInfoBloc(context);
    _secondaryCountrybloc = new UserInfoBloc(context);
    _bloc.countryCodeFetcher.listen((c) {
      setState(() {
        country = c;
      });
    });
    super.initState();
  }

  Future<bool> _willPopCallback() async {
    await AppPreferences.setCountry("");
    return true; // return true if the route to be popped
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _willPopCallback,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: new AppBar(
            backgroundColor: AppColors.primaryColor,
            centerTitle: true,
            title:
                new Text(AppLocalizations.of(context).translate("key_signup")),
          ),
          body: SafeArea(
              child: SingleChildScrollView(
            child: new Container(
              margin: new EdgeInsets.all(15.0),
              child: new Form(
                key: signUpFormKey,
                autovalidate: _autoValidate,
                child: fromUI(),
              ),
            ),
          )),
        ));
  }

  Widget fromUI() {
    final phoneNo = Row(
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
                          country = code.name;
                          /*if (secondaryCountry == null ||
                              secondaryCountry.isEmpty) {
                            secondaryCountry = code.name;
                          }*/
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
                                      AppLocalizations.of(context)
                                          .translate("key_select"),
                                      textAlign: TextAlign.center,
                                      style: countryCodeStyle,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                    Icon(Icons.keyboard_arrow_down),
                                    //SizedBox(width: 10)
                                  ]));
                        } else {
                          countryCodeDialCode = code.dialCode;
                          phoneCountryCode = code.code;
                          country = code.name;
                          /*if (secondaryCountry == null ||
                              secondaryCountry.isEmpty) {
                            secondaryCountry = code.name;
                          }*/
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
                style: false
                    ? TextStyle(
                        color: Colors.grey, fontFamily: Constants.LatoRegular)
                    : TextStyle(fontFamily: Constants.LatoRegular),
                decoration: WidgetStyles.decoration(
                        AppLocalizations.of(context).translate("key_phone")) ??
                    InputDecoration(
                        errorMaxLines: 2,
                        border: OutlineInputBorder(),
                        labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
                validator: ValidationUtils.mobileValidation,
              )),
        ]);

    final alertPhoneNo = Row(
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
                    decoration: WidgetStyles.decoration("") ??
                        InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                  ),
                  Center(
                    child: CountryCodePicker(
                      onChanged: (code) {
                        setState(() {
                          secondaryCountryCodeDialCode = code.dialCode;
                          secondaryCountry = code.name;
                        });
                      },
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: false,
                      initialSelection:
                          (secondaryCountry == "" || secondaryCountry == null)
                              ? "IN"
                              : secondaryCountry,
                      showFlag: true,
                      showFlagDialog: false,
                      enabled: true,
                      onInit: (code) {},
                      builder: (code) {
                        if (secondaryCountry == null ||
                            secondaryCountry == "") {
                          return Padding(
                              padding: EdgeInsets.all(13),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                        child: Text(
                                      AppLocalizations.of(context)
                                          .translate("key_select"),
                                      textAlign: TextAlign.center,
                                      style: countryCodeStyle,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                    Icon(Icons.keyboard_arrow_down),
                                    //SizedBox(width: 10)
                                  ]));
                        } else {
                          secondaryCountryCodeDialCode = code.dialCode;
                          secondaryPhoneCountryCode = code.code;
                          secondaryCountry = code.name;
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

                controller: secondaryPhoneController,
                maxLength: 10,
                textInputAction: TextInputAction.next,
                style: false
                    ? TextStyle(color: Colors.grey)
                    : TextStyle(fontFamily: Constants.LatoRegular),
                decoration: WidgetStyles.decoration("Alternate Phone") ??
                    InputDecoration(
                        errorMaxLines: 2,
                        border: OutlineInputBorder(),
                        labelText: 'Alternate Phone'),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
                //validator: ValidationUtils.mobileValidation,
              )),
        ]);

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
              validator: ValidationUtils.firstNameValidation,
              onSaved: (String val) {},
              obscureText: false,
              keyboardType: TextInputType.text,
              style: style,
              decoration: WidgetStyles.decoration(
                  AppLocalizations.of(context).translate("key_first_name")),
            ))
      ],
    );

    final city = new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Padding(
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: TextFormField(
              controller: cityController,
              autocorrect: false,
              textInputAction: TextInputAction.next,
              validator: ValidationUtils.cityValidation,
              onSaved: (String val) {
                //_email = val;
              },
              obscureText: false,
              keyboardType: TextInputType.text,
              style: style,
              decoration: WidgetStyles.decoration(
                  AppLocalizations.of(context).translate("key_first_name")),
            ))
      ],
    );

    final userName = new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Padding(
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: TextFormField(
              controller: userNameController,
              autocorrect: false,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                BlacklistingTextInputFormatter(new RegExp(r"\s\b|\b\s"))
              ],
              validator: ValidationUtils.usernameValidation,
              onSaved: (String val) {},
              obscureText: false,
              keyboardType: TextInputType.emailAddress,
              style: style,
              decoration: WidgetStyles.decoration(
                  AppLocalizations.of(context).translate("key_username")),
            ))
      ],
    );

    final lastName = new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Padding(
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: TextFormField(
              controller: lastNameController,
              autocorrect: false,
              textInputAction: TextInputAction.next,
              validator: ValidationUtils.lastNameValidation,
              onSaved: (String val) {},
              obscureText: false,
              keyboardType: TextInputType.emailAddress,
              style: style,
              decoration: WidgetStyles.decoration(
                  AppLocalizations.of(context).translate("key_last_name")),
            ))
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
            child: Text(
              AppLocalizations.of(context).translate("key_signup"),
              style: TextStyle(
                  color: Color(ColorInfo.WHITE),
                  fontSize: 18.0,
                  fontFamily: Constants.LatoRegular),
            ),
          )),
      onTap: () {
        onSubmitForm();
      },
    ));
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

    return Column(
      children: <Widget>[
        SizedBox(height: 4.0),
        firstName,
        SizedBox(height: 4.0),
        lastName,
        SizedBox(height: 4.0),
        userName,
        SizedBox(height: 4.0),
        PasswordWidget(
          passwordController: passwordController,
        ),
        SizedBox(height: 4.0),
        emailField,
        SizedBox(height: 10.0),
        SizedBox(height: 4.0),
        /*city,
        SizedBox(height: 4.0),*/
        phoneNo,
        SizedBox(
          height: 7,
        ),
        alertPhoneNo,
        SizedBox(
          height: 7,
        ),
        GenderWidget(
          genderController: genderController,
        ),
        MaritalStatusWidget(
          maritalStatusController: maritalStatusController,
        ),
        AgeWidget(
          ageController: ageController,
          dateController: dobController,
          inputAgeDecoration: WidgetStyles.decoration(
              AppLocalizations.of(context).translate("key_age")),
          inputDateDecoration: WidgetStyles.decoration(
              AppLocalizations.of(context).translate("key_date")),
        ),
        Card(
            child: Container(
                margin: EdgeInsets.all(10),
                child: Column(children: [
                  Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          child: Text(
                            "Present Address",
                            style: TextStyles.headerTextStyle,
                          ))
                    ],
                  ),
                  LocationTrackerWidget(
                    formKey: signUpFormKey,
                    addressController: addressController,
                    stateController: stateControlller,
                    cityController: cityController,
                    countryController: countryController,
                    zipCodeController: zipCodeController,
                    addressController2: addressController2,
                    bloc: _bloc,
                    onChangeHome: (checked) {
                      isHome = checked;
                    },
                    onLatLongInfo: (locInfo) {
                      setState(() {
                        locationInfo = locInfo;
                      });
                    },
                  )
                ]))),
        Card(
            child: Container(
                margin: EdgeInsets.all(10),
                child: Column(children: [
                  Row(children: [
                    Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        child: Text(
                          "Permanent Address",
                          style: TextStyles.headerTextStyle,
                        ))
                  ]),
                  CheckboxListTile(
                    title: Text(AppLocalizations.of(context)
                        .translate("key_use_same_address")), //    <-- label
                    value: isAddressesSame,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (newValue) {
                      setState(() {
                        isAddressesSame = newValue;
                        if (isAddressesSame) {
                          setState(() {
                            secondaryCountryController.text = country;
                            secondaryAddressController.text =
                                addressController.text;
                            secondaryAddressController2.text =
                                addressController2.text;
                            secondaryCityController.text = cityController.text;
                            secondaryStateController.text =
                                stateControlller.text;
                            secondaryZipCodeController.text =
                                zipCodeController.text;
                          });
                          _secondaryCountrybloc.countryCodeFetcher.sink
                              .add("$countryCodeDialCode");
                        } else {
                          //Clear all the value
                          setState(() {
                            secondaryAddressController.clear();
                            secondaryCityController.clear();
                            secondaryStateController.clear();
                            secondaryCountryController.clear();
                            secondaryZipCodeController.clear();
                          });
                        }
                      });
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  LocationTrackerWidget(
                    bloc: _secondaryCountrybloc,
                    mandatory: false,
                    formKey: signUpFormKey,
                    isEnabledGPS: false,
                    addressController: secondaryAddressController,
                    stateController: secondaryStateController,
                    cityController: secondaryCityController,
                    countryController: secondaryCountryController,
                    zipCodeController: secondaryZipCodeController,
                    addressController2: secondaryAddressController2,
                    isFieldEnabled: !isAddressesSame,
                  )
                ]))),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: 10),
              Checkbox(
                value: isTermsAndConditionChecked,
                activeColor: Color(ColorInfo.APP_BLUE),
                onChanged: (isClicked) async {
                  String termsandconditions =
                      await AppPreferences.getSignupTermsandConditions();
                  AlertUtils.showTermsAndConditionDialog(
                      context,
                      termsandconditions == null
                          ? AppLocalizations.of(context).translate("key_terms")
                          : termsandconditions, (value) {
                    setState(() {
                      isTermsAndConditionChecked = value;
                    });
                    Navigator.pop(context);
                  }, MediaQuery.of(context).size.width / 1.35);
                },
              ),
              Text(
                AppLocalizations.of(context).translate("key_accpect"),
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.0,
                  decoration: TextDecoration.underline,
                  color: Color(ColorInfo.NAME_BLUE),
                ),
              ),
              // FlatButton(
              //   onPressed: () {
              //     AlertUtils.showTermsAndConditionDialog(context,
              //         AppLocalizations.of(context).translate("key_terms"),
              //         (value) {
              //       setState(() {
              //         isTermsAndConditionChecked = value;
              //       });
              //       Navigator.pop(context);
              //     }, MediaQuery.of(context).size.width / 1.35);
              //   },
              //   child: new Text(
              //     AppLocalizations.of(context).translate("key_accpect"),
              //     maxLines: 2,
              //     textAlign: TextAlign.center,
              //     overflow: TextOverflow.ellipsis,
              //     style: TextStyle(
              //       fontSize: 12.0,
              //       decoration: TextDecoration.underline,
              //       color: Color(ColorInfo.NAME_BLUE),
              //     ),
              //   ),
              // ),
            ]),
        SizedBox(height: 20),
        buttonView
      ],
    );
  }

  createUser() async {
    UserInfo info = new UserInfo();
    info.active = true;
    info.firstName = firstNameController.text;
    info.lastName = lastNameController.text;
    info.departmentName = AppPreferences().deptmentName;
    info.userName = userNameController.text;
    info.city = "Others";
    info.cityName = cityController.text;
    info.country = AppPreferences().country;
    info.latLongInfo = locationInfo;
    // info.countryCodeValue = phoneCountryCode;
    // info.countryCode = countryCodeDialCode.replaceAll("+", "");
    info.countryCodeValue = countryCodeDialCode.replaceAll("+", "");
    info.countryCode = phoneCountryCode;
    info.mobileNo =
        /* AppPreferences().country == "IN"
        ? "91" + phoneController.text
        : */
        countryCodeDialCode.replaceAll("+", "") + phoneController.text;

    // Secondary fields
    if (secondaryPhoneController.text != null &&
        secondaryPhoneController.text.isNotEmpty) {
      info.secondMobileNo = secondaryCountryCodeDialCode.replaceAll("+", "") +
          secondaryPhoneController.text;
    }
    info.secondaryStateName = secondaryStateController.text;
    info.secondaryZipCode = secondaryZipCodeController.text;
    info.secondaryCountryName = secondaryCountryController.text;
    info.secondaryAddressLine1 = secondaryAddressController.text;
    info.secondaryCityName = secondaryCityController.text;
    info.gender = genderController.text;
    info.age = int.parse(ageController.text.isEmpty ? "0" : ageController.text);
    info.maritalStatus = maritalStatusController.text;
    info.secondaryCountryCodeValue =
        secondaryCountryCodeDialCode.replaceAll("+", "");
    info.secondaryCountryCode = secondaryPhoneCountryCode;
    info.pwdChangeFlag = true;
    info.birthDate =
        originalDobFormat.format(gnatDobFormat.parse(dobController.text));
    info.password = passwordController.text;
    info.secondaryAddressLine2 = secondaryAddressController2.text;
    info.sameAsPresentAddr = isAddressesSame;
    info.emailId = myEmailController.text;
    info.roleName = "User";
    info.source = "MOBILE";
    info.zipCode = zipCodeController.text;
    info.hasAdditionalInfo = false;
    info.countryName = countryController.text;
    info.stateName = stateControlller.text;
    info.addressLine1 = addressController.text;
    info.addressLine2 = addressController2.text;
//    info.
    // print("User Info ${info.toJson()}");
    CustomProgressLoader.showLoader(context);
    _bloc.createUser(info);
    _bloc.createFetcher.listen((value) {
      CustomProgressLoader.cancelLoader(context);
      if (value.status == 201 || value.status == 200) {
        Utils.toasterMessage(AppLocalizations.of(context)
            .translate("key_usercreatedsuccessfully"));
        AppPreferences.setSignUpStatus(true);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
            ModalRoute.withName(Routes.login));
      } else {
        AlertUtils.showAlertDialog(
            context,
            value.message ??
                AppLocalizations.of(context)
                    .translate("key_somethingwentwrong"));
      }
    });
  }

  onSubmitForm() async {
    if (signUpFormKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      signUpFormKey.currentState.save();

      var connectivityResult = await NetworkCheck().check();

      if (connectivityResult) {
        if (isTermsAndConditionChecked) {
          if (AppPreferences().apiURL != null &&
              AppPreferences().apiURL.isNotEmpty) {
            createUser();
          } else {
            Fluttertoast.showToast(
                msg: AppLocalizations.of(context)
                    .translate("key_service_unavailable"),
                toastLength: Toast.LENGTH_LONG,
                timeInSecForIosWeb: 5,
                gravity: ToastGravity.TOP);
          }
        } else {
          Utils.toasterMessage(Constants.TERMS_AND_CONDITION_WARNING);
        }
      } else {
        Utils.toasterMessage(Constants.NO_INTERNET_CONNECTION);
      }
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
