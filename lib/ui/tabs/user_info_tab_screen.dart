import 'dart:core';
import 'dart:io';

import '../../bloc/auth_bloc.dart';
import '../../bloc/user_info_bloc.dart';
import '../../bloc/user_info_validation_bloc.dart';
import '../../login/utils/custom_progress_dialog.dart';
import '../../model/user_info.dart';
import '../../ui/custom_drawer/navigation_home_screen.dart';
import '../../ui/membership/api/membership_api_client.dart';
import '../../ui/membership/model/membership_info.dart';
import '../../ui/membership/repo/membership_repo.dart';
import '../../ui/tabs/app_localizations.dart';
import '../../ui_utils/app_colors.dart';
import '../../ui_utils/text_styles.dart';
import '../../ui_utils/widget_styles.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_preferences.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../utils/validation_utils.dart';
import '../../widgets/marital_status.dart';
import '../../widgets/phone_no_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../membership/widgets/dismissible_message_widget.dart';
import '../membership/widgets/docs_upload_single_widget.dart';
/*class PersonalInfoScreen extends StatefulWidget {
PersonalInfoScreenState createState() => new PersonalInfoScreenState();
}*/

final DateFormat gnatDobFormat = DateFormat("dd/MM/yyyy");
final DateFormat originalDobFormat = DateFormat("MM/dd/yyyy");

class UserInformationTabScreen extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final UserInfoValidationBloc bloc;
  void Function(dynamic) delegate;

  UserInformationTabScreen(this.bloc, this.formKey, {this.delegate});

  @override
  _UserInformationTabScreenState createState() =>
      new _UserInformationTabScreenState();
}

