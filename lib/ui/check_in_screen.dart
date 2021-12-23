import '../bloc/check_in_bloc.dart';
import '../bloc/dynamic_fields_bloc.dart';
import '../login/utils/custom_progress_dialog.dart';
import '../model/check_in_dynamic.dart';
import '../model/dynamic_fields_reponse.dart';
import '../model/passing_arg.dart';
import '../model/work_force_task_model.dart';
import '../ui/people_search/model/bounds.dart';
import '../ui/smart_note/smart_notes_tab_screen.dart';
import '../ui_utils/app_colors.dart';
import '../ui_utils/icon_utils.dart';
import '../ui_utils/ui_dimens.dart';
import '../ui_utils/widget_styles.dart';
import '../utils/alert_utils.dart';
import '../utils/app_preferences.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../utils/validation_utils.dart';
import '../widgets/combo_box_item.dart';
import '../widgets/dynamic_item_input_field.dart';
import '../widgets/notification_loading_widget.dart';
import '../widgets/radio_button_item.dart';
import '../widgets/slider_item.dart';
import '../widgets/submit_button.dart';
import '../widgets/toggle_item.dart';
import '../widgets/work_force_task_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'advertise/adWidget.dart';
import 'custom_drawer/navigation_home_screen.dart';

class CheckInScreen extends StatefulWidget {
  final bool fromDailyStatus;
  final CheckInDynamic checkInDynamic;
  final String username;
  final String userFullName;
  final String departmentName;

  CheckInScreen(this.fromDailyStatus,
      {this.checkInDynamic,
      this.username,
      this.userFullName,
      this.departmentName});

  @override
  CheckInScreenState createState() => CheckInScreenState();
}

class CheckInScreenState extends State<CheckInScreen> {
  CheckInBloc _bloc;
  DynamicFieldsBloc _dynamicFieldsBloc;

  bool _autoValidate = false;
  bool readOnly = false;
  DateTime _selectedDate = DateTime.now();
  bool status = false;
  List<WorkForceTaskModel> workForceModels;
  String userName;
  String oldRangeSystolic, oldRangeDiastolic;
  List<String> rangeList = [
    "LOW",
    "NORMAL",
    "HIGH-NORMAL",
    "Grade 1 HTN",
    "Grade 2 HTN",
    "Severe HTN"
  ];
  TextEditingController userController = TextEditingController();
  TextEditingController otherController = TextEditingController();
  String role = "";

  Map responseMap = {};

  bool isDataLoaded = false;
  List<DynamicFieldsResponse> dynamicFieldsResponse;
  DynamicFieldsResponse bpDynamicFieldsResponseDiastolic,
      bpDynamicFieldsResponseSystolic;

  var dateController = TextEditingController();
  var temperatureController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isViewStatusUpdated = false;

  bool showTemperature = false;
  bool fieldEnabled = false;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.initState();

    _bloc = CheckInBloc(context);
    _dynamicFieldsBloc = DynamicFieldsBloc(context);

