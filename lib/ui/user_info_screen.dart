import 'dart:io';

import '../bloc/user_info_bloc.dart';
import '../login/utils/custom_progress_dialog.dart';
import '../model/passing_arg.dart';
import '../model/user_info.dart';
import '../ui/tabs/app_localizations.dart';
import '../ui_utils/text_styles.dart';
import '../ui_utils/widget_styles.dart';
import '../utils/alert_utils.dart';
import '../utils/app_preferences.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../utils/validation_utils.dart';
import '../widgets/marital_status.dart';
import '../widgets/phone_no_widget.dart';
import '../widgets/submit_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'custom_drawer/custom_app_bar.dart';
import 'membership/widgets/dismissible_message_widget.dart';
import 'membership/widgets/docs_upload_single_widget.dart';

final DateFormat gnatDobFormat = DateFormat("dd/MM/yyyy");
final DateFormat originalDobFormat = DateFormat("MM/dd/yyyy");

class UserInformationScreen extends StatefulWidget {
  UserInformationScreen({
    Key key,
  }) : super(key: key);

  @override
  _UserInformationScreenState createState() =>
      new _UserInformationScreenState();
}

//State is information of the application that can change over time or when some actions are taken.
class _UserInformationScreenState extends State<UserInformationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isHistoryTabOpened = false;

  //AddressBloc _addressBloc;
  bool _autoValidate = false;
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
  String initSelection = 'JM';
  String countryCodeDialCode = AppPreferences().country == "IN" ? "+91" : "+1";
  String phoneCountryCode;
  String _documentName;
  String _educationalQualification;
  String _additionalQualificationStatus;
  String role;
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
  var completionStatusController = TextEditingController();
  var nationalIdController = TextEditingController();
  var additionalInfoController = TextEditingController();

  bool readOnly = false;
  bool isAddressesSame = false;
  File addressProofPic = null;

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

  List<DropdownMenuItem<String>> _eduCompletionDropdownItems = [
    DropdownMenuItem(
      child: Text('Pursuing'),
      value: 'Pursuing',
    ),
    DropdownMenuItem(
      child: Text('Completed'),
      value: 'Completed',
    ),
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

  /////////////////
  bool fileuploaded = false;
  final secondaryPhoneController = TextEditingController();
  final secondaryAddressController = TextEditingController();
  final secondaryStateController = TextEditingController();
  final secondaryCityController = TextEditingController();
  final secondaryCountryController = TextEditingController();
  final secondaryZipCodeController = TextEditingController();
  var secondaryAddressLine2 = TextEditingController();
  String secondaryPhoneCountryCode;
  String secondaryCountryCodeDialCode = Constants.INDIA_CODE;
  String secondaryCountry = AppPreferences().country;
  final genderController = TextEditingController();
  final maritalStatusController = TextEditingController();
  bool profileHistoryEnabled = false;
  // final dobController = TextEditingController();

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
    getProfileHistoryEnabled();
    super.dispose();
  }

  @override
  initState() {
    super.initState();
  }

  getProfileHistoryEnabled() async {
    profileHistoryEnabled = await AppPreferences.getProfileHistoryEnabled();
    setState(() {
      profileHistoryEnabled = profileHistoryEnabled;
    });
  }

  _getReport(String value) {
    setState(() {
      countryCodeDialCode = value;
    });
  }

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
      switch (value) {
        case 'Male':
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
    AppPreferences().setGlobalContext(context);
    screenWidth = MediaQuery.of(context).size.width;
    return new Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
          title: AppLocalizations.of(context).translate("key_userinformation"),
          pageId: Constants.PAGE_ID_ADD_A_PERSON),
      body: new SingleChildScrollView(
        physics: PageScrollPhysics(),
        child: new Container(
          margin: new EdgeInsets.all(15.0),
          child: new Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: FormUI(),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      iconTheme: new IconThemeData(color: Colors.black45),
      title: new Text(
        AppLocalizations.of(context).translate("key_userinformation"),
        style: TextStyle(color: Colors.black87),
      ),
      actions: <Widget>[],
    );
  }

