import '../../model/user_info.dart';
import '../../ui/advertise/adWidget.dart';
import '../../ui/membership/widgets/payment_cancel_dialog.dart';
import '../../ui/membership/widgets/payments_widget.dart';
import '../../ui/tabs/app_localizations.dart';
import '../../ui_utils/app_colors.dart';
import '../../utils/validation_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import '../../ui/custom_drawer/navigation_home_screen.dart';
import '../../ui_utils/widget_styles.dart';
import '../../utils/app_preferences.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../widgets/phone_no_widget.dart';
import '../custom_drawer/custom_app_bar.dart';
import 'event_new_feed.dart';
import 'events_new_bloc.dart';
import 'user_event.dart';

class EventRegistration extends StatefulWidget {
  final UserEvent event;
  final EventFeed eventFeed;
  //final Function refresh;
  const EventRegistration({
    Key key,
    this.event,
    this.eventFeed,
  }) //this.refresh
  : super(key: key);

  @override
  _EventRegistrationState createState() => _EventRegistrationState();
}

class _EventRegistrationState extends State<EventRegistration> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  EventsBloc _eventBloc;

  UserEvent get event => widget.event;
  final DateFormat formatter = DateFormat('MM/dd/yyyy');
  final List<String> diabetesTypes = ["Type1", "Type2", "Type3"];
  DateTime dob;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool autoValidate = false;

  final ageController =
      TextEditingController(text: AppPreferences().userInfo.age.toString());
  final firstNameController =
      TextEditingController(text: AppPreferences().userInfo.firstName);
  final lastNameController =
      TextEditingController(text: AppPreferences().userInfo.lastName);
  final address1Controller =
      TextEditingController(text: AppPreferences().userInfo.addressLine1);
  final address2Controller =
      TextEditingController(text: AppPreferences().userInfo.addressLine2);
  final cityController =
      TextEditingController(text: AppPreferences().userInfo.city);
  final countyController = TextEditingController();
  final stateController =
      TextEditingController(text: AppPreferences().userInfo.stateName);
  final zipController =
      TextEditingController(text: AppPreferences().userInfo.zipCode);
  final emailController =
      TextEditingController(text: AppPreferences().userInfo.emailId);
  String dateChoosen = "Date";
  // final phoneController = TextEditingController(
  //     text: AppPreferences()
  //         .phoneNo
  //         .substring(2, AppPreferences().phoneNo.length));

  var phoneController; // = TextEditingController(
  //     text: AppPreferences()
  //         .phoneNo
  //         ?.substring(AppPreferences().phoneNo.length - 10));

  bool hasPaymentEnabled = false;

  final data = {
    "firstName": AppPreferences().userInfo.firstName,
    "lastName": AppPreferences().userInfo.lastName,
    "gender": AppPreferences().userInfo.gender,
    "dobString": AppPreferences().userInfo.birthDate,
    "age": AppPreferences().userInfo.age.toString(),
    "address1": AppPreferences().userInfo.addressLine1,
    "address2": AppPreferences().userInfo.addressLine2,
    "city": AppPreferences().userInfo.city,
    "state": AppPreferences().userInfo.stateName,
    "zip": AppPreferences().userInfo.zipCode,
    "email": AppPreferences().userInfo.emailId,
    // "phone": "",
    "diabetesType": "",
    "comments": "",
    "countryCodeDialCode": "",
    "phoneCountryCode": AppPreferences()
        .phoneNo
        .substring(0, AppPreferences().phoneNo.length - 2),
  };
  final Map<String, String> errors = {
    "firstName": null,
    "lastName": null,
    // "gender": null,
    "address1": null,
    "city": null,
    'county': null,
    "state": null,
    "zip": null,
    "email": null,
    // "phone": null,
  };

  final Map<String, String> validators = {
    "firstName": "First Name",
    "lastName": "Last Name",
    // "gender": "Gender",
    "address1": "Address 1",
    "city": "City",
    "state": "State",
    "county": "county",
    "zip": "Zip Code",
    "email": "Email",
  };

  bool checkErrors({String testKey}) {
    bool hasError = false;
    if (testKey != null) {
      if (testKey == "email") {
        hasError = RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(data['email']);
      } else {
        if (data[testKey] == null || data[testKey].length == 0) {
          hasError = true;
          errors[testKey] = "${validators[testKey]} cannot be empty";
        } else {
          errors[testKey] = null;
        }
      }
      setState(() {});
      return hasError;
    }
    for (String key in errors.keys) {
      if (data[key] == null || data[key].length == 0) {
        hasError = true;
        errors[key] = "${validators[key]} cannot be empty";
      } else {
        errors[key] = null;
      }
    }
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(data['email']);
    if (!emailValid) errors['email'] = "Invalid email";
    setState(() {});
    return hasError || !emailValid;
  }

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
        // DateTime dateChoosen1 = formatter.parse(date.toString());
        // dateChoosen = dateChoosen1.toString();

        dob = date;
        data['age'] = getUserAge(date).toString();
        ageController.text = data['age'];
        dateChoosen = formatter.format(date);
      });
    },
        currentTime: DateTime.now(),
        locale:
            /*AppPreferences().isLanguageTamil() ? LocaleType.ta :*/ LocaleType
                .en);
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
    setState(() {
      ageController.text = age.toString();
    });

    return age;
  }

  @override
  void initState() {
    setPhoneNumber();
    _eventBloc = EventsBloc(context);
    final savedDobString = AppPreferences().userInfo.birthDate;
    if (savedDobString != null && savedDobString.length == 8) {
      try {
        setState(() {
          dob = formatter.parse(savedDobString);
          data['age'] = getUserAge(dob).toString();
          ageController.text = data['age'];
        });
      } catch (e) {
        // print(e);
      }
    }

    super.initState();
    initializeAd();
  }

  setPhoneNumber() async {
    UserInfo userInfo = await AppPreferences.getUserInfo();
    setState(() {
      phoneController = TextEditingController(
          text: (userInfo.countryCodeValue != null)
              ? userInfo.mobileNo.substring(userInfo.countryCodeValue.length)
              : userInfo.mobileNo);
    });
  }

  @override
  Widget build(BuildContext context) {
    AppPreferences().setContext(context);
    AppPreferences().setGlobalContext(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: hasPaymentEnabled
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 380,
                        //height: 280,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    topRight: Radius.circular(30.0)),
                                child: Container(
                                  //color: AppColors.primaryColor,
                                  color: Color(0xFF1A237E),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 24.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text("Payment method",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          IconButton(
                                              icon: Icon(Icons.clear),
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        PaymentCancellationDialog(
                                                          onTap: () {
                                                            setState(() {
                                                              hasPaymentEnabled =
                                                                  false;
                                                            });
                                                          },
                                                        ));
                                              },
                                              color: Colors.white),
                                        ],
                                      ),
                                    ],
                                  ),
                                )),
                            Expanded(
                              child: Container(
                                color: AppColors.primaryColor,
                                child: Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.all(16.0),
                                  height: MediaQuery.of(context).size.height *
                                      1 /
                                      1.6,
                                  child: PaymentsWidget(
                                    totalAmount: getTotalAmount(),
                                    name: AppPreferences().username,
                                    isOnlyCard: true,
                                    email: emailController.text,
                                    phoneNumber: phoneController.text,
                                    departmentName:
                                        widget.eventFeed.eventDepartment,
                                    paymentDescription:
                                        "Event Fee for ${widget.eventFeed.eventName}",
                                    paymentStatus: (bool payStatus,
                                        String paymentMode,
                                        String requestId) async {
                                      // debugPrint("event payStatus --> $payStatus");
                                      // debugPrint(
                                      //     "event paymentMode --> $paymentMode");
                                      // debugPrint("event requestId --> $requestId");
                                      setState(() {
                                        hasPaymentEnabled = false;
                                      });

                                      if (payStatus) {
                                        _doEventRegisteration();
                                      }
                                    },
                                    transactionType: TransactionType.EVENT,
                                    globalKey: _scaffoldKey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Form(
                    key: formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTitleContainer(),
                        buildFormTitle(),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                                    child: TextField(
                                      controller: firstNameController,
                                      decoration: InputDecoration(
                                        errorText: errors['firstName'],
                                        border: OutlineInputBorder(),
                                        labelText: "First Name",
                                      ),
                                      onChanged: (newVal) {
                                        data["firstName"] = newVal;
                                        checkErrors(testKey: "firstName");
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: TextField(
                                      controller: lastNameController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "Last Name",
                                        errorText: errors['lastName'],
                                      ),
                                      onChanged: (newVal) {
                                        data["lastName"] = newVal;
                                        checkErrors(testKey: "lastName");
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Container(
                                      height: 50,
                                      child: Center(
                                        child: Row(
                                          children: [
                                            Flexible(
                                              flex: 4,
                                              fit: FlexFit.tight,
                                              child: Text("Gender"),
                                            ),
                                            Flexible(
                                              flex: 3,
                                              fit: FlexFit.tight,
                                              child: Row(
                                                children: [
                                                  Radio<String>(
                                                    groupValue: data['gender'],
                                                    value: "Male",
                                                    onChanged: (newVal) {
                                                      setState(() {
                                                        data['gender'] = newVal;
                                                      });
                                                    },
                                                  ),
                                                  Text("Male"),
                                                ],
                                              ),
                                            ),
                                            Flexible(
                                              flex: 3,
                                              fit: FlexFit.tight,
                                              child: Row(
                                                children: [
                                                  Radio<String>(
                                                    groupValue: data['gender'],
                                                    value: "Female",
                                                    onChanged: (newVal) {
                                                      setState(() {
                                                        data['gender'] = newVal;
                                                      });
                                                    },
                                                  ),
                                                  Text("Female"),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          flex: 3,
                                          fit: FlexFit.tight,
                                          child: Text("Date of birth"),
                                        ),
                                        Flexible(
                                          flex: 4,
                                          fit: FlexFit.tight,
                                          child: InkWell(
                                            onTap: () async {
                                              openDateSelector();
                                            },
                                            child: Container(
                                              height: 60,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Flexible(
                                                      flex: 1,
                                                      fit: FlexFit.tight,
                                                      child: Text(
                                                        AppPreferences()
                                                                        .userInfo
                                                                        .birthDate ==
                                                                    null ||
                                                                AppPreferences()
                                                                    .userInfo
                                                                    .birthDate
                                                                    .isEmpty
                                                            ? dateChoosen
                                                            : AppPreferences()
                                                                .userInfo
                                                                .birthDate,
                                                        style: TextStyle(
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                    ),
                                                    Icon(Icons.calendar_today),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          flex: 3,
                                          fit: FlexFit.tight,
                                          child: Text("Age"),
                                        ),
                                        Flexible(
                                          flex: 4,
                                          fit: FlexFit.tight,
                                          child: TextField(
                                            keyboardType: TextInputType.number,
                                            controller: ageController,
                                            readOnly: true,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: "Age",
                                              // errorText: errors['age'],
                                            ),
                                            onChanged: (newVal) {
                                              data["age"] = newVal;
                                              // checkErrors(testKey: "lastName");
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: TextField(
                                      controller: address1Controller,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: AppPreferences()
                                                .setAddress2ForDonation
                                            ? "Address 1"
                                            : "Address",
                                        errorText: errors['address1'],
                                      ),
                                      onChanged: (newVal) {
                                        data["address1"] = newVal;
                                        checkErrors(testKey: "address1");
                                      },
                                    ),
                                  ),

                                  AppPreferences().setAddress2ForDonation
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 8),
                                          child: TextField(
                                            controller: address2Controller,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: "Address 2",
                                              // errorText: errors['address2'],
                                            ),
                                            onChanged: (newVal) {
                                              // data["address2"] = newVal;
                                              // checkErrors();
                                            },
                                          ),
                                        )
                                      : SizedBox.shrink(),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: TextFormField(
                                      controller: cityController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "City",
                                        errorText: errors['city'],
                                      ),
                                      onChanged: (newVal) {
                                        data["city"] = newVal;
                                        checkErrors(testKey: "city");
                                      },
                                      validator: ValidationUtils.cityValidation,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: TextFormField(
                                      controller: stateController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "State/Province",
                                        errorText: errors['state'],
                                      ),
                                      onChanged: (newVal) {
                                        data["state"] = newVal;
                                        checkErrors(testKey: "state");
                                      },
                                      validator:
                                          ValidationUtils.stateValidation,
                                    ),
                                  ),
                                  AppPreferences().setcountyEnabledforDonataion
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 8),
                                          child: TextFormField(
                                              controller: countyController,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: AppPreferences()
                                                        .setcountyEnabledforDonataion
                                                    ? AppPreferences()
                                                        .countyLabelDonation
                                                    : "County",
                                                // errorText: errors['state'],
                                              ),
                                              onChanged: (newVal) {
                                                // data["county"] = newVal;
                                                // checkErrors(testKey: "county");
                                              },
                                              validator: ValidationUtils
                                                  .countyValidation),
                                        )
                                      : SizedBox.shrink(),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: TextFormField(
                                      controller: zipController,
                                      //enabled: false,
                                      //maxLength: 13,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: AppPreferences()
                                                      .setzipcodeLabelDonation ==
                                                  null
                                              ? AppLocalizations.of(context)
                                                  .translate("key_zip")
                                              : AppPreferences()
                                                  .setzipcodeLabelDonation),
                                      keyboardType: AppPreferences()
                                                      .setzipcodeLabelDonation ==
                                                  null ||
                                              AppPreferences()
                                                      .setzipcodeValidationDonation ==
                                                  "NUMBER-ONLY"
                                          ? TextInputType.number
                                          : TextInputType.text,

                                      inputFormatters: [
                                        if (AppPreferences()
                                                .setzipcodeValidationDonation ==
                                            "ALPHA-ONLY")
                                          FilteringTextInputFormatter.allow(
                                              RegExp("[A-Za-z]"))
                                        else if (AppPreferences()
                                                .setzipcodeValidationDonation ==
                                            "NUMBER-ONLY")
                                          FilteringTextInputFormatter.allow(
                                              RegExp("[0-9]"))
                                        else
                                          FilteringTextInputFormatter.allow(
                                              RegExp("[A-Za-z0-9]")),
                                        LengthLimitingTextInputFormatter(
                                            int.parse(AppPreferences()
                                                .zipcodeLengthDonation)),
                                      ],
                                      validator: (String value) {
                                        if (AppPreferences()
                                                .setzipcodeValidationDonation ==
                                            "NO VALIDATION") {
                                          return null;
                                        } else {
                                          if (value.isEmpty)
                                            return AppPreferences()
                                                        .setzipcodeLabelDonation ==
                                                    null
                                                ? AppLocalizations.of(context)
                                                        .translate("key_zip") +
                                                    " cannot be blank"
                                                : AppPreferences()
                                                        .setzipcodeLabelDonation +
                                                    " cannot be blank";
                                          else {
                                            if (value.length < 1)
                                              return "At least 1 digits";
                                            else
                                              return null;
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: TextField(
                                      controller: emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "Email",
                                        errorText: errors['email'],
                                      ),
                                      onChanged: (newVal) {
                                        data["email"] = newVal;
                                        checkErrors(testKey: "email");
                                      },
                                    ),
                                  ),
                                  PhoneNoWidget(
                                    phoneController: phoneController,
                                    countryCode: data["countryCodeDialCode"],
                                    country: AppPreferences().country,
                                    onChanged: (code) {
                                      setState(() {
                                        data["countryCodeDialCode"] =
                                            code.dialCode;
                                        data["phoneCountryCode"] = code.code;
                                      });
                                    },
                                    onInitCallback: (code) {
                                      data["countryCodeDialCode"] =
                                          code.dialCode;
                                      data["phoneCountryCode"] = code.code;
                                    },
                                    codeReadOnly: false,
                                    numberReadOnly: false,
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(bottom: 8),
                                  //   child: InkWell(
                                  //     onTap: () {
                                  //       showDiabetesTypeChooser();
                                  //     },
                                  //     child: Container(
                                  //       height: 60,
                                  //       decoration: BoxDecoration(
                                  //           border: Border.all(color: Colors.grey),
                                  //           borderRadius: BorderRadius.circular(4)),
                                  //       child: Align(
                                  //         alignment: Alignment.centerLeft,
                                  //         child: Padding(
                                  //           padding: const EdgeInsets.only(
                                  //               left: 10, right: 10),
                                  //           child: Row(
                                  //             children: [
                                  //               Expanded(
                                  //                   child: Text(
                                  //                       data["diabetesType"].length == 0
                                  //                           ? "Diabetes Type"
                                  //                           : data["diabetesType"])),
                                  //               Icon(Icons.arrow_drop_down),
                                  //             ],
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "Comments",
                                        errorText: errors['comments'],
                                      ),
                                      onChanged: (newVal) {
                                        data["comments"] = newVal;
                                        // checkErrors();
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Builder(
                                      builder: (context) => FlatButton(
                                        color: Color(0xFF1a49a0),
                                        colorBrightness: Brightness.dark,
                                        child: Text((widget
                                                        .eventFeed?.paidEvent !=
                                                    null &&
                                                // ignore: null_aware_in_logical_operator
                                                widget.eventFeed?.paidEvent)
                                            ? "Pay & Register"
                                            : "Register Now"),
                                        onPressed: () async {
                                          if (checkErrors() &&
                                              formKey.currentState.validate()) {
                                            if (widget.eventFeed?.paidEvent !=
                                                    null &&
                                                // ignore: null_aware_in_logical_operator
                                                widget.eventFeed?.paidEvent) {
                                              setState(() {
                                                hasPaymentEnabled = true;
                                              });
                                            } else {
                                              _doEventRegisteration();
                                            }
                                          } else {
                                            // _doEventRegisteration();
                                            setState(() {
                                              autoValidate = true;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
          ),

          /// Show Banner Ad
          getSivisoftAdWidget(),
        ],
      ),
    );
  }

  getTotalAmount() {
    double amount = 0;
    if (widget.event.registrationType == "Session Wise") {
      for (var i = 0; i < widget.eventFeed.sessions.length; i++) {
        if (widget.eventFeed.sessions[i].sessionName ==
            widget.event.sessionName) {
          amount = widget.eventFeed.sessions[i].eventFee == null
              ? 0
              : widget.eventFeed.sessions[i].eventFee;
        }
      }
    } else {
      // print(
      //     "===================>   ${widget.eventFeed.eventFee}  ${widget.eventFeed.eventFee != null}");
      amount = widget.eventFeed.eventFee != null &&
              widget.eventFeed.eventFee != "null"
          ? double.tryParse(widget.eventFeed.eventFee.toString())
          : 0;
    }
    return amount;
  }

  _doEventRegisteration() async {
    showDialog(
      context: context,
      builder: (context) => Container(
        color: Colors.black.withAlpha(128),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
    final success = await _eventBloc.registerEvent(event);
    Navigator.of(context).pop();
    if (success) {
      // widget.refresh();
      // Navigator.of(context).pop();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => NavigationHomeScreen(
                    drawerIndex: Constants.PAGE_ID_EVENTS_LIST,
                  )),
          ModalRoute.withName(Routes.navigatorHomeScreen));
    } else {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Error registering")));
    }
  }

  Widget buildFormTitle() {
    return Padding(
      padding: const EdgeInsets.all(11.0),
      child: Text(
        "Registration Form",
        style: TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }

  Widget buildTitleContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Container(
        //   margin: const EdgeInsets.all(8).copyWith(right: 18),
        //   height: 70,
        //   width: 70,
        //   decoration: BoxDecoration(
        //     color: Colors.orange,
        //     borderRadius: BorderRadius.circular(35),
        //   ),
        // ),
        Flexible(
          child: Text(
            event.eventName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w100,
            ),
          ),
        ),
      ],
    );
  }

  showDiabetesTypeChooser() async {
    final newType = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Diabetes Type"),
        content: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: diabetesTypes
                .map(
                  (e) => FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop<String>(e);
                    },
                    child: Container(
                      width: double.infinity,
                      child: Text(e),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        actions: [
          FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"))
        ],
      ),
    );
    if (newType != null)
      setState(() {
        data["diabetesType"] = newType;
      });
  }

  Widget buildAppBar() {
    return CustomAppBar(
      pageId: Constants.PAGE_ID_EVENT_DETAILS,
      title: "Event Registration",
    );
  }
}
