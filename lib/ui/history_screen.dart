import '../bloc/dynamic_fields_bloc.dart';
import '../bloc/history_bloc.dart';
import '../login/utils/custom_progress_dialog.dart';
import '../model/dynamic_fields_reponse.dart';
import '../ui_utils/app_colors.dart';
import '../utils/alert_utils.dart';
import '../utils/app_preferences.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../utils/validation_utils.dart';
import '../widgets/combo_box_item.dart';
import '../widgets/multi_select_item.dart';
import '../widgets/notification_loading_widget.dart';
import '../widgets/radio_button_item.dart';
import '../widgets/slider_item.dart';
import '../widgets/split_text_item.dart';
import '../widgets/submit_button.dart';
import '../widgets/toggle_item.dart';
import 'package:flutter/material.dart';

import 'custom_drawer/navigation_home_screen.dart';

class HistoryScreen extends StatefulWidget {
  final String username;
  final String gender;

  HistoryScreen({this.username, this.gender});

  @override
  HistoryScreenState createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> {
  HistoryBloc _bloc;
  DynamicFieldsBloc _dynamicFieldsBloc;
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  Map responseMap = {};
  bool isDataLoaded = false, autoValidate = false;
  List<DynamicFieldsResponse> dynamicFieldsResponse;

  bool readOnly = false;
  double screenWidth;

  @override
  void initState() {
    super.initState();
    _bloc = HistoryBloc(context);
    _dynamicFieldsBloc = DynamicFieldsBloc(context);

    _dynamicFieldsBloc.fetchDynamicFieldsHistory();
    _dynamicFieldsBloc.dynamicFieldsHistoryFetcher.listen((event) {
      //debugPrint("dynamicFieldsResponse without data --> $event");
      dynamicFieldsResponse = event;
      setState(() {
        isDataLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return Form(
        key: formKey,
        autovalidate: autoValidate,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primaryColor,
            centerTitle: true,
            title: Text('Additional Information'),
            automaticallyImplyLeading: false,
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
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 25),
                (!isDataLoaded)
                    ? ListLoading()
                    : _bodyContent(dynamicFieldsResponse, context),
                SizedBox(
                  height: 40,
                ),
                SubmitButton(
                    text: "Finish",
                    onPress: () async {
                      if (formKey.currentState.validate()) {
                        formKey.currentState.save();
                        CustomProgressLoader.showLoader(context);

                        responseMap["active"] = true;
                        responseMap["departmentName"] =
                            await AppPreferences.getDeptName();
                        responseMap["status"] = "Reported";
                        responseMap["userName"] = widget.username;

                        _dynamicFieldsBloc
                            .postDynamicFieldCheckInHistoryData(responseMap);
                        _dynamicFieldsBloc.dynamicFieldPostFetcher
                            .listen((event) async {
                          CustomProgressLoader.cancelLoader(context);
                          if (event != null && event.status == 201 ||
                              event.status == 200) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        NavigationHomeScreen()),
                                ModalRoute.withName(
                                    Routes.navigatorHomeScreen));
                          } else {
                            AlertUtils.showAlertDialog(
                                context, event.message);
                          }
                        });
                      } else {
                        setState(() {
                          autoValidate = true;
                        });
                      }
                    })
              ],
            ),
          ),
        ));
  }

  Widget _bodyContent(
      List<DynamicFieldsResponse> dynamicFieldsResponse, BuildContext context) {
    return Column(
      children: <Widget>[
        if (AppPreferences().role == Constants.supervisorRole)
          Padding(
              padding: EdgeInsets.only(top: 20, right: 15, left: 20),
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
                            initialValue: widget.username,
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
          height: 25,
        ),
      ],
    );
  }

  Widget _createDynamicWidget(DynamicFieldsResponse dynamicFieldsResponse) {
    if (!dynamicFieldsResponse.active) {
      return Container();
    }
    responseMap.putIfAbsent(dynamicFieldsResponse.mappedDBColumn,
        () => dynamicFieldsResponse.defaultValue);

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
      default:
        return Text(dynamicFieldsResponse.fieldCaptureType);
        break;
    }
  }

  Widget _createTextAreaItem(
      DynamicFieldsResponse dynamicFieldsResponse, String displayName) {
    return SplitTextItem(
      displayName,
      isCountShow: true,
      hideRulerLine: false,
      onChange: readOnly
          ? null
          : (value) {
              responseMap[dynamicFieldsResponse.mappedDBColumn] = value;
            },
      defValue: (readOnly)
          ? dynamicFieldsResponse.actualValue
          : dynamicFieldsResponse.defaultValue,
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

  Widget _createSliderItem(
      DynamicFieldsResponse dynamicFieldsResponse, String displayName) {
    return SliderItem(
      displayName,
      hideRulerLine: false,
      dynamicFieldsResponse: dynamicFieldsResponse,
      onChange: readOnly
          ? null
          : (value) {
              responseMap[dynamicFieldsResponse.mappedDBColumn] = value;
            },
      defValue: (readOnly)
          ? dynamicFieldsResponse.actualValue
          : double.parse(dynamicFieldsResponse.defaultValue ?? "96"),
      lcl: dynamicFieldsResponse.lcl ?? "96",
      ucl: dynamicFieldsResponse.ucl ?? "105",
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
        widget.gender != null &&
        widget.gender.toLowerCase() != "female") {
      return Container();
    }
    return ToggleItem(
      displayName,
      hideRulerLine: false,
      possibleValues: dynamicFieldsResponse.possibleValues,
      onChange: readOnly
          ? null
          : (value) {
              responseMap[dynamicFieldsResponse.mappedDBColumn] = value;
            },
      defValue: (readOnly)
          ? dynamicFieldsResponse.actualValue
          : dynamicFieldsResponse.defaultValue,
    );
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

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
