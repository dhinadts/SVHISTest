import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void showCustomLoader(
    {String msg, @required EasyLoadingIndicatorType easyLoadingIndicatorType}) {
  EasyLoading.instance
    ..userInteractions = false
    ..loadingStyle = EasyLoadingStyle.custom
    ..textColor = Colors.black
    ..textStyle = TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
    ..indicatorSize = 24
    ..indicatorType = easyLoadingIndicatorType
    ..indicatorColor = Colors.black
    ..backgroundColor = Colors.white;
  EasyLoading.show(
      status: msg ?? "",
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: false);
}

void dismissCustomLoader() {
  if (EasyLoading.isShow) EasyLoading.dismiss();
}

extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstofEach =>
      this.split(" ").map((str) => str.inCaps).join(" ");
}
