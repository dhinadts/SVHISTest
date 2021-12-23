import '../bloc/dynamic_fields_bloc.dart';
import '../bloc/history_bloc.dart';
import '../bloc/user_info_validation_bloc.dart';
import '../login/utils/custom_progress_dialog.dart';
import '../model/dynamic_fields_reponse.dart';
import '../ui/advertise/adWidget.dart';
import '../ui/custom_drawer/custom_app_bar.dart';
import '../ui/custom_drawer/navigation_home_screen.dart';
import '../ui/tabs/app_localizations.dart';
import '../ui_utils/app_colors.dart';
import '../utils/alert_utils.dart';
import '../utils/app_preferences.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../utils/validation_utils.dart';
import '../widgets/combo_box_item.dart';
import '../widgets/education_widget.dart';
import '../widgets/experience_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/multi_select_item.dart';
import '../widgets/radio_button_item.dart';
import '../widgets/slider_item.dart';
import '../widgets/split_text_item.dart';
import '../widgets/submit_button.dart';
import '../widgets/toggle_item.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserAdditionalInformationScreen extends StatefulWidget {
  final String userName;
  final String firstName;
  final String lastName;
  final String deptName;
  final GlobalKey<FormState> formKey;
  final UserInfoValidationBloc bloc;
  //final ValueChanged<bool> onOpen;
  final String gender;

  UserAdditionalInformationScreen(
    this.bloc,
    this.formKey, {
    this.userName,
    this.firstName,
    this.lastName,
    this.deptName,
    //this.onOpen,
    this.gender,
  });

  @override
  UserAdditionalInformationScreenState createState() =>
      UserAdditionalInformationScreenState();
}