//State is information of the application that can change over time or when some actions are taken.
class _UserInformationTabScreenState extends State<UserInformationTabScreen>
    with AutomaticKeepAliveClientMixin<UserInformationTabScreen> {
  EdgeInsets contentPadding = EdgeInsets.symmetric(vertical: 2, horizontal: 16);

  //AddressBloc _addressBloc;
  bool _autoValidate = false;
  bool maritalStatusLoading = false;
  bool readOnly = false;
  String _firstName, _lastName, _age;
  String _email;
  String _mobile;
  String _username;
  String _bloodGroup;
  String _pregnant = "No";
  String _street;
  String _state;
  String _stateName;
  String _area;
  String _city;
  String _countryName;
  String _zip;
  double screenWidth;
  String _genderValue = "Male";
  String choice;
  String roleName;
  String countryCodeDialCode;
  String countryCode;
  String _documentName;
  String _educationalQualification;
  String role;
  String addressProofPicURL;

  var usernameController = TextEditingController();
  var dateController = TextEditingController();
  var ageController = TextEditingController();
  var zipCodeController = TextEditingController();
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var countryController = TextEditingController();
  var streetController = TextEditingController();
  var areaController = TextEditingController();
  var firstController = TextEditingController();
  var phoneController = TextEditingController();
  var lastController = TextEditingController();
  var emailController = TextEditingController();
  var countryCodeController = TextEditingController();
  var courseMajorController = TextEditingController();
  var additionalInfoController = TextEditingController();
  var nationalIdController = TextEditingController();

  var courseCompletionStatusController = TextEditingController();

  bool isAddressesSame = false;

  /////////////////
  File addressProofPic;
  bool fileuploaded = false;
  final secondaryPhoneController = TextEditingController();
  final secondaryAddressLine1Controller = TextEditingController();
  final secondaryStateController = TextEditingController();
  final secondaryCityController = TextEditingController();
  final secondaryCountryController = TextEditingController();
  final secondaryZipCodeController = TextEditingController();
  var secondaryAddressLine2 = TextEditingController();
  String secondaryPhoneCountryCode, maritalStatus;
  String secondaryCountryCodeDialCode = Constants.INDIA_CODE;
  String secondaryCountry = AppPreferences().country;
  final genderController = TextEditingController();
  final maritalStatusController = TextEditingController();

  // final dobController = TextEditingController();
  List<DropdownMenuItem> _eduQualDropdownMenuItems =
      AppPreferences().clientId == Constants.GNAT_KEY
          ? [
              DropdownMenuItem(child: Text("DGNM"), value: "DGNM"),
              DropdownMenuItem(
                child: Text("PBBSc(N)"),
                value: "PBBSc(N)",
              ),
              DropdownMenuItem(
                child: Text("BSc(N)"),
                value: "BSc(N)",
              ),
              DropdownMenuItem(child: Text("MSc(N)"), value: "MSc(N)"),
              DropdownMenuItem(
                child: Text("PhD(N)"),
                value: "PhD(N)",
              ),
              DropdownMenuItem(
                child: Text("Medical"),
                value: "Medical",
              ),
              DropdownMenuItem(
                child: Text("Non-medical"),
                value: "Non-medical",
              ),
            ]
          : [
              DropdownMenuItem(
                child: Text("Bcom"),
                value: "Bcom",
              ),
              DropdownMenuItem(
                child: Text("MBA"),
                value: "MBA",
              ),
              DropdownMenuItem(
                child: Text("BA"),
                value: "BA",
              ),
              DropdownMenuItem(
                child: Text("PhD"),
                value: "PhD",
              ),
              DropdownMenuItem(
                child: Text("Others"),
                value: "Others",
              ),
            ];

  List<String> _eduCompletionDropdownItems = [
    'Pursuing',
    'Completed',
  ];

  List<DropdownMenuItem> _roledropdownMenuItems =
      AppPreferences().clientId == Constants.GNAT_KEY
          ? [
              DropdownMenuItem(
                child: Text("Registered Nurse"),
                value: "Registered Nurse",
              ),
              DropdownMenuItem(
                child: Text("Student Nurse"),
                value: "Student Nurse",
              ),
              DropdownMenuItem(
                child: Text("Volunteers"),
                value: "Volunteers",
              ),
            ]
          : [
              DropdownMenuItem(
                child: Text("User"),
                value: "User",
              )
            ];

  List<DropdownMenuItem> _documentNameDropdownMenuItems = [
    DropdownMenuItem(
      child: Text("Ration Card"),
      value: "Ration Card",
    ),
    DropdownMenuItem(
      child: Text("Passport"),
      value: "Passport",
    ),
    DropdownMenuItem(
      child: Text("Aadhar Card"),
      value: "Aadhar Card",
    ),
    DropdownMenuItem(
      child: Text("Driving Licencse"),
      value: "Driving Licencse",
    ),
  ];
  FocusNode node = FocusNode();

  FocusNode addressFocusNode;

  _onLayoutDone(_) {
    FocusScope.of(context).requestFocus(node);
  }

  genderChangedDelegate(dynamic gender) {
    widget.delegate(_genderValue);
  }

  MembershipRepository _membershipRepository;
  MembershipInfo _membershipInfo;
  bool isMemberShipStatusUnderReview = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
    addressFocusNode = FocusNode();
    if (AppPreferences().role != Constants.supervisorRole) {
      getMemberShipInfo();
    }
    AppPreferences.getRole().then((role) {
      if (role != Constants.supervisorRole) {
        setState(() {
          readOnly = true;
        });

        AppPreferences.getEmail().then((value) {
          emailController.text = value;
        });
        AppPreferences.getUsername().then((value) {
          usernameController.text = value;
        });
        AppPreferences.getPhone().then((value) {
          if (value != null && value != "") {
            phoneController.text = value.substring(value.length - 10);
          }
        });
//        _addressBloc = AddressBloc(context);

        AppPreferences.getDOB().then((value) {
          if (value != null && value != "") {
            // print("DOB $value");
            dateController.text =
                gnatDobFormat.format(originalDobFormat.parse(value));
            var year = value.split("/");
            if (year.length > 2) {
              int bYear = int.parse(year[2]);
              int bMonth = int.parse(year[0]);
              int bDay = int.parse(year[1]);

              DateTime currentDate = DateTime.now();
              int age = currentDate.year - bYear;
              int month1 = currentDate.month;
              int month2 = bMonth;
              if (month2 > month1) {
                age--;
              } else if (month1 == month2) {
                int day1 = currentDate.day;
                int day2 = bDay;
                if (day2 > day1) {
                  age--;
                }
              }
              ageController.text = age.toString();
            }
          }
        });

        AppPreferences.getAddress().then((value) {
          if (value != null && value != "") {
            var arr = value.split("~/*^");
            if (arr.length > 5) {
              zipCodeController.text = arr[5].trim();
              streetController.text = arr[0].trim();
              areaController.text = arr[1].trim();
              cityController.text = arr[2].trim();
              stateController.text = arr[3].trim();
              countryController.text = arr[4].trim();
            }
          }
        });
      }
    });

    AppPreferences.getUserInfo()?.then((value) {
      // print("user info = " + value.toJson().toString());
      setState(() {
        countryCode = value?.countryCode ?? AppPreferences().country;
        // print("user info = CC $countryCode");
        firstController.text = value.firstName;
        lastController.text = value.lastName;
        secondaryCountry = value.secondaryCountry;
        secondaryCountryCodeDialCode = value.secondaryCountryCodeValue;
        secondaryPhoneCountryCode =
            value?.secondaryCountryCode ?? AppPreferences().country;
        if (value.secondMobileNo != null && value.secondMobileNo.length >= 10) {
          secondaryPhoneController.text =
              value.secondMobileNo.substring(value.secondMobileNo.length - 10);
        } else {
          secondaryPhoneController.text = value.secondMobileNo;
        }
        _genderValue = value.gender;
        genderChangedDelegate(_genderValue);
        //Address
        streetController.text = value.addressLine1;
        areaController.text = value.addressLine2;
        cityController.text = value.cityName;
        countryController.text = value.countryName;
        stateController.text = value.stateName;
        zipCodeController.text = value.zipCode;
        secondaryAddressLine1Controller.text = value.secondaryAddressLine1;
        secondaryAddressLine2.text = value.secondaryAddressLine2;
        secondaryCityController.text = value.secondaryCityName;
        secondaryCountryController.text = value.secondaryCountryName;
        secondaryStateController.text = value.secondaryStateName;
        secondaryZipCodeController.text = value.secondaryZipCode;
        courseMajorController.text = value.additionalQualificationMajor;
        courseCompletionStatusController.text =
            value.additionalQualificationStatus;
        additionalInfoController.text = value.additionalInfo;
        _documentName = value.addressProof;
        addressProofPicURL = value.addressProofPic;
        nationalIdController.text = value.addressProofId;
        _educationalQualification = value.qualification;
        role = value.tempUserSubType;
        isAddressesSame =
            value.sameAsPresentAddr != null ? value.sameAsPresentAddr : false;
        maritalStatus = value.maritalStatus;
        maritalStatusLoading = true;
      });
    });

    widget.bloc.actionTrigger.listen((value) {
      _validateInputs();
    });

    widget.bloc.validationTrigger.listen((value) {
      setState(() {
        _autoValidate = value;
      });
    });

    AppPreferences.getUserInfo()?.then((value) {
      UserInfo user = value;
      setState(() {
        _bloodGroup = (user?.bloodGroup == null || user?.bloodGroup.isEmpty)
            ? null
            : user?.bloodGroup;
        /*_genderValue =
            (user.gender.isEmpty || user?.gender == null) ? null : user?.gender;*/
        _pregnant = ValidationUtils.isNullEmptyOrFalse(user?.pregnant)
            ? "No"
            : user?.pregnant;
        _genderValue = ValidationUtils.isNullEmptyOrFalse(user?.gender)
            ? "No"
            : user?.gender;
        genderChangedDelegate(_genderValue);
      });
//      print("user info = " + value.toJson().toString());
    });

    super.initState();
  }

  getMemberShipInfo() async {
    _membershipRepository = MembershipRepository(
        membershipApiClient: MembershipApiClient(httpClient: http.Client()));
    _membershipInfo = await _membershipRepository
        .getMembershipInfoByUserName(AppPreferences().username);
    setState(() {
      isMemberShipStatusUnderReview = ((_membershipInfo != null)
          ? (_membershipInfo.membershipStatus == Constants.UNDER_REVIEW)
          : false);
    });
  }

  @override
  void dispose() {
    //_addressBloc.dispose();
    cityController.clearComposing();
    cityController.clear();
    stateController.clearComposing();
    stateController.clear();
    countryController.clearComposing();
    countryController.clear();
    usernameController.clear();
    addressFocusNode.dispose();
    super.dispose();
  }

  _getReport(String value) {
    setState(() {
      countryCodeDialCode = value;
    });
  }

  DateTime _dob = DateTime.now();

  void _radioPregChanges(String value) {
    setState(() {
      if (_pregnant == "Yes") {
        _pregnant = "No";
      } else {
        _pregnant = "Yes";
      }
    });
  }

  void _radioValueChanges(String value) {
    setState(() {
      _genderValue = value;
      genderChangedDelegate(_genderValue);
      switch (value) {
        case 'Male':
          _pregnant = "No";
          choice = value;
//widget.onChange(true);
          break;
        case 'Female':
          choice = value;
// widget.onChange(false);
          break;
        default:
          choice = null;
      }
      debugPrint(choice); //Debug the choice in console
    });
  }

  @override
  Widget build(BuildContext context) {
    AppPreferences().setContext(context);
    AppPreferences().setGlobalContext(context);
    // print("==================> $secondaryCountryCodeDialCode");
    screenWidth = MediaQuery.of(context).size.width;
    return new Scaffold(
      body: new Container(
        margin: new EdgeInsets.all(15.0),
        child: new Form(
          key: widget.formKey,
          autovalidate: _autoValidate,
          child: SafeArea(
              child: SingleChildScrollView(
                  reverse: false,
                  physics: PageScrollPhysics(),
                  child: IgnorePointer(
                      ignoring: isMemberShipStatusUnderReview,
                      child: FormUI()))),
        ),
      ),
    );
  }

