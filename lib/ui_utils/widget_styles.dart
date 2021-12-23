import 'dart:io';

import '../login/colors/color_info.dart';
import '../login/utils.dart';
import '../utils/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'app_colors.dart';
import 'text_styles.dart';

class WidgetStyles {
  static const textFieldUnderLine =
      UnderlineInputBorder(borderSide: BorderSide(color: AppColors.lightGrey));

  static InputDecoration inputDecoration(String text) => InputDecoration(
        hintText: text,
        hintStyle: TextStyles.textStyle8,
        enabledBorder: WidgetStyles.textFieldUnderLine,
      );
  static OutlineInputBorder enabledBorder = const OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black, width: 0.0),
      borderRadius: BorderRadius.all(Radius.circular(15.0)));

  static OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
      borderSide: BorderSide(color: Colors.black));

  static Widget buildAppBar(BuildContext context,
      {String title, List<Widget> actions}) {
    return new AppBar(
      backgroundColor: AppColors.backupPrimaryColor,
      centerTitle: true,
      iconTheme: new IconThemeData(color: Colors.white),
      title: new Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      actions: actions,
    );
  }

  static InputDecoration inputDecorationWithErrorTxt(
          String text, String errorTxt,
          {bool enableBorder = true}) =>
      InputDecoration(
        hintText: text,
        hintStyle: TextStyles.textStyle8,
        errorText: errorTxt,
        errorMaxLines: 3,
        enabledBorder: enableBorder
            ? WidgetStyles.textFieldUnderLine
            : WidgetStyles.textFieldUnderLine,
//        border:
//            enableBorder ? WidgetStyles.textFieldUnderLine : InputBorder.none,
      );

  static InputDecoration inputDecorationWithoutBorderWithErrorTxt(
          String text, String errorTxt) =>
      InputDecoration(
        hintText: text,
        hintStyle: TextStyles.textStyle8,
        errorText: errorTxt,
        errorMaxLines: 3,
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      );

  static InputDecoration inputDecorationWithErrorTxtForDatePicker(String text,
          String errorTxt, TextStyle labelStyle, bool removeBorder) =>
      InputDecoration(
          labelText: text,
          labelStyle: labelStyle,
          border:
              removeBorder ? InputBorder.none : WidgetStyles.textFieldUnderLine,
          hintText: text,
          hintStyle: TextStyles.textStyle8,
          errorText: errorTxt,
          errorMaxLines: 5,
          enabledBorder: errorTxt != null
              ? UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.lightGrey))
              : InputBorder.none);

  static InputDecoration inputDecorationWithoutBorder(String text) =>
      InputDecoration(
        hintText: text,
        hintStyle: TextStyles.textStyle8,
        border: InputBorder.none,
      );

  static IconData get backIcon =>
      Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back;

  static DatePickerTheme get datePickerTheme =>
      AppPreferences().isLanguageTamil()
          ? DatePickerTheme(
              headerColor: Color(ColorInfo.DATE_PICKER_COLOR),
              backgroundColor: Colors.white,
              itemStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              doneStyle: TextStyle(color: Colors.white, fontSize: 13),
              cancelStyle: TextStyle(color: Colors.white, fontSize: 13))
          : DatePickerTheme(
              headerColor: Color(ColorInfo.DATE_PICKER_COLOR),
              backgroundColor: Colors.white,
              itemStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              doneStyle: TextStyle(color: Colors.white, fontSize: 18),
              cancelStyle: TextStyle(color: Colors.white, fontSize: 18));

  static InputDecoration decoration(String hint) {
    return InputDecoration(
        errorMaxLines: 2,
        hintText: hint ?? "",
        labelText: hint ?? "",
        hintStyle: Utils.hintStyleBlack,
        contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
        // fillColor: Colors.transparent,
        filled: true,
        border: OutlineInputBorder(
            // borderRadius: BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide(color: Colors.black)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 0.0),
          // borderRadius: BorderRadius.all(Radius.circular(15.0))
        ));
  }

  static InputDecoration heightAndWeightDecoration() {
    return InputDecoration(
      // contentPadding: EdgeInsets.all(1),
      isDense: true,
      errorMaxLines: 3,
      contentPadding: EdgeInsets.all(10),
      counterText: "",
      labelText: "",
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
    );
  }

  static List<BoxShadow> get cardBoxShadow => <BoxShadow>[
        BoxShadow(
            offset: Offset(2.0, 2.0),
            blurRadius: 15.0,
            spreadRadius: 0.0,
            color: AppColors.boxShadow),
      ];
}
