import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguage extends ChangeNotifier {
  Locale _appLocale = Locale('en');

  Locale get appLocal => _appLocale ?? Locale("en");

  fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('language_code') == null) {
      _appLocale = Locale('en');
      return Null;
    }
    _appLocale = Locale(prefs.getString('language_code'));
    return Null;
  }

  void changeLanguage(Locale type) async {
    // print("changeLanguage called");
    var prefs = await SharedPreferences.getInstance();
    if (_appLocale == type) {
      return;
    }
    if (type == Locale("ta")) {
      // print("ta called");
      _appLocale = Locale("ta");
      await prefs.setString('language_code', 'ta');
      await prefs.setString('countryCode', '');
    } else if (type == Locale("hi")) {
      // print("hi called");
      _appLocale = Locale("hi");
      await prefs.setString('language_code', 'hi');
      await prefs.setString('countryCode', '');
    } else if (type == Locale("te")) {
      // print("te called");
      _appLocale = Locale("te");
      await prefs.setString('language_code', 'te');
      await prefs.setString('countryCode', '');
    } else {
      // print("en called");
      _appLocale = Locale("en");
      await prefs.setString('language_code', 'en');
      await prefs.setString('countryCode', '');
    }
    // print("notify called");
    notifyListeners();
  }

  bool udpateIsClicked = false;
  void updateProfileBtnTapped() {
    udpateIsClicked = true;
    // print("notifyListeners clicked...");
    notifyListeners();
  }
}