// Here is our Form UI
  Widget FormUI() {
    return new Column(
      children: <Widget>[
        SizedBox(height: 20),
        TextFormField(
          style: TextStyles.mlDynamicTextStyle,
          controller: firstController,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 16),
              border: OutlineInputBorder(),
              labelText:
                  AppLocalizations.of(context).translate("key_first_name")),
          keyboardType: TextInputType.text,
          validator: ValidationUtils.firstNameValidation,
          onSaved: (String val) {
            _firstName = val;
          },
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          style: TextStyles.mlDynamicTextStyle,
          controller: lastController,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 16),
            border: OutlineInputBorder(),
            labelText: AppLocalizations.of(context).translate("key_last_name"),
          ),
          keyboardType: TextInputType.text,
          validator: ValidationUtils.lastNameValidation,
          onSaved: (String val) {
            _lastName = val;
          },
        ),
        SizedBox(
          height: 10,
        ),
        Container(
            child: TextFormField(
          style: TextStyles.mlDynamicTextStyle,
          readOnly: readOnly,
          controller: usernameController,
          /*style: TextStyle(color: Colors.grey),*/
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 16),
              border: OutlineInputBorder(),
              labelText:
                  AppLocalizations.of(context).translate("key_username")),
          keyboardType: TextInputType.text,
          inputFormatters: [
            BlacklistingTextInputFormatter(new RegExp(r"\s\b|\b\s"))
          ],
          validator: ValidationUtils.usernameValidation,
          onSaved: (String val) {
            _username = val;
          },
        )),
        SizedBox(
          height: 10,
        ),
        Container(
            width: screenWidth / 1,
            child: new TextFormField(
              style: TextStyles.mlDynamicTextStyle,
              readOnly: readOnly,
              controller: emailController,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                border: OutlineInputBorder(),
                labelText: AppLocalizations.of(context).translate("key_email"),
              ),
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
          contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 16),
          phoneController: phoneController,
          countryCode: countryCodeDialCode,
          country: AppPreferences().country,
          onChanged: (code) {
            setState(() {
              countryCodeDialCode = code.dialCode;
              phoneCountryCode = code.code;
            });
          },
          onInitCallback: (code) {
            countryCodeDialCode = code.dialCode;
            phoneCountryCode = code.code;
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
          hint: "Alternate phone",
          phoneController: secondaryPhoneController,
          countryCode: secondaryCountryCodeDialCode,
          country: AppPreferences().country,
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
        SizedBox(
          height: 10,
        ),
        Card(
            child: Container(
                padding: EdgeInsets.all(7),
                child: Column(
                  children: [
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
                                  onChanged: _radioValueChanges,
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
                                  onChanged: _radioValueChanges,
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
                                  onChanged: _radioValueChanges,
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
                  ],
                ))),
        MaritalStatusWidget(
          maritalStatusController: maritalStatusController,
        ),
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
                      IgnorePointer(
                          ignoring: false,
                          child: TextFormField(
                            style: TextStyles.mlDynamicTextStyle,
                            focusNode: null,
                            validator: validateDOB,
                            readOnly: true,
                            controller: dateController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 16),
                              labelText: AppLocalizations.of(context)
                                  .translate("key_date"),
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            onTap: () {
                              openDateSelector();
                            },
                          )),
                      GestureDetector(
                          onTap: () => {
//                            _selectDate(context)
                                openDateSelector()
                              },
                          child: Container(
                              padding: EdgeInsets.only(right: 10, bottom: 10),
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
                            style: TextStyles.mlDynamicTextStyle,
                            controller: ageController,
                            readOnly: true,
                            enableInteractiveSelection: false,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 16),
                              labelText: AppLocalizations.of(context)
                                  .translate("key_age"),
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
//fillColor: Colors.green
                            ),
                            keyboardType: TextInputType.number,
                            /*style: TextStyle(
                              color: Colors.grey,
                              fontFamily: "Poppins",
                            ),*/
                            validator: (arg) {
                              if (arg == null || arg.isEmpty) {
                                return "Age cannot be blank";
                              } else {
                                return null;
                              }
                            },
                          )),
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
                  style: TextStyles.mlDynamicTextStyle
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
                onChanged: (_) {
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
                  style: TextStyles.mlDynamicTextStyle
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
                onChanged: (_) {
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
              style: TextStyles.mlDynamicTextStyle,
              controller: courseMajorController,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                border: OutlineInputBorder(),
                labelText: "Course Major",
              ),
              keyboardType: TextInputType.text,
              /* validator: (String value) {
                if (value.isEmpty)
                  return "Course Major cannot be blank";
                else
                  return null;
              }, */
            ),
          ),
        if (_educationalQualification != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: DropdownButtonFormField(
              style:
                  TextStyles.mlDynamicTextStyle.copyWith(color: Colors.black),
              //controller: completionStatusController,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                border: OutlineInputBorder(),
                labelText: "Completion status",
              ),
              items: _eduCompletionDropdownItems,
              onChanged: (value) {
                setState(() {
                  _additionalQualificationStatus = value;
                });
              },
              //keyboardType: TextInputType.text,
              // validator: (String value) {
              //   if (value.isEmpty)
              //     return "Completion status cannot be blank";
              //   else
              //     return null;
              // },
            ),
          ),
        if (_educationalQualification != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextFormField(
              style: TextStyles.mlDynamicTextStyle,
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
                  style: TextStyles.mlDynamicTextStyle
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
                onChanged: (_) {
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
            style: TextStyles.mlDynamicTextStyle,
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
              isRestrictToEditFields: false,
              documentImageCallback: (File addressProofImage) {
                if (addressProofImage != null) {
                  setState(() {
                    addressProofPic = addressProofImage;
                  });
                } else {
                  setState(() {
                    fileuploaded = true;
                  });
                }
              },
              documentImageUrl: null,
            ),
          ],
        ),
        Column(
          children: <Widget>[
            Row(children: [
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Text(
                    "Present Address",
                    style: TextStyles.headerTextStyle,
                  ))
            ]),
            SizedBox(
              height: 10,
            ),
            Container(
              child: new TextFormField(
                style: TextStyles.mlDynamicTextStyle,
                controller: streetController,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                  border: OutlineInputBorder(),
                  labelText:
                      AppLocalizations.of(context).translate("key_address1"),
                ),
                keyboardType: TextInputType.text,
                validator: ValidationUtils.streetValidation,
                onSaved: (String val) {
                  _street = val;
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: new TextFormField(
                style: TextStyles.mlDynamicTextStyle,
                controller: areaController,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                  border: OutlineInputBorder(),
                  labelText:
                      AppLocalizations.of(context).translate("key_address2"),
                ),
                keyboardType: TextInputType.text,
//                validator: validateArea,
                onSaved: (String val) {
                  _area = val;
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
                      style: TextStyles.mlDynamicTextStyle,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        errorMaxLines: 2,
                        border: OutlineInputBorder(),
                        labelText:
                            AppLocalizations.of(context).translate("key_city"),
                      ),
                      controller: cityController,
                      keyboardType: TextInputType.text,
                      validator: ValidationUtils.cityValidation,
                      onSaved: (String val) {
                        _city = val;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 7,
                ),
                Expanded(
                  child: Container(
                    child: new TextFormField(
                      style: TextStyles.mlDynamicTextStyle,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        errorMaxLines: 3,
                        border: OutlineInputBorder(),
                        labelText:
                            AppLocalizations.of(context).translate("key_state"),
                      ),
                      controller: stateController,
                      keyboardType: TextInputType.text,
                      validator: ValidationUtils.stateValidation,
                      onSaved: (String val) {
                        _stateName = val;
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
                      style: TextStyles.mlDynamicTextStyle,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        errorMaxLines: 2,
                        border: OutlineInputBorder(),
                        labelText: AppLocalizations.of(context)
                            .translate("key_country"),
                      ),
                      controller: countryController,
                      keyboardType: TextInputType.text,
                      validator: ValidationUtils.countryValidation,
                      onSaved: (String val) {
                        _countryName = val;
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
                    style: TextStyles.mlDynamicTextStyle,
                    controller: zipCodeController,
                    //maxLength: 6,
                    decoration: InputDecoration(
                        errorMaxLines: 2,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        border: OutlineInputBorder(),
                        labelText:
                            AppLocalizations.of(context).translate("key_zip")),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: validateZip,
                    onSaved: (String val) {
                      _zip = val;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            permanentAddress(),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
        SubmitButton(
          text: profileHistoryEnabled
              ? AppLocalizations.of(context).translate("key_save")
              : "Save",
          onPress: () async {
            _validateInputs();
          },
        ),
      ],
    );
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
          onChanged: (newValue) {
            setState(() {
              isAddressesSame = newValue;
              if (isAddressesSame) {
                secondaryAddressController.text = streetController.text;
                secondaryAddressLine2.text = areaController.text;
                secondaryCityController.text = cityController.text;
                secondaryStateController.text = stateController.text;
                secondaryCountryController.text = countryController.text;
                secondaryZipCodeController.text = zipCodeController.text;
              } else {
                //Clear all the value
                secondaryAddressController.clear();
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
            style: TextStyles.mlDynamicTextStyle,
            controller: secondaryAddressController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 16),
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
            style: TextStyles.mlDynamicTextStyle,
            controller: secondaryAddressLine2,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 16),
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
                  style: TextStyles.mlDynamicTextStyle,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                    errorMaxLines: 2,
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
                  style: TextStyles.mlDynamicTextStyle,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                    errorMaxLines: 3,
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
                  style: TextStyles.mlDynamicTextStyle,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                    errorMaxLines: 2,
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
                style: TextStyles.mlDynamicTextStyle,
                controller: secondaryZipCodeController,
                //maxLength: 6,
                decoration: InputDecoration(
                    errorMaxLines: 2,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                    border: OutlineInputBorder(),
                    labelText:
                        AppLocalizations.of(context).translate("key_zip")),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (String value) {
                  if (value.isNotEmpty && value.length < 6) {
                    return AppLocalizations.of(context)
                        .translate("key_pincodeerror");
                  } else
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
          height: 10,
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  String validateDOB(String value) {
    if (value.trim().length == 0)
      return "Date of birth is required";
    else
      return null;
  }

  String validateZip(String value) {
    if (value.isEmpty) {
      return AppLocalizations.of(context).translate("key_pincode_empty");
    } else if (value.length < 6)
      return AppLocalizations.of(context).translate("key_pincodeerror");
    else
      return null;
  }

  openDateSelector() {
    FocusScope.of(context).requestFocus(new FocusNode());
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        maxTime: DateTime.now().subtract(Duration(days: 5490)),
        minTime: DateTime.now().subtract(Duration(days: 43830)),
        theme: WidgetStyles.datePickerTheme, onChanged: (date) {
      // print('change $date in time zone ' +
          // date.timeZoneOffset.inHours.toString());
    }, onConfirm: (date) {
      // print('confirm $date');

      setState(() {
        dateController.text = gnatDobFormat.format(date.toLocal());
        ageController.text = getUserAge(date).toString();
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

  void _validateInputs() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      CustomProgressLoader.showLoader(context);
      UserInfo info = new UserInfo();
      info.active = true;
      info.firstName = _firstName;
      info.lastName = _lastName;
      info.userFullName = firstController.text + " " + lastController.text;
      info.departmentName = await AppPreferences.getDeptName();
      info.userName = await AppPreferences.getUsername();
      info.state = _state;
      info.stateName = _stateName;
      info.countryName = _countryName;
      info.addressLine1 = _street;
      info.addressLine2 = _area;
      info.country = AppPreferences().country;
      info.zipCode = zipCodeController.text;
      info.mobileNo = await AppPreferences.getPhone();
      info.emailId = await AppPreferences.getEmail();
      info.qualification = _educationalQualification;
      info.tempUserSubType = role;
      info.addressProof = _documentName;
      info.addressProofId = nationalIdController.text;
      info.birthDate =
          originalDobFormat.format(gnatDobFormat.parse(dateController.text));
      info.additionalQualificationMajor = courseMajorController.text;
      info.additionalQualificationStatus = _additionalQualificationStatus;
      info.additionalInfo = additionalInfoController.text;
      //info.pregnant = _pregnant;
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
      info.secondaryAddressLine1 = secondaryAddressController.text;
      info.secondaryAddressLine2 = secondaryAddressLine2.text;
      info.hasAdditionalInfo = false;
      info.secondaryCityName = secondaryCityController.text;
      info.age =
          int.parse(ageController.text.isEmpty ? "0" : ageController.text);
      info.maritalStatus = maritalStatusController.text;

      info.bloodGroup = _bloodGroup;
      info.gender = _genderValue;
      if (ageController.text != null && ageController.text.isNotEmpty)
        info.age = int.parse(ageController.text);
      info.roleName = "User";
      info.cityName = _city;
      info.city = "Others";
      info.source = "MOBILE";

      UserInfoBloc al = new UserInfoBloc(context);
      if (await AppPreferences.getRole() == Constants.supervisorRole) {
        info.emailId = _email;
        info.userName = _username;
        info.countryCodeValue = countryCodeDialCode.replaceAll("+", "");
        info.countryCode = phoneCountryCode;
        info.mobileNo =
            "${countryCodeDialCode.replaceAll("+", "")}${phoneController.text}";
        // print('info ${info.toJson().toString()}');
        al.createUserInfo(info, addressProofPic);
        al.createFetcher.listen((value) {
          CustomProgressLoader.cancelLoader(context);
          if (value.status == 201 || value.status == 200) {
            Fluttertoast.showToast(
                msg: AppLocalizations.of(context)
                    .translate("key_usercreatedsuccessfully"),
                toastLength: Toast.LENGTH_LONG,
                timeInSecForIosWeb: 5,
                gravity: ToastGravity.TOP);
            // print(_genderValue);
            Navigator.pushNamed(context, Routes.historyScreen,
                arguments:
                    Args(arg: null, username: _username, gender: _genderValue));
          } else {
            String messageBody = value.message;
            AlertUtils.showAlertDialog(
                context,
                (messageBody != null && messageBody.isNotEmpty)
                    ? messageBody
                    : AppLocalizations.of(context)
                        .translate("key_somethingwentwrong"));
          }
        });
      } else {
        al.updateUserInfo(info, addressProofPic);
        al.createFetcher.listen((value) {
          CustomProgressLoader.cancelLoader(context);
          if (value.status == 201 || value.status == 200) {
            AppPreferences.setFullName(
                firstController.text + " " + lastController.text);
            AppPreferences.setUsername(_username);
            AppPreferences.setDOB(originalDobFormat
                .format(gnatDobFormat.parse(dateController.text)));
            AppPreferences.setBloodGroup(_bloodGroup);
            AppPreferences.setAddress(_street +" "+
                _area +
                "@@" +
                _city +
                "@@" +
                _stateName +
                "@@" +
                _countryName +
                "@@" +
                _zip);
            if (profileHistoryEnabled) {
              Navigator.pushNamed(context, Routes.symptomScreen,
                  arguments: Args(arg: null));
            } else {
              Navigator.pop(context);
            }

            // Navigator.pushNamed(context, Routes.symptomDynamicScreen,
            //     arguments: Args(arg: null));
          } else {
            String messageBody = value.message;
            AlertUtils.showAlertDialog(
                context,
                (messageBody != null && messageBody.isNotEmpty)
                    ? messageBody
                    : AppLocalizations.of(context)
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
}
