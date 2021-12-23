import '../../bloc/dynamic_fields_bloc.dart';
import '../../bloc/history_bloc.dart';
import '../../bloc/user_info_validation_bloc.dart';
import '../../model/dynamic_fields_reponse.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_preferences.dart';
import '../../utils/constants.dart';
import '../../utils/validation_utils.dart';
import '../../widgets/combo_box_item.dart';
import '../../widgets/education_widget.dart';
import '../../widgets/experience_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/multi_select_item.dart';
import '../../widgets/radio_button_item.dart';
import '../../widgets/slider_item.dart';
import '../../widgets/split_text_item.dart';
import '../../widgets/toggle_item.dart';
import 'package:flutter/material.dart';

class HistoryTabScreen extends StatefulWidget {
  final String userName;
  final GlobalKey<FormState> formKey;
  final UserInfoValidationBloc bloc;
  final ValueChanged<bool> onOpen;
  final String gender;

  HistoryTabScreen(
    this.bloc,
    this.formKey, {
    this.userName,
    this.onOpen,
    this.gender,
  });

  @override
  HistoryTabScreenState createState() => HistoryTabScreenState();
}

class HistoryTabScreenState extends State<HistoryTabScreen>
    with AutomaticKeepAliveClientMixin<HistoryTabScreen> {
  HistoryBloc _bloc;
  DynamicFieldsBloc _dynamicFieldsBloc;

  bool readOnly = false;

  Map responseMap = {};
  bool isDataLoaded = false, autoValidate = false;
  bool isEditable = false;
  String username;
  List<DynamicFieldsResponse> dynamicFieldsResponse;

  @override
  void initState() {
    super.initState();
    if (widget.onOpen != null) {
      widget.onOpen(true);
    }
    _bloc = HistoryBloc(context);
    _dynamicFieldsBloc = DynamicFieldsBloc(context);

    widget.bloc.actionTrigger.listen((value) {
      additionalHistoryTabSubmit();
    });
    widget.bloc.usernameStream.listen((value) {
      setState(() {
        username = value;
      });
      additionalHistoryTabSubmit();
    });

    _bloc.fetchHistoryDynamicList();
    _bloc.dynamicFieldsHistoryFetcherWithData.listen((event) async {
      if (event != null) {
        if (event.length > 0) {
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
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AppPreferences().setContext(context);
    AppPreferences().setGlobalContext(context);
    return Form(
        key: widget.formKey,
        autovalidate: autoValidate,
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            SizedBox(height: 25),
            (!isDataLoaded)
                ? ListLoading(
                    itemCount: 8,
                  )
                : _bodyContent(dynamicFieldsResponse, context),
            SizedBox(
              height: 10,
            ),
          ],
        )));
  }

  Widget _bodyContent(
      List<DynamicFieldsResponse> dynamicFieldsResponse, BuildContext context) {
    return Column(
      children: <Widget>[
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
        // print("Array $value");
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
    responseMap["active"] = true;
    responseMap["status"] = "Reported";
    responseMap["userName"] =
        (AppPreferences().role == Constants.supervisorRole)
            ? username
            : await AppPreferences.getUsername();
    responseMap["departmentName"] = await AppPreferences.getDeptName();

    if (AppPreferences().role == Constants.supervisorRole) {}
    // print("History dynamic Create : $responseMap");
    _dynamicFieldsBloc.postDynamicFieldCheckInHistoryData(responseMap,
        isUpdate: readOnly);
    _dynamicFieldsBloc.dynamicFieldPostFetcher.listen((event) async {
      if (event != null && event.status == 201 || event.status == 200) {
        await AppPreferences.setCheckInSaved(true);
        await AppPreferences().init();
      } else {
        AlertUtils.showAlertDialog(context, event.message);
      }
    });
  }

  @override
// TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
