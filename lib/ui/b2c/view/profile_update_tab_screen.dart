import 'dart:convert';
import 'dart:io';

import '../../../login/utils/custom_progress_dialog.dart';
import '../../../ui/b2c/bloc/userDetails_bloc.dart';
import '../../../ui/b2c/model/user_details_model.dart';
import '../../../ui/committees/widgets/formField_dropdown.dart';
import '../../../ui_utils/app_colors.dart';
import '../../../ui_utils/network_check.dart';
import '../../../utils/app_preferences.dart';
import '../../../utils/constants.dart';
import '../../../utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:http/http.dart' as http;

class ProfileTabScreen extends StatefulWidget {
  ProfileTabScreen(
      this.dropDownCountyList, this.dropDownStateList, this.isProfile,
      {this.userDetailsData});

  final List<DropdownMenuItem> dropDownCountyList;
  final List<DropdownMenuItem> dropDownStateList;
  final UserDetailsModel userDetailsData;
  final bool isProfile;

  @override
  _ProfileTabScreenState createState() => _ProfileTabScreenState();
}

class _ProfileTabScreenState extends State<ProfileTabScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  bool isUserDetailLoading = false;
  bool isCountyListLoading = false;
  bool isStateListLoading = false;
  bool isCategoryListLoading = false;
  bool _autoValidate = false;
  String selectedItem;
  bool isNewUser = false;
  bool showForcedLayoffNo = false;

  bool _supplierCannotSeeMe = false;
  bool update = false;

  UserDetailsModel userData = new UserDetailsModel();

  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController organisationNameController =
      new TextEditingController();
  TextEditingController jobTitleController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();

  TextEditingController countyController = new TextEditingController();
  TextEditingController stateController = new TextEditingController();
  TextEditingController zipCodeController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController companyIndividualController =
      new TextEditingController();
  TextEditingController chamberBuyingController = new TextEditingController();
  TextEditingController revenueAffectedController = new TextEditingController();
  TextEditingController forcedLayoffController = new TextEditingController();
  TextEditingController aboutUsController = new TextEditingController();
  TextEditingController categoryTypeController = new TextEditingController();
  TextEditingController subCategoryTypeController = new TextEditingController();
  TextEditingController forcedLayoffNoController = new TextEditingController();

//  var focusNodeTransport = new FocusNode();
//  var focusNodeZipCode = new FocusNode();
//  var focusNodeForcedLayoffNo = new FocusNode();
  String state = "";
  var file;

  @override
  void initState() {
    // TODO: implement initState

    if (widget.isProfile == false) {
      companyIndividualController.text = "Company";
      chamberBuyingController.text = "Yes";
      revenueAffectedController.text = "Not affected";
      forcedLayoffController.text = "No";
      aboutUsController.text = "Google";
      countyController.text = "";
      stateController.text = "";
      forcedLayoffNoController.text = "";
    } else {
      userData = widget.userDetailsData;
      firstNameController.text = userData.firstName;
      lastNameController.text = userData.lastName;
      organisationNameController.text = userData.organizationName;
      jobTitleController.text = userData.jobTitle;
      addressController.text = userData.address1;
      cityController.text = userData.city;
      countyController.text = userData.county;
      stateController.text = userData.state;
      zipCodeController.text = userData.zipCode.toString();
      phoneController.text = userData.mobile.toString();
      companyIndividualController.text = userData.companyIndividual;
      chamberBuyingController.text = userData.chamberBuying;
      revenueAffectedController.text = userData.revenueAffected;
      forcedLayoffController.text = userData.forcedLayoff;
      aboutUsController.text = userData.aboutUs;
      //  categoryTypeController.text =
      // userData.categoryList[0]['category_type'];
      //  subCategoryTypeController.text =
      // userData.categoryList[0]['subcategory_type'];
      _supplierCannotSeeMe = userData.toHide;
      forcedLayoffNoController.text = userData.forcedLayoffNo.toString();
      if (userData.forcedLayoffNo > 0) {
        showForcedLayoffNo = true;
      }
    }

    super.initState();
  }

  void _onActiveChanged(bool newValue) => setState(() {
        FocusScope.of(context).requestFocus(new FocusNode());
        _supplierCannotSeeMe = newValue;
      });

