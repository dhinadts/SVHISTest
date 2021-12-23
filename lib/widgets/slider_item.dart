import '../model/dynamic_fields_reponse.dart';
import '../ui/people_search/model/bounds.dart';
import '../ui/tabs/app_localizations.dart';
import '../ui_utils/app_colors.dart';
import '../ui_utils/icon_utils.dart';
import '../ui_utils/ui_dimens.dart';
import '../ui_utils/widget_styles.dart';
import '../utils/app_preferences.dart';
import '../utils/constants.dart';
import '../utils/validation_utils.dart';
import '../widgets/prandial_toggle_widget.dart';
import '../widgets/split_text_item.dart';
import 'package:expressions/expressions.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SliderItem extends StatefulWidget {
  @override
  SliderItemState createState() => SliderItemState();
  final String name;
  final ValueChanged<double> onChange;
  final double defValue;
  final double lcl;
  final double ucl;
  final String fieldUnit;
  final ValueChanged<String> onPrandialStatusCallBack;
  final bool hideRulerLine;
  final DynamicFieldsResponse dynamicFieldsResponse;
  final List<Map<String, dynamic>> bounds;

  SliderItem(this.name,
      {this.onChange,
      this.defValue,
      this.hideRulerLine: false,
      this.lcl,
      this.ucl,
      this.onPrandialStatusCallBack,
      this.fieldUnit,
      this.dynamicFieldsResponse,
      this.bounds});
}

class SliderItemState extends State<SliderItem> {
  double _sliderValue;
  int _heightValue;
  int _weightValue;
  String boundsInfo, prandialStatus = Constants.PRE_PRANDIABLE;
  Color promptColor = Colors.blueAccent;
  Color foregroundColor = Colors.black;
  TextEditingController controller = TextEditingController();
  bool fieldEnabled = false;

  @override
  void initState() {
    super.initState();

    _sliderValue = double.parse(widget.defValue == null
        ? widget.lcl.toString()
        : widget.defValue.toStringAsFixed(2));
    if (widget.name == "BMI" &&
        widget.onChange != null &&
        AppPreferences().role != Constants.supervisorRole) {
      _heightValue = double.parse(
              "${ValidationUtils.validStringOrNot(AppPreferences().height) ? "0" : "${AppPreferences().height}"}")
          .toInt();
      _weightValue = double.parse(
              "${ValidationUtils.validStringOrNot(AppPreferences().weight) ? "0" : "${AppPreferences().weight}"}")
          .toInt();
    } else {
      fieldEnabled = !(widget.defValue == null || widget.defValue == 0.0);
      // print("default value ${widget.defValue}");
    }

    if (widget.dynamicFieldsResponse.hasPrandiable) {
      if (widget.onPrandialStatusCallBack != null) {
        widget.onPrandialStatusCallBack(Constants.PRE_PRANDIABLE);
      } else {
        setState(() {
          prandialStatus = widget.dynamicFieldsResponse.prePrandiable
              ? Constants.PRE_PRANDIABLE
              : Constants.POST_PRANDIABLE;
          updateMessageBoundInfo(widget.defValue);
        });
      }
    }
    updateMessageBoundInfo(_sliderValue);
    if (widget.dynamicFieldsResponse?.fieldDataType == "DOUBLE")
      controller.text = _sliderValue?.toString();
  }

  void _sliderValueChanges(double value, {bool isFromText: true}) {
    if (isFromText)
      setState(() {
        _sliderValue = double.parse(value.toStringAsFixed(2));
        controller?.text = _sliderValue?.toString();
      });
    widget.onChange(_sliderValue);
  }

  BoxDecoration leftBoxDecoration() {
    return BoxDecoration(
        // border: Border.all(width: 2, color: Colors.green),
        borderRadius: BorderRadius.all(
            Radius.circular(5.0) //         <--- border radius here
            ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment
              .bottomLeft, // 10% of the width, so there are ten blinds.
          colors: [
            //AppColors.primaryLightColor,
            AppColors.deliveredColor,
            AppColors.deliveredColor
          ], // whitish to gray
        ));
  }

