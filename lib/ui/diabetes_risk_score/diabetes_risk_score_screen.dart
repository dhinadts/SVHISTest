import '../../country_picker_util/country_code_picker.dart';
import '../../login/utils/custom_progress_dialog.dart';
import '../../model/user_info.dart';
import '../../ui/advertise/adWidget.dart';
import '../../ui/custom_drawer/custom_app_bar.dart';
import '../../ui/diabetes_risk_score/model/answers_data.dart';
import '../../ui/diabetes_risk_score/model/health_score.dart';
import '../../ui/diabetes_risk_score/repository/diabetes_risk_score_api_client.dart';
import '../../ui/diabetes_risk_score/repository/diabetes_risk_score_repository.dart';
import '../../ui/diabetes_risk_score/widgets/diabetes_risk_result_widget.dart';
import '../../ui/diabetes_risk_score/widgets/diabetes_score_item.dart';
import '../../ui/tabs/app_localizations.dart';
import '../../ui_utils/app_colors.dart';
import '../../ui_utils/icon_utils.dart';
import '../../ui_utils/text_styles.dart';
import '../../utils/app_preferences.dart';
import '../../utils/constants.dart';
import '../../utils/validation_utils.dart';
import '../../widgets/submit_button.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DiabetesRiskScoreScreen extends StatefulWidget {
  final HealthScore healthScoreData;
  final UserInfo userInfo;
  final bool isProspect;

  DiabetesRiskScoreScreen({
    this.healthScoreData,
    this.userInfo,
    this.isProspect: false,
  });

  @override
  _DiabetesRiskScoreScreenState createState() =>
      new _DiabetesRiskScoreScreenState();
}