//  void switchScreen(str, context) =>
//      Navigator.push(context, MaterialPageRoute(
//          builder: (context) => UploadPage(url: str)
//      ));
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    AppPreferences().userGroup == "Provider"
                        ? Container(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, top: 0, bottom: 0, right: 15.0),
                              child: Row(
                                children: <Widget>[
                                  _supplierCannotSeeMe
                                      ? Text("Supplier can see me ")
                                      : Text("Supplier cannot see me "),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Switch(
                                    value: _supplierCannotSeeMe,
                                    onChanged: _onActiveChanged,
                                    activeTrackColor: Colors.lightGreenAccent,
                                    activeColor: Colors.green,
                                  ),
                                ],
                              ),
                            ))
                        : SizedBox(
                            height: 5,
                          ),
                    Container(
                        //width: MediaQuery.of(context).size.width*.8,
                        height: 60.0,
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 5, bottom: 0, right: 20.0),
                          child: TextFormField(
                            controller: firstNameController,

                            inputFormatters: [
                              new WhitelistingTextInputFormatter(
                                  RegExp("[a-z A-Z ]")),
                            ],
                            //keyboardType: TextInputType.number,
                            autocorrect: false,
                            textInputAction: TextInputAction.next,

                            decoration: InputDecoration(
                              labelText: "First Name *",

                              //hintStyle: Utils.hintStyleBlack,
                              fillColor: Colors.transparent,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(color: Colors.black)),
                            ),
                            onSaved: (String val) {
                              firstNameController.text = val;
                            },
                            validator: (String arg) {
                              if (arg.length > 0) {
                                return null;
                              } else {
                                return Constants.VALIDATION_BLANK_FIRSTNAME;
                              }
                            },
                          ),
                        )),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                        //width: MediaQuery.of(context).size.width*.8,
                        height: 60.0,
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 5, bottom: 0, right: 20.0),
                          child: TextFormField(
                            controller: lastNameController,

                            inputFormatters: [
                              new WhitelistingTextInputFormatter(
                                  RegExp("[a-z A-Z ]")),
                            ],
                            //keyboardType: TextInputType.number,
                            autocorrect: false,
                            textInputAction: TextInputAction.next,

                            decoration: InputDecoration(
                              labelText: "Last Name *",

                              //hintStyle: Utils.hintStyleBlack,
                              fillColor: Colors.transparent,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(color: Colors.black)),
                            ),
                            onSaved: (String val) {
                              lastNameController.text = val;
                            },
                            validator: (String arg) {
                              if (arg.length > 0) {
                                return null;
                              } else {
                                return Constants.VALIDATION_BLANK_LASTNAME;
                              }
                            },
                          ),
                        )),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                        //width: MediaQuery.of(context).size.width*.8,
                        height: 60.0,
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 5, bottom: 0, right: 20.0),
                          child: TextFormField(
                            controller: organisationNameController,

//                              inputFormatters: [
//                                new WhitelistingTextInputFormatter(
//                                    RegExp("[0-9]")),
//                              ],
                            //keyboardType: TextInputType.number,
                            autocorrect: false,
                            textInputAction: TextInputAction.next,

                            decoration: InputDecoration(
                              labelText: "Organisation Name *",

                              //hintStyle: Utils.hintStyleBlack,
                              fillColor: Colors.transparent,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(color: Colors.black)),
                            ),
                            onSaved: (String val) {
                              organisationNameController.text = val;
                            },
                            validator: (String arg) {
                              if (arg.length > 0) {
                                return null;
                              } else {
                                return Constants
                                    .VALIDATION_BLANK_ORGANISATION_NAME;
                              }
                            },
                          ),
                        )),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                        //width: MediaQuery.of(context).size.width*.8,
                        height: 60.0,
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 5, bottom: 0, right: 20.0),
                          child: TextFormField(
                            controller: jobTitleController,

//                              inputFormatters: [
//                                new WhitelistingTextInputFormatter(
//                                    RegExp("[0-9]")),
//                              ],
                            //keyboardType: TextInputType.number,
                            autocorrect: false,
                            textInputAction: TextInputAction.next,

                            decoration: InputDecoration(
                              labelText: "Job Title *",

                              //hintStyle: Utils.hintStyleBlack,
                              fillColor: Colors.transparent,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(color: Colors.black)),
                            ),
                            onSaved: (String val) {
                              jobTitleController.text = val;
                            },
                            validator: (String arg) {
                              if (arg.length > 0) {
                                return null;
                              } else {
                                return Constants.VALIDATION_BLANK_JOB_TITLE;
                              }
                            },
                          ),
                        )),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                        //width: MediaQuery.of(context).size.width*.8,
                        height: 60.0,
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 5, bottom: 0, right: 20.0),
                          child: TextFormField(
                            controller: addressController,

//                              inputFormatters: [
//                                new WhitelistingTextInputFormatter(
//                                    RegExp("[0-9]")),
//                              ],
                            //keyboardType: TextInputType.number,
                            autocorrect: false,
                            textInputAction: TextInputAction.next,

                            decoration: InputDecoration(
                              labelText: "Address *",

                              //hintStyle: Utils.hintStyleBlack,
                              fillColor: Colors.transparent,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(color: Colors.black)),
                            ),
                            onSaved: (String val) {
                              addressController.text = val;
                            },
                            validator: (String arg) {
                              if (arg.length > 0) {
                                return null;
                              } else {
                                return Constants.VALIDATION_BLANK_ADDRESS;
                              }
                            },
                          ),
                        )),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                        //width: MediaQuery.of(context).size.width*.8,
                        height: 60.0,
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 5, bottom: 0, right: 20.0),
                          child: TextFormField(
                            controller: cityController,

                            inputFormatters: [
                              new WhitelistingTextInputFormatter(
                                  RegExp("[a-z A-Z ]")),
                            ],
                            //keyboardType: TextInputType.number,
                            autocorrect: false,
                            textInputAction: TextInputAction.next,

                            decoration: InputDecoration(
                              labelText: "City *",

                              //hintStyle: Utils.hintStyleBlack,
                              fillColor: Colors.transparent,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(color: Colors.black)),
                            ),
                            onSaved: (String val) {
                              cityController.text = val;
                            },
                            validator: (String arg) {
                              if (arg.length > 0) {
                                return null;
                              } else {
                                return Constants.VALIDATION_BLANK_CITY;
                              }
                            },
                          ),
                        )),
                    SizedBox(
                      height: 5,
                    ),
                    AppPreferences().userGroup == "Provider"
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: 15, top: 0, bottom: 0, right: 15.0),
                            child: Column(
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Colors.grey[500],
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: SearchableDropdown.single(
                                    items: widget.dropDownCountyList,
                                    value: countyController.text,
                                    hint: "Select County *",
                                    style: TextStyle(
                                        fontSize: 14.0, color: Colors.black),
                                    searchHint: "Search County",
                                    underline: null,
                                    onChanged: (value) {
                                      setState(() {
                                        FocusScope.of(context)
                                            .requestFocus(new FocusNode());
                                        if (value == null) {
                                          countyController.text = "";
                                        }
                                        // countyController.text = "";
                                        else
                                          countyController.text = value;
//                                  print(
//                                      "selectedItem is county ${countyController.text}");
                                      });
                                    },
                                    dialogBox: false,
                                    isExpanded: true,
                                    menuConstraints: BoxConstraints.tight(
                                        Size.fromHeight(350)),
                                    validator: (_autoValidate)
                                        ? (selectedItemsForValidator) {
//                                      print(
//                                          "selectedItemsForValidator $selectedItemsForValidator");
                                            if (selectedItemsForValidator ==
                                                null) {
                                              return ("");
                                            }
                                            return (null);
                                          }
                                        : null,
                                  ),
                                ),
                                (_autoValidate && countyController.text.isEmpty)
                                    ? Container(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12.0),
                                          child: Text(
                                            Constants.VALIDATION_BLANK_COUNTY,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xffD32F2F)),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          )
                        : Container(),
                    AppPreferences().userGroup == "Provider"
                        ? SizedBox(
                            height: 5,
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15, top: 0, bottom: 0, right: 15.0),
                      child: Column(
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.grey[500],
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: SearchableDropdown.single(
                              items: widget.dropDownStateList,
                              value: stateController.text,
                              hint: "Select State *",
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.black),
                              searchHint: "Search State",
                              underline: null,
                              onChanged: (value) {
                                setState(() {
                                  if (value == null)
                                    stateController.text = "";
                                  else
                                    stateController.text = value;
//                                  print(
//                                      "selectedItem is ${stateController.text}");
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                });
                              },
                              dialogBox: false,
                              isExpanded: true,
                              menuConstraints:
                                  BoxConstraints.tight(Size.fromHeight(350)),
                              validator: (_autoValidate)
                                  ? (selectedItemsForValidator) {
                                      if (selectedItemsForValidator == null) {
                                        return ("");
                                      }
                                      return (null);
                                    }
                                  : null,
                            ),
                          ),
                          (_autoValidate && stateController.text.isEmpty)
                              ? Container(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Text(
                                      Constants.VALIDATION_BLANK_STATE,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xffD32F2F)),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                        //width: MediaQuery.of(context).size.width*.8,
                        height: 60.0,
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 5, bottom: 0, right: 20.0),
                          child: TextFormField(
                            //  focusNode: focusNodeZipCode,
                            controller: zipCodeController,
                            inputFormatters: [
                              new WhitelistingTextInputFormatter(
                                  RegExp("[0-9]")),
                            ],
                            keyboardType: TextInputType.number,
                            autocorrect: false,
                            textInputAction: TextInputAction.next,

                            decoration: InputDecoration(
                              labelText: "Zip Code *",
                              fillColor: Colors.transparent,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(color: Colors.black)),
                            ),
                            onSaved: (String val) {
                              zipCodeController.text = val;
                            },
                            validator: (String arg) {
                              if (arg.length < 0) {
                                return Constants.VALIDATION_BLANK_ZIP_CODE;
                              } else if (arg.length != 5) {
                                return Constants.VALIDATION_VALID_ZIP_CODE;
                              } else {
                                return null;
                              }
                            },
                          ),
                        )),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                        //width: MediaQuery.of(context).size.width*.8,
                        height: 80.0,
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 5, bottom: 0, right: 20.0),
                          child: TextFormField(
                            //focusNode: focusNodeTransport,
                            controller: phoneController,
                            inputFormatters: [
                              new WhitelistingTextInputFormatter(
                                  RegExp("[0-9]")),
                            ],
                            maxLength: 10,
                            keyboardType: TextInputType.number,
                            autocorrect: false,
                            textInputAction: TextInputAction.next,

                            decoration: InputDecoration(
                              labelText: "Phone *",
                              fillColor: Colors.transparent,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(color: Colors.black)),
                            ),
                            onSaved: (String val) {
                              phoneController.text = val;
                            },
                            validator: (String arg) {
                              if (arg.isEmpty) {
                                return Constants.VALIDATION_BLANK_PHONE_NO;
                              } else if (arg.length > 0 &&
                                  int.parse(arg) < 1000000000) {
                                return Constants.VALIDATION_VALID_PHONE_NO;
                              } else {
                                return null;
                              }
                            },
                          ),
                        )),
                  ],
                ),