  @override
  Widget build(BuildContext context) {
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
              _sliderWidget(),
            ],
          ),
        ));
  }

  _sliderWidget() {
    return Column(
      children: [
        Row(
          children: [
           // if (widget.name != "BMI")
              Checkbox(
                value: fieldEnabled,
                activeColor: AppColors.hyperlinkColor,
                onChanged: widget.onChange != null
                    ? (value) {
                        setState(() {
                          fieldEnabled = !fieldEnabled;
                          if (!fieldEnabled) {
                            controller?.text = 0.toString();
                            _sliderValue = 0;
                            updateMessageBoundInfo(_sliderValue);
                            _sliderValueChanges(_sliderValue);
                          }
                        });
                      }
                    : null,
              ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              alignment: Alignment.centerLeft,
              child: Text(widget.name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        //SizedBox(height: 10),
        if (widget.dynamicFieldsResponse?.hasPrandiable ?? false)
          Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              alignment: Alignment.centerLeft,
              child: PrandialToggleItem(
                "Have you had anything to eat or drink (except water) in the last 8 hours ?",
                onChange: widget.onChange == null
                    ? null
                    : (s) {
                        setState(() {
                          prandialStatus = s;
                          widget.onPrandialStatusCallBack(s);
                        });
                        updateMessageBoundInfo(_sliderValue);
                      },
                defValue: prandialStatus,
                possibleValues: [
                  Constants.POST_PRANDIABLE,
                  Constants.PRE_PRANDIABLE
                ],
              )),

        // SizedBox(height: 10),

        if (widget.name == Constants.BMI && widget.onChange != null)
          Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              child: Column(children: [
                SplitTextItem("Height (cms)",
                    isEnabled: fieldEnabled,
                    onChange: widget.onChange == null || !fieldEnabled
                        ? null
                        : (s) {
                      // print("s SplitTextItem Height $s");
                      if (s.isNotEmpty) {
                        _heightValue = double.parse(s).toInt();
                      } else {
                        _heightValue = null;
                      }
                      calculation();
                    },
                    defValue: "${_heightValue ?? "0.0"}",
                    dataType: "DOUBLE",
                    validator: (arg) {
                      if (arg.isNotEmpty) {
                        double height = double.tryParse(arg);
                        if (height > 249.99) {
                          return "Height should be < 250";
                        }
                      }
                      return ValidationUtils.dynamicFieldsValidator(arg,
                          errorMessage: "Height is required");
                    },
                    hideRulerLine: true,
                    maxCount: 6,
                    hideCounterText: true,
                    decoration: WidgetStyles.heightAndWeightDecoration()),
                SplitTextItem("Weight (kgs)",
                    isEnabled: fieldEnabled,
                    onChange: widget.onChange == null || !fieldEnabled
                        ? null
                        :  (s) {
                      // print("s SplitTextItem Weight $s");
                      if (s.isNotEmpty) {
                        _weightValue = double.parse(s).toInt();
                      } else {
                        _weightValue = null;
                      }
                      // print("_height $_weightValue");
                      calculation();
                    },
                    maxCount: 6,
                    validator: (arg) {
                      if (arg.isNotEmpty) {
                        double weight = double.tryParse(arg);
                        if (weight > 249.99) {
                          return "Weight should be < 250";
                        }
                      }
                      return ValidationUtils.dynamicFieldsValidator(arg,
                          errorMessage: "Weight is required");
                    },
                    dataType: "DOUBLE",
                    defValue: "${_weightValue ?? "0.0"}",
                    hideRulerLine: true,
                    hideCounterText: true,
                    decoration: WidgetStyles.heightAndWeightDecoration()),
                SizedBox(
                  height: 5,
                )
              ])),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: <Widget>[
                    if (widget.name == Constants.BMI)
                      Text(
                        '${_sliderValue.toInt()}' + " (${widget.fieldUnit})",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    if (widget.name != Constants.BMI)
                      SplitTextItem("${widget.name}",
                          isEnabled: fieldEnabled,
                          onChange: widget.onChange == null || !fieldEnabled
                              ? null
                              : (s) {
                                  // print("Onchange ");
                                  if (s.isNotEmpty) {
                                    double localSliderValue = double.parse(s);
                                    if (localSliderValue <= widget.ucl &&
                                        localSliderValue >= widget.lcl) {
                                      _sliderValue = localSliderValue;
                                    } else {
                                      if (localSliderValue > widget.lcl) {
                                        _sliderValue = widget.ucl;
                                      }
                                    }
                                    _sliderValueChanges(_sliderValue,
                                        isFromText: false);
                                    updateMessageBoundInfo(_sliderValue);
                                  } else {
                                    boundsInfo = null;
                                    _sliderValue = 0;
                                    promptColor = Colors.blueAccent;
                                  }
                                  setState(() {});
                                },
                          maxCount: 5, validator: (arg) {
                        return ValidationUtils.dynamicSliderTextFieldsValidator(
                            arg,
                            errorMessage: "${widget.name} is required",
                            lcl: widget.lcl,
                            ucl: widget.ucl);
                      },
                          dataType: "DOUBLE",
                          hideRulerLine: true,
                          hideCounterText: true,
                          controller: controller,
                          decoration: WidgetStyles.heightAndWeightDecoration()),
                    Slider(
                      value: _sliderValue.toDouble(),
                      onChanged: widget.onChange == null
                          ? null
                          : (arg) {
                              /*if (widget.onChange != null &&
                                  widget.name != Constants.BMI) {
                                _temperatureValueChanges(arg);
                                updateMessageBoundInfo(arg);
                              } else {*/
                              return null;
                              // }
                            },
                      min: widget.lcl,
                      max: widget.ucl,
                      activeColor: promptColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        if (boundsInfo != null &&
            boundsInfo.trim().isNotEmpty &&
            _sliderValue != 0)
          Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(
                      color: widget.onChange == null
                          ? Colors.grey[400]
                          : ColorUtils.brighten(promptColor, 70),
                      width: 1),
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
                boundsInfo,
                style: TextStyle(
                    //fontWeight: FontWeight.w600,
                    color: widget.onChange == null
                        ? Colors.black
                        : foregroundColor),
              )),
        SizedBox(height: 5),
      ],
    );
  }

  updateMessageBoundInfo(double arg) {
    if (widget.bounds != null && widget.bounds.length > 0) {
      bool notified = false;
      if (widget.dynamicFieldsResponse?.hasPrandiable ?? false) {
        for (Map<String, dynamic> boundMap in widget.bounds) {
          if (boundMap != null) {
            Bounds bound = Bounds.fromJson(boundMap);
            if (arg >= bound.lowerCut && arg <= bound.upperCut) {
              notified = true;
              if (bound.boundClassification != null &&
                  prandialStatus.toLowerCase() ==
                      bound.boundClassification.toLowerCase()) {
                boundsInfo = bound.infoMessage;
                promptColor = hexToColor(bound.colorCode);
                foregroundColor = hexToColor(bound.foregroundColor);
              }
            }
          }
        }
      } else {
        for (Map<String, dynamic> boundMap in widget.bounds) {
          if (boundMap != null) {
            Bounds bound = Bounds.fromJson(boundMap);
            if (arg >= bound.lowerCut && arg <= bound.upperCut) {
              notified = true;
              boundsInfo = bound.infoMessage;
              promptColor = hexToColor(bound.colorCode);
              foregroundColor = hexToColor(bound.foregroundColor);
            }
          }
        }
      }
      if (!notified || _sliderValue == 0) {
        boundsInfo = null;
      }
    }
  }

  void calculation() {
    if ((widget.dynamicFieldsResponse?.hasExpression ?? false) &&
        _heightValue is num &&
        _weightValue is num &&
        _heightValue != 0 &&
        _weightValue != 0) {
      try {
        var context = {'weight': _weightValue, 'height': (_heightValue / 100)};
        // print(
        // "expression  ${widget.dynamicFieldsResponse.conversionExpression.replaceAll(" ", "")}");
        Expression expression = Expression.parse(
            "${widget.dynamicFieldsResponse.conversionExpression}");

        final evaluator = const ExpressionEvaluator();
        _sliderValue = evaluator.eval(expression, context);
        // print("_temperatureValue  $_sliderValue");
        if (_sliderValue > widget.dynamicFieldsResponse.ucl) {
          _sliderValue = widget.dynamicFieldsResponse.ucl;
        }
        if (_sliderValue < widget.dynamicFieldsResponse.lcl) {
          _sliderValue = widget.dynamicFieldsResponse.lcl;
        }
        _sliderValueChanges(_sliderValue);
        updateMessageBoundInfo(_sliderValue);
        setState(() {});
      } catch (_) {
        Fluttertoast.showToast(
            msg: AppLocalizations.of(context)
                    .translate("key_somethingwentwrong") +
                _,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);
      }
    } else {
      _sliderValue = 0;
      _sliderValueChanges(_sliderValue);
      updateMessageBoundInfo(_sliderValue);
      setState(() {});
    }
    if (_sliderValue != null) controller.text = _sliderValue.toString();

    // print("Controller value ${controller.text}");
    setState(() {});
  }

  Color hexToColor(String hexColor) {
    if (hexColor == null) {
      return Colors.blueAccent;
    }
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}