// Here is our Form UI
  Widget FormUI() {
    return new Column(
      children: <Widget>[
        SizedBox(height: 7),
        TextFormField(
          readOnly: isMemberShipStatusUnderReview,
          controller: firstController,
          style: isMemberShipStatusUnderReview
              ? TextStyle(
                  color: Colors.grey,
                )
              : TextStyles.mlDynamicTextStyle,
          decoration: InputDecoration(
              contentPadding: contentPadding,
              border: OutlineInputBorder(),
              labelText:
                  AppLocalizations.of(context).translate("key_first_name"),
              errorMaxLines: 2),
          keyboardType: TextInputType.text,
          validator: ValidationUtils.firstNameValidation,
          onSaved: (String val) {
            setState(() {
              _firstName = val;
            });
          },
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          readOnly: isMemberShipStatusUnderReview,
          controller: lastController,
          style: isMemberShipStatusUnderReview
              ? TextStyle(
                  color: Colors.grey,
                )
              : TextStyles.mlDynamicTextStyle,
          decoration: InputDecoration(
              contentPadding: contentPadding,
              border: OutlineInputBorder(),
              labelText:
                  AppLocalizations.of(context).translate("key_last_name"),
              errorMaxLines: 2),
          keyboardType: TextInputType.text,
          validator: ValidationUtils.lastNameValidation,
          onSaved: (String val) {
            setState(() {
              _lastName = val;
            });
          },
        ),
        SizedBox(
          height: 10,
        ),
        Container(
            child: TextFormField(
          readOnly: readOnly,
          controller: usernameController,
          style: TextStyle(
              color: Colors.grey,
              fontSize: AppPreferences().isLanguageTamil() ? 13 : 16),
          decoration: InputDecoration(
              contentPadding: contentPadding,
              border: OutlineInputBorder(),
              labelText: AppLocalizations.of(context).translate("key_username"),
              errorMaxLines: 2),
          keyboardType: TextInputType.text,
          inputFormatters: [
            BlacklistingTextInputFormatter(new RegExp(r"\s\b|\b\s"))
          ],
          validator: ValidationUtils.usernameValidation,
          onSaved: (String val) {
            setState(() {
              _username = val;
            });
          },
        )),
        SizedBox(
          height: 10,
        ),
        Container(
            width: screenWidth / 1,
            child: new TextFormField(
              readOnly: readOnly,
              controller: emailController,
              style: TextStyle(color: AppColors.warmGrey, fontSize: 13),
              decoration: InputDecoration(
                  contentPadding: contentPadding,
                  border: OutlineInputBorder(),
                  labelText:
                      AppLocalizations.of(context).translate("key_email"),
                  errorMaxLines: 2),
              validator: ValidationUtils.emailValidation,
              onSaved: (String value) {
                _email = value;
              },
              keyboardType: TextInputType.emailAddress,
            )),
        SizedBox(
          height: 10,
        ),
        PhoneNoWidget(
          contentPadding: contentPadding,
          phoneController: phoneController,
          country: (countryCode != null && countryCode.isNotEmpty)
              ? countryCode
              : AppPreferences().country,
          onChanged: (code) {
            setState(() {
              countryCodeDialCode = code.dialCode;
              countryCode = code.code;
            });
          },
          codeReadOnly: readOnly,
          numberReadOnly: readOnly,
        ),
        SizedBox(
          height: 10,
        ),
        PhoneNoWidget(
          mandatory: false,
          contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 16),
          hint: "Alternate Phone",
          phoneController: secondaryPhoneController,
          countryCode: secondaryCountryCodeDialCode,
          country: (secondaryPhoneCountryCode != null &&
                  secondaryPhoneCountryCode.isNotEmpty)
              ? secondaryPhoneCountryCode
              : AppPreferences().country,
          onChanged: (code) {
            setState(() {
              secondaryCountryCodeDialCode = code.dialCode;
              secondaryPhoneCountryCode = code.code;
            });
          },
          onInitCallback: (code) {
            secondaryCountryCodeDialCode = code.dialCode;
            secondaryPhoneCountryCode = code.code;
          },
          codeReadOnly: readOnly,
          numberReadOnly: readOnly,
        ),
        SizedBox(
          height: 10,
        ),
        Card(
            child: Container(
                padding: EdgeInsets.all(7),
                child: Column(children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          //padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          width: screenWidth / 3,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            AppLocalizations.of(context)
                                .translate("key_gender"),
                            style: TextStyles.mlDynamicTextStyle,
                            maxLines: 2,
                          )),
                      // Expanded(
                      //     child: Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: <Widget>[
                      //     Radio(
                      //       value: 'Male',
                      //       groupValue: _genderValue,
                      //       onChanged: _radioValueChanges,
                      //     ),
                      //     Text(
                      //       AppLocalizations.of(context).translate("key_male"),
                      //       style: TextStyles.mlDynamicTextStyle,
                      //     ),
                      //     Radio(
                      //         value: "Female",
                      //         groupValue: _genderValue,
                      //         onChanged: _radioValueChanges),
                      //     Text(
                      //       AppLocalizations.of(context).translate("key_female"),
                      //       style: TextStyles.mlDynamicTextStyle,
                      //     ),
                      //   ],
                      // ),),
                    ],
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Wrap(
                      runSpacing: -15.0,
                      children: [
                        IntrinsicWidth(
                          child: Row(
                            children: <Widget>[
                              Radio(
                                value: 'Male',
                                groupValue: _genderValue,
                                onChanged: isMemberShipStatusUnderReview
                                    ? null
                                    : _radioValueChanges,
                              ),
                              Text(
                                AppLocalizations.of(context)
                                    .translate("key_male"),
                                style: TextStyles.mlDynamicTextStyle,
                              ),
                            ],
                          ),
                        ),
                        IntrinsicWidth(
                          child: Row(
                            children: <Widget>[
                              Radio(
                                value: 'Female',
                                groupValue: _genderValue,
                                onChanged: isMemberShipStatusUnderReview
                                    ? null
                                    : _radioValueChanges,
                              ),
                              Text(
                                AppLocalizations.of(context)
                                    .translate("key_female"),
                                style: TextStyles.mlDynamicTextStyle,
                              ),
                            ],
                          ),
                        ),
                        IntrinsicWidth(
                          child: Row(
                            children: <Widget>[
                              Radio(
                                value: 'Not to disclose',
                                groupValue: _genderValue,
                                onChanged: isMemberShipStatusUnderReview
                                    ? null
                                    : _radioValueChanges,
                              ),
                              Text(
                                'Not to disclose',
                                style: TextStyles.mlDynamicTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ]))),
        !maritalStatusLoading
            ? MaritalStatusWidget(
                readOnly: isMemberShipStatusUnderReview,
                maritalStatusController: maritalStatusController,
                defValue: (maritalStatus == null || maritalStatus.isEmpty)
                    ? null
                    : maritalStatus,
              )
            : Container(),
        // SizedBox(
        //   height: 15,
        // ),
        // if (_genderValue == "Female")
        //   Container(
        //       //width: screenWidth / 2.2,
        //       padding: EdgeInsets.symmetric(horizontal: 5),
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.start,
        //         children: <Widget>[
        //           Text(
        //             AppLocalizations.of(context).translate("key_pergnant"),
        //             style: TextStyles.mlDynamicTextStyle,
        //           ),
        //           Spacer(),
        //           Radio(
        //             value: 'Yes',
        //             groupValue: _pregnant,
        //             onChanged: _radioPregChanges,
        //           ),
        //           Text(
        //             AppLocalizations.of(context).translate("key_yes"),
        //             style: TextStyles.mlDynamicTextStyle,
        //           ),
        //           Radio(
        //             value: 'No',
        //             groupValue: _pregnant,
        //             onChanged: _radioPregChanges,
        //           ),
        //           Text(
        //             AppLocalizations.of(context).translate("key_no"),
        //             style: TextStyles.mlDynamicTextStyle,
        //           ),
        //         ],
        //       )),
        if (false)
          Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).translate("key_bloodgroup"),
                    style: TextStyles.mlDynamicTextStyle,
                  ),
                  Spacer(),
                  Container(
                      padding: EdgeInsets.only(right: 10),
                      child: DropdownButton<String>(
                        hint: Text(
                          _bloodGroup == null
                              ? AppLocalizations.of(context)
                                  .translate("key_select")
                              : _bloodGroup,
                          style: TextStyles.mlDynamicTextStyle,
                        ),
                        items: <String>[
                          'A+',
                          'B+',
                          'AB+',
                          'O+',
                          'A-',
                          'B-',
                          'AB-',
                          'O-',
                        ].map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(
                              value,
                              style: TextStyles.mlDynamicTextStyle,
                            ),
                          );
                        }).toList(),
                        onChanged: (_) {
                          setState(() {
                            _bloodGroup = _;
                          });
                        },
                      ))
                ],
              )),
        SizedBox(
          height: 10,
        ),
        /* !maritalStatusLoading
            ? MaritalStatusWidget(
                readOnly: isMemberShipStatusUnderReview,
                maritalStatusController: maritalStatusController,
                defValue: (maritalStatus == null || maritalStatus.isEmpty)
                    ? null
                    : maritalStatus,
              )
            : Container(), */
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Text(
                AppLocalizations.of(context).translate("key_dob"),
                style: TextStyles.mlDynamicTextStyle,
              )),
              Container(
                  width: screenWidth / 2.2,
                  padding: EdgeInsets.only(right: 0),
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: <Widget>[
                      TextFormField(
                        readOnly: isMemberShipStatusUnderReview,
                        enabled: isMemberShipStatusUnderReview,
                        focusNode: null,
                        //validator: validateDOB,
                        onChanged: (_) {},
                        controller: dateController,
                        decoration: InputDecoration(
                          contentPadding: contentPadding,
                          labelText: AppLocalizations.of(context)
                              .translate("key_date"),
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),

//fillColor: Colors.green
                        ),
                        keyboardType: TextInputType.text,
                        style: isMemberShipStatusUnderReview
                            ? TextStyle(
                                color: Colors.grey,
                                fontFamily: "Poppins",
                                fontSize: 15)
                            : TextStyles.mlDynamicTextStyle,
                      ),
                      GestureDetector(
                          onTap: () => {
//                            _selectDate(context)
                                if (!isMemberShipStatusUnderReview)
                                  openDateSelector()
                              },
                          child: Container(
                              padding: EdgeInsets.only(right: 10),
                              alignment: Alignment.centerRight,
                              child: Icon(Icons.calendar_today)))
                    ],
                  ))