    userController.text = widget.username ?? "";
    if (widget.fromDailyStatus && widget.checkInDynamic != null) {
      // print("widget.checkInDynamic --> ${widget.checkInDynamic.toJson()}");
      /*if ((AppPFreferences().role == Constants.supervisorRole) &&
          (widget.checkInDynamic.viewed == null ||
              widget.checkInDynamic.viewed == false)) {
        updateViewedStatus();
      }*/
      _bloc.fetchCheckInDynamicById(
          widget.departmentName, widget.username, widget.checkInDynamic.id);
      _bloc.dynamicFieldsCheckInFetcherWithData.listen((event) {
        dynamicFieldsResponse = event;
        setState(() {
          userController.text = widget.checkInDynamic?.userName;
          dateController.text = DateUtils.convertUTCToLocalTimeCheckIn(
              widget.checkInDynamic.checkInDate);
          if (dynamicFieldsResponse.isNotEmpty &&
              dynamicFieldsResponse[0].domain[0] ==
                  "${Constants.DOMAIN_DATT}") {
            controller.text = "${dynamicFieldsResponse[2].actualValue ?? "0"}";
            controllerDiastolic.text =
                "${dynamicFieldsResponse[1].actualValue ?? "0"}";
            bpDynamicFieldsResponseSystolic = dynamicFieldsResponse[2];
            bpDynamicFieldsResponseDiastolic = dynamicFieldsResponse[1];
            fieldEnabled =
                !((bpDynamicFieldsResponseSystolic.actualValue == null &&
                        bpDynamicFieldsResponseDiastolic.actualValue == null) ||
                    (bpDynamicFieldsResponseSystolic.actualValue == 0.0 &&
                        bpDynamicFieldsResponseDiastolic.actualValue == 0.0));
            // print(
            //     "Condition : ${(bpDynamicFieldsResponseSystolic.actualValue == null && bpDynamicFieldsResponseDiastolic.actualValue == null)}");
            // print(
            //     "Condition 2: ${(bpDynamicFieldsResponseSystolic.actualValue == 0.0 && bpDynamicFieldsResponseDiastolic.actualValue == 0.0)}");
            comparisonCalculation();
          }
          readOnly = true;
          isDataLoaded = true;
        });
      });
    } else {
      _dynamicFieldsBloc.fetchDynamicFieldsCheckIn(
          departmentName: widget.departmentName, username: widget.username);
      _dynamicFieldsBloc.dynamicFieldsCheckInFetcher.listen((event) {
        dynamicFieldsResponse = event;
        setState(() {
          //Set current date
          if (dynamicFieldsResponse.isNotEmpty &&
              dynamicFieldsResponse[0].domain[0] ==
                  "${Constants.DOMAIN_DATT}") {
            controller.text = "${dynamicFieldsResponse[2].actualValue ?? "0"}";
            controllerDiastolic.text =
                "${dynamicFieldsResponse[1].actualValue ?? "0"}";
            bpDynamicFieldsResponseSystolic = dynamicFieldsResponse[2];
            bpDynamicFieldsResponseDiastolic = dynamicFieldsResponse[1];
            fieldEnabled =
                !(bpDynamicFieldsResponseSystolic.actualValue == null &&
                    bpDynamicFieldsResponseDiastolic.actualValue == null);
            //comparisonCalculation();
          }
          dateController.text = DateFormat(DateUtils.dateAndTimeFormatCheckIn)
              .format(_selectedDate.toLocal());
          isDataLoaded = true;
        });
      });
    }