//                Center(
//                  child: Column(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      Text(state)
//                    ],
//                  ),
//                ),
//                Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: Row(
//                    children: <Widget>[
//                     // Text("Insert the URL that will receive the Multipart POST request (including the starting http://)", style: Theme.of(context).textTheme.headline),
//                      Container(
//                        width: MediaQuery.of(context).size.width*.6,
//                        child: TextField(
//                          controller: controller,
//                         // onSubmitted: (str) => switchScreen(str, context),
//                        ),
//                      ),
//                      Container(
//                        width: MediaQuery.of(context).size.width*.25,
//                        child: RaisedButton(
//                          color: AppColors.primaryColor,
//                          child: Text("Upload",style: TextStyle(color: Colors.white),),
//                          onPressed: () async {
//                             file = await ImagePicker.pickImage(source: ImageSource.gallery);
//                           // var res = await http.MultipartFile.fromPath('picture', file.path);
////                            var res =  http.MultipartFile.fromBytes(
////                                'picture',
////                                File(file.path).readAsBytesSync(),
////                                filename: file.path.split("/").last
////                            );
//                            setState(() {
//                             // state = res;
//                              controller.text = file.path.split("/").last;
////                              print("Hello Pranay value of res.filename ${res.filename}");
////                              print("Hello Pranay value of res ${res.contentType}");
//                              print("Hello Pranay value of file.path ${file.path}");
//                              print("Hello Pranay value of file.readAsBytes() ${file.readAsBytes()}");
//                            });
//                          },
//                        ),
//                      )
//                    ],
//                  ),
//                ),

                Container(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20, top: 15, bottom: 5, right: 15.0),
                      child: Text(
                          "Are you representing your company or are you submitting as an individual?"),
                    )),
                Container(
                  //height: 50.0,
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: DropDownFormField(
                    filled: false,
                    titleText: null,
                    hintText: "",
                    value: companyIndividualController.text,
                    onSaved: (value) {
                      setState(() {
                        companyIndividualController.text = value;
//                        FocusScope.of(context)
//                            .dispose();
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        companyIndividualController.text = value;
                      });
                    },
                    dataSource: [
                      {
                        "display": "Company",
                        "value": "Company",
                      },
                      {
                        "display": "Individual",
                        "value": "Individual",
                      },
                    ],
                    textField: 'display',
                    valueField: 'value',
                  ),
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20, top: 15, bottom: 5, right: 15.0),
                      child: Text(
                          "Are you willing to participate in a buying collective through a chamber of commerce or an association?"),
                    )),
                Container(
                  //height: 50.0,
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: DropDownFormField(
                    filled: false,
                    titleText: null,
                    hintText: "",
                    value: chamberBuyingController.text,
                    onSaved: (value) {
                      setState(() {
                        chamberBuyingController.text = value;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        chamberBuyingController.text = value;
                      });
                    },
                    dataSource: [
                      {
                        "display": "Yes",
                        "value": "Yes",
                      },
                      {
                        "display": "No",
                        "value": "No",
                      },
                    ],
                    textField: 'display',
                    valueField: 'value',
                  ),
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20, top: 15, bottom: 5, right: 15.0),
                      child: Text(
                          "How much has your revenue been affected by COVID-19 pandemic?"),
                    )),
                Container(
                  //height: 50.0,
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: DropDownFormField(
                    filled: false,
                    titleText: null,
                    hintText: "",
                    value: revenueAffectedController.text,
                    onSaved: (value) {
                      setState(() {
                        revenueAffectedController.text = value;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        revenueAffectedController.text = value;
                      });
                    },
                    dataSource: [
                      {
                        "display": "Not affected",
                        "value": "Not affected",
                      },
                      {
                        "display": "Less than 25% reduction",
                        "value": "Less than 25% reduction",
                      },
                      {
                        "display": "25% - 50% reduction",
                        "value": "25% - 50% reduction",
                      },
                      {
                        "display": "51% - 75% reduction",
                        "value": "51% - 75% reduction",
                      },
                      {
                        "display": "76% - 100% reduction",
                        "value": "76% - 100% reduction",
                      },
                      {
                        "display": "Revenues are increasing",
                        "value": "Revenues are increasing",
                      },
                    ],
                    textField: 'display',
                    valueField: 'value',
                  ),
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20, top: 15, bottom: 5, right: 15.0),
                      child: Text(
                          "Have you been forced to lay off any employees as a result of COVID-19 pandemic?"),
                    )),
                Container(
                  //height: 50.0,
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: DropDownFormField(
                    filled: false,
                    titleText: null,
                    hintText: "",
                    value: forcedLayoffController.text,
                    onSaved: (value) {
                      setState(() {
                        forcedLayoffController.text = value;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        forcedLayoffController.text = value;
                        if (value == "Yes") {
                          showForcedLayoffNo = true;
                          forcedLayoffNoController.clear();
                        } else {
                          showForcedLayoffNo = false;
                          forcedLayoffNoController.clear();
                        }
                      });
                    },
                    dataSource: [
                      {
                        "display": "No",
                        "value": "No",
                      },
                      {
                        "display": "Not yet, but expected",
                        "value": "Not yet, but expected",
                      },
                      {
                        "display": "Yes",
                        "value": "Yes",
                      },
                    ],
                    textField: 'display',
                    valueField: 'value',
                  ),
                ),
                showForcedLayoffNo
                    ? SizedBox(
                        height: 15,
                      )
                    : Container(),
                showForcedLayoffNo
                    ? Container(
                        //width: MediaQuery.of(context).size.width*.8,
                        height: 60.0,
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16, top: 5, bottom: 0, right: 18.0),
                          child: TextFormField(
                            // focusNode: focusNodeForcedLayoffNo,
                            controller: forcedLayoffNoController,
                            inputFormatters: [
                              new WhitelistingTextInputFormatter(
                                  RegExp("[0-9]")),
                            ],
                            keyboardType: TextInputType.number,
                            autocorrect: false,
                            textInputAction: TextInputAction.next,

                            decoration: InputDecoration(
                              labelText: "No of Employees *",
                              fillColor: Colors.transparent,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(color: Colors.black)),
                            ),
                            onSaved: (String val) {
                              forcedLayoffNoController.text = val;
                            },
                            validator: (String arg) {
                              if (arg.length > 0 && int.parse(arg) > 0) {
                                return null;
                              } else {
                                return Constants
                                    .VALIDATION_BLANK_NO_OF_EMPLOYEES;
                              }
                            },
                          ),
                        ))
                    : Container(),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20, top: 15, bottom: 5, right: 15.0),
                      child: Text("How did you hear about us?"),
                    )),
                Container(
                  //height: 50.0,
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: DropDownFormField(
                    filled: false,
                    titleText: null,
                    hintText: "",
                    value: aboutUsController.text,
                    onSaved: (value) {
                      setState(() {
                        aboutUsController.text = value;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        aboutUsController.text = value;
                      });
                    },
                    dataSource: [
                      {
                        "display": "Google",
                        "value": "Google",
                      },
                      {
                        "display": "TV ads",
                        "value": "TV ads",
                      },
                      {
                        "display": "Facebook",
                        "value": "Facebook",
                      },
                      {
                        "display": "Twitter",
                        "value": "Twitter",
                      },
                      {
                        "display": "Friend",
                        "value": "Friend",
                      },
                    ],
                    textField: 'display',
                    valueField: 'value',
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                RaisedButton(
                  onPressed: () {
                    onSubmitClick();
                  },
                  elevation: 10.0,
                  color: AppColors.primaryColor,
                  child: update
                      ? Text(
                          "Update",
                          style: TextStyle(color: Colors.white),
                        )
                      : Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

//  Future<String> uploadImage(filename, url) async {
//    var request = http.MultipartRequest('POST', Uri.parse(url));
//    request.files.add(await http.MultipartFile.fromPath('picture', filename));
//    var res = await request.send();
//    return res.reasonPhrase;
//  }

  void onSubmitClick() {
    _validateInputsForNewRequest();
  }

  void _validateInputsForNewRequest() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      if ((AppPreferences().userGroup == "Provider"
              ? countyController.text.isNotEmpty
              : true) &&
          stateController.text.isNotEmpty) {
        var connectivityResult = await NetworkCheck().check();
        if (connectivityResult) {
          apiCall();
        } else {
          Fluttertoast.showToast(
              timeInSecForIosWeb: 5,
              msg: Constants.NO_INTERNET_CONNECTION,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP);
        }
      } else {
        setState(() {
          _autoValidate = true;
          Fluttertoast.showToast(
              timeInSecForIosWeb: 5,
              msg: "Please fill or check the mandatory fields",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP);
        });
      }
    } else {
      setState(() {
        _autoValidate = true;
        Fluttertoast.showToast(
            timeInSecForIosWeb: 5,
            msg: "Please fill or check the mandatory fields",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);
      });
    }
  }

  apiCall() async {
    CustomProgressLoader.showLoader(context);

    UserDetailsModel userDetailsData = new UserDetailsModel();

    userDetailsData.firstName = firstNameController.text.toString();
    userDetailsData.lastName = lastNameController.text.toString();
    userDetailsData.organizationName =
        organisationNameController.text.toString();
    userDetailsData.jobTitle = jobTitleController.text.toString();
    userDetailsData.address1 = addressController.text.toString();
    userDetailsData.city = cityController.text.toString();
    userDetailsData.county = countyController.text.toString();
    userDetailsData.state = stateController.text.toString();
    userDetailsData.zipCode = zipCodeController.text.toString();
    userDetailsData.mobile = phoneController.text.toString();
    userDetailsData.companyIndividual =
        companyIndividualController.text.toString();
    userDetailsData.chamberBuying = chamberBuyingController.text.toString();
    userDetailsData.revenueAffected = revenueAffectedController.text.toString();
    userDetailsData.forcedLayoff = forcedLayoffController.text.toString();
    userDetailsData.aboutUs = aboutUsController.text.toString();
    userDetailsData.categoryType = categoryTypeController.text.toString();
    userDetailsData.subCategoryType = subCategoryTypeController.text.toString();
    userDetailsData.forcedLayoffNo = forcedLayoffNoController.text.isNotEmpty
        ? int.parse(forcedLayoffNoController.text.toString())
        : 0;
    userDetailsData.toHide = _supplierCannotSeeMe;
    //userDetailsData.attachProfileRequester = controller.text;

    UserDetailsBloc _bloc = new UserDetailsBloc(context);
    _bloc.createOrUpdateUserProfile(userDetailsData,
        isUpdate: update, file: file);
    _bloc.userProfileCreateOrUpdateFetcher.listen((response) async {
      if (response.status == 200) {
        // print("Hello Pranay Request submission is successful");
        if (widget.isProfile == false) {
          AppPreferences.setLoginStatus(true);
          isNewUser = true;

          AppPreferences.setFirstName(firstNameController.text);
          AppPreferences.setUserGroup(AppPreferences().userGroup);
          AppPreferences.setToken(AppPreferences().token);

          await AppPreferences().init();
          //  getUpdatedUserDetails();

          //   ProfileInfoScreen.tabController.animateToPage(1, duration: Duration(seconds: 1), curve: Curves.easeOut);

          Fluttertoast.showToast(
              timeInSecForIosWeb: 5,
              msg: "Profile details submitted successfully",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP);
        } else {
          AppPreferences.setFirstName(firstNameController.text);
          // getUpdatedUserDetails();

          await AppPreferences().init();
          Fluttertoast.showToast(
              timeInSecForIosWeb: 5,
              msg: "Profile details updated successfully",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP);
        }
        CustomProgressLoader.cancelLoader(context);
        // ProfileInfoScreen.myTabbedPageKey.currentState.tabController.animateTo((ProfileInfoScreen.tabController.index + 1) % 2);
        // Navigator.pushReplacementNamed(context, Routes.profileCategoryTabScreen);
        if (AppPreferences().userGroup == "Provider") {
          Navigator.pushReplacementNamed(context, Routes.requesterDashBoard);
        } else if (AppPreferences().userGroup == "Supplier") {
          Navigator.pushReplacementNamed(context, Routes.supplierDashBoard);
        } else {
          Navigator.pushReplacementNamed(context, Routes.managerDashBoard);
        }
      } else if (response.status == 404) {
        Fluttertoast.showToast(
            timeInSecForIosWeb: 5,
            msg: response.error,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);
        CustomProgressLoader.cancelLoader(context);
      } else {
        CustomProgressLoader.cancelLoader(context);
        Fluttertoast.showToast(
            msg: response?.error ?? AppPreferences().getApisErrorMessage,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);
      }
    });
  }

  getUpdatedUserDetails() {
    UserDetailsBloc _userBloc = new UserDetailsBloc(context);
    _userBloc.fetchUserDetails(AppPreferences().token);
    _userBloc.userDetailsFetcher.listen((userResponse) async {
      userData = userResponse;

//      print("Value of userResponse.status ${userResponse.status}");
//
//      print("Value of User Group ${userData.firstName}");
//      print("Value of  userResponse.county ${userResponse.county}");
//      print("Value of  userResponse.state ${userResponse.state}");
      setState(() {});
    });
  }
}
