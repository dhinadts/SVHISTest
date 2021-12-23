import '../model/dynamic_fields_reponse.dart';
import '../widgets/combo_box_item.dart';
import '../widgets/loading_widget.dart';
import '../widgets/radio_button_item.dart';
import '../widgets/slider_item.dart';
import '../widgets/split_text_item.dart';
import '../widgets/toggle_item.dart';
import 'package:flutter/material.dart';

class SubDynamicWidget extends StatefulWidget {
  final List<DynamicFieldsResponse> dynamicFieldsResponse;
  final ValueChanged<Map> onChanged;

  SubDynamicWidget(this.dynamicFieldsResponse, {this.onChanged});

  @override
  SubDynamicWidgetState createState() => SubDynamicWidgetState();
}

class SubDynamicWidgetState extends State<SubDynamicWidget> {
  List<DynamicFieldsResponse> dynamicFieldsResponse;

  @override
  void initState() {
    super.initState();
    setState(() {
      dynamicFieldsResponse = widget.dynamicFieldsResponse;
    });
  }

  Map responseMap = {};
  bool isDataLoaded = false, readOnly = false;

  Widget _bodyContent(
      List<DynamicFieldsResponse> dynamicFieldsResponse, BuildContext context) {
    return Column(
      children: <Widget>[
        for (var dynamicField in dynamicFieldsResponse)
          _createDynamicWidget(dynamicField),
        SizedBox(
          height: 25,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 25),
        (!isDataLoaded)
            ? ListLoading()
            : _bodyContent(dynamicFieldsResponse, context),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget _createDynamicWidget(DynamicFieldsResponse dynamicFieldsResponse) {
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
    return SplitTextItem(displayName,
        hideRulerLine: false,
        onChange: readOnly
            ? null
            : (value) {
                responseMap[dynamicFieldsResponse.mappedDBColumn] = value;
                widget.onChanged(responseMap);
              },
        defValue: (readOnly)
            ? dynamicFieldsResponse.actualValue
            : dynamicFieldsResponse.defaultValue);
  }

  Widget _createComboBoxItem(
      DynamicFieldsResponse dynamicFieldsResponse, String displayName) {
    return ComboBoxItem(displayName,
        hideRulerLine: false,
        onChange: readOnly
            ? null
            : (value) {
                responseMap[dynamicFieldsResponse.mappedDBColumn] = value;
                widget.onChanged(responseMap);
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
      onChange: readOnly
          ? null
          : (value) {
              responseMap[dynamicFieldsResponse.mappedDBColumn] = value;
              widget.onChanged(responseMap);
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
                widget.onChanged(responseMap);
              },
        defValue: (readOnly)
            ? dynamicFieldsResponse.actualValue
            : dynamicFieldsResponse.defaultValue);
  }

  Widget _createToggleItem(
      DynamicFieldsResponse dynamicFieldsResponse, String displayName) {
    return ToggleItem(
      displayName,
      hideRulerLine: false,
      possibleValues: dynamicFieldsResponse.possibleValues,
      onChange: readOnly
          ? null
          : (value) {
              responseMap[dynamicFieldsResponse.mappedDBColumn] = value;
              widget.onChanged(responseMap);
            },
      defValue: (readOnly)
          ? dynamicFieldsResponse.actualValue
          : dynamicFieldsResponse.defaultValue,
    );
  }
}