//Icon(Icons.calendar_today)
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Text(
                AppLocalizations.of(context).translate("key_age"),
                style: TextStyles.mlDynamicTextStyle,
              )),
              Container(
                  width: screenWidth / 2.2,
                  padding: EdgeInsets.only(right: 0),
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: <Widget>[
                      FocusScope(
                          node: null,
                          child: TextFormField(
                            enabled: isMemberShipStatusUnderReview,
                            controller: ageController,
                            readOnly: true,
                            enableInteractiveSelection: false,
                            decoration: InputDecoration(
                              contentPadding: contentPadding,
                              labelText: AppLocalizations.of(context)
                                  .translate("key_age"),
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
//fillColor: Colors.green
                            ),
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                                color: Colors.grey,
                                fontFamily: "Poppins",
                                fontSize: AppPreferences().isLanguageTamil()
                                    ? 13
                                    : 16),
                          )),
                    ],
                  ))
//Icon(Icons.calendar_today)
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Role", style: TextStyles.mlDynamicTextStyle),
              //Spacer(),
              SizedBox(width: 20),
              Expanded(
                  child: DropdownButtonFormField(
                hint: Text(
                  role == null ? 'Select' : role,
                  style: isMemberShipStatusUnderReview
                      ? TextStyle(
                          color: Colors.grey,
                        )
                      : TextStyles.mlDynamicTextStyle
                          .copyWith(color: Colors.black87),
                ),
                items: _roledropdownMenuItems,
                validator: (value) {
                  if (role == null) {
                    return "Role is required";
                  } else {
                    return null;
                  }
                },
                onChanged: isMemberShipStatusUnderReview
                    ? null
                    : (_) {
                        setState(() {
                          role = _;
                        });
                      },
              ))
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Education Qualification",
                  style: TextStyles.mlDynamicTextStyle),
              //Spacer(),
              SizedBox(width: 20),
              Expanded(
                  child: DropdownButtonFormField(
                hint: Text(
                  _educationalQualification == null
                      ? 'Select'
                      : _educationalQualification,
                  style: isMemberShipStatusUnderReview
                      ? TextStyle(
                          color: Colors.grey,
                        )
                      : TextStyles.mlDynamicTextStyle
                          .copyWith(color: Colors.black87),
                ),
                items: _eduQualDropdownMenuItems,
                validator: (value) {
                  if (_educationalQualification == null) {
                    return "Qualification is required";
                  } else {
                    return null;
                  }
                },
                onChanged: isMemberShipStatusUnderReview
                    ? null
                    : (_) {
                        // print(_);
                        setState(() {
                          _educationalQualification = _;
                        });
                      },
              ))
            ],
          ),
        ),
        if (_educationalQualification != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextFormField(
              readOnly: isMemberShipStatusUnderReview,
              style: isMemberShipStatusUnderReview
                  ? TextStyle(
                      color: Colors.grey,
                    )
                  : TextStyles.mlDynamicTextStyle,
              controller: courseMajorController,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                border: OutlineInputBorder(),
                labelText: "Course Major",
              ),
              keyboardType: TextInputType.text,
            ),
          ),
        if (_educationalQualification != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: PopupMenuButton<String>(
              child: TextFormField(
                style: isMemberShipStatusUnderReview
                    ? TextStyle(
                        color: Colors.grey,
                      )
                    : TextStyles.mlDynamicTextStyle,
                readOnly: true,
                enabled: false,
                controller: courseCompletionStatusController,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                    disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.grey)),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                    labelText: "Completion Status",
                    labelStyle: TextStyle(color: Colors.grey[600])),
                keyboardType: TextInputType.text,
              ),
              onSelected: isMemberShipStatusUnderReview
                  ? null
                  : (String value) {
                      courseCompletionStatusController.text = value;
                    },
              itemBuilder: (BuildContext context) {
                return _eduCompletionDropdownItems
                    .map<PopupMenuItem<String>>((String value) {
                  return new PopupMenuItem(
                      child: new Text(value), value: value);
                }).toList();
              },
            ),
          ),

        if (_educationalQualification != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextFormField(
              readOnly: isMemberShipStatusUnderReview,
              style: isMemberShipStatusUnderReview
                  ? TextStyle(
                      color: Colors.grey,
                    )
                  : TextStyles.mlDynamicTextStyle
                      .copyWith(color: Colors.black87),
              controller: additionalInfoController,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                border: OutlineInputBorder(),
                labelText: "Additional Details",
              ),
              keyboardType: TextInputType.text,
              // validator: (String value) {
              //   if (value.isEmpty)
              //     return "Completion status cannot be blank";
              //   else
              //     return null;
              // },
            ),
          ),
        if (_educationalQualification != null)
          Center(
              child: Text(
            "You can update year pursuing, year of course completion etc",
            style: TextStyle(color: Colors.grey, fontSize: 10.0),
          )),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Address Proof", style: TextStyles.mlDynamicTextStyle),
              //Spacer(),
              SizedBox(width: 20),
              Expanded(
                  child: DropdownButtonFormField(
                hint: Text(
                  _documentName == null ? 'Select' : _documentName,
                  style: isMemberShipStatusUnderReview
                      ? TextStyle(
                          color: Colors.grey,
                        )
                      : TextStyles.mlDynamicTextStyle
                          .copyWith(color: Colors.black87),
                ),
                items: _documentNameDropdownMenuItems,
                validator: (value) {
                  if (_documentName == null) {
                    return "Address proof is required";
                  } else {
                    return null;
                  }
                },
                onChanged: isMemberShipStatusUnderReview
                    ? null
                    : (_) {
                        setState(() {
                          _documentName = _;
                        });
                      },
              ))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: TextFormField(
            style: isMemberShipStatusUnderReview
                ? TextStyle(
                    color: Colors.grey,
                  )
                : TextStyles.mlDynamicTextStyle,
            controller: nationalIdController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 16),
              border: OutlineInputBorder(),
              labelText:
                  AppLocalizations.of(context).translate("key_tt_national"),
            ),
            keyboardType: TextInputType.text,
            validator: (String value) {
              if (value.isEmpty)
                return "Address proof id cannot be blank";
              else
                return null;
            },
          ),
        ),
        Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  children: [
                    Text("Upload Address Proof Picture",
                        style: TextStyles.mlDynamicTextStyle),
                  ],
                )),
            // SizedBox(
            //   height: 10,
            // ),
            (fileuploaded)
                ? DismissibleMessageWidget(
                    msg: "Please select address proof picture",
                    color: Colors.red[400],
                  )
                : Container(),
            SizedBox(
              height: 5.0,
            ),
            DocsUploadSingleWidget(
              isRestrictToEditFields: isMemberShipStatusUnderReview,
              documentImageCallback: (File addressProofImage) {
                if (addressProofImage != null) {
                  setState(() {
                    addressProofPic = addressProofImage;
                    // print(addressProofImage.path);
                  });
                } else {
                  setState(() {
                    fileuploaded = true;
                  });
                }
              },
              documentImageUrl:
                  addressProofPicURL != null && addressProofPicURL.isNotEmpty
                      ? addressProofPicURL
                      : null,
            ),
          ],
        ),

        SizedBox(
          height: 10,
        ),
        Row(children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Text(
                "Present Address",
                style: TextStyles.headerTextStyle,
              ))
        ]),
        Container(
          child: new TextFormField(
            readOnly: isMemberShipStatusUnderReview,
            controller: streetController,
            focusNode: addressFocusNode,
            style: isMemberShipStatusUnderReview
                ? TextStyle(
                    color: Colors.grey,
                  )
                : TextStyles.mlDynamicTextStyle,
            decoration: InputDecoration(
              contentPadding: contentPadding,
              border: OutlineInputBorder(),
              labelText: AppLocalizations.of(context).translate("key_address1"),
            ),
            keyboardType: TextInputType.text,
            validator: ValidationUtils.streetValidation,
            onSaved: (String val) {
              setState(() {
                _street = val;
              });
            },
          ),
        ),
        Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Container(
              child: new TextFormField(
                readOnly: isMemberShipStatusUnderReview,
                style: isMemberShipStatusUnderReview
                    ? TextStyle(
                        color: Colors.grey,
                      )
                    : TextStyles.mlDynamicTextStyle,
                controller: areaController,
                decoration: InputDecoration(
                  contentPadding: contentPadding,
                  border: OutlineInputBorder(),
                  labelText:
                      AppLocalizations.of(context).translate("key_address2"),
                ),
                keyboardType: TextInputType.text,
//                validator: validateArea,
                onSaved: (String val) {
                  setState(() {
                    _area = val;
                  });
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: new TextFormField(
                      readOnly: isMemberShipStatusUnderReview,
                      decoration: InputDecoration(
                          contentPadding: contentPadding,
                          border: OutlineInputBorder(),
                          labelText: AppLocalizations.of(context)
                              .translate("key_city"),
                          errorMaxLines: 2),
                      controller: cityController,
                      keyboardType: TextInputType.text,
                      validator: ValidationUtils.cityValidation,
                      onSaved: (String val) {
                        setState(() {
                          _city = val;
                        });
                      },
                      style: isMemberShipStatusUnderReview
                          ? TextStyle(
                              color: Colors.grey,
                            )
                          : TextStyles.mlDynamicTextStyle,
                    ),
                  ),
                ),
                SizedBox(
                  width: 7,
                ),
                Expanded(
                  child: Container(
                    child: new TextFormField(
                      readOnly: isMemberShipStatusUnderReview,
                      style: isMemberShipStatusUnderReview
                          ? TextStyle(
                              color: Colors.grey,
                            )
                          : TextStyles.mlDynamicTextStyle,
                      decoration: InputDecoration(
                        contentPadding: contentPadding,
                        border: OutlineInputBorder(),
                        labelText:
                            AppLocalizations.of(context).translate("key_state"),
                        errorMaxLines: 2,
                      ),
                      controller: stateController,
                      keyboardType: TextInputType.text,
                      validator: ValidationUtils.stateValidation,
                      onSaved: (String val) {
                        setState(() {
                          _stateName = val;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2.2,
                    child: new TextFormField(
                      readOnly: isMemberShipStatusUnderReview,
                      style: isMemberShipStatusUnderReview
                          ? TextStyle(
                              color: Colors.grey,
                            )
                          : TextStyles.mlDynamicTextStyle,
                      decoration: InputDecoration(
                          contentPadding: contentPadding,
                          border: OutlineInputBorder(),
                          labelText: AppLocalizations.of(context)
                              .translate("key_country"),
                          errorMaxLines: 2),
                      controller: countryController,
                      keyboardType: TextInputType.text,
                      validator: ValidationUtils.countryValidation,
                      onSaved: (String val) {
                        setState(() {
                          _countryName = val;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 7,
                ),
//                Spacer(),
                Container(
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: TextFormField(
                    readOnly: isMemberShipStatusUnderReview,
                    style: isMemberShipStatusUnderReview
                        ? TextStyle(
                            color: Colors.grey,
                          )
                        : TextStyles.mlDynamicTextStyle,
                    controller: zipCodeController,
                    //maxLength: 13,
                    decoration: InputDecoration(
                        contentPadding: contentPadding,
                        border: OutlineInputBorder(),
                        labelText:
                            AppLocalizations.of(context).translate("key_zip"),
                        errorMaxLines: 2),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      LengthLimitingTextInputFormatter(6),
                    ],
                    validator: (String value) {
                      if (value.isEmpty)
                        return AppLocalizations.of(context)
                            .translate("key_pincode_empty");
                      else if (value.length < 6)
                        return AppLocalizations.of(context)
                            .translate("key_pincodeerror");
                      else
                        return null;
                    },
                    onSaved: (String val) {
                      _zip = val;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            permanentAddress(),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ],
    );
  }

  String validateDOB(String value) {
    if (value.trim().length == 0)
      return AppLocalizations.of(context).translate("key_birthdateisrequired");
    else
      return null;
  }

/* sathya*/
  String validateZip(String value) {
    if (value.length < 1)
      return AppLocalizations.of(context).translate("key_pincodeerror");
    else if (value.length > 13)
      return AppLocalizations.of(context).translate("key_mustbebelow");
    else
      return null;
  }

// The pattern of the email didn't match the regex above.
// return 'Email is not valid';
// }

  openDateSelector() {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        maxTime: DateTime.now(),
        minTime: DateTime.now().subtract(Duration(days: 43830)),
        theme: WidgetStyles.datePickerTheme, onChanged: (date) {
      // print('change $date in time zone ' +
      // date.timeZoneOffset.inHours.toString());
    }, onConfirm: (date) {
      // print('confirm $date');

      setState(() {
        dateController.text = gnatDobFormat.format(date.toLocal());
        ageController.text = getUserAge(date).toString();
        addressFocusNode.requestFocus();
      });
    }, currentTime: DateTime.now(), locale: LocaleType.en);
    // locale:
    //     AppPreferences().isLanguageTamil() ? LocaleType.ta : LocaleType.en);
  }

  getUserAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  Widget permanentAddress() {
    return Column(
      children: <Widget>[
        Row(children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
          onChanged: isMemberShipStatusUnderReview
              ? null
              : (newValue) {
                  setState(() {
                    isAddressesSame = newValue;
                    if (isAddressesSame) {
                      secondaryAddressLine1Controller.text =
                          streetController.text;
                      secondaryAddressLine2.text = areaController.text;
                      secondaryCityController.text = cityController.text;
                      secondaryStateController.text = stateController.text;
                      secondaryCountryController.text = countryController.text;
                      secondaryZipCodeController.text = zipCodeController.text;
                    } else {
                      //Clear all the value
                      secondaryAddressLine1Controller.clear();
                      secondaryAddressLine2.clear();
                      secondaryCityController.clear();
                      secondaryStateController.clear();
                      secondaryCountryController.clear();
                      secondaryZipCodeController.clear();
                    }
                  });
                },
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          child: new TextFormField(
            enabled: !isAddressesSame,
            readOnly: isMemberShipStatusUnderReview,
            style: isMemberShipStatusUnderReview
                ? TextStyle(
                    color: Colors.grey,
                  )
                : TextStyles.mlDynamicTextStyle,
            controller: secondaryAddressLine1Controller,
            decoration: InputDecoration(
              contentPadding: contentPadding,
              fillColor:
                  !isAddressesSame ? Colors.transparent : Colors.grey[300],
              filled: true,
              border: OutlineInputBorder(),
              labelText: AppLocalizations.of(context).translate("key_address1"),
            ),
            keyboardType: TextInputType.text,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          child: new TextFormField(
            enabled: !isAddressesSame,

            readOnly: isMemberShipStatusUnderReview,
            style: isMemberShipStatusUnderReview
                ? TextStyle(
                    color: Colors.grey,
                  )
                : TextStyles.mlDynamicTextStyle,
            controller: secondaryAddressLine2,
            decoration: InputDecoration(
              contentPadding: contentPadding,
              fillColor:
                  !isAddressesSame ? Colors.transparent : Colors.grey[300],
              filled: true,
              border: OutlineInputBorder(),
              labelText: AppLocalizations.of(context).translate("key_address2"),
            ),
            keyboardType: TextInputType.text,
//
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                child: new TextFormField(
                  enabled: !isAddressesSame,
                  readOnly: isMemberShipStatusUnderReview,
                  style: isMemberShipStatusUnderReview
                      ? TextStyle(
                          color: Colors.grey,
                        )
                      : TextStyles.mlDynamicTextStyle,
                  decoration: InputDecoration(
                    contentPadding: contentPadding,
                    errorMaxLines: 2,
                    fillColor: !isAddressesSame
                        ? Colors.transparent
                        : Colors.grey[300],
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText:
                        AppLocalizations.of(context).translate("key_city"),
                  ),
                  controller: secondaryCityController,
                  keyboardType: TextInputType.text,
                ),
              ),
            ),
            SizedBox(
              width: 7,
            ),
            Expanded(
              child: Container(
                child: new TextFormField(
                  enabled: !isAddressesSame,
                  readOnly: isMemberShipStatusUnderReview,
                  style: isMemberShipStatusUnderReview
                      ? TextStyle(
                          color: Colors.grey,
                        )
                      : TextStyles.mlDynamicTextStyle,
                  decoration: InputDecoration(
                    contentPadding: contentPadding,
                    errorMaxLines: 3,
                    fillColor: !isAddressesSame
                        ? Colors.transparent
                        : Colors.grey[300],
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText:
                        AppLocalizations.of(context).translate("key_state"),
                  ),
                  controller: secondaryStateController,
                  keyboardType: TextInputType.text,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width / 2.2,
                child: new TextFormField(
                  enabled: !isAddressesSame,
                  readOnly: isMemberShipStatusUnderReview,
                  style: isMemberShipStatusUnderReview
                      ? TextStyle(
                          color: Colors.grey,
                        )
                      : TextStyles.mlDynamicTextStyle,
                  decoration: InputDecoration(
                    contentPadding: contentPadding,
                    errorMaxLines: 2,
                    fillColor: !isAddressesSame
                        ? Colors.transparent
                        : Colors.grey[300],
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText:
                        AppLocalizations.of(context).translate("key_country"),
                  ),
                  controller: secondaryCountryController,
                  keyboardType: TextInputType.text,
                ),
              ),
            ),
            SizedBox(
              width: 7,
            ),
//                Spacer(),
            Container(
              width: MediaQuery.of(context).size.width / 2.2,
              child: TextFormField(
                enabled: !isAddressesSame,
                readOnly: isMemberShipStatusUnderReview,
                style: isMemberShipStatusUnderReview
                    ? TextStyle(
                        color: Colors.grey,
                      )
                    : TextStyles.mlDynamicTextStyle,
                controller: secondaryZipCodeController,
                //maxLength: 13,
                decoration: InputDecoration(
                    errorMaxLines: 2,
                    fillColor: !isAddressesSame
                        ? Colors.transparent
                        : Colors.grey[300],
                    filled: true,
                    contentPadding: contentPadding,
                    border: OutlineInputBorder(),
                    labelText:
                        AppLocalizations.of(context).translate("key_zip")),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                  LengthLimitingTextInputFormatter(6),
                ],
                validator: (String value) {
                  if (value.isNotEmpty && value.length < 6) {
                    return AppLocalizations.of(context)
                        .translate("key_pincodeerror");
                  } else
                    return null;
                },
                // onSaved: (String val) {
                //   _zip = val;
                // },
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  void _validateInputs() async {
    if (widget.formKey.currentState.validate()) {
// If all data are correct then save data to out variables
      widget.formKey.currentState.save();
      CustomProgressLoader.showLoader(context);
      UserInfo info = new UserInfo();
      info.active = true;
      info.firstName = _firstName;
      info.lastName = _lastName;
      info.departmentName = await AppPreferences.getDeptName();
      info.userName = await AppPreferences.getUsername();
      info.state = _state;
      info.stateName = stateController.text;
      info.countryName = countryController.text;
      info.addressLine1 = streetController.text;
      info.addressLine2 = areaController.text;
      info.country = AppPreferences().country;
      info.zipCode = _zip;
      info.qualification = _educationalQualification;
      info.addressProof = _documentName;
      info.addressProofId = nationalIdController.text;
      info.tempUserSubType = role;
      info.additionalQualificationMajor = courseMajorController.text;
      info.additionalQualificationStatus =
          courseCompletionStatusController.text;
      info.additionalInfo = additionalInfoController.text;
      info.mobileNo = await AppPreferences.getPhone();
      info.emailId = await AppPreferences.getEmail();
      info.birthDate =
          originalDobFormat.format(gnatDobFormat.parse(dateController.text));
      //info.pregnant = _pregnant;
      info.bloodGroup = _bloodGroup;
      info.gender = _genderValue;
      info.age = int.parse(
          ageController.text != null && ageController.text.isNotEmpty
              ? ageController.text
              : "0");
      info.roleName = "User";
      info.cityName = _city;
      info.city = "Others";
//Secondary fields
      if (secondaryPhoneController.text != null &&
          secondaryPhoneController.text.isNotEmpty) {
        info.secondaryCountryCodeValue =
            secondaryCountryCodeDialCode.replaceAll("+", "");
        info.secondaryCountryCode = secondaryPhoneCountryCode;
        info.secondaryCountry = secondaryPhoneCountryCode;
        info.secondMobileNo = secondaryCountryCodeDialCode.replaceAll("+", "") +
            secondaryPhoneController.text;
      }
      info.secondaryZipCode = secondaryZipCodeController.text;
      info.secondaryCountryName = secondaryCountryController.text;
      info.secondaryStateName = secondaryStateController.text;
      info.secondaryAddressLine1 = secondaryAddressLine1Controller.text;
      info.secondaryAddressLine2 = secondaryAddressLine2.text;
      info.secondaryCityName = secondaryCityController.text;

      info.sameAsPresentAddr = isAddressesSame;
      info.age =
          int.parse(ageController.text.isEmpty ? "0" : ageController.text);
      info.maritalStatus = maritalStatusController.text;

      UserInfoBloc al = new UserInfoBloc(context);
      if (await AppPreferences.getRole() == Constants.supervisorRole) {
        // print("userInof Create : ${info.toJson().toString()}");

        info.emailId = _email;
        info.userName = _username;
        info.mobileNo =
            /*AppPreferences().country == "IN"
            ? "91" + _mobile
            : */
            countryCodeDialCode.replaceAll("+", "") + _mobile;
        al.createUserInfo(info, addressProofPic);
        al.createFetcher.listen((value) async {
          if (value.status == 201 || value.status == 200) {
            // await AppPreferences.setUserInfo(info);
            Fluttertoast.showToast(
                msg: AppLocalizations.of(context)
                    .translate("key_usercreatedsuccessfully"),
                toastLength: Toast.LENGTH_LONG,
                timeInSecForIosWeb: 5,
                gravity: ToastGravity.TOP);
          } else {
            AlertUtils.showAlertDialog(
                context,
                value.message ??
                    AppLocalizations.of(context)
                        .translate("key_somethingwentwrong"));
          }
        });
      } else {
        // print("userInof Update : ${info.toJson().toString()}");

        al.updateUserInfo(info, addressProofPic);
        al.createFetcher.listen((value) async {
          if (value.status == 201 || value.status == 200) {
            AuthBloc bloc = AuthBloc(context);
            await bloc.getUserInformation();
            //await AppPreferences.setUserInfo(info);
            AppPreferences.setFullName(
                lastController.text + ", " + firstController.text);
            AppPreferences.setSecondFullName(
                firstController.text + " " + lastController.text);
            AppPreferences.setUsername(_username);
            AppPreferences.setDOB(originalDobFormat
                .format(gnatDobFormat.parse(dateController.text)));
            AppPreferences.setProfileUpdate(true);
            AppPreferences.setAddress(_street +
                " " +
                "@@" +
                _area +
                "@@" +
                _city +
                "@@" +
                _stateName +
                "@@" +
                _countryName +
                "@@" +
                _zip);

            Fluttertoast.showToast(
                msg: AppLocalizations.of(context)
                    .translate("key_user_updated_successfully"),
                toastLength: Toast.LENGTH_LONG,
                timeInSecForIosWeb: 5,
                gravity: ToastGravity.TOP);

            CustomProgressLoader.cancelLoader(context);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => NavigationHomeScreen()),
                ModalRoute.withName(Routes.navigatorHomeScreen));
          } else {
            AlertUtils.showAlertDialog(
                context,
                value.message ??
                    AppLocalizations.of(context)
                        .translate("key_somethingwentwrong"));
          }
        });
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void _searchByZipCode() async {}

  @override
  bool get wantKeepAlive => true;
}