class _DiabetesRiskScoreScreenState extends State<DiabetesRiskScoreScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  int _howOldValue = 0;
  int _genderValue = 0;
  int _ethnicValue = 0;
  int _familyValue = 5;
  int _waistValue = 0;
  int _bmiValue = 0;
  int _bloodPressureValue = 5;
  String _riskLevel = '';
  String _chanceDiabetes = '';
  String _chanceGlucose = '';
  String _needToDo = '';
  bool readonly = false;
  String countryCode;
  String countryCodePhone = "";
  String countryDialCodePhone = "";
  TextEditingController _pointsController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  DiabetesRiskScoreRepository _diabetesRiskScoreRepository;
  AdmobBannerSize bannerSize;

  @override
  void initState() {
    super.initState();
    // debugPrint("Country code --> ${AppPreferences().country}");
    //debugPrint("people --> ${widget.userInfo?.toJson()}");
    _diabetesRiskScoreRepository = DiabetesRiskScoreRepository(
      diabetesRiskScoreApiClient: DiabetesRiskScoreApiClient(
        httpClient: http.Client(),
      ),
    );
    if (widget.healthScoreData != null) {
      _dateController.text =
          DateUtils.convertUTCToLocalTime(widget.healthScoreData.createdOn);
    } else {
      _dateController.text =
          DateFormat(DateUtils.formatCheckIn).format(DateTime.now());
    }

    if (widget.healthScoreData != null) {
      //setState(() {
      setHealthScoreData();
      //});
    } else if (widget.userInfo != null) {
      _userNameController.text =
          "${widget.userInfo.firstName} ${widget.userInfo.lastName}";
    } else if (!widget.isProspect) {
      _userNameController.text =
          "${AppPreferences().userInfo.firstName} ${AppPreferences().userInfo.lastName}";
    }
    if (widget.isProspect) {
      AppPreferences.getUserInfo()?.then((value) {
        // print("user info = " + value.toJson().toString());
        setState(() {
          countryCode = value?.countryCode ?? AppPreferences().country;
          // print("user info = CC $countryCode");
        });
      });
    }

    /// Ads initialization
    initializeAd();
  }

  setHealthScoreData() {
    _userNameController.text =
        "${widget.healthScoreData.firstName} ${widget.healthScoreData.lastName}";
    _pointsController.text = widget.healthScoreData.scorePoints.toString();
    _riskLevel = widget.healthScoreData.riskLevel;
    _howOldValue = int.tryParse(widget.healthScoreData.answers.age ?? '0') ?? 0;
    _genderValue =
        int.tryParse(widget.healthScoreData.answers.gender ?? '0') ?? 0;
    _bloodPressureValue =
        int.tryParse(widget.healthScoreData.answers.bloodPressure ?? '5') ?? 5;
    _bmiValue =
        int.tryParse(widget.healthScoreData.answers.bmiRange ?? '0') ?? 0;
    _ethnicValue =
        int.tryParse(widget.healthScoreData.answers.ethnicBackground ?? '0') ??
            0;
    _waistValue =
        int.tryParse(widget.healthScoreData.answers.waistRange ?? '0') ?? 0;
    _familyValue =
        int.tryParse(widget.healthScoreData.answers.familyDiabetes ?? '5') ?? 5;

    if (widget.isProspect) {
      _firstNameController.text = widget.healthScoreData.firstName;
      _lastNameController.text = widget.healthScoreData.lastName;
      _emailController.text = widget.healthScoreData.emailId;
      _phoneController.text = widget.healthScoreData.mobileNo;
      countryCodePhone = widget.healthScoreData.countryCode;
      countryDialCodePhone = widget.healthScoreData.countryCodeValue;
    }
    readonly = true;
  }

  @override
  void dispose() {
    _pointsController.dispose();
    _userNameController.dispose();
    _dateController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppPreferences().setGlobalContext(context);
    updatePointsValue();
    return Scaffold(
      appBar: //(AppPreferences().role == Constants.supervisorRole)
          //?
          CustomAppBar(
        title:
            AppLocalizations.of(context).translate("key_diabetes_risk_title"),
        pageId: Constants.PAGE_ID_DIABETES_RISK_SCORE_TAB,
      ),
      //: null,
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
              child: SingleChildScrollView(
                child: formUI(),
              ),
            ),
          ),

          /// Show Banner ad
          getSivisoftAdWidget(),
        ],
      ),
    );
  }

  Widget formUI() {
    final screenWidth = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      autovalidate: _autoValidate,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10, right: 10, left: 10),
            child: Visibility(
              visible: widget.isProspect,
              child: Column(
                children: [
                  TextFormField(
                    readOnly: readonly,
                    controller: _firstNameController,
                    style: TextStyles.mlDynamicTextStyle,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: AppLocalizations.of(context)
                            .translate("key_first_name"),
                        errorMaxLines: 2),
                    keyboardType: TextInputType.text,
                    validator: ValidationUtils.firstNameValidation,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    readOnly: readonly,
                    controller: _lastNameController,
                    style: TextStyles.mlDynamicTextStyle,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: AppLocalizations.of(context)
                            .translate("key_last_name"),
                        errorMaxLines: 2),
                    keyboardType: TextInputType.text,
                    validator: ValidationUtils.lastNameValidation,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    readOnly: readonly,
                    controller: _emailController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: AppLocalizations.of(context)
                            .translate("key_email_address"),
                        errorMaxLines: 2),
                    validator: ValidationUtils.emailValidation,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          child: Container(
                        width: MediaQuery.of(context).size.width / 7,
                        child: Stack(children: <Widget>[
                          TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 7),
                            child: Center(
                              child: CountryCodePicker(
                                  enabled: !readonly,
                                  onChanged: _oncountryCodePhoneChanged,
                                  showCountryOnly: false,
                                  showOnlyCountryWhenClosed: false,
                                  // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                  initialSelection: (countryCodePhone != null &&
                                          countryCodePhone.isNotEmpty)
                                      ? countryCodePhone
                                      : AppPreferences().country,
                                  showFlag: true,
                                  showFlagDialog: true,
                                  onInit: (code) {
                                    countryCodePhone = code.code;
                                    countryDialCodePhone = code.dialCode;
                                    //print("countryDialCodePhone $countryDialCodePhone");
                                  }),
                            ),
                          )
                        ]),
                      )),
                      SizedBox(
                        width: 1,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.6,
                        child: TextFormField(
                          controller: _phoneController,
                          maxLength: 10,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: AppLocalizations.of(context)
                                  .translate("key_phone")),
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly,
                          ],
                          validator: ValidationUtils.mobileValidation,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              replacement: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: Text(AppLocalizations.of(context)
                            .translate("key_name"))),
                    Container(
                      width: screenWidth / 2,
                      child: IgnorePointer(
                          child: TextFormField(
                              readOnly: true,
                              enableInteractiveSelection: false,
                              controller: _userNameController,
                              decoration: InputDecoration(
                                labelText: "",
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                //fillColor: Colors.green
                              ),
                              keyboardType: TextInputType.text,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey))),
                    )
                  ]),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(AppLocalizations.of(context)
                      .translate("key_reported_date")),
                ),
                Container(
                    width: screenWidth / 2,
                    padding: EdgeInsets.only(right: 0),
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: <Widget>[
                        IgnorePointer(
                          child: TextFormField(
                              readOnly: true,
                              enableInteractiveSelection: false,
                              controller: _dateController,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)
                                    .translate("key_selectdate"),
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                //fillColor: Colors.green
                              ),
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                  color: AppColors.warmGrey, fontSize: 14)),
                        ),
                        GestureDetector(
                            onTap: () => {
                                  /*if (!readOnly) _selectDate(context)*/
                                },
                            child: Container(
                                padding: EdgeInsets.only(right: 5),
                                alignment: Alignment.centerRight,
                                child: Icon(Icons.calendar_today)))
                      ],
                    ))
                //Icon(Icons.calendar_today)
              ],
            ),
          ),
          Divider(
            color: AppColors.borderLine,
            thickness: 1.0,
          ),
          SizedBox(
            height: 10.0,
          ),
          DiabetesScoreItem(
            groupValue: _howOldValue,
            onChanged: readonly ? null : onHowOldRadioChange,
            titleText: AppLocalizations.of(context).translate("key_how_old"),
            optionTextOne: AppLocalizations.of(context).translate("key_forty"),
            optionValueOne: 0,
            optionTextTwo: AppLocalizations.of(context).translate("key_fifty"),
            optionValueTwo: 5,
            optionTextThree:
                AppLocalizations.of(context).translate("key_sixty"),
            optionValueThree: 9,
            optionTextFour:
                AppLocalizations.of(context).translate("key_seventy"),
            optionValueFour: 13,
          ),
          DiabetesScoreItem(
            groupValue: _genderValue,
            onChanged: readonly ? null : onGenderChange,
            titleText:
                AppLocalizations.of(context).translate("key_gender_selection"),
            optionTextOne: AppLocalizations.of(context).translate("key_female"),
            optionValueOne: 0,
            optionTextTwo: AppLocalizations.of(context).translate("key_male"),
            optionValueTwo: 1,
          ),
          DiabetesScoreItem(
            groupValue: _ethnicValue,
            onChanged: readonly ? null : onEthnicChange,
            titleText:
                AppLocalizations.of(context).translate("key_ethnic_background"),
            optionTextOne:
                AppLocalizations.of(context).translate("key_only_white"),
            optionValueOne: 0,
            optionTextTwo:
                AppLocalizations.of(context).translate("key_other_ethnic"),
            optionValueTwo: 6,
          ),
          DiabetesScoreItem(
            groupValue: _familyValue,
            onChanged: readonly ? null : onFamilyChange,
            titleText: AppLocalizations.of(context).translate("key_family"),
            optionTextOne: AppLocalizations.of(context).translate("key_yes"),
            optionValueOne: 5,
            optionTextTwo: AppLocalizations.of(context).translate("key_no"),
            optionValueTwo: 0,
          ),
          DiabetesScoreItem(
            groupValue: _waistValue,
            onChanged: readonly ? null : onWaistChange,
            titleText:
                AppLocalizations.of(context).translate("key_person_waist"),
            optionTextOne:
                AppLocalizations.of(context).translate("key_ninety_less"),
            optionValueOne: 0,
            optionTextTwo: AppLocalizations.of(context).translate("key_ninety"),
            optionValueTwo: 4,
            optionTextThree:
                AppLocalizations.of(context).translate("key_hundred"),
            optionValueThree: 6,
            optionTextFour:
                AppLocalizations.of(context).translate("key_hundred_ten"),
            optionValueFour: 9,
          ),
          DiabetesScoreItem(
            groupValue: _bmiValue,
            onChanged: readonly ? null : onBMIChange,
            titleText: AppLocalizations.of(context).translate("key_bmi"),
            optionTextOne:
                AppLocalizations.of(context).translate("key_twenty_five_less"),
            optionValueOne: 0,
            optionTextTwo:
                AppLocalizations.of(context).translate("key_twenty_five"),
            optionValueTwo: 3,
            optionTextThree:
                AppLocalizations.of(context).translate("key_thirty"),
            optionValueThree: 5,
            optionTextFour:
                AppLocalizations.of(context).translate("key_thirty_five"),
            optionValueFour: 8,
          ),
          DiabetesScoreItem(
            groupValue: _bloodPressureValue,
            onChanged: readonly ? null : onBloodPressureChange,
            titleText:
                AppLocalizations.of(context).translate("key_blood_pressure"),
            optionTextOne: AppLocalizations.of(context).translate("key_yes"),
            optionValueOne: 5,
            optionTextTwo: AppLocalizations.of(context).translate("key_no"),
            optionValueTwo: 0,
          ),
          Row(
            children: [
              Flexible(
                flex: 2,
                child: Text(
                  AppLocalizations.of(context).translate("key_your_score"),
                  style: TextStyles.textStyle4,
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                flex: 2,
                child: Card(
                  child: TextField(
                    controller: _pointsController,
                    textAlign: TextAlign.center,
                    enabled: false,
                    style: TextStyle(),
                  ),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Flexible(
                child: Text(
                  AppLocalizations.of(context).translate("key_points"),
                  style: TextStyles.textStyle4,
                ),
              ),
            ],
          ),
          DiabetesRiskResultWidget(
            riskTitle: AppLocalizations.of(context).translate("key_risk_level"),
            riskResult: _riskLevel,
          ),
          DiabetesRiskResultWidget(
            riskTitle: AppLocalizations.of(context).translate("key_chances"),
            riskResult: _chanceDiabetes,
          ),
          DiabetesRiskResultWidget(
            riskTitle: AppLocalizations.of(context).translate("key_glucose"),
            riskResult: _chanceGlucose,
          ),
          DiabetesRiskResultWidget(
            riskTitle: AppLocalizations.of(context).translate("key_need_to_do"),
            riskResult: _needToDo,
            isChangeTextColor: true,
          ),
          SizedBox(
            height: 20.0,
          ),
          Visibility(
            visible: widget.healthScoreData == null,
            child: Column(
              children: [
                SubmitButton(
                  text: AppLocalizations.of(context).translate("key_submit"),
                  onPress: () async {
                    if (_formKey.currentState.validate()) {
                      CustomProgressLoader.showLoader(context);
                      HealthScore healthScore = HealthScore();
                      healthScore.active = true;

                      healthScore.departmentName =
                          AppPreferences().deptmentName;
                      healthScore.active = true;
                      healthScore.scorePoints =
                          double.tryParse(_pointsController.text) ?? 0;
                      healthScore.riskLevel = _riskLevel;
                      healthScore.answers = AnswersData(
                        age: _howOldValue.toString(),
                        gender: _genderValue.toString(),
                        bloodPressure: _bloodPressureValue.toString(),
                        bmiRange: _bmiValue.toString(),
                        ethnicBackground: _ethnicValue.toString(),
                        waistRange: _waistValue.toString(),
                        familyDiabetes: _familyValue.toString(),
                      );

                      if (AppPreferences().role == Constants.supervisorRole) {
                        healthScore.countryCode = widget.isProspect
                            ? countryCodePhone
                            : widget.userInfo.countryCode;
                        healthScore.countryCodeValue = widget.isProspect
                            ? countryDialCodePhone
                            : widget.userInfo.countryCodeValue;
                        healthScore.emailId = widget.isProspect
                            ? _emailController.text
                            : widget.userInfo.emailId;
                        healthScore.firstName = widget.isProspect
                            ? _firstNameController.text
                            : widget.userInfo.firstName;
                        healthScore.lastName = widget.isProspect
                            ? _lastNameController.text
                            : widget.userInfo.lastName;
                        healthScore.mobileNo = widget.isProspect
                            ? _phoneController.text
                            : widget.userInfo.mobileNo;
                      } else {
                        await AppPreferences.getUserInfo()?.then((value) {
                          healthScore.countryCode = value.countryCode;
                          healthScore.countryCodeValue = value.countryCodeValue;
                          healthScore.emailId = value.emailId;
                          healthScore.firstName = value.firstName;
                          healthScore.lastName = value.lastName;
                          healthScore.mobileNo = value.mobileNo;
                          healthScore.userFullName = value.userFullName;
                        });
                      }

                      if (widget.isProspect) {
                        healthScore.isProspect = true;
                      } else {
                        healthScore.isProspect = false;
                        if (AppPreferences().role == Constants.supervisorRole) {
                          healthScore.userName = widget.userInfo.userName;
                        } else {
                          healthScore.userName = AppPreferences().username;
                        }
                      }

                      if (AppPreferences().role == Constants.supervisorRole) {
                        healthScore.recommendedBy = "Supervisor";
                      } else {
                        healthScore.recommendedBy = "User";
                      }

                      // debugPrint(
                      // "healthScore info --> ${healthScore.toJson()}");

                      Map<String, dynamic> healthScoreDetails =
                          healthScore.toJson();
                      try {
                        await _diabetesRiskScoreRepository.createHealthScore(
                          healthScoreDetails: healthScoreDetails,
                        );
                        CustomProgressLoader.cancelLoader(context);
                        await Fluttertoast.showToast(
                            msg: 'Created Successfully',
                            gravity: ToastGravity.TOP,
                            toastLength: Toast.LENGTH_LONG);
                        Navigator.pop(context, true);
                      } catch (e) {
                        CustomProgressLoader.cancelLoader(context);
                      }
                    } else {
                      setState(() {
                        _autoValidate = true;
                      });
                    }
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _oncountryCodePhoneChanged(CountryCode country) async {
    countryCodePhone = country.code;
    countryDialCodePhone = country.dialCode;
  }

  onHowOldRadioChange(newValue) {
    setState(() {
      _howOldValue = newValue;
    });
    updatePointsValue();
  }

  onGenderChange(newValue) {
    setState(() {
      _genderValue = newValue;
    });
    updatePointsValue();
  }

  onEthnicChange(newValue) {
    setState(() {
      _ethnicValue = newValue;
    });
    updatePointsValue();
  }

  onFamilyChange(newValue) {
    setState(() {
      _familyValue = newValue;
    });
    updatePointsValue();
  }

  onWaistChange(newValue) {
    setState(() {
      _waistValue = newValue;
    });
    updatePointsValue();
  }

  onBMIChange(newValue) {
    setState(() {
      _bmiValue = newValue;
    });
    updatePointsValue();
  }

  onBloodPressureChange(newValue) {
    setState(() {
      _bloodPressureValue = newValue;
    });
    updatePointsValue();
  }

  updatePointsValue() {
    setState(() {
      _pointsController.text = (_howOldValue +
              _genderValue +
              _ethnicValue +
              _familyValue +
              _waistValue +
              _bmiValue +
              _bloodPressureValue)
          .toString();
    });
    setResult(int.tryParse(_pointsController.text) ?? 0);
  }

  setResult(int riskPoints) {
    if (riskPoints >= 0 && riskPoints <= 6) {
      _riskLevel = AppLocalizations.of(context).translate("key_risk_low");
      _chanceDiabetes =
          AppLocalizations.of(context).translate("key_chances_one");
      _chanceGlucose =
          AppLocalizations.of(context).translate("key_glucose_one");
      _needToDo = AppLocalizations.of(context).translate("key_need_one");
    } else if (riskPoints >= 7 && riskPoints <= 15) {
      _riskLevel = AppLocalizations.of(context).translate("key_risk_increased");
      _chanceDiabetes =
          AppLocalizations.of(context).translate("key_chances_two");
      _chanceGlucose =
          AppLocalizations.of(context).translate("key_glucose_two");
      _needToDo = AppLocalizations.of(context).translate("key_need_two");
    } else if (riskPoints >= 16 && riskPoints <= 24) {
      _riskLevel = AppLocalizations.of(context).translate("key_risk_moderate");
      _chanceDiabetes =
          AppLocalizations.of(context).translate("key_chances_three");
      _chanceGlucose =
          AppLocalizations.of(context).translate("key_glucose_three");
      _needToDo = AppLocalizations.of(context).translate("key_need_three");
    } else if (riskPoints >= 25) {
      _riskLevel = AppLocalizations.of(context).translate("key_risk_high");
      _chanceDiabetes =
          AppLocalizations.of(context).translate("key_chances_four");
      _chanceGlucose =
          AppLocalizations.of(context).translate("key_glucose_four");
      _needToDo = AppLocalizations.of(context).translate("key_need_four");
    }
    setState(() {});
  }
}