class UserAdditionalInformationScreenState
    extends State<UserAdditionalInformationScreen>
    with AutomaticKeepAliveClientMixin<UserAdditionalInformationScreen> {
  HistoryBloc _bloc;
  DynamicFieldsBloc _dynamicFieldsBloc;

  bool readOnly = false;

  Map responseMap = {};
  bool isDataLoaded = false, autoValidate = false;
  bool isEditable = false;
  //String username;
  List<DynamicFieldsResponse> dynamicFieldsResponse;

  double screenWidth;

  @override
  void initState() {
    super.initState();
    // if (widget.onOpen != null) {
    //   widget.onOpen(true);
    // }
    _bloc = HistoryBloc(context);
    _dynamicFieldsBloc = DynamicFieldsBloc(context);

    // widget.bloc.actionTrigger.listen((value) {
    //   additionalHistoryTabSubmit();
    // });
    // widget.bloc.usernameStream.listen((value) {
    //   setState(() {
    //     username = value;
    //   });
    //   additionalHistoryTabSubmit();
    // });

    _bloc.fetchHistoryDynamicList(
        username: widget.userName, dept: widget.deptName);
    _bloc.dynamicFieldsHistoryFetcherWithData.listen((event) async {
      // print("check event -- ${event.length}");
      if (event != null) {
        if (event.length > 0) {
          // debugPrint("count > 0 ....");
          //Add Value in Height
          for (DynamicFieldsResponse response in event) {
            if (response.mappedDBColumn == "column10") {
              await AppPreferences.setHeight("${response.actualValue}");
            } else if (response.mappedDBColumn == "column9") {
              await AppPreferences.setWeight("${response.actualValue}");
            }
          }
          dynamicFieldsResponse = event;
          setState(() {
            readOnly = true;
            isDataLoaded = true;
          });
          saveHistoryState();
        } else {
          _dynamicFieldsBloc.fetchDynamicFieldsHistory();
          _dynamicFieldsBloc.dynamicFieldsHistoryFetcher.listen((event) {
            //debugPrint("dynamicFieldsResponse without data --> $event");
            dynamicFieldsResponse = event;
            setState(() {
              isDataLoaded = true;
            });
          });
        }
      } else {
        // print(dynamicFieldsResponse);
      }
    });

    initializeAd();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    AppPreferences().setContext(context);
    AppPreferences().setGlobalContext(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: Text(AppLocalizations.of(context).translate("key_history")),
        ),
        body: SafeArea(
            child: Column(
          children: [
            Expanded(
              child: Container(
                  child: Form(
                      key: widget.formKey,
                      autovalidate: autoValidate,
                      child: SingleChildScrollView(
                          child: Column(
                        children: <Widget>[
                          SizedBox(height: 25),
                          (!isDataLoaded)
                              ? ListLoading()
                              : _bodyContent(dynamicFieldsResponse, context),
                          SizedBox(
                            height: 40,
                          ),
                          Center(
                            child: SubmitButton(
                              text: "Submit",
                              onPress: () {
                                if (widget.formKey.currentState.validate()) {
                                  widget.formKey.currentState.save();
                                  additionalHistoryTabSubmit();
                                } else {
                                  setState(() {
                                    autoValidate = true;
                                  });
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      )))),
            ),

            /// Show Banner Ad
            getSivisoftAdWidget(),
          ],
        )));
  }

  Widget _bodyContent(
      List<DynamicFieldsResponse> dynamicFieldsResponse, BuildContext context) {
    return Column(
      children: <Widget>[
        if (AppPreferences().role == Constants.supervisorRole)
          Padding(
              padding: EdgeInsets.only(top: 0, right: 15, left: 20),
              child: Column(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(child: Text("Name")),
                      Container(
                        width: screenWidth / 1.7,
                        child: TextFormField(
                            readOnly: true,
                            initialValue:
                                "${widget.firstName} ${widget.lastName}",
                            decoration: InputDecoration(
                              labelText: "",
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              //fillColor: Colors.green
                            ),
                            keyboardType: TextInputType.text,
                            style: TextStyle(fontSize: 16, color: Colors.grey)),
                      )
                    ]),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  height: 5,
                  color: AppColors.borderShadow,
                ),
              ])),
        for (var dynamicField in dynamicFieldsResponse)
          _createDynamicWidget(dynamicField),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }

  saveHistoryState() async {
    await AppPreferences.setHistorySaved(true);
    await AppPreferences().init();
  }

  Widget _createDynamicWidget(DynamicFieldsResponse dynamicFieldsResponse) {
    if (!dynamicFieldsResponse.active) {
      return Container();
    }
    responseMap.putIfAbsent(
        dynamicFieldsResponse.mappedDBColumn,
        () => (dynamicFieldsResponse.actualValue != null &&
                dynamicFieldsResponse.actualValue.toString().isNotEmpty)
            ? dynamicFieldsResponse.actualValue
            : dynamicFieldsResponse.defaultValue);

    String displayName = "";
    // Check fieldClassification value, if it is PRIMARY, show display name as it is.
    if (dynamicFieldsResponse.fieldClassification == "PRIMARY" ||
        dynamicFieldsResponse.fieldClassification == "SECONDARY") {
      displayName = dynamicFieldsResponse.fieldDisplayName;
      Widget newWidget = _getDynamicWidget(dynamicFieldsResponse, displayName);
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
                    groupPrimaryNames[1],
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

  Widget _getDynamicWidget(
      DynamicFieldsResponse dynamicFieldsResponse, String displayName) {
    switch (dynamicFieldsResponse.fieldCaptureType) {
      case "RADIO":
        return _createRadioItem(dynamicFieldsResponse, displayName);
        break;
      case "TOGGLE":
        return _createToggleItem(dynamicFieldsResponse, displayName);
        break;
      case "MULTISELECT":
        return _createMultiSelectItem(dynamicFieldsResponse, displayName);
        break;
      case "SLIDER":
        return _createSliderItem(dynamicFieldsResponse, displayName);
        break;
      case "INPUT_TEXT_AREA":
        return _createTextAreaItem(dynamicFieldsResponse, displayName);
        break;
      case "INPUT_TEXT":
        return Text(dynamicFieldsResponse.fieldCaptureType);
        break;
      case "INPUT_NUMBER":
        return Text(dynamicFieldsResponse.fieldCaptureType);
        break;
      case "CHECKBOX":
        return Text(dynamicFieldsResponse.fieldCaptureType);
        break;
      case "DATE_PICKER":
        return Text(dynamicFieldsResponse.fieldCaptureType);
        break;
      case "COMBO_BOX":
        return _createComboBoxItem(dynamicFieldsResponse, displayName);
        break;
      case "GROUP ENTITY":
        return _createGroupEntity(dynamicFieldsResponse, displayName);
        break;
      default:
        return Text(dynamicFieldsResponse.fieldCaptureType);
        break;
    }
  }

  Widget _createTextAreaItem(
      DynamicFieldsResponse dynamicFieldsResponse, String displayName) {
    if (dynamicFieldsResponse.fieldUnit != null &&
        dynamicFieldsResponse.fieldUnit.trim().isNotEmpty) {
      displayName = displayName + " (${dynamicFieldsResponse.fieldUnit})";
    }
    return SplitTextItem(
      displayName,
      hideRulerLine: false,
      dataType: dynamicFieldsResponse?.fieldDataType,
      onChange: (value) {
        responseMap[dynamicFieldsResponse.mappedDBColumn] = value;
      },
      defValue: (readOnly)
          ? dynamicFieldsResponse.actualValue?.toString()
          : dynamicFieldsResponse.defaultValue?.toString(),
      validator: (arg) {
        if (dynamicFieldsResponse.fieldClassification ==
            Constants.PRIMARY_KEY) {
          return ValidationUtils.dynamicFieldsValidator(arg,
              errorMessage: dynamicFieldsResponse.errorMessage);
        } else {
          return null;
        }
      },
    );
//    }
  }

  Widget _createGroupEntity(
      DynamicFieldsResponse dynamicFieldsResponse, String displayName) {
    if (dynamicFieldsResponse.fieldDisplayName == "Education") {
      return EducationWidget(formKey: widget.formKey);
    } else {
      return ExperienceWidget(
        formKey: widget.formKey,
      );
    }
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
        defValue: (readOnly)
            ? dynamicFieldsResponse.actualValue
            : dynamicFieldsResponse.defaultValue,
        possibleValues: dynamicFieldsResponse.possibleValues);
  }

  Widget _createMultiSelectItem(
      DynamicFieldsResponse dynamicFieldsResponse, String displayName) {
    return MultiSelectChip(
      displayName,
      choiceList: dynamicFieldsResponse.possibleValues,
      selectedList: dynamicFieldsResponse.actualValue,
      onSelectionChanged: (value) {
        responseMap[dynamicFieldsResponse.mappedDBColumn] = value;
        // print("_createMultiSelectItem Array $value");
      },
    );
  }

  Widget _createSliderItem(
      DynamicFieldsResponse dynamicFieldsResponse, String displayName) {
    return SliderItem(
      displayName,
      dynamicFieldsResponse: dynamicFieldsResponse,
      hideRulerLine: false,
      onChange: readOnly
          ? null
          : (value) {
              responseMap[dynamicFieldsResponse.mappedDBColumn] = value;
            },
      defValue: (readOnly)
          ? dynamicFieldsResponse.actualValue
          : double.parse(dynamicFieldsResponse.defaultValue),
      lcl: dynamicFieldsResponse.lcl,
      ucl: dynamicFieldsResponse.ucl,
      fieldUnit: dynamicFieldsResponse.fieldUnit,
    );
  }

  Widget _createRadioItem(
      DynamicFieldsResponse dynamicFieldsResponse, String displayName) {
    return RadioButtonItem(displayName,
        hideRulerLine: false,
        possibleValues: dynamicFieldsResponse.possibleValues,
        onChange: readOnly
            ? null
            : (value) {
                responseMap[dynamicFieldsResponse.mappedDBColumn] = value;
              },
        defValue: (readOnly)
            ? dynamicFieldsResponse.actualValue
            : dynamicFieldsResponse.defaultValue);
  }

  Widget _createToggleItem(
      DynamicFieldsResponse dynamicFieldsResponse, String displayName) {
    if (displayName.toLowerCase() == "pregnant" &&
        widget.gender.toLowerCase() != "female") {
      return Container();
    }
    return ToggleItem(
      displayName,
      hideRulerLine: false,
      possibleValues: dynamicFieldsResponse.possibleValues,
      onChange: /*readOnly
          ? null
          : */
          (value) {
        responseMap[dynamicFieldsResponse.mappedDBColumn] = value;
      },
      defValue: (readOnly)
          ? dynamicFieldsResponse.actualValue
          : dynamicFieldsResponse.defaultValue,
    );
  }

  additionalHistoryTabSubmit() async {
    CustomProgressLoader.showLoader(context);
    responseMap["active"] = true;
    responseMap["status"] = "Reported";
    responseMap["userName"] =
        (AppPreferences().role == Constants.supervisorRole)
            ? widget.userName
            : await AppPreferences.getUsername();
    responseMap["departmentName"] =
        (AppPreferences().role == Constants.supervisorRole)
            ? widget.deptName
            : await AppPreferences.getDeptName();

    if (AppPreferences().role == Constants.supervisorRole) {}
    // print("History dynamic Create : $responseMap");
    _dynamicFieldsBloc.postDynamicFieldCheckInHistoryData(responseMap,
        isUpdate: readOnly);
    _dynamicFieldsBloc.dynamicFieldPostFetcher.listen((event) async {
      // print(event.message);
      CustomProgressLoader.cancelLoader(context);
      if (event != null && event.status == 201 || event.status == 200) {
        Fluttertoast.showToast(
            msg: "Additional info submitted successfully",
            gravity: ToastGravity.TOP,
            toastLength: Toast.LENGTH_LONG);
        if (AppPreferences().role == Constants.supervisorRole) {
          Navigator.pop(context);
        } else {
          await AppPreferences.setCheckInSaved(true);
          await AppPreferences().init();
          Navigator.pop(context);
        }
      } else {
        AlertUtils.showAlertDialog(context, event.message);
      }
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