    initializeAd();
  }

  @override
  Widget build(BuildContext context) {
    isAlreadyShown = false;
    final screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, isViewStatusUpdated);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          centerTitle: true,
          title: Text("Log Book Entry"),
          automaticallyImplyLeading: widget.fromDailyStatus ? true : false,
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NavigationHomeScreen()),
                      ModalRoute.withName(Routes.navigatorHomeScreen));
                })
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: (!isDataLoaded)
                  ? Container(
                      margin: new EdgeInsets.only(top: 15.0),
                      child: ListLoading(),
                    )
                  : Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: SingleChildScrollView(
                          child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Column(children: <Widget>[
                          if (AppPreferences().role == Constants.supervisorRole)
                            Padding(
                              padding:
                                  EdgeInsets.only(top: 20, right: 15, left: 15),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Expanded(child: Text("Name")),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.7,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 10),
                                        child: Text(
                                          widget.userFullName ?? "",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ]),
                            ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                    child: Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Text(
                                            widget.fromDailyStatus ?? false
                                                ? "Date Reported"
                                                : "Reporting Start Date"))),
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.7,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 10),
                                    child: Text(
                                      dateController.text
                                              .split("\n")
                                              .join(" ") ??
                                          "",
                                    )),
                              ],
                            ),
                          ),
                          if (bpDynamicFieldsResponseDiastolic != null &&
                              bpDynamicFieldsResponseDiastolic != null)
                            _bloodPressure(),
                          ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: dynamicFieldsResponse.length,
                            itemBuilder: (context, index) {
                              return _createDynamicWidget(
                                  dynamicFieldsResponse[index]);
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (widget.checkInDynamic == null)
                            SubmitButton(
                                text:
                                    widget.fromDailyStatus ? "Submit" : "Next",
                                onPress: () async {
                                  if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                    if (widget.fromDailyStatus) {
                                      if (userController.text ==
                                              widget.checkInDynamic?.userName &&
                                          dateController.text ==
                                              widget.checkInDynamic
                                                  ?.checkInDate) {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    NavigationHomeScreen()),
                                            ModalRoute.withName(
                                                Routes.navigatorHomeScreen));
                                      } else {
                                        // UPDATE functionality API call
                                        createOrUpdate();
                                      }
                                    } else {
                                      print("else");
                                      setState(() {
                                        _autoValidate = true;
                                      });
                                      //CREATE functionality API call
                                      createOrUpdate();
                                    }
                                  } else {
                                    if (workForceModels != null) {
                                      for (int i = 0;
                                          i < workForceModels.length;
                                          i++) {
                                        if (validationWorkForceModel(
                                            workForceModels[i])) {
                                          expControllerList[i].expanded = true;
                                        }
                                      }
                                    }

                                    _bloc.setExpandable(expControllerList);
                                  }
                                }),
                          SizedBox(
                            height: 15,
                          ),
                        ]),
                      ))),
            ),

            /// Show Banner Ad
            getSivisoftAdWidget(),
          ],
        ),
      ),
    );
  }

  _prandialCallBack(String prandialStatus) {
    responseMap["prandiable"] = prandialStatus;
  }

  Future<void> openSmartNoteScreen() async {
    String userName = (userController.text == null || userController.text == "")
        ? await AppPreferences.getUsername()
        : userController.text;
    String deptName = await AppPreferences.getDeptName();
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 30,
              height: MediaQuery.of(context).size.height - 70,
              // padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
              ),
              child: SmartNotesTabScreen(
                  currentUserDepartmentName: deptName,
                  currentUserName: userName),
            ),
          );
        });
  }

  Widget _createDynamicWidget(DynamicFieldsResponse dynamicFieldsResponse) {
    responseMap.putIfAbsent(dynamicFieldsResponse.mappedDBColumn,
        () => dynamicFieldsResponse.defaultValue);

    String displayName = "";
    // Check fieldClassification value, if it is PRIMARY, show display name as it is.
    if (dynamicFieldsResponse.fieldClassification == "PRIMARY" ||
        dynamicFieldsResponse.fieldClassification == "SECONDARY") {
      displayName = dynamicFieldsResponse.fieldDisplayName;
      Widget newWidget;
      if (dynamicFieldsResponse.fieldName == "temperature") {
        newWidget = Visibility(
          visible: showTemperature,
          child: _getDynamicWidget(dynamicFieldsResponse, displayName),
        );
      } else {
        newWidget = _getDynamicWidget(dynamicFieldsResponse, displayName);
      }

      return newWidget;
    }
    //If fieldClassification is not PRIMARY
    else {
      var groupPrimaryNames =
          dynamicFieldsResponse.fieldClassification.split("## ");

      /// Split fieldClassification to find GROUP_PRIMARY and other data
      /// If the the length is equal to 1, then it has no other data.
      if (groupPrimaryNames.length == 1) {
        displayName =
            dynamicFieldsResponse.fieldDisplayName.split("## ").join("\n");
        Widget newWidget =
            _getDynamicWidget(dynamicFieldsResponse, displayName);
        return newWidget;
      }

      /// If the length is greater than 1, we need to show other data value as caption
      else {
        displayName =
            dynamicFieldsResponse.fieldDisplayName.split("## ").join("\n");
        return Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 15, 0),
                  child: Text(
                    groupPrimaryNames[1] ?? "",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            _getDynamicWidget(dynamicFieldsResponse, displayName),
          ],
        );
      }
    }
  }

  bool isAlreadyShown = false, systolicView = false;
  String systolic, diastolic;

  Widget _getDynamicWidget(
      DynamicFieldsResponse dynamicFieldsResponse, String displayName) {
    switch (dynamicFieldsResponse.fieldCaptureType) {
      case "RADIO":
        return _createRadioItem(dynamicFieldsResponse, displayName);
        break;
      case "TOGGLE":
        return _createToggleItem(dynamicFieldsResponse, displayName);
        break;
      case "SLIDER":
        if (displayName.toLowerCase().contains("Blood P".toLowerCase())) {
          /*if (!isAlreadyShown) {
            isAlreadyShown = true;
            controllerDiastolic.text = dynamicFieldsResponse.actualValue != null
                ? dynamicFieldsResponse.actualValue.toString()
                : "0.0";*/
          return Container();
          /* } else {
            systolicView = true;
            controller.text = dynamicFieldsResponse.actualValue != null
                ? dynamicFieldsResponse.actualValue.toString()
                : "0.0";
            return _bloodPressure(dynamicFieldsResponse);
          }*/
        } else {
          return _createSliderItem(dynamicFieldsResponse, displayName);
        }
        break;
      case "INPUT_TEXT_AREA":
        return _createTextAreaItem(dynamicFieldsResponse, displayName);
        break;
      case "INPUT_TEXT":
        return Text(dynamicFieldsResponse.fieldCaptureType ?? "");
        break;
      case "INPUT_NUMBER":
        return Text(dynamicFieldsResponse.fieldCaptureType ?? "");
        break;
      case "CHECKBOX":
        return Text(dynamicFieldsResponse.fieldCaptureType ?? "");
        break;
      case "DATE_PICKER":
        return Text(dynamicFieldsResponse.fieldCaptureType ?? "");
        break;
      case "COMBO_BOX":
        return _createComboBoxItem(dynamicFieldsResponse, displayName);
        break;
      case "GROUP ENTITY":
        // print("Task Dynamic ${dynamicFieldsResponse.toJson().toString()}");
        return WorkForceTaskWidget(
          formKey: _formKey,
          onValidationCallBack: (validation) {
            setState(() {
              _autoValidate = validation;
            });
          },
          readOnly: readOnly,
          models: dynamicFieldsResponse.workForceTasks != null
              ? dynamicFieldsResponse.workForceTasks
              : null,
          onChanged: (models) {
            List<Object> json = List();
            workForceModels = models;
            for (int i = 0; i < models.length; i++) {
              models[i].taskId = dynamicFieldsResponse.id;
              json.add(models[i].toJson());
            }
            responseMap[dynamicFieldsResponse.mappedDBColumn] = json;
          },
          expandableControllerCallBack: (expControllerList) {
            this.expControllerList = expControllerList;
          },
        );
        break;
      default:
        return Container();
        break;
    }
  }

  List expControllerList;

  Widget _createTextAreaItem(
      DynamicFieldsResponse dynamicFieldsResponse, String displayName) {
    return InputFieldItem(
      displayName,
      hideRulerLine: false,
      bounds: dynamicFieldsResponse.bounds,
      onChange: readOnly
          ? null
          : (value) {
              debugPrint("InputFieldItem --> $value");
              responseMap[dynamicFieldsResponse.mappedDBColumn] = value;
            },
      defValue: (widget.fromDailyStatus && widget.checkInDynamic != null)
          ? dynamicFieldsResponse.actualValue
          : double.parse(dynamicFieldsResponse.defaultValue),
      lcl: dynamicFieldsResponse.lcl,
      ucl: dynamicFieldsResponse.ucl,
      fieldUnit: dynamicFieldsResponse.fieldUnit,
      dynamicFieldsResponse: dynamicFieldsResponse,
    );
  }

  Widget _createComboBoxItem(
      DynamicFieldsResponse dynamicFieldsResponse, String displayName) {
    return ComboBoxItem(displayName,
        hideRulerLine: false,
        onChange: readOnly
            ? null
            : (value) {
                responseMap[dynamicFieldsResponse.mappedDBColumn] = value;
              },
        defValue: (widget.fromDailyStatus && widget.checkInDynamic != null)
            ? dynamicFieldsResponse.actualValue
            : dynamicFieldsResponse.defaultValue,
        possibleValues: dynamicFieldsResponse.possibleValues);
  }

  Widget _createSliderItem(
      DynamicFieldsResponse dynamicFieldsResponse, String displayName) {
    return SliderItem(
      displayName,
      hideRulerLine: false,
      bounds: dynamicFieldsResponse.bounds,
      onPrandialStatusCallBack: (readOnly) ? null : _prandialCallBack,
      onChange: readOnly
          ? null
          : (value) {
              // print(value);
              responseMap[dynamicFieldsResponse.mappedDBColumn] = value;
            },
      defValue: (widget.fromDailyStatus && widget.checkInDynamic != null)
          ? dynamicFieldsResponse.actualValue
          : double.parse(dynamicFieldsResponse.defaultValue),
      lcl: dynamicFieldsResponse.lcl,
      ucl: dynamicFieldsResponse.ucl,
      fieldUnit: dynamicFieldsResponse.fieldUnit,
      dynamicFieldsResponse: dynamicFieldsResponse,
    );
  }

  _checkTemperatureVisibility(DynamicFieldsResponse dynamicFieldsResponse) {
    if (dynamicFieldsResponse.fieldName == "fever") {
      if (dynamicFieldsResponse.actualValue != null) {
        setState(() {
          if (dynamicFieldsResponse.actualValue ==
              dynamicFieldsResponse.possibleValues[0])
            showTemperature = true;
          else if (dynamicFieldsResponse.actualValue ==
              dynamicFieldsResponse.possibleValues[1]) showTemperature = false;
        });
      }
    }
  }

  _updateTemperatureVisibility(
      DynamicFieldsResponse dynamicFieldsResponse, String value) {
    if (dynamicFieldsResponse.fieldName == "fever") {
      // print("_updateTemperatureVisibility --> $value");
      setState(() {
        if (value == dynamicFieldsResponse.possibleValues[0])
          showTemperature = true;
        else if (value == dynamicFieldsResponse.possibleValues[1])
          showTemperature = false;
      });
    }
  }

  Widget _createRadioItem(
      DynamicFieldsResponse dynamicFieldsResponse, String displayName) {
    _checkTemperatureVisibility(dynamicFieldsResponse);

    return RadioButtonItem(displayName,
        hideRulerLine: false,
        possibleValues: dynamicFieldsResponse.possibleValues,
        onChange: readOnly
            ? null
            : (value) {
                responseMap[dynamicFieldsResponse.mappedDBColumn] = value;
                _updateTemperatureVisibility(dynamicFieldsResponse, value);
              },
        defValue: (widget.fromDailyStatus && widget.checkInDynamic != null)
            ? dynamicFieldsResponse.actualValue
            : dynamicFieldsResponse.defaultValue);
  }

  Widget _createToggleItem(
      DynamicFieldsResponse dynamicFieldsResponse, String displayName) {
    _checkTemperatureVisibility(dynamicFieldsResponse);
    return ToggleItem(
      displayName,
      hideRulerLine: false,
      possibleValues: dynamicFieldsResponse.possibleValues ?? [],
      onChange: readOnly
          ? null
          : (value) {
              responseMap[dynamicFieldsResponse.mappedDBColumn] = value;
              _updateTemperatureVisibility(dynamicFieldsResponse, value);
            },
      defValue: (widget.fromDailyStatus && widget.checkInDynamic != null)
          ? dynamicFieldsResponse.actualValue
          : dynamicFieldsResponse.defaultValue,
    );
  }

  TextEditingController controller = new TextEditingController();
  TextEditingController controllerDiastolic = new TextEditingController();

  Widget _bloodPressure() {
    return Container(
        // height: 180,
        margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
        // padding: EdgeInsets.all(20),
        // decoration: leftBoxDecoration(),
        child: Container(
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
          // width: 320,
          // padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.all(
                  Radius.circular(5.0) //         <--- border radius here
                  )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Checkbox(
                    value: fieldEnabled,
                    activeColor: AppColors.hyperlinkColor,
                    onChanged: (bpDynamicFieldsResponseSystolic.actualValue ==
                                    null &&
                                bpDynamicFieldsResponseDiastolic.actualValue ==
                                    null) &&
                            !readOnly
                        ? (value) {
                            setState(() {
                              fieldEnabled = !fieldEnabled;
                              if (!fieldEnabled) {
                                controller?.text = 0.toString();
                                controllerDiastolic?.text = 0.toString();
                                responseMap["column3"] = 0;
                                try {
                                  comparisonCalculation();
                                } catch (_) {}
                                /*} else {
                            diastolicBoundsInfo = null;
                            // setState(() {});
                          }*/

                              }
                            });
                          }
                        : null,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    alignment: Alignment.centerLeft,
                    child: Text(
                        bpDynamicFieldsResponseDiastolic.fieldDisplayName
                            .replaceFirst("(diastolic)", ""),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              SizedBox(
                height: AppUIDimens.paddingMedium,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Systolic"),
                    SizedBox(width: 5),
                    Container(
                        width: MediaQuery.of(context).size.width / 4,
                        child: TextFormField(
                            enabled: fieldEnabled,
                            controller: controller,
                            autovalidateMode: AutovalidateMode.always,
                            onTap: () {
                              if (readOnly) {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              }
                            },
                            keyboardType: bpDynamicFieldsResponseSystolic
                                            .fieldDataType !=
                                        null &&
                                    bpDynamicFieldsResponseSystolic
                                            .fieldDataType
                                            .trim() ==
                                        "DOUBLE"
                                ? TextInputType.numberWithOptions(decimal: true)
                                : TextInputType.text,
                            //initialValue: systolic ?? "0.0",
                            maxLength: 6,
                            onChanged: (arg) {
                              //if (arg != null && arg.isNotEmpty) {
                              try {
                                comparisonCalculation();
                              } catch (_) {}
                              // } else {
                              //   systolicBoundsInfo = null;
                              //   // setState(() {});
                              // }

                              responseMap["column3"] = double.parse(arg);
                            },
                            maxLines: null,
                            inputFormatters:
                                bpDynamicFieldsResponseSystolic.fieldDataType !=
                                            null &&
                                        bpDynamicFieldsResponseSystolic
                                                .fieldDataType
                                                .trim() ==
                                            "DOUBLE"
                                    ? [
                                        //Allowed only One dot (.)
                                        LengthLimitingTextInputFormatter(6),
                                        FilteringTextInputFormatter.deny(
                                            new RegExp('[\\-|\\ ]')),
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d+\.?\d*')),
                                      ]
                                    : [],
                            decoration:
                                WidgetStyles.heightAndWeightDecoration(),
                            readOnly: readOnly,
                            style: readOnly
                                ? TextStyle(color: AppColors.warmGrey)
                                : TextStyle(),
                            validator: (arg) {
                              if (arg.length > 0) {
                                if (arg[0] == ".") {
                                  arg = "0" + arg;
                                  if (arg.length > 0) {
                                    if (double.parse(arg) >= 1000) {
                                      return "Value should be < 1000";
                                    } else {
                                      return ValidationUtils
                                          .dynamicFieldsValidator(arg,
                                              errorMessage: " ");
                                    }
                                  }
                                } else {
                                  if (arg.length > 0) {
                                    if (double.parse(arg) >= 1000) {
                                      return "Value should be < 1000";
                                    } else {
                                      return ValidationUtils
                                          .dynamicFieldsValidator(arg,
                                              errorMessage: " ");
                                    }
                                  }
                                }
                              }
                              // setState(() {});
                            })),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text("/"),
                      SizedBox(
                        width: 10,
                      ),
                    ]),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Diastolic"),
                      Container(
                          width: MediaQuery.of(context).size.width / 4,
                          child: TextFormField(
                              autovalidateMode: AutovalidateMode.always,
                              enabled: fieldEnabled,
                              controller: controllerDiastolic,
                              onTap: () {
                                if (readOnly) {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                }
                              },
                              keyboardType: bpDynamicFieldsResponseDiastolic
                                              .fieldDataType !=
                                          null &&
                                      bpDynamicFieldsResponseDiastolic
                                              .fieldDataType
                                              .trim() ==
                                          "DOUBLE"
                                  ? TextInputType.numberWithOptions(
                                      decimal: true)
                                  : TextInputType.text,
                              maxLength: 5,
                              onChanged: (arg) {
                                //if (arg != null && arg.isNotEmpty) {
                                try {
                                  comparisonCalculation();
                                } catch (_) {}
                                /*} else {
                            diastolicBoundsInfo = null;
                            // setState(() {});
                          }*/
                                responseMap["column3"] = double.parse(arg);
                              },
                              maxLines: null,
                              inputFormatters: bpDynamicFieldsResponseDiastolic
                                              .fieldDataType !=
                                          null &&
                                      bpDynamicFieldsResponseDiastolic
                                              .fieldDataType
                                              .trim() ==
                                          "DOUBLE"
                                  ? [
                                      //Allowed only One dot (.)
                                      FilteringTextInputFormatter.deny(
                                          new RegExp('[\\-|\\ ]')),
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d+\.?\d*')),
                                      LengthLimitingTextInputFormatter(6),
                                    ]
                                  : [],
                              decoration:
                                  WidgetStyles.heightAndWeightDecoration(),
                              readOnly: readOnly,
                              style: readOnly
                                  ? TextStyle(color: AppColors.warmGrey)
                                  : TextStyle(),
                              validator: (arg) {
                                if (arg.length > 0) {
                                  if (arg[0] == ".") {
                                    arg = "0" + arg;
                                    if (arg.length > 0) {
                                      if (double.parse(arg) >= 1000) {
                                        return "Value should be < 1000";
                                      } else {
                                        return ValidationUtils
                                            .dynamicFieldsValidator(arg,
                                                errorMessage: " ");
                                      }
                                    }
                                  } else {
                                    if (arg.length > 0) {
                                      if (double.parse(arg) >= 1000) {
                                        return "Value should be < 1000";
                                      } else {
                                        return ValidationUtils
                                            .dynamicFieldsValidator(arg,
                                                errorMessage: " ");
                                      }
                                    }
                                  }
                                }
                              })),
                    ]),
                SizedBox(width: 5),
              ]),
              SizedBox(
                height: 20,
              ),
              if (systolicBoundsInfo != null)
                boundCalculation(systolicBoundsInfo, systolicPromptColor,
                    doubleValue ? "Systolic / Diastolic" : "Systolic"),
              if (diastolicBoundsInfo != null)
                boundCalculation(
                    diastolicBoundsInfo, diastolicPromptColor, "Diastolic"),
              if (diastolicBoundsInfo != null || systolicBoundsInfo != null)
                SizedBox(height: 10)
            ],
          ),
        ));
  }

  String systolicBoundsInfo,
      diastolicBoundsInfo,
      prandialStatus = "PRE_PRANDIABLE";
  bool doubleValue = false;
  Color systolicPromptColor = Colors.blueAccent;
  Color diastolicPromptColor = Colors.blueAccent;
  Color foregroundColor = Colors.black;

  Bounds updateMessageBoundInfo(double arg, var dynamicFieldsResponse,
      {bool isFromSystolic: true}) {
    Bounds bound;
    if (dynamicFieldsResponse.bounds != null &&
        dynamicFieldsResponse.bounds.length > 0) {
      bool notified = false;
      if (dynamicFieldsResponse?.hasPrandiable ?? false) {
        for (Map<String, dynamic> boundMap in dynamicFieldsResponse.bounds) {
          if (boundMap != null) {
            bound = Bounds.fromJson(boundMap);
            if (arg >= bound.lowerCut && arg <= bound.upperCut) {
              notified = true;
              if (bound.boundClassification != null &&
                  prandialStatus.toLowerCase() ==
                      bound.boundClassification.toLowerCase()) {
                systolicBoundsInfo = bound.infoMessage;
                systolicPromptColor = ColorUtils.hexToColor(bound.colorCode);
                foregroundColor = ColorUtils.hexToColor(bound.foregroundColor);
              }
            }
          }
        }
      } else {
        for (Map<String, dynamic> boundMap in dynamicFieldsResponse.bounds) {
          if (boundMap != null) {
            bound = Bounds.fromJson(boundMap);
            if (arg >= bound.lowerCut && arg <= bound.upperCut) {
              notified = true;
              //if(oldRangeSystolic == null || rangeList.indexOf(oldRangeSystolic) < rangeList.indexOf(bound.boundInfo)) {
              foregroundColor = ColorUtils.hexToColor(bound.foregroundColor);
              return bound;
              // setState(() {});
              //}
            }
          }
        }
      }
    }
    return bound;
  }

  comparisonCalculation() {
    if (controller.text.isEmpty) {
      systolicBoundsInfo = null;
      setState(() {});
    }
    if (controllerDiastolic.text.isEmpty) {
      diastolicBoundsInfo = null;
      setState(() {});
    }

    Bounds systolic = controller.text == "0" || controller.text == "0.0"
        ? null
        : updateMessageBoundInfo(
            double.parse(controller.text), bpDynamicFieldsResponseSystolic);
    Bounds diastolic =
        controllerDiastolic.text == "0" || controllerDiastolic.text == "0.0"
            ? null
            : updateMessageBoundInfo(double.parse(controllerDiastolic.text),
                bpDynamicFieldsResponseDiastolic);

    if (systolic != null &&
        diastolic != null &&
        rangeList.indexOf(systolic?.boundInfo) ==
            rangeList.indexOf(diastolic?.boundInfo)) {
      systolicBoundsInfo = systolic.infoMessage;
      systolicPromptColor = ColorUtils.hexToColor(systolic.colorCode);
      doubleValue = true;
      diastolicBoundsInfo = null;
      diastolicBoundsInfo = null;
    } else {
      doubleValue = false;
      if (diastolic == null && systolic == null) {
        systolicBoundsInfo = null;
        diastolicBoundsInfo = null;
      } else {
        if ((systolic != null && rangeList.indexOf(systolic.boundInfo) != 1) ||
            diastolic == null) {
          systolicBoundsInfo = systolic.infoMessage;
          systolicPromptColor = ColorUtils.hexToColor(systolic.colorCode);
          if (diastolic == null) diastolicBoundsInfo = null;
        } else {
          if ((systolic == null ||
                  rangeList.indexOf(systolic.boundInfo) == 1) &&
              diastolic != null) {
            systolicBoundsInfo = null;
          }
        }
        if ((diastolic != null &&
                rangeList.indexOf(diastolic.boundInfo) != 1) ||
            systolic == null) {
          diastolicBoundsInfo = diastolic.infoMessage;
          diastolicPromptColor = ColorUtils.hexToColor(diastolic.colorCode);
          if (systolic == null) systolicBoundsInfo = null;
        } else {
          if ((diastolic == null ||
                  rangeList.indexOf(diastolic.boundInfo) == 1) &&
              systolic != null) {
            diastolicBoundsInfo = null;
          }
        }
      }
    }
    setState(() {});
  }

  boundCalculation(String str, Color promptColor, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.only(left: AppUIDimens.paddingMedium),
            child: Text("$title")),
        Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                    color: ColorUtils.brighten(promptColor, 70), width: 1),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      ColorUtils.brighten(promptColor, 80), Colors.white
                      //ColorUtils.darken(Colors.white, 15),
                    ])),
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
                horizontal: AppUIDimens.paddingSmall,
                vertical: AppUIDimens.paddingXSmall),
            child: Text(
              str,
              style: TextStyle(
                  //fontWeight: FontWeight.w600,
                  color: readOnly ? Colors.black : foregroundColor),
            ))
      ],
    );
  }

  createOrUpdate({bool isUpdate = false}) async {
    CustomProgressLoader.showLoader(context);
    String userName = (userController.text == null || userController.text == "")
        ? await AppPreferences.getUsername()
        : userController.text;
    responseMap["active"] = true;
    responseMap["departmentName"] = widget.departmentName != null
        ? widget.departmentName
        : AppPreferences.getDeptName();
    responseMap["status"] = "Reported";
    responseMap["userName"] = userName;
    if (controllerDiastolic.text != null &&
        controllerDiastolic.text.isNotEmpty &&
        controller.text != null &&
        controller.text.isNotEmpty) {
      responseMap["column3"] = controller.text == "0" ? null : controller.text;
      responseMap["column4"] =
          controllerDiastolic.text == "0" ? null : controllerDiastolic.text;
    }

    if (isUpdate) {
      responseMap["id"] = widget.checkInDynamic?.id;
      responseMap["createdBy"] = widget.checkInDynamic.createdBy;
      responseMap["createdOn"] = widget.checkInDynamic.createdOn;
      responseMap["checkInDate"] = widget.checkInDynamic.checkInDate;
    }
// STatic set
    // print("Sys ${controller.text}");
    // print("dia ${controllerDiastolic.text}");
    // print("responseMap --> $responseMap");
    _dynamicFieldsBloc.postDynamicFieldCheckInData(responseMap);
    _dynamicFieldsBloc.dynamicFieldPostFetcher.listen((event) async {
      CustomProgressLoader.cancelLoader(context);
      if (event != null && event.status == 201 || event.status == 200) {
        if (await AppPreferences.getRole() == Constants.supervisorRole) {
          if (widget.fromDailyStatus) {
            ///Daily status navigation for Supervisor
            Fluttertoast.showToast(
                msg: "Log Book updated successfully",
                gravity: ToastGravity.TOP,
                toastLength: Toast.LENGTH_LONG);
            Navigator.pop(context, true);
          } else {
            Navigator.pushNamed(context, Routes.historyScreen,
                arguments: Args(username: userName));
          }
        } else {
          if (widget.fromDailyStatus) {
            ///Daily status Navigtaion for user
            Fluttertoast.showToast(
                msg: "Log Book updated successfully",
                gravity: ToastGravity.TOP,
                toastLength: Toast.LENGTH_LONG);
            /*Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => NavigationHomeScreen()),
                ModalRoute.withName(Routes.navigatorHomeScreen));*/
            Navigator.pop(context, true);
          } else {
            ///Stymptoms Navigation for user
            Navigator.pushNamed(context, Routes.dailyStatusHistoryScreen);
          }
        }
      } else {
        AlertUtils.showAlertDialog(
            context,
            event != null
                ? event.message
                : AppPreferences().getApisErrorMessage);
      }
    });
  }

  String validateDOB(String value) {
    if (value.trim().length == 0)
      return 'Start date is required ';
    else
      return null;
  }

  validationWorkForceModel(WorkForceTaskModel model) {
    return !(model.taskName != null &&
        model.taskName.isNotEmpty &&
        model.description != null &&
        model.description.isNotEmpty &&
        model.startTime != null &&
        model.startTime.isNotEmpty &&
        model.endTime != null &&
        model.endTime.isNotEmpty &&
        model.status != null &&
        model.status.isNotEmpty &&
        model.comments != null &&
        model.comments.isNotEmpty);
  }
}
